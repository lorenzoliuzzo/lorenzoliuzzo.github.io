import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import {
  EDITABLE_COLLECTIONS,
  applyPatch,
  hashBody,
  resolveDocPath,
  splitFrontMatter,
  touchesVerificationKeys,
  updateFrontMatter,
} from "./core.mjs";
import { loadApiKey, streamMessage, systemPrompt } from "./anthropic.mjs";

const TOOL_DIR = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(TOOL_DIR, "..", "..");
const PORT = Number(process.env.MYTHINGSLAB_PORT ?? 4001);
// Any loopback origin, not just :4000 — `jekyll serve` gets moved to another port often
// enough (a second worktree, an occupied 4000) that pinning one port just breaks the
// drawer with a confusing CORS error. A page on the public internet still carries its own
// origin and is rejected.
const LOOPBACK_ORIGIN = /^http:\/\/(?:localhost|127\.0\.0\.1|\[::1\]):\d+$/;

// Resolved lazily: reading, applying, and verifying are pure disk work, so the
// server stays useful without a key and only /api/chat requires one.
let cachedKey = null;
function apiKey() {
  return (cachedKey ??= loadApiKey(TOOL_DIR));
}

const server = http.createServer(async (req, res) => {
  const origin = req.headers.origin;
  if (origin && LOOPBACK_ORIGIN.test(origin)) {
    res.setHeader("Access-Control-Allow-Origin", origin);
    res.setHeader("Access-Control-Allow-Headers", "content-type");
    res.setHeader("Vary", "Origin");
  } else if (origin) {
    return send(res, 403, { error: "origin not allowed" });
  }

  if (req.method === "OPTIONS") {
    res.writeHead(204).end();
    return;
  }

  const url = new URL(req.url, `http://localhost:${PORT}`);

  try {
    if (req.method === "GET" && url.pathname === "/api/note") {
      return handleReadNote(res, url.searchParams.get("collection"), url.searchParams.get("path"));
    }
    if (req.method === "POST" && url.pathname === "/api/chat") {
      return await handleChat(req, res);
    }
    if (req.method === "POST" && url.pathname === "/api/apply") {
      return handleApply(res, await readJson(req));
    }
    if (req.method === "POST" && url.pathname === "/api/verify") {
      return handleVerify(res, await readJson(req));
    }
    send(res, 404, { error: "no such route" });
  } catch (err) {
    // Surface the real reason: this is a local dev tool and a swallowed error here
    // just looks like a drawer that silently does nothing.
    console.error(`[mythingslab] ${req.method} ${url.pathname}:`, err.message);
    if (!res.headersSent) send(res, 500, { error: err.message });
    else res.end();
  }
});

function handleReadNote(res, collection, relPath) {
  const file = resolveDocPath(REPO_ROOT, collection, relPath);
  if (!fs.existsSync(file)) return send(res, 404, { error: "document not found" });

  const source = fs.readFileSync(file, "utf8");
  const { body } = splitFrontMatter(source);
  send(res, 200, { collection, path: relPath, source, content_hash: hashBody(body) });
}

