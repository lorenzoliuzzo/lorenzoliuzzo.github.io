"""One wiggly curve, three fits: a global cubic polynomial misses the shape, a cubic spline with three knots follows it."""
import math
import random
from kit import Fig
from linalg import lstsq

KNOTS = (0.25, 0.5, 0.75)


def truth(x):
    return math.sin(2 * math.pi * x) + 0.6 * x


def data():
    rng = random.Random(11)
    xs = [(i + 0.5) / 40 for i in range(40)]
    return xs, [truth(x) + rng.gauss(0, 0.28) for x in xs]


def poly_row(x):
    return [1, x, x * x, x ** 3]


def spline_row(x):
    return poly_row(x) + [max(x - k, 0) ** 3 for k in KNOTS]


def build():
    xs, ys = data()
    bp = lstsq([poly_row(x) for x in xs], ys)
    bs = lstsq([spline_row(x) for x in xs], ys)
    f = Fig(760, 300)
    ax = f.axes(52, 22, 520, 232, (0, 1), (-1.6, 1.9))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1), yticks=(-1, 0, 1), xlabel="x", ylabel="y")
    for k in KNOTS:
        ax.vline(k, -1.6, 1.9, "f-grid f-dash")
    for x, y in zip(xs, ys):
        ax.point(x, y, 2.8, "f-faint")
    ax.curve(truth, cls="f-c-line f-dash")
    ax.curve(lambda x: sum(c * v for c, v in zip(bp, poly_row(x))), cls="f-b-line")
    ax.curve(lambda x: sum(c * v for c, v in zip(bs, spline_row(x))), cls="f-a-line")
    f.legend(600, 70, [("cubic spline, 3 knots", "f-a-line"), ("cubic polynomial", "f-b-line"), ("true curve", "f-c-line f-dash")])
    for i, line in enumerate(("Both fits are small: 7", "parameters for the spline,", "4 for the polynomial. The", "spline bends at the dotted", "knots; the polynomial must", "bend everywhere.")):
        f.text(600, 150 + 19 * i, line, "f-muted", 12.5)
    return f
