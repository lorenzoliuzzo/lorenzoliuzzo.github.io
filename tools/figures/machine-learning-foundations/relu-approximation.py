"""A one-hidden-layer ReLU network with n hidden units can follow any piecewise-linear function with n segments. Here the interpolant of sin x on [0, 2 pi] with n = 3 and n = 8 segments."""
import math
from kit import Fig

A, B = 0.0, 2 * math.pi


def interp(n):
    knots = [A + (B - A) * i / n for i in range(n + 1)]
    ys = [math.sin(k) for k in knots]

    def fn(x):
        i = min(int((x - A) / (B - A) * n), n - 1)
        t = (x - knots[i]) / (knots[i + 1] - knots[i])
        return ys[i] + t * (ys[i + 1] - ys[i])
    return fn, knots, ys


def maxerr(n):
    fn, _, _ = interp(n)
    return max(abs(fn(A + (B - A) * k / 4000) - math.sin(A + (B - A) * k / 4000)) for k in range(4001))


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (A, B), (-1.2, 1.2))
    ax.frame(xticks=(0, math.pi, 2 * math.pi), yticks=(-1, 0, 1), xlabel="*x*", xfmt=lambda v: {0: "0", 1: "π", 2: "2π"}[round(v / math.pi)])
    ax.curve(math.sin, cls="f-line")
    for n, cls in ((3, "f-a"), (8, "f-b")):
        fn, kn, ys = interp(n)
        f.poly([(ax.X(k), ax.Y(y)) for k, y in zip(kn, ys)], cls + "-line")
    f.legend(560, 50, [("sin *x*", "f-line"), ("3 hidden units", "f-a-line"), ("8 hidden units", "f-b-line")])
    f.text(560, 140, f"Largest error: {maxerr(3):.2f} with 3 units,", "f-muted", 12.5)
    f.text(560, 158, f"{maxerr(8):.3f} with 8. Error falls as", "f-muted", 12.5)
    f.text(560, 176, "1/*n*², so width buys accuracy", "f-muted", 12.5)
    f.text(560, 194, "but the units must be found.", "f-muted", 12.5)
    return f
