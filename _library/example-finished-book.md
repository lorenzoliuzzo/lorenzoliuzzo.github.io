---
title: "Example — a book you have finished"
author: "Author Name"
published: 1998
shelf: "Physics"
status: read
finished: 2026-05-18
rating: 4
excerpt: "Placeholder entry. Replace it with a real book, or delete the file."
---

This is a scaffold entry, not something Lorenzo has read — swap the front matter and
this text for a real book, or delete the file.

The front matter above is the whole schema:

| Key | Meaning |
|---|---|
| `title` | The book. Required. |
| `author` | Shown under the title on the card and the page. |
| `published` | Year of original publication. Optional. |
| `shelf` | Which section of `/library/` the book files under. Books with no shelf land in **Unshelved**. |
| `status` | `read` or `reading`. Defaults to `read`. |
| `finished` | Date you finished it. Omit it and the card just says "Read". |
| `started` | Date you picked it up. Only shown while `status: reading`. |
| `rating` | 1–5, drawn as stars. Omit it to show none. |
| `excerpt` | One line, shown on the archive card. |

Below the front matter is the write-up: what the book argued, what stuck, what you
disagreed with. It is ordinary Markdown, so figures, tables and MathJax all work the
same way they do in a note.

Run `jekyll serve` and the local authoring drawer opens on this page too — select a
passage to talk about it, apply edits straight to this file, and sign the write-up
off as human-verified when you have read it back.