async function handleChat(req, res) {
  const { collection, path: relPath, messages, selection } = await readJson(req);
  const file = resolveDocPath(REPO_ROOT, collection, relPath);
  if (!fs.existsSync(file)) return send(res, 404, { error: "document not found" });
  if (!Array.isArray(messages) || messages.length === 0) {
    return send(res, 400, { error: "messages required" });
  }

  // Resolve the key before switching to SSE, so a missing key surfaces as a normal
  // JSON error the drawer can display rather than an error inside an event stream.
  let key;
  try {
    key = apiKey();
  } catch (err) {
    return send(res, 400, { error: err.message });
  }

  const source = fs.readFileSync(file, "utf8");

  // The file is re-read and re-sent on every turn, so the model always reasons over
  // what is on disk right now rather than a copy from before the last applied patch.
  let context = `File: _${collection}/${relPath}\n\n<source>\n${source}\n</source>`;
  if (selection && selection.trim()) {
    context +=
      `\n\nThe reader has selected this passage in the rendered page. It is the rendered ` +
      `text, so it will not match the source character for character — locate the ` +
      `corresponding source text yourself:\n\n<selection>\n${selection.trim()}\n</selection>`;
  }

  const conversation = messages.map((m, i) => ({
    role: m.role === "assistant" ? "assistant" : "user",
    content: i === 0 ? `${context}\n\n---\n\n${m.content}` : m.content,
  }));

  res.writeHead(200, {
    "content-type": "text/event-stream",
    "cache-control": "no-cache",
    connection: "keep-alive",
  });

  const abort = new AbortController();
  req.on("close", () => abort.abort());

  try {
    const { stopReason } = await streamMessage({
      apiKey: key,
      system: systemPrompt(collection),
      messages: conversation,
      signal: abort.signal,
      onText: (text) => sendEvent(res, "text", { text }),
      onThinking: () => sendEvent(res, "thinking", {}),
    });
    sendEvent(res, "done", { stop_reason: stopReason });
  } catch (err) {
    if (!abort.signal.aborted) sendEvent(res, "error", { message: err.message });
  }
  res.end();
}

function handleApply(res, { collection, path: relPath, old_string, new_string }) {
  const file = resolveDocPath(REPO_ROOT, collection, relPath);
  if (!fs.existsSync(file)) return send(res, 404, { error: "document not found" });

  if (touchesVerificationKeys(new_string)) {
    return send(res, 400, {
      error: "patch would write verification front matter; only you can sign off on a page",
    });
  }

  const source = fs.readFileSync(file, "utf8");
  const result = applyPatch(source, old_string, new_string);
  if (!result.ok) {
    return send(res, 409, {
      error: {
        not_found: "That exact text is not in the source — it may have changed since.",
        ambiguous: "That text appears more than once; more surrounding context is needed.",
        empty_old_string: "The patch had no target text.",
        no_change: "The patch would not change anything.",
      }[result.reason],
      reason: result.reason,
    });
  }

  fs.writeFileSync(file, result.content);
  const { body } = splitFrontMatter(result.content);
  send(res, 200, { ok: true, content_hash: hashBody(body) });
}

function handleVerify(res, { collection, path: relPath, ai_generated }) {
  const file = resolveDocPath(REPO_ROOT, collection, relPath);
  if (!fs.existsSync(file)) return send(res, 404, { error: "document not found" });

  const source = fs.readFileSync(file, "utf8");
  const { body } = splitFrontMatter(source);
  const hash = hashBody(body);

  const updates = {
    human_verified: true,
    verified_at: new Date().toLocaleDateString("en-CA"),
    verified_hash: hash,
  };
  if (typeof ai_generated === "boolean") updates.ai_generated = ai_generated;

  fs.writeFileSync(file, updateFrontMatter(source, updates));
  send(res, 200, { ok: true, verified_hash: hash, verified_at: updates.verified_at });
}

function readJson(req) {
  return new Promise((resolve, reject) => {
    let raw = "";
    req.on("data", (chunk) => {
      raw += chunk;
      if (raw.length > 5_000_000) reject(new Error("request too large"));
    });
    req.on("error", reject);
    req.on("end", () => {
      try {
        resolve(raw ? JSON.parse(raw) : {});
      } catch {
        reject(new Error("invalid JSON body"));
      }
    });
  });
}

function send(res, status, payload) {
  const body = JSON.stringify(payload);
  res.writeHead(status, { "content-type": "application/json" }).end(body);
}

function sendEvent(res, event, payload) {
  res.write(`event: ${event}\ndata: ${JSON.stringify(payload)}\n\n`);
}

// Loopback only: this process can write to the collections below and holds an API key.
server.listen(PORT, "127.0.0.1", () => {
  console.log(`MyThingsLab listening on http://127.0.0.1:${PORT}`);
  for (const collection of EDITABLE_COLLECTIONS) {
    console.log(`  writable: ${path.join(REPO_ROOT, `_${collection}`)}`);
  }
});
