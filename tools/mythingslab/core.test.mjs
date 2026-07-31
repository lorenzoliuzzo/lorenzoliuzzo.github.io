import test from "node:test";
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

import {
  applyPatch,
  hashBody,
  normalizeBody,
  resolveNotePath,
  splitFrontMatter,
  touchesVerificationKeys,
  updateFrontMatter,
} from "./core.mjs";

const REPO_ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "..");

test("normalization collapses only insignificant whitespace", () => {
  assert.equal(normalizeBody("a\r\nb\r\n"), "a\nb");
  assert.equal(normalizeBody("a   \nb\t\t\n"), "a\nb");
  assert.equal(normalizeBody("\n\n\nbody\n\n\n"), "body");
  assert.equal(normalizeBody("﻿body"), "body");
  assert.equal(normalizeBody("old\rmac\r"), "old\nmac");

  // Interior blank lines are meaningful in Markdown — they separate paragraphs.
  assert.equal(normalizeBody("a\n\nb"), "a\n\nb");
});

test("hashing distinguishes real edits but ignores line-ending churn", () => {
  assert.equal(hashBody("Feynman diagrams\r\n"), hashBody("Feynman diagrams\n"));
  assert.notEqual(hashBody("notes are vital"), hashBody("notes are essential"));
  assert.match(hashBody("x"), /^sha256:[0-9a-f]{64}$/);
});

// The badge is only trustworthy if the Jekyll plugin and this tool agree on what
// "the same note" is. Divergence here would silently break every verification badge.
test("Ruby plugin and Node core produce identical hashes", () => {
  const cases = [
    "hello\n",
    "hello\r\nworld\r\n",
    "  trailing   \nand\ttabs\t\n",
    "\n\n\npadded\n\n\n",
    "﻿bom prefixed\n",
    "unicode: αβγ — ∫ψ†ψ\n",
    "## Heading\n\n{% include figure.html id=\"x\" %}\n\n$$E = mc^2$$\n",
    "",
    "no trailing newline",
  ];

  const script = `
    require "json"
    require_relative "_plugins/note_verification"
    puts JSON.generate(JSON.parse(ARGV[0]).map { |c| MyThingsLab::Verification.digest(c) })
  `;
  const rubyHashes = JSON.parse(
    execFileSync("ruby", ["-e", script, JSON.stringify(cases)], {
      cwd: REPO_ROOT,
      encoding: "utf8",
    }),
  );

  assert.deepEqual(rubyHashes, cases.map(hashBody));
});

test("patch applies only on an unambiguous single match", () => {
  const source = "alpha beta gamma";
  assert.equal(applyPatch(source, "beta", "delta").content, "alpha delta gamma");

  assert.equal(applyPatch(source, "zeta", "x").reason, "not_found");
  assert.equal(applyPatch("beta beta", "beta", "x").reason, "ambiguous");
  assert.equal(applyPatch(source, "", "x").reason, "empty_old_string");
  assert.equal(applyPatch(source, "beta", "beta").reason, "no_change");

  // A rejected patch must never produce content the caller could write out.
  assert.equal(applyPatch("beta beta", "beta", "x").content, undefined);
});

test("patch preserves Liquid includes and maths around the edit", () => {
  const source = '# T\n\n{% include figure.html id="d" %}\n\nAs $E = mc^2$ shows, this is vague.\n';
  const out = applyPatch(source, "this is vague", "mass and energy are equivalent");
  assert.ok(out.ok);
  assert.ok(out.content.includes('{% include figure.html id="d" %}'));
  assert.ok(out.content.includes("$E = mc^2$"));
});

test("front matter update replaces existing keys and appends missing ones", () => {
  const source = [
    "---",
    "title: \"Friedman Test\"",
    "tags:",
    "  - Supervised Learning",
    "human_verified: false",
    "---",
    "",
    "Body stays byte-identical.",
    "",
  ].join("\n");

  const out = updateFrontMatter(source, {
    human_verified: true,
    verified_hash: "sha256:abc123",
  });

  assert.match(out, /^human_verified: true$/m);
  assert.doesNotMatch(out, /^human_verified: false$/m);
  assert.match(out, /^verified_hash: "sha256:abc123"$/m);
  assert.equal(out.match(/^human_verified:/gm).length, 1);

  assert.equal(splitFrontMatter(out).body, splitFrontMatter(source).body);
  // The indented list item must not be mistaken for a top-level key.
  assert.ok(out.includes("  - Supervised Learning"));
});

test("front matter update refuses a note with no front matter", () => {
  assert.throws(() => updateFrontMatter("just a body\n", { human_verified: true }), /front matter/);
});

test("verification keys are recognised so the model cannot self-certify", () => {
  assert.ok(touchesVerificationKeys("human_verified: true"));
  assert.ok(touchesVerificationKeys("intro\nverified_hash: sha256:x\n"));
  assert.ok(!touchesVerificationKeys("The results were verified by hand."));
});

test("note paths are confined to _notes/", () => {
  const ok = resolveNotePath(REPO_ROOT, "supervised-learning/friedman-test.md");
  assert.equal(ok, path.join(REPO_ROOT, "_notes/supervised-learning/friedman-test.md"));

  for (const bad of [
    "../../etc/passwd",
    "../_config.yml",
    "/etc/passwd",
    "../../../../../../etc/hosts.md",
    "notes.txt",
    "",
  ]) {
    assert.throws(() => resolveNotePath(REPO_ROOT, bad), `should reject ${JSON.stringify(bad)}`);
  }

  // A path that escapes and comes back is fine; one that ends outside is not.
  assert.throws(() => resolveNotePath(REPO_ROOT, "sub/../../_pages/about.md"), /escapes/);
});
