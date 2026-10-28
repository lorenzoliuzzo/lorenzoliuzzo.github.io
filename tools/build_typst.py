#!/usr/bin/env python3
"""Compile the technical references (assets/notes/<course>/<course>-reference/*.typ) to PDF.

    pip install typst
    python3 tools/build_typst.py                    # all courses
    python3 tools/build_typst.py statistics         # one course
    python3 tools/build_typst.py statistics --png /tmp/pages   # also write one PNG per page, to look at

The compile root is assets/notes, so a reference imports the shared style as
"../../_typst/note-style.typ" and its figures are written "/<course>/figures/<name>.svg".
Commit the PDF with the source: the Pages build has no Typst.
"""
import pathlib
import sys

import typst

ROOT = pathlib.Path(__file__).resolve().parent.parent
NOTES = ROOT / "assets" / "notes"


def main(argv):
    png_dir = None
    if "--png" in argv:
        i = argv.index("--png")
        png_dir = pathlib.Path(argv[i + 1])
        argv = argv[:i] + argv[i + 2:]
    courses = set(argv)
    for src in sorted(NOTES.glob("*/*-reference/*.typ")):
        course = src.parent.parent.name
        if courses and course not in courses:
            continue
        typst.compile(str(src), output=str(src.with_suffix(".pdf")), root=str(NOTES))
        print(src.relative_to(ROOT), "->", src.with_suffix(".pdf").name)
        if png_dir:
            png_dir.mkdir(parents=True, exist_ok=True)
            pages = typst.compile(str(src), root=str(NOTES), format="png", ppi=70)
            for n, data in enumerate(pages, 1):
                (png_dir / f"{src.stem}-{n:02d}.png").write_bytes(data)


if __name__ == "__main__":
    main(sys.argv[1:])
