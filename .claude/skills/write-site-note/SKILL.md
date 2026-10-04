---
name: write-site-note
description: Write, fill in, rewrite or split a study note for the course archive on this Jekyll site (_notes/<course>/<note>.md). Use whenever asked to write a note, turn a stub into a note, restructure or "clean" an existing note, or review one against the standard. Covers the reader and the path, front matter and concept ids, structure, prose rules, the component set (callouts, margin notes, figures, tables, recall cards) and the checks to run.
---

# Writing a site note

A site note is one step on a path through a course. It is read by its author, a Master's student in AI, who is studying from it, and it is one of many: the course is a sequence of notes, and the same material is also the raw material of a knowledge graph. The proofs and the exhaustive statements live in the course's Typst reference (see `write-typst-reference`); the note carries the understanding.

A good note does four things, in this order of importance:

1. **It leaves one thing in the reader's head** (the hook).
2. **It makes the path obvious**: what you need first, what you can do after, what to read next.
3. **It explains, in connected prose**, why each step follows from the last.
4. **It gives the facts to have at hand**: the formulas, the traps, the rules of thumb.

Reference examples, in the order to read them: `_notes/statistics/sampling-distributions.md` (the standard shape), `common-random-variables.md` (margin spec cards), `hypothesis-tests.md` (a figure that carries the argument), `probability-foundations.md` (no prerequisites).

## 1. Before writing anything

1. Open the course's data file, `_data/courses/<slug>.yml`. Find the note (or add it, see `plan-course-notes`). Read its neighbours: the note before it, the note after it, and the stub titles in the same part. Everything a note *requires* must be defined by an earlier note in that file.
2. Read the material the user points at (slides, book chapter). Decide, in writing, before drafting:
   - **the hook**: the single claim worth remembering if all else is forgotten;
   - **2 to 4 goals**: what the reader can *do* afterwards;
   - **the concepts it defines** (ids, section 3) and **the concepts it requires**;
   - **the anchor figure**: the one picture the note will be remembered by.
3. Size check. A note is about **700 to 1,300 words**, formulas and tables included (the linter warns above 1,500). If the plan has more than two big ideas or will not fit, split it and update the course file. A note that cannot state its hook in one sentence is two notes.
4. Order of work for new material: outline (hook, goals, concepts) → reference chapter in Typst → figure scripts → the note → checks. The note is a digest of the reference, never the other way round.

## 2. File anatomy

```markdown
---
collection: notes
title: "Sampling Distributions"
date: 2026-10-03
excerpt: "What the next reader gets from this note, in one sentence."
hook: "An estimate from one sample is one draw from a distribution; the sampling distribution says how far the next draw could land."
goals:
  - give the distribution of the sample mean, proportion and variance
  - choose between the normal, t, chi-square and F for a statistic
requires:
  - variance-of-a-sum
  - central-limit-theorem
defines:
  - {id: sampling-distribution, name: sampling distribution, anchor: what-a-sampling-distribution-is}
  - {id: student-t, name: Student's t, anchor: students-t}
read_time: true
tags:
  - Statistics
  - Inference
---

One or two sentences saying what the note gives you, ending with the link to the reference PDF.

# First section

...

# Recap

<details class="qa" markdown="1">
<summary>A question that needs a sentence to answer</summary>

The answer.
</details>
```

Rules for the file:

- **Never** set `layout` or `permalink` (the collection defaults apply) and **never** set `human_verified`, `verified_at` or `verified_hash`: those are the author's sign-off, recorded by the MyThingsLab drawer, and a note stays "AI-drafted" until they give it.
- The tags are `[Course area, Part]`, e.g. `Statistics`, `Inference`. They only matter for notes outside any course; the course order comes from the course file.
- A stub is a note with front matter and an **empty body**. The build keeps it out of the site and lists it as planned. A stub may already carry `defines`, so later notes can require its concepts.

## 3. Front matter, field by field

| Field | Rule |
|---|---|
| `excerpt` | One sentence, 15 to 30 words, written for the *next* reader: it is shown on the previous note's "Next step" card and in search. Say what the note gives, not what it "covers". |
| `hook` | One sentence, at most 35 words, one claim, concrete. Best form is a contrast: "X, not Y", "the 95% belongs to the procedure, not the interval". Markdown and `$math$` allowed. Shown as **The idea** in the header card. |
| `goals` | 2 to 4 items, each a verb phrase that completes "After this note you can ...": *derive*, *choose*, *explain why*, *compute*, *size*. No "understand" or "know about". |
| `requires` | Concept ids (not note names) this note uses beyond common maths. At most 8. Each must be defined by a **strictly earlier** note in the same course (or another course). The header card builds the "You need" table from this, grouped by source note, with links. Never list background maths. |
| `defines` | The concepts this note introduces, each `{id, name, anchor}`. At least 1, usually 3 to 8. `anchor` must be the auto-generated id of a heading in this note (kramdown: lower-case, punctuation dropped, spaces to hyphens). |

