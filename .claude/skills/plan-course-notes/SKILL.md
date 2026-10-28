---
name: plan-course-notes
description: Plan or extend the structure of a course on this site: the course's data file (_data/courses/<slug>.yml), its domain, its parts and the notes in reading order, the stubs with their concept ids, and how the course will map to a Typst reference and a knowledge graph. Use when starting a new course, adding or splitting notes, reordering a course, filling in the stubs of an existing one, or reviewing whether a course reads as a path.
---

# Planning a course

A course is the unit the reader studies and the unit of the knowledge graph. It is a **path**: parts (a few notes that belong together), notes in reading order, each note requiring only what came before. The path, the numbering, the colours, the prerequisites table, the "Next step" card and `/graph.json` and the shelf, the course page and the glossary are all generated from two things you write: the course's data file `_data/courses/<slug>.yml` and each note's front matter. Planning a course means getting those two right *before* writing prose.

## 1. The course file and the domain

The notes shelf (`/notes/`) lists the courses, grouped by **domain** (`_data/domains.yml`: Artificial Intelligence, Physics, Mathematics). Each course has its own page at `/notes/<slug>/` with its parts, what each note gives and how it connects to other courses. A new course is one file, `_data/courses/<slug>.yml`; the file name is the slug.

```yaml
domain: mathematics            # an id from _data/domains.yml
order: 1                       # position within its domain on the shelf (optional)
title: "Statistics and Statistical Learning"
short: "Statistics"            # optional, for the glossary and other tight places
summary: "One sentence on what the course covers and in what order."
reference: /assets/notes/statistics/statistics-reference/statistics-reference.pdf   # optional
parts:
  - title: "Inference"
    blurb: "From a sample back to the mechanism: how far an estimate can be off, how to build one, and how to decide between claims."
    notes:
      - statistics/sampling-distributions
      - statistics/point-estimation
```

- **Courses** are the course as taught or as the author studies it (one merged course if the lectures are one). Their number is expected to grow into the dozens: keep `summary` to one sentence (it is the card's text, three lines at most), and keep the title short enough to fit a card.
- **Domain**: pick by topic, not by degree. A new domain is a block in `_data/domains.yml` (`id`, `title`, `blurb`, `hue` 1 to 6 from `_sass/_tokens.scss`).
- **Parts**: 2 to 6 notes each, 3 to 7 parts per course (a small course may have one). A part title is one or two words. The `blurb` is one sentence, at most 25 words, saying what the part lets you do. Parts take colours in order (the sixth hue repeats after six).
- **Order is the dependency order.** A note may require only concepts defined by earlier notes. When two orders are possible, put the one that lets the reader use a result sooner first. The linter fails on a forward `requires`.
- Paths are `_notes/` relative, no extension. A note listed here and absent on disk is an error; a note listed in two courses is an error; a note on disk and in no course is a warning (the shelf lists it under "More notes").
- **`legacy: true`** marks a course whose notes were imported before the standard existed. They are listed and linked like any other, but the linter checks only the structure, not the note standard. Remove the flag when the notes have been rewritten (`write-site-note`).
- Do not reorder or rename existing entries without being asked: other notes' links and `requires` depend on them.
- **Cross-course links appear by themselves.** When a note `requires` a concept that another course defines, the course page shows "Builds on" and "Leads to" and the card shows a link count. Nothing to write.

## 2. Stubs

Create each planned note as `_notes/<course>/<slug>.md` with front matter and **no body**:

```yaml
---
collection: notes
title: "Linear Regression"
date: 2026-10-03
excerpt: "Least squares, inference on coefficients, ANOVA and the F-test, diagnostics and leverage."
tags:
  - Statistics
  - Regression
defines:
  - {id: least-squares, name: least squares, anchor: least-squares}
  - {id: leverage, name: leverage, anchor: diagnostics}
---
```

The build keeps a stub off the site and lists it as planned; the path dots show it dashed. Naming its `defines` now lets earlier and later notes plan their `requires` against the whole course, and gives the graph its skeleton. Anchors in a stub are intentions: they are checked once the note has a body.

## 3. Sizing and splitting

- A note carries **one idea and 700 to 1,300 words**. If a lecture covers three ideas, it becomes three notes.
- Split when a note needs more than two big sections, when two halves have different prerequisites, or when a later note needs one half but not the other.
- Merge when a note would be under about 500 words and its only job is to introduce the next one.
- The reference chapter does not have to follow the notes one to one; the chapter's `notes-line` records the mapping.

## 4. Concept map before prose

Before writing a part, list for each note: the hook, the goals, the concepts defined, the concepts required. Check:

- every required concept is defined earlier (or in another course);
- every defined concept is used by some later note or is a deliberate dead end (a result for its own sake);
- each part has a small number of entry points (concepts the rest of the part needs), and those are defined in the part's first note;
- the goals of a note are the natural prerequisites of the next: if not, the order is wrong or a note is missing.

A gap shows up as a `requires` that points nowhere. Add a stub for it rather than weakening the requirement.

## 5. The path as the reader sees it

Check the result in the browser: the shelf lists the course under its domain; the course page shows the parts with each note's excerpt (so every note needs a good `excerpt`), and the connections; a note shows the path dots, header card and Next-step card. Read the first three notes of the course in order as a new reader: is every "You need" row satisfied by what you have already read? Does the Next-step card sell the next note (its `excerpt`)? Fix the data, not the layout.

## 6. Order of work for a whole course

1. Plan: the course file (and its domain), stubs with `defines`, concept map.
2. Reference chapters for the first part (`write-typst-reference`), with figures (`note-figure`).
3. Notes of that part, in order (`write-site-note`).
4. `ruby tools/check_notes.rb`, build, look. Then the next part.

Do one part at a time. Do not draft the whole course at once: the first part teaches what the standard needs to be.
