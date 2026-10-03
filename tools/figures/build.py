#!/usr/bin/env python3
"""Render every figure script under tools/figures/<course>/ for the site and for Typst.

    python3 tools/figures/build.py              # all courses
    python3 tools/figures/build.py statistics   # one course

A figure script is tools/figures/<course>/<name>.py defining `build() -> Fig`. Outputs:

    _includes/fig/<course>/<name>.svg                          site (CSS classes, themed by the page)
    assets/notes/<course>/figures/<name>.svg                   print (embedded colours, for Typst)

Both outputs are committed: the Pages build has no Python. Rerun this after editing a
script and commit the two SVGs with it.
"""
import importlib.util
import pathlib
import sys

sys.dont_write_bytecode = True  # keep __pycache__ out of the tree

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
import kit  # noqa: E402


def main(courses):
    known = kit.known_classes()
    made = 0
    for course in sorted(p for p in HERE.iterdir() if p.is_dir() and not p.name.startswith("_")):
        if courses and course.name not in courses:
            continue
        for script in sorted(course.glob("*.py")):
            spec = importlib.util.spec_from_file_location(f"{course.name}_{script.stem}", script)
            mod = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(mod)
            fig = mod.build()
            unknown = fig.classes - known
            if unknown:
                sys.exit(f"{script}: unknown classes {sorted(unknown)}; add them to kit.py and _sass/_blocks.scss")
            site = ROOT / "_includes" / "fig" / course.name / f"{script.stem}.svg"
            prnt = ROOT / "assets" / "notes" / course.name / "figures" / f"{script.stem}.svg"
            for path, theme in ((site, "site"), (prnt, "print")):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(fig.svg(theme))
            made += 1
            print(f"{course.name}/{script.stem}")
    print(f"{made} figure(s)")


if __name__ == "__main__":
    main(set(sys.argv[1:]))
