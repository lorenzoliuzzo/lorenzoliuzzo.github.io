#!/usr/bin/env python3
"""One LLM call for the MyThingsLab drawer, routed through mythings.engine.

Not a CLI -- no argparse, no subcommands, nothing else should invoke this
except server.mjs's `child_process.spawn`. Reads one JSON request from stdin,
writes one JSON response to stdout:

  chat (default, or "mode": "chat"):
    in:  {"collection": "notes"|"library", "messages": [{"role", "content"}, ...],
          "query": "<latest question, unprefixed>", "doc_path": "<absolute path>"}
    out: {"text": "..."}                      on success (text may be empty)

  quiz ("mode": "quiz" -- server.mjs only takes this path once it has confirmed
  the note is verified; this script does not re-check that):
    in:  {"mode": "quiz", "doc_path": "<absolute path>", "topic": "<note title>",
          "questions": 3}
    out: {"text": "<rendered questions + sources>"}

  Either mode: {"error": "human-readable reason"} on failure, exit code 1.

Runs with the MyThingsLab fleet's shared venv interpreter (see
MYTHINGS_PYTHON in server.mjs), so `import mythings`/`import myprofessor`
resolve without any sys.path surgery here.

Set MYTHINGSLAB_ENGINE=noop to get NoopEngine instead of a real, billed
Claude call -- the zero-token path for testing the drawer end to end.
MYTHINGSLAB_NOOP_REPLY sets what it replies with (default: empty, which the
drawer already treats as an error, matching a real empty model reply).
"""

from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path

from mythings.corpus import Chunk, chunk as chunk_doc, cite, extract, ingest, shortlist
from mythings.engine import ClaudeCLIEngine, Engine, EngineRequest, MeteredEngine, NoopEngine
from mythings.ledger import Ledger
from myprofessor.professor import Lesson, load_corpus, quiz as run_quiz

REPO_ROOT = Path(__file__).resolve().parents[2]
MODEL = "claude-opus-4-8"

# What the assistant is editing changes what "better" means: a note is judged on
# whether the physics is right, a library entry on whether it says something true
# about a book he actually read. Everything else -- the patch protocol, the
# front-matter ban -- is shared. Ported verbatim from the deleted anthropic.mjs.
_PREAMBLE = {
    "notes": (
        "You help him sharpen study notes he publishes -- physics, machine learning, "
        "statistics -- that serve both as public work and as his own long-term memory.\n\n"
        "You are given the note's raw Markdown source. Your job is to make the writing "
        "clearer and the explanations more correct, not to rewrite it in your voice."
    ),
    "library": (
        "You help him write up the books in his library: what a book argued, what stuck, "
        "what he disagreed with. These are his own reactions to something he read, so the "
        "bar is his voice sharpened, never replaced.\n\n"
        "You are given the entry's raw Markdown source. Never invent a reaction, an opinion, "
        "or a detail of his reading he has not written down -- if a claim about the book is "
        "missing, say what is missing rather than filling it in. You may correct facts about "
        "the book itself: its argument, its publication details, who its author was."
    ),
}


def _collection_noun(collection: str) -> str:
    return "notes" if collection == "notes" else "library write-ups"


def system_prompt(collection: str) -> str:
    preamble = _PREAMBLE.get(collection)
    if preamble is None:
        raise ValueError(f"no system prompt for collection {collection!r}")
    collection_noun = _collection_noun(collection)

    return f"""You are MyThingsLab, an editing assistant built into Lorenzo Liuzzo's personal site.
{preamble}

Rules for the source text:
- Preserve Liquid tags ({{% include figure.html ... %}}, {{% include table.html ... %}}, bibliography
  includes) exactly. Never reword, reformat, or drop them.
- Preserve LaTeX/MathJax exactly unless the maths itself is what is wrong.
- Preserve the existing heading structure and reference links like [](#results) unless asked.
- Never edit the YAML front matter. Never write the keys human_verified, verified_at, or
  verified_hash -- those record a human review you cannot perform.

How to answer:
- Explain your reasoning briefly first, in prose. If a passage is unclear because the underlying
  idea is muddled, say so plainly rather than smoothing the prose over it -- he is using these
  pages to check his own understanding, so a fluent paragraph that hides a misconception is worse
  than an awkward one that exposes it.
- If he asks a question rather than requesting an edit, just answer it. Do not propose a patch.
- You may be given related passages from other {collection_noun} below the source, each marked
  with a citation like [doc-id:n]. If one of them is what your answer actually rests on, cite its
  marker inline. Never invent a marker that was not given to you, and never cite one just because
  it is there -- most turns will not need it.
- When you do propose a concrete edit, end your reply with exactly one fenced block:

```mythingslab-patch
{{"old_string": "<text copied verbatim from the source>", "new_string": "<replacement>"}}
```

  old_string must appear EXACTLY ONCE in the source, copied character for character including
  indentation and line breaks. Include enough surrounding context to be unique. Propose one patch
  per reply; if several changes are needed, do the most important one and offer the rest."""


