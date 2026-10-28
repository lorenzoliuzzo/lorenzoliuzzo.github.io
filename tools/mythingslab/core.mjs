import { createHash } from "node:crypto";
import path from "node:path";
import fs from "node:fs";

// Must stay byte-for-byte identical to Verification.normalize in
// _plugins/note_verification.rb — the badge is only trustworthy if the build-time
// checker and this tool agree on what "the same note" means.
export function normalizeBody(text) {
  return String(text ?? "")
    .replace(/^\uFEFF/, "")
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((line) => line.replace(/[ \t]+$/, ""))
    .join("\n")
    .replace(/^\n+/, "")
    .replace(/\n+$/, "");
}

export function hashBody(text) {
  return "sha256:" + createHash("sha256").update(normalizeBody(text), "utf8").digest("hex");
}

const FRONT_MATTER_RE = /^---[ \t]*\r?\n([\s\S]*?)\r?\n---[ \t]*(?:\r?\n|$)/;

export function splitFrontMatter(source) {
  const match = FRONT_MATTER_RE.exec(source);
  if (!match) return { frontMatter: null, body: source, offset: 0 };
  return {
    frontMatter: match[1],
    body: source.slice(match[0].length),
    offset: match[0].length,
  };
}

function formatScalar(value) {
  if (typeof value === "boolean" || typeof value === "number") return String(value);
  const text = String(value);
  // Quote anything a YAML reader could mistake for a non-string (hashes contain ':').
  return /^[A-Za-z0-9._\/-]+$/.test(text) ? text : JSON.stringify(text);
}

// Line-level surgical edit rather than a YAML round-trip, which would reformat
// hand-written front matter (comment loss, key reordering, re-quoting).
export function updateFrontMatter(source, updates) {
  const { frontMatter, offset } = splitFrontMatter(source);
  if (frontMatter === null) {
    throw new Error("note has no front matter block");
  }

  let block = frontMatter;
  for (const [key, value] of Object.entries(updates)) {
    const line = `${key}: ${formatScalar(value)}`;
    // Unanchored indentation on purpose: nested keys are indented, so `^key:` only
    // ever matches a top-level key.
    const existing = new RegExp(`^${escapeRegExp(key)}:[^\\n]*$`, "m");
    block = existing.test(block) ? block.replace(existing, line) : `${block}\n${line}`;
  }

  return `---\n${block}\n---\n` + source.slice(offset);
}

function escapeRegExp(text) {
  return text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function unquote(value) {
  if (value.length >= 2 && value[0] === value[value.length - 1] && (value[0] === '"' || value[0] === "'")) {
    return value.slice(1, -1);
  }
  return value;
}

// Reads one flat scalar key out of the front matter block — title, human_verified,
// verified_hash, anything formatScalar() could have written. Not a YAML parser: a
// nested value (a list like `tags:`) is invisible to this on purpose, same
// unanchored-indentation reasoning as updateFrontMatter's `^key:` match.
export function frontMatterValue(source, key) {
  const { frontMatter } = splitFrontMatter(source);
  if (frontMatter === null) return null;
  const match = new RegExp(`^${escapeRegExp(key)}:[ \\t]*(.*)$`, "m").exec(frontMatter);
  return match ? unquote(match[1].trim()) : null;
}

// Must mirror Verification.state_for's "verified" branch in
// _plugins/note_verification.rb: recorded, hashed, and the hash matches the body
// on disk right now. Used to gate a server action (quizzing) on the same claim the
// badge renders, not just on what the client last saw painted on the page.
export function isVerified(source) {
  if (frontMatterValue(source, "human_verified") !== "true") return false;
  const storedHash = frontMatterValue(source, "verified_hash");
  if (!storedHash) return false;
  const { body } = splitFrontMatter(source);
  return storedHash === hashBody(body);
}

export function applyPatch(source, oldString, newString) {
  if (typeof oldString !== "string" || oldString.length === 0) {
    return { ok: false, reason: "empty_old_string" };
  }
  if (oldString === newString) {
    return { ok: false, reason: "no_change" };
  }

  const first = source.indexOf(oldString);
  if (first === -1) return { ok: false, reason: "not_found" };
  if (source.indexOf(oldString, first + 1) !== -1) {
    return { ok: false, reason: "ambiguous" };
  }

  return {
    ok: true,
    content: source.slice(0, first) + newString + source.slice(first + oldString.length),
  };
}

export const VERIFICATION_KEYS = ["human_verified", "verified_at", "verified_hash"];

// The model edits prose; it must never be able to assert its own review status.
export function touchesVerificationKeys(text) {
  return VERIFICATION_KEYS.some((key) => new RegExp(`^${key}\\s*:`, "m").test(String(text ?? "")));
}

// The collections the drawer may read and write, and the whole of what it may
// touch on disk. A page outside them — a _pages page, _config.yml, this tool's own
// source — is not addressable through the API at all, whatever path is requested.
// Kept in step with `mythingslab_collections` in _config.yml, which is what decides
// where the drawer is served and which pages show a provenance badge.
export const EDITABLE_COLLECTIONS = ["notes", "library"];

export function resolveDocPath(repoRoot, collection, relPath) {
  if (!EDITABLE_COLLECTIONS.includes(collection)) {
    throw new Error(
      `collection must be one of ${EDITABLE_COLLECTIONS.join(", ")}, got ${JSON.stringify(collection)}`,
    );
  }
  if (typeof relPath !== "string" || relPath.length === 0) {
    throw new Error("missing document path");
  }
  if (relPath.includes("\0")) {
    throw new Error("invalid document path");
  }

  const dirName = `_${collection}`;
  const rootDir = path.resolve(repoRoot, dirName);
  // An absolute relPath makes resolve() ignore rootDir, so the containment
  // check below is what actually enforces the boundary.
  const abs = path.resolve(rootDir, relPath.replace(/^\/+/, ""));

  if (path.extname(abs) !== ".md") {
    throw new Error("document path must end in .md");
  }
  if (!isInside(rootDir, abs)) {
    throw new Error(`document path escapes ${dirName}/`);
  }
  // Re-check after symlink resolution so a link inside the collection can't point out of it.
  if (fs.existsSync(abs) && !isInside(fs.realpathSync(rootDir), fs.realpathSync(abs))) {
    throw new Error(`document path escapes ${dirName}/ via symlink`);
  }

  return abs;
}

function isInside(dir, target) {
  const rel = path.relative(dir, target);
  return rel.length > 0 && !rel.startsWith("..") && !path.isAbsolute(rel);
}
