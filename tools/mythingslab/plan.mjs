#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { resolveDocPath, splitFrontMatter, updateFrontMatter } from "./core.mjs";
import { draftSystemPrompt, loadApiKey, streamMessage } from "./anthropic.mjs";

// CLI companion to the browser drawer (server.mjs), for the two things a chat drawer
// can't do: scaffolding a batch of empty notes ahead of an exam, and writing the first
// draft of one when there is no existing prose for the patch protocol to anchor on.
//
// Usage:
//   node tools/mythingslab/plan.mjs stubs <syllabus.json>
//   node tools/mythingslab/plan.mjs draft <notes/path/to/note.md> [--source <file>]
//   node tools/mythingslab/plan.mjs draft-tag "<tag>" [--collection notes]

const TOOL_DIR = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(TOOL_DIR, "..", "..");

async function main() {
  const [command, ...rest] = process.argv.slice(2);

  if (command === "stubs") return cmdStubs(rest);
  if (command === "draft") return cmdDraft(rest);
  if (command === "draft-tag") return cmdDraftTag(rest);

  console.error(
    "Usage:\n" +
      "  node tools/mythingslab/plan.mjs stubs <syllabus.json>\n" +
      "  node tools/mythingslab/plan.mjs draft <notes/relative/path.md> [--source <file>]\n" +
      '  node tools/mythingslab/plan.mjs draft-tag "<tag>"',
  );
  process.exitCode = 1;
}

// --- stubs: scaffold empty (planned) notes from a syllabus -----------------------------

function cmdStubs(args) {
  const [syllabusPath] = args;
  if (!syllabusPath) throw new Error("usage: plan.mjs stubs <syllabus.json>");

  const topics = JSON.parse(fs.readFileSync(path.resolve(syllabusPath), "utf8"));
  if (!Array.isArray(topics)) throw new Error("syllabus must be a JSON array of {path, title, tags}");

  let created = 0;
  let skipped = 0;

  for (const topic of topics) {
    if (!topic.path || !topic.title || !Array.isArray(topic.tags) || topic.tags.length === 0) {
      throw new Error(`each entry needs path, title, and a non-empty tags array: ${JSON.stringify(topic)}`);
    }

    const file = resolveDocPath(REPO_ROOT, "notes", topic.path);
    if (fs.existsSync(file)) {
      console.log(`skip (exists): ${topic.path}`);
      skipped++;
      continue;
    }

    fs.mkdirSync(path.dirname(file), { recursive: true });
    fs.writeFileSync(file, stubFrontMatter(topic));
    console.log(`created: ${topic.path}`);
    created++;
  }

  console.log(`\n${created} stub(s) created, ${skipped} skipped.`);
}

function stubFrontMatter({ title, tags }) {
  const tagLines = tags.map((tag) => `  - ${yamlScalar(tag)}`).join("\n");
  return `---\ncollection: notes\ntitle: ${yamlScalar(title)}\ntags:\n${tagLines}\n---\n`;
}

function yamlScalar(value) {
  const text = String(value);
  return /^[A-Za-z0-9 ._-]+$/.test(text) ? text : JSON.stringify(text);
}

// --- draft: write the first version of one empty note -----------------------------------

async function cmdDraft(args) {
  const positionals = args.filter((a) => !a.startsWith("--"));
  const relPath = positionals[0];
  if (!relPath) throw new Error("usage: plan.mjs draft <notes/relative/path.md> [--source <file>]");

  const sourceFlagIndex = args.indexOf("--source");
  const sourcePath = sourceFlagIndex !== -1 ? args[sourceFlagIndex + 1] : null;

  const collectionFlagIndex = args.indexOf("--collection");
  const collection = collectionFlagIndex !== -1 ? args[collectionFlagIndex + 1] : "notes";

  const sourceText = sourcePath ? fs.readFileSync(path.resolve(sourcePath), "utf8") : null;

  await draftOne(REPO_ROOT, collection, relPath, sourceText);
}

async function draftOne(repoRoot, collection, relPath, sourceText) {
  const file = resolveDocPath(repoRoot, collection, relPath);
  if (!fs.existsSync(file)) throw new Error(`no such note: ${relPath}`);

  const source = fs.readFileSync(file, "utf8");
  const { frontMatter, body } = splitFrontMatter(source);
  if (frontMatter === null) throw new Error(`${relPath} has no front matter`);
  if (body.trim() !== "") {
    throw new Error(
      `${relPath} already has content — draft is only for empty (planned) notes; use the browser chat drawer to edit it`,
    );
  }

  const title = (/^title:\s*(.*)$/m.exec(frontMatter) || [])[1]?.replace(/^["']|["']$/g, "") ?? relPath;
  const tags = [...frontMatter.matchAll(/^\s+-\s*(.+)$/gm)].map((m) => m[1].trim());

  let userMessage = `Title: ${title}\nTags: ${tags.join(", ") || "(none)"}\n\n`;
  userMessage += sourceText
    ? `Source material:\n\n<source>\n${sourceText}\n</source>`
    : "No source material was supplied — draft from your own knowledge of the topic.";

  const apiKey = loadApiKey(TOOL_DIR);
  process.stdout.write(`drafting ${relPath}... `);
  const { text, stopReason } = await streamMessage({
    apiKey,
    system: draftSystemPrompt(collection),
    messages: [{ role: "user", content: userMessage }],
  });
  console.log(stopReason === "end_turn" ? "done" : `done (${stopReason})`);

  if (!text.trim()) throw new Error("model returned an empty draft");

  const withBody = `---\n${frontMatter}\n---\n\n${text.trim()}\n`;
  fs.writeFileSync(file, updateFrontMatter(withBody, { ai_generated: true }));
  console.log(`wrote ${relPath} — read it, correct it, then mark it human-verified.`);
}

// --- draft-tag: batch-draft every still-empty note under a tag --------------------------

async function cmdDraftTag(args) {
  const positionals = args.filter((a) => !a.startsWith("--"));
  const tag = positionals[0];
  if (!tag) throw new Error('usage: plan.mjs draft-tag "<tag>"');

  const collectionFlagIndex = args.indexOf("--collection");
  const collection = collectionFlagIndex !== -1 ? args[collectionFlagIndex + 1] : "notes";

  const collectionDir = path.resolve(REPO_ROOT, `_${collection}`);
  const targets = [];
  for (const file of walk(collectionDir)) {
    const source = fs.readFileSync(file, "utf8");
    const { frontMatter, body } = splitFrontMatter(source);
    if (frontMatter === null || body.trim() !== "") continue;

    const tags = [...frontMatter.matchAll(/^\s+-\s*(.+)$/gm)].map((m) => m[1].trim());
    if (tags.includes(tag)) targets.push(path.relative(collectionDir, file));
  }

  if (targets.length === 0) {
    console.log(`no empty notes tagged "${tag}" under _${collection}/`);
    return;
  }

  console.log(`drafting ${targets.length} note(s) tagged "${tag}":`);
  for (const relPath of targets) {
    await draftOne(REPO_ROOT, collection, relPath, null);
  }
}

function* walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) yield* walk(full);
    else if (entry.isFile() && entry.name.endsWith(".md")) yield full;
  }
}

main().catch((err) => {
  console.error(`error: ${err.message}`);
  process.exitCode = 1;
});
