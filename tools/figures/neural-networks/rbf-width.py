"""The same nine Gaussian centres with three widths: too narrow leaves spikes, too wide loses the shape (seed chosen for the typical case)."""
import math
import random
from kit import Fig
from nnutil import solve


def fit(xs, ys, centres, sigma, lam=1e-2):
    phi = lambda x: [math.exp(-((x - c) ** 2) / (2 * sigma ** 2)) for c in centres]
    P = [phi(x) for x in xs]
    m = len(centres)
    A = [[sum(P[i][a] * P[i][b] for i in range(len(xs))) + (lam if a == b else 0) for b in range(m)] for a in range(m)]
    bvec = [sum(P[i][a] * ys[i] for i in range(len(xs))) for a in range(m)]
    w = solve(A, bvec)
    return lambda x: sum(wj * pj for wj, pj in zip(w, phi(x)))


def build():
    rng = random.Random(7)
    truth = lambda x: math.sin(2 * math.pi * x)
    xs = sorted(rng.uniform(0, 1) for _ in range(30))
    ys = [truth(x) + rng.gauss(0, 0.2) for x in xs]
    centres = [i / 8 for i in range(9)]
    f = Fig(760, 300)
    ax = f.axes(48, 30, 520, 220, (0, 1), (-4.5, 2.6))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1), yticks=(-1, 0, 1), xlabel="x")
    ax.curve(truth, cls="f-c-line f-dash")
    for x, y in zip(xs, ys):
        ax.point(x, y, 3, "f-faint f-solid".replace(" f-solid", ""))
    for c in centres:
        ax.point(c, -1.7, 3, "f-ink")
    clip = lambda g: (lambda x: max(-4.4, min(4.4, g(x))))
    ax.curve(clip(fit(xs, ys, centres, 0.03)), cls="f-b-line", n=600)
    ax.curve(clip(fit(xs, ys, centres, 0.12)), cls="f-a-line", n=400)
    ax.curve(clip(fit(xs, ys, centres, 0.8)), cls="f-d-line", n=400)
    f.legend(596, 70, [("width 0.03", "f-b-line"), ("width 0.12", "f-a-line"), ("width 0.8", "f-d-line"), ("true curve", "f-c-line f-dash")])
    f.text(596, 168, "Dots are the nine centres.", "f-muted", 12.5)
    f.text(596, 186, "Narrow bumps leave gaps;", "f-muted", 12.5)
    f.text(596, 204, "wide ones smooth away the sine.", "f-muted", 12.5)
    return f