def build_prompt(messages: list[dict]) -> str:
    # ClaudeCLIEngine takes one prompt string, not a Messages-API turn list, so the
    # conversation is flattened into a transcript -- the same shape a completion
    # model would be given. The turn structure (and the file source/selection
    # server.mjs already folds into the first turn's content) is preserved; only
    # the wire format changes from a list to text.
    turns = []
    for message in messages:
        speaker = "Assistant" if message.get("role") == "assistant" else "Human"
        turns.append(f"{speaker}: {message.get('content', '')}")
    return "\n\n".join(turns)


RELATED_TOP = 6
_FRONT_MATTER_RE = re.compile(r"\A---[ \t]*\r?\n.*?\r?\n---[ \t]*(?:\r?\n|\Z)", re.DOTALL)


def _extract_body(path: Path) -> str:
    # ingest()'s default extractor hands back the whole file. Front matter is
    # metadata, not prose -- left in, it chunks and cites like content (a doc's
    # very first chunk is routinely almost entirely the YAML block), which is
    # noise for a citation the model is meant to quote or reason from.
    return _FRONT_MATTER_RE.sub("", extract(path), count=1)


def related_context(collection: str, query: str, doc_path: str) -> str:
    # The drawer otherwise only ever sees the one file it was opened on -- every
    # turn re-sends exactly that document, so a question genuinely answered by
    # another note (or another book's write-up) gets nothing. mythings.corpus is
    # the fleet's own seam for exactly this ("shortlist from a corpus, then
    # cite" -- ADR 0001), reused rather than rebuilding retrieval in Node.
    #
    # No cached_extractor: that seam exists because pdftotext costs tens of
    # seconds per document (corpus.py's own docstring), and every file in this
    # corpus is plain Markdown -- extract() for a .md is just read_text(), so
    # caching it would add a directory and an invalidation story for a read
    # that is already free.
    root = REPO_ROOT / f"_{collection}"
    paths = sorted(root.rglob("*.md"))
    if not paths:
        return ""

    documents = ingest(paths, extractor=_extract_body)
    current = str(Path(doc_path).resolve())
    others = [d for d in documents if str(Path(d.path).resolve()) != current]
    if not others:
        return ""  # only the current document exists in this collection

    chunks: list[Chunk] = [c for doc in others for c in chunk_doc(doc)]
    if not chunks:
        return ""

    picked = shortlist(chunks, query, top=RELATED_TOP)
    citations = cite(picked, others)

    root_str = str(root.resolve())
    blocks = []
    for c, citation in zip(picked, citations, strict=True):
        doc = next(d for d in others if d.id == c.doc_id)
        rel_path = str(Path(doc.path).resolve()).removeprefix(root_str + "/")
        blocks.append(f"{citation.marker()} (_{collection}/{rel_path}):\n{c.text}")

    noun = _collection_noun(collection)
    return (
        f"\n\n<related-{collection}>\nPassages from other {noun} that scored relevant to "
        f"the question below. Not necessarily what you need -- most questions are answered by the "
        f"source above alone.\n\n" + "\n\n".join(blocks) + f"\n</related-{collection}>"
    )


