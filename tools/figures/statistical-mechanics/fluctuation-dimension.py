"""Variance of a Goldstone field on an L^d lattice: it grows with L in one dimension, as ln L in two, and saturates in three."""
import math
from kit import Fig


def var(d, L):
    c = [math.cos(2 * math.pi * k / L) for k in range(L)]
    tot = 0.0
    n = L ** d
    import itertools
    for ks in itertools.product(range(L), repeat=d):
        if not any(ks):
            continue
        lam = 2 * d - 2 * sum(c[k] for k in ks)
        tot += 1 / lam
    return tot / n


def build():
    Ls = (4, 8, 16, 32, 64)
    data = {1: [var(1, L) for L in Ls], 2: [var(2, L) for L in Ls], 3: [var(3, L) for L in Ls[:4]]}
    f = Fig(760, 290)
    ax = f.axes(56, 24, 500, 220, (2, 6), (0, 1.4))
    ax.frame(xticks=(2, 3, 4, 5, 6), yticks=(0, 0.5, 1.0), xlabel="log₂ L", ylabel=None)
    for d, c in ((1, "b"), (2, "c"), (3, "a")):
        pts = [(ax.X(math.log2(L)), ax.Y(v)) for L, v in zip(Ls, data[d]) if v <= 1.4]
        f.poly(pts, f"f-{c}-line")
        for x, y in pts:
            f.circle(x, y, 3, f"f-{c}-solid")
    f.legend(590, 50, [("d = 1: grows as L/12", "f-b-line"), ("d = 2: grows as ln L", "f-c-line"), ("d = 3: saturates", "f-a-line")])
    f.text(590, 130, "Mean square fluctuation of a", "f-muted", 12.5)
    f.text(590, 148, "Goldstone field of stiffness 1.", "f-muted", 12.5)
    f.text(590, 166, "If it diverges, no order.", "f-muted", 12.5)
    f.text(590, 184, "d = 1 leaves the plot at L = 32.", "f-muted", 12.5)
    return f
