"""Binomial(n, lambda/n) bars against Poisson(lambda) for growing n."""
from kit import Fig
from dist import binom_pmf, pois_pmf


def build():
    f = Fig(760, 292)
    lam = 2
    for i, n in enumerate((10, 100)):
        ax = f.axes(52 + i * 380, 38, 300, 180, (-0.6, 8.6), (0, 0.4))
        ax.frame(xticks=range(0, 9), yticks=(0, 0.1, 0.2, 0.3, 0.4), xlabel="k", ylabel=None if i else "probability")
        ks = list(range(0, 9))
        ax.bars(ks, [binom_pmf(k, n, lam / n) for k in ks], 20, "f-a-fill")
        pts = [(ax.X(k), ax.Y(pois_pmf(k, lam))) for k in ks]
        f.poly(pts, "f-b-line")
        for k in ks:
            ax.point(k, pois_pmf(k, lam), 3.2, "f-b-solid")
        f.text(ax.x0, 16, f"Binomial(n = {n}, p = {lam}/{n})", "f-a", 13, weight=600)
        f.text(52, 284, "Bars: binomial.  Orange: Poisson with the same mean λ = 2.", "f-muted", 12.5)
    return f