def _render_lesson(lesson: Lesson) -> str:
    # Same shape as myprofessor's own CLI render (myprofessor/cli.py's
    # _render_lesson), reproduced rather than imported: that one is a leading-
    # underscore internal of a different package, and the drawer's chat log is a
    # plain-text bubble, not a terminal, so the heading underline it prints
    # doesn't carry over.
    lines = [f"Quiz: {lesson.topic}", ""]
    if lesson.questions:
        for i, question in enumerate(lesson.questions, 1):
            lines.append(f"{i}. {question.q}")
            if question.expects:
                lines.append(f"   (a correct answer should cover: {question.expects})")
        lines.append("")
    else:
        # Honest degrade (NoopEngine, an engine failure professor.quiz() already
        # swallows into an empty Lesson, or a note too short for the corpus seam
        # to shortlist anything): no fabricated questions, the excerpts instead.
        lines += ["(no questions came back -- here are the source excerpts instead)", "", lesson.excerpts, ""]
    if lesson.citations:
        lines.append("Sources:")
        for c in lesson.citations:
            lines.append(f"  {c.marker()} {c.title} (chars {c.start}-{c.end})")
    return "\n".join(lines).rstrip()


def handle_quiz(request: dict) -> str:
    doc_path = Path(request["doc_path"])
    topic = request.get("topic") or doc_path.stem
    questions = int(request.get("questions", 3))

    documents, chunks = load_corpus([doc_path], extractor=_extract_body)
    lesson = run_quiz(topic, documents, chunks, build_engine(tool="mythingslab-quiz"), questions=questions)
    return _render_lesson(lesson)


def build_engine(*, tool: str = "mythingslab") -> Engine:
    if os.environ.get("MYTHINGSLAB_ENGINE") == "noop":
        return NoopEngine(reply=os.environ.get("MYTHINGSLAB_NOOP_REPLY", ""))

    # Own ledger, local to this repo -- not the MyThingsLab fleet's shared one at
    # a different path on disk, which belongs to a different git history. Same
    # `.mythings/ledger.jsonl` convention every fleet tool defaults to. `tool`
    # distinguishes quiz spend from chat spend in that shared ledger.
    ledger = Ledger(REPO_ROOT / ".mythings" / "ledger.jsonl")
    return MeteredEngine(ClaudeCLIEngine(model=MODEL), ledger, tool=tool, model=MODEL)


def main() -> int:
    request = json.loads(sys.stdin.read())

    if request.get("mode") == "quiz":
        # myprofessor.professor.quiz() degrades an engine failure into an empty
        # Lesson itself (see _render_lesson's degrade branch) rather than raising,
        # so there is no is_error envelope to inspect here the way chat mode below
        # has one -- that resilience is the library's own design, not duplicated.
        print(json.dumps({"text": handle_quiz(request)}))
        return 0

    collection = request["collection"]
    messages = request["messages"]

    prompt = build_prompt(messages)
    query = request.get("query", "")
    doc_path = request.get("doc_path", "")
    if query and doc_path:
        prompt += related_context(collection, query, doc_path)

    engine = build_engine()
    result = engine.run(
        EngineRequest(
            system=system_prompt(collection),
            prompt=prompt,
            context={"collection": collection},
        )
    )

    if result.data.get("is_error"):
        # ClaudeCLIEngine discards its own stdout whenever `claude` exits nonzero,
        # even on a run that got as far as its own JSON envelope (confirmed: a
        # disabled-headless-access 403 exits 1 with a fully-formed, informative
        # `result` string on stdout, and only an empty proc.stderr survives into
        # `data`). So `stderr`/`result` are rarely populated for that case; the
        # returncode is the one thing that reliably is, and a hint beats silence.
        detail = result.data.get("stderr") or result.data.get("result")
        if not detail:
            code = result.data.get("returncode")
            detail = (
                f"claude CLI exited with status {code} and gave no further detail. "
                "Check `claude -p` works directly from a shell, and that either "
                "Claude Code has headless/API access enabled for this account, or "
                "ANTHROPIC_API_KEY is set."
            )
        print(json.dumps({"error": str(detail).strip()}))
        return 1

    print(json.dumps({"text": result.text}))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:  # noqa: BLE001 -- last-resort: never let a stray
        # traceback reach stdout where server.mjs expects exactly one JSON line.
        print(json.dumps({"error": str(exc)}))
        sys.exit(1)
