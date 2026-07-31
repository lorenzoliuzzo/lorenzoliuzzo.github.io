import fs from "node:fs";
import path from "node:path";

// Every Anthropic call goes through this module. Swapping in @anthropic-ai/sdk, or
// pointing at a hosted proxy for a public version of the chat, means rewriting only
// this file.

const API_URL = "https://api.anthropic.com/v1/messages";
const API_VERSION = "2023-06-01";
const MODEL = "claude-opus-4-8";

export function loadApiKey(toolDir) {
  if (process.env.ANTHROPIC_API_KEY) return process.env.ANTHROPIC_API_KEY;

  const envFile = path.join(toolDir, ".env");
  if (fs.existsSync(envFile)) {
    for (const line of fs.readFileSync(envFile, "utf8").split("\n")) {
      const match = /^\s*(?:export\s+)?ANTHROPIC_API_KEY\s*=\s*(.*)$/.exec(line);
      if (match) return match[1].trim().replace(/^["']|["']$/g, "");
    }
  }

  throw new Error(
    "No Anthropic API key. Set ANTHROPIC_API_KEY, or write it to tools/mythingslab/.env " +
      "(gitignored). Get one at https://console.anthropic.com/settings/keys",
  );
}

export async function streamMessage({ apiKey, system, messages, signal, onText, onThinking }) {
  const response = await fetch(API_URL, {
    method: "POST",
    signal,
    headers: {
      "x-api-key": apiKey,
      "anthropic-version": API_VERSION,
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: MODEL,
      max_tokens: 8000,
      // Adaptive is the only thinking mode on Opus 4.8; "summarized" so the drawer
      // can show progress instead of an unexplained pause.
      thinking: { type: "adaptive", display: "summarized" },
      output_config: { effort: "medium" },
      system,
      messages,
      stream: true,
    }),
  });

  if (!response.ok) {
    throw new Error(await describeFailure(response));
  }

  return consumeStream(response.body, { onText, onThinking });
}

async function describeFailure(response) {
  let detail = "";
  try {
    const body = await response.json();
    detail = body?.error?.message ?? "";
  } catch {
    detail = await response.text().catch(() => "");
  }

  const hint =
    {
      401: "Check ANTHROPIC_API_KEY.",
      404: "Model not available to this key.",
      429: "Rate limited — wait and retry.",
      529: "API overloaded — retry shortly.",
    }[response.status] ?? "";

  return `Anthropic API ${response.status}: ${detail}${hint ? ` (${hint})` : ""}`;
}

async function consumeStream(body, { onText, onThinking }) {
  const decoder = new TextDecoder();
  let buffer = "";
  let text = "";
  let stopReason = null;

  for await (const chunk of body) {
    buffer += decoder.decode(chunk, { stream: true });

    // SSE frames are separated by a blank line; a frame can straddle chunks.
    let split;
    while ((split = buffer.indexOf("\n\n")) !== -1) {
      const frame = buffer.slice(0, split);
      buffer = buffer.slice(split + 2);

      const dataLine = frame.split("\n").find((line) => line.startsWith("data:"));
      if (!dataLine) continue;

      let event;
      try {
        event = JSON.parse(dataLine.slice(5).trim());
      } catch {
        continue;
      }

      if (event.type === "content_block_delta") {
        if (event.delta?.type === "text_delta") {
          text += event.delta.text;
          onText?.(event.delta.text);
        } else if (event.delta?.type === "thinking_delta") {
          onThinking?.(event.delta.thinking);
        }
      } else if (event.type === "message_delta" && event.delta?.stop_reason) {
        stopReason = event.delta.stop_reason;
      } else if (event.type === "error") {
        throw new Error(`Anthropic stream error: ${event.error?.message ?? "unknown"}`);
      }
    }
  }

  return { text, stopReason };
}

// What the assistant is editing changes what "better" means: a note is judged on whether
// the physics is right, a library entry on whether it says something true about a book he
// actually read. Everything else — the patch protocol, the front-matter ban — is shared.
const PREAMBLE = {
  notes: `You help him sharpen study notes he publishes — physics, machine learning,
statistics — that serve both as public work and as his own long-term memory.

You are given the note's raw Markdown source. Your job is to make the writing clearer and the
explanations more correct, not to rewrite it in your voice.`,

  library: `You help him write up the books in his library: what a book argued, what stuck,
what he disagreed with. These are his own reactions to something he read, so the bar is his
voice sharpened, never replaced.

You are given the entry's raw Markdown source. Never invent a reaction, an opinion, or a detail
of his reading he has not written down — if a claim about the book is missing, say what is
missing rather than filling it in. You may correct facts about the book itself: its argument,
its publication details, who its author was.`,
};

export function systemPrompt(collection) {
  const preamble = PREAMBLE[collection];
  if (!preamble) throw new Error(`no system prompt for collection ${JSON.stringify(collection)}`);

  return `You are MyThingsLab, an editing assistant built into Lorenzo Liuzzo's personal site.
${preamble}

Rules for the source text:
- Preserve Liquid tags ({% include figure.html ... %}, {% include table.html ... %}, bibliography
  includes) exactly. Never reword, reformat, or drop them.
- Preserve LaTeX/MathJax exactly unless the maths itself is what is wrong.
- Preserve the existing heading structure and reference links like [](#results) unless asked.
- Never edit the YAML front matter. Never write the keys human_verified, verified_at, or
  verified_hash — those record a human review you cannot perform.

How to answer:
- Explain your reasoning briefly first, in prose. If a passage is unclear because the underlying
  idea is muddled, say so plainly rather than smoothing the prose over it — he is using these pages
  to check his own understanding, so a fluent paragraph that hides a misconception is worse than
  an awkward one that exposes it.
- If he asks a question rather than requesting an edit, just answer it. Do not propose a patch.
- When you do propose a concrete edit, end your reply with exactly one fenced block:

\`\`\`mythingslab-patch
{"old_string": "<text copied verbatim from the source>", "new_string": "<replacement>"}
\`\`\`

  old_string must appear EXACTLY ONCE in the source, copied character for character including
  indentation and line breaks. Include enough surrounding context to be unique. Propose one patch
  per reply; if several changes are needed, do the most important one and offer the rest.`;
}
