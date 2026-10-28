import test from "node:test";
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import {
  EDITABLE_COLLECTIONS,
  applyPatch,
  frontMatterValue,
  hashBody,
  isVerified,
  normalizeBody,
  resolveDocPath,
  splitFrontMatter,
  touchesVerificationKeys,
  updateFrontMatter,
} from "./core.mjs";

const REPO_ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "..");
const TOOL_DIR = path.join(REPO_ROOT, "tools", "mythingslab");
const MYTHINGS_PYTHON =
  process.env.MYTHINGS_PYTHON || "/home/lollinux/Desktop/MyThingsLab/.venv/bin/python";

// shim.py needs the MyThingsLab fleet's venv (for `import mythings`) present on the
// machine running the suite -- true on the author's box, not guaranteed on an
// arbitrary CI runner. Skip rather than fail red for an absent dependency this repo
// does not own, the same "honest degrade" every NoopEngine-backed tool already uses.
const hasMythingsPython = fs.existsSync(MYTHINGS_PYTHON);

// Exercises the actual wire contract server.mjs depends on -- stdin JSON in, stdout
// JSON out -- rather than importing shim.py's functions directly (it's Python; this
// suite is Node). MYTHINGSLAB_ENGINE=noop keeps it at zero token cost, same knob the
// manual browser verification used.
test(
  "shim.py round-trips a request through the noop engine",
  { skip: !hasMythingsPython && "MyThingsLab venv not present on this machine" },
  () => {
    const request = {
      collection: "notes",
      messages: [{ role: "user", content: "File: _notes/physics/special-relativity.md\n\n---\n\nhi" }],
      query: "hi",
      doc_path: path.join(REPO_ROOT, "_notes", "physics", "special-relativity.md"),
    };
    const raw = execFileSync(MYTHINGS_PYTHON, [path.join(TOOL_DIR, "shim.py")], {
      input: JSON.stringify(request),
      cwd: REPO_ROOT,
      encoding: "utf8",
      env: { ...process.env, MYTHINGSLAB_ENGINE: "noop", MYTHINGSLAB_NOOP_REPLY: "pong [x:0]" },
    });
    assert.deepEqual(JSON.parse(raw), { text: "pong [x:0]" });
  },
);

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

// Both keys are already set for these collections by _config.yml's defaults —
// `layout: single`, and a `/:collection/:path/` permalink derived from where the
// file sits. Pinning either in front matter can only override that, and a wrong
// override fails silently: Jekyll logs one "Build Warning: Layout 'note' ... does
// not exist" among 240 Sass deprecation warnings, exits 0, and writes a 166-byte
// page with no masthead, no stylesheet and no provenance badge. Measured, not
// assumed. A drafting tool that opens a PR which auto-merges on a green build
// would ship exactly that, so "green" has to mean more than "exit 0".
//
// `layout: single` is tolerated because 21 existing notes pin it redundantly;
// anything else, and any permalink at all, is a mistake.
test("no page overrides the layout or permalink its collection already sets", () => {
  const script = `
    require "date"
    require "json"
    require "yaml"

    FRONT_MATTER = /\\A---[ \\t]*\\r?\\n(.*?)\\r?\\n---[ \\t]*(?:\\r?\\n|\\z)/m

    offenders = Dir.glob("{_notes,_library}/**/*.md").sort.flat_map do |path|
      match = FRONT_MATTER.match(File.read(path)) or next []
      data = YAML.safe_load(match[1], permitted_classes: [Date, Time]) || {}
      found = []
      layout = data["layout"]
      found << [path, "layout: #{layout}"] if layout && layout != "single"
      found << [path, "permalink: #{data["permalink"]}"] if data.key?("permalink")
      found
    end
    puts JSON.generate(offenders)
  `;
  const offenders = JSON.parse(
    execFileSync("ruby", ["-e", script], { cwd: REPO_ROOT, encoding: "utf8" }),
  );

  assert.deepEqual(
    offenders,
    [],
    "Drop the key and let _config.yml's collection defaults apply:\n" +
      offenders.map(([p, what]) => `  ${p} — ${what}`).join("\n"),
  );
});

