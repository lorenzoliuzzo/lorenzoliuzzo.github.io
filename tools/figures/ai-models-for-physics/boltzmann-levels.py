"""Probability of each energy level of an open chain of four Ising spins (J = 1) at three temperatures."""
import itertools
import math
from kit import Fig


def build():
    levels = {}
    for s in itertools.product((-1, 1), repeat=4):
        e = -sum(s[i] * s[i + 1] for i in range(3))
        levels[e] = levels.get(e, 0) + 1
    es = sorted(levels)
    f = Fig(760, 250)
    for k, T in enumerate((0.5, 1.5, 4.0)):
        x0 = 36 + k * 248
        z = sum(g * math.exp(-e / T) for e, g in levels.items())
        ps = [levels[e] * math.exp(-e / T) / z for e in es]
        ax = f.axes(x0 + 20, 40, 190, 150, (-0.6, len(es) - 0.4), (0, 1.0))
        f.text(x0 + 20, 24, f"T = {T}", "f-ink", 13.5, weight=600)
        ax.frame(xticks=(), yticks=(0, 0.5, 1.0), ylabel=None)
        ax.bars(range(len(es)), ps, 30, "f-a-fill", "f-a-line")
        for i, e in enumerate(es):
            f.text(ax.X(i), 208, f"{e}", "f-muted", 12.5, "middle")
        f.text(ax.X((len(es) - 1) / 2), 232, "energy of the level", "f-muted", 12.5, "middle")
    return f
