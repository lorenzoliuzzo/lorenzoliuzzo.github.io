"""Spin correlation <s_0 s_r> = tanh(K)^r of the 1D Ising chain, on a logarithmic scale."""
import math
from kit import Fig


def build():
    f = Fig(760, 290)
    ax = f.axes(56, 24, 500, 220, (0, 12), (-10, 0))
    ax.frame(xticks=range(0, 13, 2), yticks=(-10, -8, -6, -4, -2, 0), xlabel="distance r", ylabel=None)
    rows = []
    for K, c in ((0.5, "b"), (1.0, "c"), (1.5, "a")):
        lam = math.log(math.tanh(K))
        f.poly([(ax.X(r), ax.Y(r * lam)) for r in range(13)], f"f-{c}-line")
        for r in range(13):
            ax.point(r, r * lam, 2.6, f"f-{c}-solid")
        rows.append((f"βJ = {K}: ξ = {-1 / lam:.1f}", f"f-{c}-line"))
    f.legend(590, 50, rows)
    f.text(590, 130, "ln⟨s₀ s_r⟩ is a straight line:", "f-muted", 12.5)
    f.text(590, 148, "the correlation decays as", "f-muted", 12.5)
    f.text(590, 166, "e^(−r/ξ) at every T > 0.", "f-muted", 12.5)
    return f
