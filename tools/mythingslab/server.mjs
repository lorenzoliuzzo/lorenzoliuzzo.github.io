import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { spawn } from "node:child_process";
import { fileURLToPath } from "node:url";

import {
  EDITABLE_COLLECTIONS,
  applyPatch,
  frontMatterValue,
  hashBody,
  isVerified,
  resolveDocPath,
  splitFrontMatter,
  touchesVerificationKeys,
  updateFrontMatter,
} from "./core.mjs";

const TOOL_DIR = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(TOOL_DIR, "..", "..");
const SHIM_PATH = path.join(TOOL_DIR, "shim.py");
const PORT = Number(process.env.MYTHINGSLAB_PORT ?? 4001);
// Any loopback origin, not just :4000 — `jekyll serve` gets moved to another port often
// enough (a second worktree, an occupied 4000) that pinning one port just breaks the
// drawer with a confusing CORS error. A page on the public internet still carries its own
// origin and is rejected.
const LOOPBACK_ORIGIN = /^http:\/\/(?:localhost|127\.0\.0\.1|\[::1\]):\d+$/;

// The drawer's one LLM call site is a Python subprocess (tools/mythingslab/shim.py)
// rather than a direct Anthropic fetch, so it goes through the same mythings.engine
// seam every other MyThingsLab tool does -- spend lands in the shared Ledger, and
// MYTHINGSLAB_ENGINE=noop gets the whole drawer testable at zero token cost. The
// trade is this repo now depends on that fleet checkout being at MYTHINGS_PYTHON;
// resolved lazily so read/apply/verify stay usable without it, same as the old key.
const DEFAULT_MYTHINGS_PYTHON = "/home/lollinux/Desktop/MyThingsLab/.venv/bin/python";
let cachedPython = null;
function mythingsPython() {
  if (cachedPython) return cachedPython;
  const bin = process.env.MYTHINGS_PYTHON || DEFAULT_MYTHINGS_PYTHON;
  if (!fs.existsSync(bin)) {
    throw new Error(
      `No Python interpreter at ${bin}. Set MYTHINGS_PYTHON to the MyThingsLab fleet's ` +
        `venv interpreter (e.g. /path/to/MyThingsLab/.venv/bin/python), or MYTHINGSLAB_ENGINE=noop ` +
        `to test the drawer without it.`,
    );
  }
  return (cachedPython = bin);
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
    if (req.method === "POST" && url.pathname === "/api/quiz") {
      return await handleQuiz(req, res);
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

  // Resolve the interpreter before switching to SSE, so a missing venv surfaces as a
  // normal JSON error the drawer can display rather than an error inside an event stream.
  let python;
  try {
    python = mythingsPython();
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

  // The raw latest question, unprefixed by file source/selection — shim.py uses this
  // (not the flattened transcript, which would be dominated by the current note's own
  // text) as the query for shortlisting related passages from the rest of the collection.
  const latestQuery = messages[messages.length - 1].content;

  runShim(python, { collection, messages: conversation, query: latestQuery, doc_path: file }, res, req);
}

async function handleQuiz(req, res) {
  const { collection, path: relPath } = await readJson(req);
  const file = resolveDocPath(REPO_ROOT, collection, relPath);
  if (!fs.existsSync(file)) return send(res, 404, { error: "document not found" });
  // Server-side, not just a hidden button: quizzing yourself on an unreviewed
  // AI-drafted note teaches whatever the model got wrong, so this checks the same
  // claim the badge renders rather than trusting whatever the client last painted.
  if (collection !== "notes") {
    return send(res, 400, { error: "quizzing is only wired up for the notes collection" });
  }

  let python;
  try {
    python = mythingsPython();
  } catch (err) {
    return send(res, 400, { error: err.message });
  }

  const source = fs.readFileSync(file, "utf8");
  if (!isVerified(source)) {
    return send(res, 400, {
      error: "this note is not human-verified yet — read it through and mark it verified first",
    });
  }

  const topic = frontMatterValue(source, "title") || path.basename(relPath, ".md");
  runShim(python, { mode: "quiz", doc_path: file, topic, questions: 3 }, res, req);
}

// Shared by /api/chat and /api/quiz: spawn shim.py, keep the SSE connection alive
// with a "thinking" heartbeat while it runs (ClaudeCLIEngine is a blocking one-shot
// call, not a stream, so there is nothing incremental to relay), then forward
// exactly one "text" event with its reply.
function runShim(python, payload, res, req) {
  res.writeHead(200, {
    "content-type": "text/event-stream",
    "cache-control": "no-cache",
    connection: "keep-alive",
  });

  const child = spawn(python, [SHIM_PATH]);
  let stdout = "";
  let stderr = "";
  child.stdout.on("data", (chunk) => (stdout += chunk));
  child.stderr.on("data", (chunk) => (stderr += chunk));
  child.stdin.end(JSON.stringify(payload));

  const heartbeat = setInterval(() => sendEvent(res, "thinking", {}), 1500);
  req.on("close", () => {
    clearInterval(heartbeat);
    child.kill();
  });

  child.on("close", (code) => {
    clearInterval(heartbeat);
    try {
      const reply = JSON.parse(stdout);
      if (reply.error) throw new Error(reply.error);
      sendEvent(res, "text", { text: reply.text });
      sendEvent(res, "done", { stop_reason: code === 0 ? "end_turn" : "error" });
    } catch (err) {
      const message = stdout.trim() ? err.message : stderr.trim() || `shim exited ${code}`;
      sendEvent(res, "error", { message });
    }
    res.end();
  });
  child.on("error", (err) => {
    // spawn() itself failing (bad interpreter path, no exec permission) rather
    // than the shim running and failing -- distinct from the "close" handler above.
    clearInterval(heartbeat);
    sendEvent(res, "error", { message: err.message });
    res.end();
  });
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

  // _config.yml already defaults ai_generated to true for both collections, so
  // the case this catches is the inverted one: a page that overrode the default
  // with `ai_generated: false` to claim it was written by hand, and is now having
  // a model's words patched into it. Without this it would keep rendering "Written
  // by hand" over prose a model wrote. Recording it at apply time rather than at
  // sign-off matters because a page can be edited from this drawer many times and
  // never verified at all.
  //
  // Written by the server, never taken from the reply — the model's own patch is
  // still barred from front matter by touchesVerificationKeys above. Safe against
  // the badge because hashBody() digests the body alone, so adding a front-matter
  // key can neither forge a verification nor clear one; the body edit on the line
  // above is what legitimately staled it.
  const stamped = updateFrontMatter(result.content, { ai_generated: true });

  fs.writeFileSync(file, stamped);
  const { body } = splitFrontMatter(stamped);
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