### Concept ids (the knowledge graph)

Every `defines` entry becomes a node of `/graph.json`; every `requires` entry an edge. The graph is only as good as the ids, so:

- An id names **one idea you could ask "what is X?" about**: `expectation`, `bayes-theorem`, `fisher-information`, `p-value`. Not a section title ("limit-theorems") and not a fact ("variance-of-a-sum" is acceptable only because it is a named, reusable identity).
- Lower-case, hyphenated, singular, the most standard English name. Abbreviations only when universal (`mle` no, `maximum-likelihood-estimator` yes; `cdf` yes).
- Unique across the whole site. The linter fails on a duplicate and the build warns.
- **Never rename or delete an id** once another note requires it. If you must, grep `_notes/` for it and fix every `requires`.
- A concept lives where it is *defined*, once. Later notes `require` it; they do not redefine it.
- Granularity: if two things are always used together (a pmf and a density), one id is fine; if a later note can need one without the other, split them.

## 4. Structure of the body

1. **Introduction** (before the first heading): one or two sentences, no summary of what follows. End with the reference link:
   `Proofs are in the [reference (PDF)]({{ '/assets/notes/<course>/<course>-reference/<course>-reference.pdf' | relative_url }}).`
2. **`#` sections**, 2 to 6 of them, each with a job (a step in the argument), 100 to 300 words. `##` only for parallel items (the distributions of a catalogue) or a genuine sub-step. No `###`.
3. **`# Recap`**: 2 to 4 recall cards (section 7).
4. **`# Where this goes next`**: only for links the course order does not give (other courses, later topics that reuse the note). The previous/next pager and the Next-step card come from the course file; do not repeat them.
5. A `# Vocabulary` section only when the note introduces many terms that need a one-line gloss. Usually omitted. **Never** a `# Before you start` section: the header card builds it.

Cross-links inside the course: `[Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}#limit-theorems)`. The target note must exist and the anchor must be one of its headings (the linter checks).

## 5. Prose rules

The note is for **studying**, not only lookup. It should read as if the author explained the topic to themselves.

- Connected paragraphs. Each step says *why* it is taken and how it leads to the next. Bullets and tables only for genuinely parallel items.
- Open each `#` section with the need it answers ("Often the conditional probabilities are easy to specify while the overall probability is not.") before the tool that meets it.
- Common maths and physics are assumed (sets, counting, calculus, linear algebra, series, convexity). Do not define or list them. A note keeps only the tools, observations and facts specific to its topic.
- Define a term in **bold** where it is first used, in the sentence that needs it.
- A worked example survives only if it carries an observation (a base-rate surprise, a biased MLE), never to illustrate a definition.
- Concrete numbers beat adjectives: "a standard error of 0.04, so measured accuracy lands between 0.72 and 0.88".
- No stock phrases: "it is worth noting", "in conclusion", "let's dive", "delve", "crucial", "key takeaway", "it is important to". No em dashes (use a comma, a colon or two sentences). No rhetorical-question openers, no exclamation marks. No generic "where it is used" lists.
- Sentences are plain and varied in length; first person plural ("we") for derivations is fine.

### Rhythm (what makes a page easy to stay on)

- No more than **two paragraphs in a row** without a display element: a formula, a table, a figure, a callout, a margin card.
- A formula is displayed (`$$ ... $$`) only if it is one the reader will use again; otherwise it stays inline.
- Every figure is introduced by the sentence before it and answers "what should I look at" in its caption.

## 6. What makes it stick

