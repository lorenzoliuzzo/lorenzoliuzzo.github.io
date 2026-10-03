# Note structure

Every note in a course follows the same order, so a reader always knows where to
look. The statistics notes are the reference examples.

1. **Front matter.** `collection`, `title`, `date`, `excerpt`, `read_time`, `tags`.
   Do not set `layout` or `permalink`: the collection defaults apply.
2. **Introduction (2 to 4 sentences).** What the note is about, why it matters, and
   what it builds on. Then one line pointing to the technical reference PDF if the
   course has one.
3. **`# Before you start`.** A three-column table of what the note assumes, and
   nothing else:

   | You should know | In one line | Where |
   |---|---|---|

   - one row per concept or notation the note leans on, 3 to 6 rows;
   - *In one line* is a reminder, not a definition (the definition lives in the note
     that introduced it);
   - *Where* links to the note and section that introduced the concept, with the
     heading's anchor (`#expectation`), or says "Assumed" for background maths;
   - use `\mid` for a conditional bar inside a table cell, never `|`.
4. **Body.** `#` sections, `##` subsections. Worked examples inline.
5. **`# Vocabulary`.** A two-column table of the terms *this note introduces*, one
   line each. Terms from earlier notes belong in Before you start, not here.
6. **`# Recap`.** A handful of bold questions, each answered in a sentence or two.
7. **`# Where this goes next`.** Links to the notes that use this one. The
   previous/next links at the bottom of the page come from `_data/courses.yml`;
   this section is for the reasons, and for other courses.

A new note also needs a line in `_data/courses.yml`, which is where its place in the
reading order is decided.
