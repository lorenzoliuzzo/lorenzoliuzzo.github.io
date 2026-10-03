# Note structure

These are personal notes. Common maths (sets, counting, calculus, linear algebra,
series, convexity) and common physics are assumed known and are not explained or
listed as prerequisites. A note keeps only the tools, observations and useful facts
specific to its topic: the formulas to have at hand, the traps, the rules of thumb.
No textbook definitions, no worked toy examples, no generic "where it is used" lists.

The notes are for studying, not only for lookup, so they are written as connected
prose, the way you would explain the topic to yourself: say why a step is taken and
how one idea leads to the next, and use bullets and tables only for genuinely
parallel items (a list of rules, a choice table). Avoid telegraphic fragments, stacks
of bold lead-ins and stock phrases. The statistics notes are the reference examples.

Order, every part optional except the first three:

1. **Front matter.** `collection`, `title`, `date`, `excerpt`, `read_time`, `tags`.
   Do not set `layout` or `permalink`: the collection defaults apply.
2. **Introduction: one or two sentences** saying what the note gives you, ending with
   the link to the course's technical reference PDF if it has one. No summary of the
   sections that follow, no "this note shows...".
3. **`# Before you start`.** A two-column table, only the concepts this note needs from
   earlier notes, each linked to the note and section that introduced it:

   | You should know | Where |
   |---|---|

   Omit the section when there is nothing to list. Never list background maths.
   Use `\mid` for a conditional bar inside a table cell, never `|`.
4. **Body.** `#` sections, `##` subsections. Define a term in bold where it is first
   used. Keep a worked example only if it carries an observation (a base-rate
   surprise, a biased MLE), not to illustrate a definition.
5. **`# Vocabulary`.** Only for terms specific enough to need a one-line gloss, and
   only if the note introduces several. Usually omitted.
6. **`# Recap`.** One to four bold questions on the non-obvious points and traps, each
   answered in a sentence or two. Do not re-ask the definitions.
7. **`# Where this goes next`.** Only for links that the course order does not already
   give (other courses, later topics that reuse the note). The previous/next pager
   comes from `_data/courses.yml`.

A new note also needs a line in `_data/courses.yml`, which is where its place in the
reading order is decided.