// The badge is a mechanism that has to be *enforced* to mean anything: nothing
// stops an edit landing on a page someone already signed off, and the claim would
// then sit there looking green in the archive listing. This is that enforcement —
// it runs over the real collections, in CI, on every PR.
//
// It deliberately does not fail on "unverified". That is the honest state of most
// of this site and gating on it would fail every PR from day one, so the check
// would be switched off within a week. It fails only where a page asserts a human
// review that cannot be substantiated:
//
//   stale    — verified, then the text changed underneath the hash
//   unlocked — verified with no hash at all, so the claim is uncheckable
//
// Both, not just stale: if only stale failed, the way to silence a red build would
// be to delete the verified_hash line, which converts a caught regression into an
// unfalsifiable claim. Same rule, two spellings.
test("no page claims a human review it cannot substantiate", () => {
  const script = `
    require "date"
    require "json"
    require "yaml"
    require_relative "_plugins/note_verification"

    FRONT_MATTER = /\\A---[ \\t]*\\r?\\n(.*?)\\r?\\n---[ \\t]*(?:\\r?\\n|\\z)/m

    offenders = Dir.glob("{_notes,_library}/**/*.md").sort.filter_map do |path|
      source = File.read(path)
      match = FRONT_MATTER.match(source) or next
      # Jekyll hands the plugin doc.content — the body with front matter stripped —
      # so the hash must be taken over exactly that, not the whole file.
      data = YAML.safe_load(match[1], permitted_classes: [Date, Time]) || {}
      body = source[match[0].length..] || ""
      state = MyThingsLab::Verification.state_for(data, body)
      [path, state] unless %w[verified unverified].include?(state)
    end
    puts JSON.generate(offenders)
  `;
  const offenders = JSON.parse(
    execFileSync("ruby", ["-e", script], { cwd: REPO_ROOT, encoding: "utf8" }),
  );

  assert.deepEqual(
    offenders,
    [],
    "Re-read each page and re-sign it from the drawer, or drop the claim:\n" +
      offenders.map(([p, state]) => `  ${p} — ${state}`).join("\n"),
  );
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

// /api/apply stamps ai_generated onto a note straight after patching its body, so
// the two claims the front matter carries must stay independent: recording that a
// model touched the page can neither forge a verification nor clear one.
test("stamping provenance leaves the verification hash untouched", () => {
  const source = [
    "---",
    'title: "Spin"',
    "human_verified: true",
    'verified_hash: "sha256:whatever"',
    "---",
    "",
    "The body the badge is locked to.",
    "",
  ].join("\n");

  const before = hashBody(splitFrontMatter(source).body);
  const stamped = updateFrontMatter(source, { ai_generated: true });

  assert.match(stamped, /^ai_generated: true$/m);
  assert.equal(hashBody(splitFrontMatter(stamped).body), before);
  // Stamping is not a sign-off: it must not touch what the human recorded.
  assert.match(stamped, /^human_verified: true$/m);
  assert.match(stamped, /^verified_hash: "sha256:whatever"$/m);

  // Re-applying is idempotent — a note edited repeatedly gets one key, not five.
  const twice = updateFrontMatter(stamped, { ai_generated: true });
  assert.equal(twice.match(/^ai_generated:/gm).length, 1);
});

test("frontMatterValue reads a flat scalar and ignores nested list values", () => {
  const source = [
    "---",
    'title: "Hydrogen Atom"',
    "tags:",
    "  - Physics",
    "  - Quantum Mechanics",
    "human_verified: true",
    "---",
    "",
    "Body.",
    "",
  ].join("\n");

  assert.equal(frontMatterValue(source, "title"), "Hydrogen Atom");
  assert.equal(frontMatterValue(source, "human_verified"), "true");
  // "tags" is a nested list, not a flat scalar -- this reader must not mistake
  // an indented list item for the key's value.
  assert.equal(frontMatterValue(source, "tags"), "");
  assert.equal(frontMatterValue(source, "no_such_key"), null);
  assert.equal(frontMatterValue("no front matter here", "title"), null);
});

// The gate a server-side action (quizzing) checks before running, so it has to
// agree with the badge on exactly what "verified" means -- unverified, staled by
// an edit, and "unlocked" (verified with no hash to check) must all read as false.
test("isVerified agrees with the badge's own verified/stale/unlocked states", () => {
  const verified = [
    "---",
    'title: "Spin"',
    "human_verified: true",
    `verified_hash: "${hashBody("The body.\n")}"`,
    "---",
    "",
    "The body.",
    "",
  ].join("\n");
  assert.ok(isVerified(verified));

  const stale = verified.replace("The body.\n", "An edited body.\n");
  assert.ok(!isVerified(stale));

  const unlocked = [
    "---",
    'title: "Spin"',
    "human_verified: true",
    "---",
    "",
    "The body.",
    "",
  ].join("\n");
  assert.ok(!isVerified(unlocked));

  const unverified = ["---", 'title: "Spin"', "---", "", "The body.", ""].join("\n");
  assert.ok(!isVerified(unverified));
});

test("front matter update refuses a note with no front matter", () => {
  assert.throws(() => updateFrontMatter("just a body\n", { human_verified: true }), /front matter/);
});

test("verification keys are recognised so the model cannot self-certify", () => {
  assert.ok(touchesVerificationKeys("human_verified: true"));
  assert.ok(touchesVerificationKeys("intro\nverified_hash: sha256:x\n"));
  assert.ok(!touchesVerificationKeys("The results were verified by hand."));
});

test("document paths are confined to their own collection directory", () => {
  assert.equal(
    resolveDocPath(REPO_ROOT, "notes", "supervised-learning/friedman-test.md"),
    path.join(REPO_ROOT, "_notes/supervised-learning/friedman-test.md"),
  );
  assert.equal(
    resolveDocPath(REPO_ROOT, "library", "example-bare-entry.md"),
    path.join(REPO_ROOT, "_library/example-bare-entry.md"),
  );

  for (const collection of EDITABLE_COLLECTIONS) {
    for (const bad of [
      "../../etc/passwd",
      "../_config.yml",
      "/etc/passwd",
      "../../../../../../etc/hosts.md",
      "notes.txt",
      "",
    ]) {
      assert.throws(
        () => resolveDocPath(REPO_ROOT, collection, bad),
        `${collection} should reject ${JSON.stringify(bad)}`,
      );
    }

    // A path that escapes and comes back is fine; one that ends outside is not.
    assert.throws(() => resolveDocPath(REPO_ROOT, collection, "sub/../../_pages/about.md"), /escapes/);
  }

  // One collection must not be a way into another, nor into an arbitrary directory.
  assert.throws(() => resolveDocPath(REPO_ROOT, "library", "../_notes/logic/fuzzy.md"), /escapes/);
});

test("only the declared collections are addressable", () => {
  assert.deepEqual(EDITABLE_COLLECTIONS, ["notes", "library"]);

  for (const bad of ["projects", "pages", "plugins", "", null, undefined, "_notes", "../tools"]) {
    assert.throws(
      () => resolveDocPath(REPO_ROOT, bad, "anything.md"),
      /collection must be one of/,
      `should reject collection ${JSON.stringify(bad)}`,
    );
  }
});
