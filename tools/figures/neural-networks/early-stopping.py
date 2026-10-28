"""Gradient descent on a flexible model: training error keeps falling, held-out error turns up (seed chosen for the typical shape)."""
import math
import random
from kit import Fig
from nnutil import legendre

M = 11


def build():
    rng = random.Random(3)
    f_true = lambda x: math.sin(2.2 * x)
    xs = sorted(rng.uniform(-1, 1) for _ in range(12))
    ys = [f_true(x) + rng.gauss(0, 0.3) for x in xs]
    vx = [-1 + 2 * i / 199 for i in range(200)]
    vy = [f_true(x) + rng.gauss(0, 0.3) for x in vx]
    Phi = [legendre(x, M) for x in xs]
    V = [legendre(x, M) for x in vx]
    n = len(xs)
    # step size from the largest eigenvalue of Phi^T Phi / n (power iteration)
    v = [1.0] * M
    for _ in range(200):
        u = [sum(Phi[i][j] * v[j] for j in range(M)) for i in range(n)]
        w = [sum(Phi[i][j] * u[i] for i in range(n)) / n for j in range(M)]
        nv = math.sqrt(sum(a * a for a in w))
        lam, v = nv, [a / nv for a in w]
    lr = 0.5 / lam
    wts = [0.0] * M
    keep = {int(10 ** (k / 12)) for k in range(0, 12 * 5)}
    rows = []
    for t in range(1, 60001):
        r = [sum(Phi[i][j] * wts[j] for j in range(M)) - ys[i] for i in range(n)]
        g = [2 * sum(Phi[i][j] * r[i] for i in range(n)) / n for j in range(M)]
        wts = [wts[j] - lr * g[j] for j in range(M)]
        if t in keep:
            tr = sum(a * a for a in r) / n
            va = sum((sum(V[i][j] * wts[j] for j in range(M)) - vy[i]) ** 2 for i in range(200)) / 200
            rows.append((t, tr, va))
    fig = Fig(760, 290)
    ax = fig.axes(56, 30, 520, 206, (0, 4.8), (0, 1.0))
    ax.frame(xticks=range(0, 5), yticks=(0, 0.25, 0.5, 0.75, 1.0), xlabel="training steps", ylabel="mean squared error", xfmt=lambda v: "1" if v == 0 else f"10^{{{int(v)}}}")
    fig.poly([(ax.X(math.log10(t)), ax.Y(min(tr, 1.0))) for t, tr, va in rows], "f-a-line")
    fig.poly([(ax.X(math.log10(t)), ax.Y(min(va, 1.0))) for t, tr, va in rows], "f-b-line")
    best = min(rows, key=lambda r: r[2])
    ax.vline(math.log10(best[0]), cls="f-c-line f-dash")
    ax.point(math.log10(best[0]), best[2], 4.5, "f-c-solid")
    fig.legend(600, 70, [("training", "f-a-line"), ("held out", "f-b-line")])
    fig.text(600, 140, "Held-out error is lowest", "f-muted", 12.5)
    fig.text(600, 158, f"after {best[0]} steps ({best[2]:.2f}).", "f-muted", 12.5)
    fig.text(600, 176, "Training longer fits the", "f-muted", 12.5)
    fig.text(600, 194, "noise in the 12 points.", "f-muted", 12.5)
    return fig
