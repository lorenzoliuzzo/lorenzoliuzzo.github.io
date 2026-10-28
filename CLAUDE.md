# Working on this site

A Jekyll site (Minimal Mistakes remote theme) with a study archive at its core. Notes are
the product; most of the machinery exists to make them connected, sourced and checkable.

## Layout of the archive

- `_notes/<area>/<course>/<note>.md` are notes; `_data/courses/<slug>.yml` orders them into
  courses and parts; `_data/domains.yml` groups courses on `/notes/`. A note that is in no
  course shows up under "More notes".
- `_threads/<slug>.md` are essays that follow one idea across courses. Their `route` front
  matter names the notes they pass through.
- `_data/papers.yml` is the one bibliography. Cite with `{% cite id %}` or `{% citet id %}`;
  the reference list is built by the layout. `unverified: true` marks entries whose details
  have not been checked against the source; the linter warns until it is removed.
- `assets/notes/<course>/` holds the Typst reference (the precise layer behind the short
  notes), figure SVGs, data files and notebooks.

## Rules that are not obvious from the code

- **A note with an empty body is a planned note.** It is not published; it appears dashed in
  its course. Give it prose and it publishes; empty it and it retires. Do not add a `status`.
- **Provenance is derived, never declared.** `ai_generated` is the default. `human_verified`,
  `verified_at` and `verified_hash` are set only by the MyThingsLab drawer after the author
  has read a note end to end; never write them by hand. Editing a verified note clears the badge.
- **Never rename or delete a concept id** once another note `requires` it.
- **Courses marked `legacy: true`** are imported notes; the linter checks their structure only.
  Remove the flag when the notes have been rewritten to the standard.
- **Copyright.** Lecture slides and past exams stay in the gitignored paths described in
  `study/README.md`. Only extraction and synthesis may enter `_notes/`.
- **Sources.** Every theorem, named method, dataset and number taken from the literature is
  cited. Copy identifiers from the paper, never from memory.
- **Kinds of knowledge.** Statements in a note are typed blocks (`> text` then
  `{: .definition #def-x title="X"}`); the kinds and their layers (define, claim, justify,
  interpret, use, caution) are in `_data/knowledge.yml`, drawn by `_sass/_context.scss` and
  `_sass/_blocks.scss`, and listed on `/notes/knowledge/`. Every concept in `defines` gets a
  `.definition` whose `#id` is its `anchor`. Say what holds with `.property`, `.theorem`,
  `.law` or `.hypothesis`, what follows with `.implication`, where it is used with
  `.application` or `.example`. One claim per block; define symbols inside it.
  A block belongs to the concept of the definition above it, or to the ids in `about="id id"`.
  Each concept gets a page, `/concepts/<id>/` (definition, results with proofs, uses,
  pitfalls); the course page folds the same sheets into a formulary; `/notes/review/` is
  flashcards and `/notes/audit/` the curator's gap table. `ruby tools/knowledge.rb` prints
  the gaps, `--suggest` drafts definitions and `--apply <course>` makes the clean ones.
  Check every `--apply` definition reads as a full sentence before keeping it.
- **Six slots per concept**: define, claim, justify, instance, boundary, practice.
  `ruby tools/knowledge.rb --slots [course]` scores them. A claim block (`.theorem`, `.law`,
  `.property` and so on) needs a `.proof` or `.derive` after it, or a `{% cite %}` for a law
  taken from experiment; the linter warns when it has none. A `.trap` or `.rule` must name a
  concrete input that fails, not restate the claim.
- No em dashes in notes. No stock phrases (see the writing skill).

## Before you finish

```bash
ruby tools/check_notes.rb          # structure, ids, anchors, figures, citations, threads
ruby tools/test_citations.rb       # citation numbering and rendering
ruby tools/graph.rb --check        # /notes/map/ data; fix with --write
python3 tools/figures/build.py && git status --short   # figures up to date
bundle exec jekyll serve --livereload                  # look at /notes/, /threads/, /references/, /notes/status/
```

The skills in `.claude/skills/` hold the detailed standards: `write-site-note`,
`note-figure`, `plan-course-notes`, `write-typst-reference`.
