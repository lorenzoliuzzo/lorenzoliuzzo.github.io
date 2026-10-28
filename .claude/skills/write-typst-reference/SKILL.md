---
name: write-typst-reference
description: Write or extend a course's Typst technical reference (assets/notes/<course>/<course>-reference/*.typ and its PDF). Use when asked to add a chapter or section to a reference, state or prove a result, add a formula table, set up a reference for a new course, or review a reference against the standard. The reference is the complete, precise layer behind the short site notes.
---

# Writing a Typst technical reference

Each course has **one** reference PDF. It is the complete layer: precise statements, proofs of the results an exam is likely to ask for, the formulas gathered in tables. The site notes (see `write-site-note`) explain and stay short; the reference states and proves and can be as long as the course needs. It is also the detailed layer under the knowledge graph: every definition and theorem carries the same concept id as the site note that introduces it.

Reader: the author, checking a formula, reviewing a proof, or preparing for an exam. They already read the site note. The reference is **not a tutorial**: no motivation paragraphs, no analogies, no "intuitively". It is terse, exact and impersonal ("we" in proofs is fine).

Existing example: `assets/notes/statistics/statistics-reference/statistics-reference.typ`. Shared style: `assets/notes/_typst/note-style.typ`. Read both before writing.

## 1. Layout of the files

```
assets/notes/_typst/note-style.typ                 shared template, same for every course
assets/notes/<course>/<course>-reference/<course>-reference.typ   the source
assets/notes/<course>/<course>-reference/<course>-reference.pdf   the build, committed
assets/notes/<course>/figures/<name>.svg           print figures, generated (see `note-figure`)
```

The compile root is `assets/notes`. A reference starts with:

```typst
#import "../../_typst/note-style.typ": *

#show: reference.with(
  title: "Course Title",
  subtitle: "Technical reference",
  abstract: [One or two sentences: what it covers and how it relates to the notes.],
  site: "https://lorenzoliuzzo.github.io/notes/",
)

#let notes = "https://lorenzoliuzzo.github.io/notes/<course>/"
```

`reference` sets the page, type, running header (course title and current chapter), numbered headings, title block and contents. Do not re-set page, text or heading styles in the course file; if the style needs to change for every course, change `note-style.typ`.

A new course also needs `reference: /assets/notes/<course>/<course>-reference/<course>-reference.pdf` in the course's data file `_data/courses/<slug>.yml` (it becomes the PDF button on the course page, the badge on its shelf card and the link in each note's introduction).

## 2. Structure

- **Chapters** (`=`) follow the logical order of the subject, not necessarily one chapter per site note. Right under each chapter heading put
  `#notes-line(notes, ("Note title", "note-slug"), ...)` naming the site notes that explain it. That line is the mapping between the two layers.
- **Sections** (`==`) are one topic each, 1 to 2 pages. Use `=== ` sparingly.
- Order inside a section: the **definition**, the **theorem(s)**, the **proof(s)**, then **examples** and **remarks**. Results are stated before they are proved; proofs are not interleaved with prose.
- The last chapter is a **summary of formulas**: `#formulas(("Quantity", "Result", "Where explained"), ...)`, one row per result worth having at hand, the third column linking to the site note and anchor (`#link(notes + "slug/#anchor")[Note title]`). For long references add a `#formulas` table at the end of a chapter too.
- A **References** chapter at the end: the textbooks and papers, each with a clause saying what to use it for.

## 3. Environments (from the template)

| Function | Use |
|---|---|
| `#definition(title: [...], id: "concept-id")[...]` | a definition. `id` is the site concept id (it attaches a label, so the graph can link both layers) |
| `#theorem(title: [...], id: "...")[...]`, `#lemma(...)` | a result, stated precisely with all hypotheses |
| `#proof[...]` | ends with a square; short, complete, no skipped step an exam would want |
| `#example(title: [...])[...]` | only if it adds an observation or a computation to remember |
| `#remark[...]` | a caveat or a pointer |
| `#key[...]`, `#trap[...]`, `#rule[...]` | the same three callouts as on the site, one line each, at most one or two per chapter. A `#trap` here must correspond to a `.trap` in the note |
| `#fig("/<course>/figures/<name>.svg", caption: [...], width: 88%)` | a figure, same script as on the site |

Colours match the site's hues (blue = definition and key idea, violet = theorem, green = example and rule of thumb, orange = trap). Do not introduce colours.

## 4. Rules for the mathematics

- State **every hypothesis**: finite variance, independence, $n>1$, "for every $\theta$". A result without its conditions is a bug here.
- **Prove** what an exam would ask for and what is short; **state with a reference** (`see Casella and Berger, thm 5.5.9`) what is long or standard. Never claim a proof you skipped; say "proof omitted" with a pointer.
- Operators and shorthands come from the template: `EE`, `PP`, `Var`, `Cov`, `MSE`, `bias`, `se`, `argmax`, `iid`, `cd` (converges in distribution), `cp` (in probability). Add course-specific ones near the top of the course file, not in the template. Use them consistently and spell the same quantity the same way in the site notes.
- Number only the equations that are referenced (`<label>` and `@label`). Use `slash` for inline fractions, `/` only inside display fractions.
- Quantiles and critical values: give the numbers that recur (z_0.975 = 1.960) once, in the section that introduces them.
- Keep section titles stable. The site notes link to the PDF, and the summary table links back to the site by anchor; a renamed section is a broken mapping.

## 5. Figures

Use the same figure as the site note: write it once in `tools/figures/<course>/<name>.py` (see `note-figure`), which emits the print SVG this reference includes. One figure per section at most, only where it shows what words and formulas cannot (shape of a distribution, geometry of an estimator, a coverage experiment). The caption is self-contained: it says what the figure shows and what to notice, because the PDF has no surrounding note.

## 6. Build and check

```bash
pip install typst
python3 tools/figures/build.py <course>            # if figures changed
python3 tools/build_typst.py <course> --png /tmp/pages   # PDF next to the source, one PNG per page
```

Open two or three page PNGs (a definition-heavy page, a figure page, the formula table). Check: no overfull lines, no orphaned captions, boxes do not split awkwardly, links are blue, the contents match the chapters. Commit the PDF with the source.

## 7. Do not

- Explain what the reader should already know from the note; link to it with `notes-line`.
- Copy site prose into the reference or vice versa. If a paragraph reads fine in both, it belongs in one.
- Leave a theorem without hypotheses or a `proof`/pointer.
- Change the shared template for one course's taste, add decorative boxes, or put colour in a figure script.
- Forget to rebuild the PDF after editing the `.typ` (the site links to the committed PDF).
