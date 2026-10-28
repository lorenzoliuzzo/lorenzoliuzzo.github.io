"""Graphical solution of m = tanh(b m): the line y = m against tanh curves of slope b = 0.6, 1, 1.5 and 2."""
import math
from kit import Fig


def build():
    f = Fig(760, 300)
    ax = f.axes(56, 20, 520, 226, (-1.5, 1.5), (-1.2, 1.2))
    ax.frame(xticks=(-1, 0, 1), yticks=(-1, 0, 1), xlabel="m", ylabel=None)
    ax.curve(lambda m: m, -1.2, 1.2, "f-line f-dash")
    for b, cls in ((0.6, "f-c-line"), (1.0, "f-d-line"), (1.5, "f-a-line"), (2.0, "f-b-line")):
        ax.curve(lambda m, b=b: math.tanh(b * m), -1.5, 1.5, cls)
    for b in (1.5, 2.0):
        m = 0.9
        for _ in range(200):
            m = math.tanh(b * m)
        ax.point(m, m, 4, "f-a-solid" if b == 1.5 else "f-b-solid")
        ax.point(-m, -m, 4, "f-a-solid" if b == 1.5 else "f-b-solid")
    f.legend(600, 50, [("slope 0.6", "f-c-line"), ("slope 1", "f-d-line"), ("slope 1.5", "f-a-line"), ("slope 2", "f-b-line"), ("y = m", "f-line f-dash")])
    f.text(600, 170, "Slope b = βzJ. Dots", "f-muted", 12.5)
    f.text(600, 188, "mark the nonzero solutions.", "f-muted", 12.5)
    return f
