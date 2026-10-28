"""Distribution of the energy per unit of N independent two-level units: the width shrinks as 1/sqrt(N)."""
import math
from kit import Fig

P = 0.3


def pmf_density(N, e):
    k = round(e * N)
    lp = math.lgamma(N + 1) - math.lgamma(k + 1) - math.lgamma(N - k + 1) + k * math.log(P) + (N - k) * math.log(1 - P)
    return math.exp(lp) * N


def build():
    f = Fig(760, 290)
    ax = f.axes(56, 24, 500, 220, (0, 0.6), (0, 30))
    ax.frame(xticks=(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6), yticks=(0, 10, 20, 30), xlabel="energy per unit, E/(Nε)", ylabel=None)
    for N, c in ((10, "b"), (100, "c"), (1000, "a")):
        pts = []
        for i in range(0, 601):
            e = i / 1000
            k = e * N
            if abs(k - round(k)) < 1e-9 or N == 1000:
                pts.append((ax.X(e), ax.Y(min(30, pmf_density(N, e)))))
        if N == 1000:
            f.poly(pts, f"f-{c}-line")
        else:
            xs = [(round(k) / N) for k in range(0, int(0.6 * N) + 1)]
            f.poly([(ax.X(x), ax.Y(min(30, pmf_density(N, x)))) for x in xs], f"f-{c}-line")
    f.legend(590, 50, [("N = 10", "f-b-line"), ("N = 100", "f-c-line"), ("N = 1000", "f-a-line")])
    f.text(590, 140, "Each unit is excited with", "f-muted", 12.5)
    f.text(590, 158, "probability 0.3. The relative", "f-muted", 12.5)
    f.text(590, 176, "width falls as 1/√N.", "f-muted", 12.5)
    return f