- **One hook per note**, in front matter, repeated nowhere else in the same words.
- **One anchor figure** per note (at most three): the picture the idea can be recalled from. Natural frequencies for Bayes, a coverage plot for confidence intervals, tails for the t distribution.
- **At most one `.idea` callout per `#` section** (it is the section's takeaway) and only when the section has a takeaway. If everything is a key idea, none is.
- **A `.trap` for each real misreading** (p-value as P(H0), uncorrelated vs independent). Traps are the most reused part of a note on re-reading.
- **Recall cards** phrase questions that need a sentence ("Why can an accurate test still give a low probability of disease?"), never "Define X". Answers are 1 to 3 sentences.
- Optional `.try` callout: one small thing to compute or simulate. Put the answer in a recall card.

## 7. Component catalogue

All components are plain Markdown plus a class, so the file stays readable. Styles are in `_sass/_blocks.scss`.

**Callouts**: a blockquote followed by an attribute line. The label is added by CSS; do not type it.

```markdown
> Four times the data halves the uncertainty.
{: .idea}
```

| Class | Label | Use | Limit |
|---|---|---|---|
| `.idea` | Key idea | the takeaway of a section | at most 1 per `#` section |
| `.trap` | Watch out | a common mistake and why it is one | as many as are real, usually 1 to 3 per note |
| `.rule` | Rule of thumb | a practical threshold or heuristic, with its caveat | 0 to 2 |
| `.derive` | Why it works | a short derivation or intuition, at most 5 lines; long proofs go to the reference | 0 to 2 |
| `.try` | Try it | one micro-exercise | 0 to 1 |

**Margin note and spec card** (shown beside the text on wide screens, inline on narrow ones). Place it *just before* the paragraph it annotates.

```markdown
> A frequentist reads P(A) as a long-run frequency, a Bayesian as a degree of belief.
{: .margin}

> **pmf** $\binom nk p^k(1-p)^{n-k}$  
> **Mean** $np$  
> **Variance** $np(1-p)$
{: .margin .spec}
```

Use a spec card for the facts to have at hand about a distribution or method (two trailing spaces end each line), and a margin note for an aside the argument does not depend on. If a page has no margin items its text column stays centred; if it has any, the column moves left. Margin items are decoration for wide screens: nothing essential may live only there.

**Figure** (needs a figure script, see `note-figure`):

```markdown
{% include fig.html src="statistics/clt" id="fig-clt" alt="What the figure shows, for a screen reader." caption="What to look at, and what it shows." %}
```
Add `place="margin"` for a small figure beside the text. `alt` and `caption` are required and at least a sentence; `$math$` is allowed in the caption.

**Tables**: plain Markdown. Headers are short nouns. At most 5 columns. Right-align numbers with `---:`. `{: .keyed}` on the line after a table makes the first column bold (lookup tables). Inside math in a cell use `\mid`, never `|` (the linter counts cells).

**Recall card**:

```markdown
<details class="qa" markdown="1">
<summary>Why is the sample maximum not normal?</summary>

It is tied to the boundary of the support, so it is skewed and biased.
</details>
```

**Equations**: `$...$` inline, `$$ ... $$` display. Operators spelled with `\operatorname{}`; `\mathbb{E}`, `\mathbb{P}` or `P` consistently within a course (follow the existing notes).

## 8. Layout and colour: what you do *not* control

The part colour, header card ("The idea", goals, prerequisites, path dots), "Next step" card, section numbering, contents rail, breadcrumbs and pager are generated from front matter and the course file (`_data/courses/<slug>.yml`). Do not recreate them in Markdown, do not add inline styles or HTML other than the recall-card `<details>`, and do not number headings by hand.

## 9. Checks (run all, fix everything)

```bash
ruby tools/check_notes.rb                                  # structure, ids, anchors, figures, tables
python3 tools/figures/build.py && git status --short        # figures up to date (no diff after the run)
LC_ALL=C.UTF-8 node --test tools/mythingslab/core.test.mjs  # repo suite
bundle exec jekyll build                                   # the site builds; look at /notes/ and the note
```

Look at the rendered page at a wide width (1440 px) and a phone width (390 px), light and dark. If the remote theme is unreachable, build with the gem theme as in the repository's notes on local builds. A page with raw `$...$` locally only means MathJax's CDN is blocked.

Then read the note once as the reader: Is the hook true and memorable? Does each section start from a need? Could a recall card be answered without having read the note (then it is a definition, rewrite it)? Is every `requires` really used?

## 10. Do not

- Copy textbook definitions of common maths, or pad with "where it is used".
- Put a proof longer than five lines in a note: it goes to the reference.
- Add more than three figures, or a figure that decorates instead of arguing.
- Repeat the header card's content (prerequisites, goals) in the body.
- Edit another note's `defines` ids, or reorder a course file, without being asked.
- Leave a stub's `defines` pointing at anchors that will not exist: the anchor is checked only once the note has a body.
