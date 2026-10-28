"""Polynomials of degree 1, 3 and 12 fitted to 20 noisy points of a sine wave: too rigid, about right, chasing the noise."""
import math
import random
from kit import Fig
from linalg import lstsq

N, SIGMA = 20, 0.3


def target(x):
    return math.sin(2 * math.pi * x)


def basis(x, d):
    # Legendre polynomials on [0, 1] mapped to [-1, 1]: well conditioned up to degree 12.
    t = 2 * x - 1
    P = [1.0, t]
    for k in range(1, d):
        P.append(((2 * k + 1) * t * P[k] - k * P[k - 1]) / (k + 1))
    return P[: d + 1]


def fit(xs, ys, d):
    w = lstsq([basis(x, d) for x in xs], ys)
    return lambda x: sum(c * b for c, b in zip(w, basis(x, d)))


def build():
    rng = random.Random(7)  # a draw that shows the typical case
    xs = [i / (N - 1) for i in range(N)]
    ys = [target(x) + rng.gauss(0, SIGMA) for x in xs]
    f = Fig(760, 292)
    for i, (d, title) in enumerate(((1, "degree 1: underfits"), (3, "degree 3: about right"), (12, "degree 12: overfits"))):
        ax = f.axes(34 + i * 246, 36, 214, 190, (0, 1), (-1.7, 1.7))
        ax.frame(xticks=(0, 0.5, 1), yticks=(-1, 0, 1), grid=True, yaxis=(i == 0))
        f.text(ax.x0, 24, title, "f-ink", 13.5, weight=600)
        ax.curve(target, cls="f-c-line f-dash")
        g = fit(xs, ys, d)
        ax.curve(lambda x: max(-1.65, min(1.65, g(x))), cls="f-a-line")
        for x, y in zip(xs, ys):
            ax.point(x, y, 3, "f-ink")
    f.line(34, 268, 60, 268, "f-c-line f-dash")
    f.text(66, 272, "true function", "f-muted", 12.5)
    f.circle(200, 268, 3, "f-ink")
    f.text(210, 272, "training data", "f-muted", 12.5)
    f.line(330, 268, 356, 268, "f-a-line")
    f.text(362, 272, "fitted polynomial", "f-muted", 12.5)
    return f
