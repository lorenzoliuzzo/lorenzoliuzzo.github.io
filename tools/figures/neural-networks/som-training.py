"""A self-organizing map of 8 x 8 units trained on points of the unit square: a tangle of random reference vectors unfolds into a grid that covers the square."""
import math
import random

from kit import Fig

N = 8
T = 3000
SNAPSHOTS = (0, 150, T)


def schedule(t):
    """Learning rate and neighbourhood radius, both falling geometrically from their start to their end value."""
    frac = t / T
    return 0.6 * (0.02 / 0.6) ** frac, 4.0 * (0.6 / 4.0) ** frac


def train(seed=7):
    """The seed gives a typical run: untwisted at the end."""
    rng = random.Random(seed)
    w = {(i, j): [rng.random(), rng.random()] for i in range(N) for j in range(N)}
    states = {0: {k: v[:] for k, v in w.items()}}
    for t in range(1, T + 1):
        x = (rng.random(), rng.random())
        win = min(w, key=lambda k: (w[k][0] - x[0]) ** 2 + (w[k][1] - x[1]) ** 2)
        eta, rho = schedule(t)
        for (i, j), r in w.items():
            d2 = (i - win[0]) ** 2 + (j - win[1]) ** 2
            h = eta * math.exp(-d2 / (2 * rho**2))
            r[0] += h * (x[0] - r[0])
            r[1] += h * (x[1] - r[1])
        if t in SNAPSHOTS:
            states[t] = {k: v[:] for k, v in w.items()}
    return states


def build():
    f = Fig(760, 270)
    states = train()
    for j, t in enumerate(SNAPSHOTS):
        ax = f.axes(40 + j * 245, 46, 190, 190, (0, 1), (0, 1))
        f.text(ax.x0, 26, "random start" if t == 0 else f"after {t} steps", "f-ink", 14, weight=600)
        f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
        w = states[t]
        for i in range(N):
            for k in range(N):
                for di, dk in ((1, 0), (0, 1)):
                    if i + di < N and k + dk < N:
                        a, b = w[(i, k)], w[(i + di, k + dk)]
                        f.line(ax.X(a[0]), ax.Y(a[1]), ax.X(b[0]), ax.Y(b[1]), "f-a-line")
        for r in w.values():
            ax.point(r[0], r[1], 2.5, "f-a-solid")
    f.text(40, 262, "Each dot is a reference vector, lines join neighbours on the grid. The inputs are uniform in the square.", "f-muted", 12.5)
    return f
