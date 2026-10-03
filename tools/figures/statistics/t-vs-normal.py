"""Heavier tails of Student's t: the 97.5% critical values."""
from kit import Fig
from dist import norm_pdf, t_pdf

CRIT = ((1.960, "f-a", "f-a-line", "1.96"), (2.228, "f-d", "f-d-line", "2.23"), (3.182, "f-b", "f-b-line", "3.18"))


def build():
    f = Fig(760, 312)
    # Left: the whole density. The curves are close, which is the point of the t.
    ax = f.axes(52, 22, 300, 224, (-5, 5), (0, 0.42))
    ax.frame(xticks=(-4, -2, 0, 2, 4), yticks=(0, 0.1, 0.2, 0.3, 0.4), xlabel="value", ylabel="density")
    ax.curve(lambda x: t_pdf(x, 3), cls="f-b-line")
    ax.curve(lambda x: t_pdf(x, 10), cls="f-d-line")
    ax.curve(norm_pdf, cls="f-a-line")
    # Right: the right tail, magnified ten times. This is where the intervals differ.
    bx = f.axes(420, 22, 300, 224, (1.8, 5), (0, 0.1))
    bx.frame(xticks=(2, 3, 4, 5), yticks=(0, 0.02, 0.04, 0.06, 0.08, 0.1), xlabel="right tail, magnified", ylabel=None)
    bx.curve(lambda x: t_pdf(x, 3), 1.8, 5, "f-b-line")
    bx.curve(lambda x: t_pdf(x, 10), 1.8, 5, "f-d-line")
    bx.curve(norm_pdf, 1.8, 5, "f-a-line")
    for q, text_cls, line_cls, label in CRIT:
        bx.vline(q, 0, 0.1, line_cls + " f-dash")
        anchor = {"1.96": "end", "2.23": "start", "3.18": "middle"}[label]
        shift = {"end": -4, "start": 4, "middle": 0}[anchor]
        f.text(bx.X(q) + shift, bx.Y(0.1) - 5, label, text_cls, 12.5, anchor, 600)
    f.text(52, 306, "Orange: t with 3 df.  Violet: t with 10 df.  Blue: normal.  Dashes: 97.5% critical values.", "f-muted", 12.5)
    return f
