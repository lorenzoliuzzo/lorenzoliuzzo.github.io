"""Spontaneous magnetisation of the square-lattice Ising model: mean field against the exact Onsager result."""
import math
from kit import Fig

TC_MF = 4.0
TC = 2 / math.log(1 + math.sqrt(2))


def mf(T):
    m = 1.0
    for _ in range(4000):
        m = math.tanh(TC_MF * m / T)
    return m if m > 1e-3 else 0.0


def exact(T):
    s = math.sinh(2 / T)
    return (1 - s ** -4) ** 0.125


def build():
    f = Fig(760, 290)
    ax = f.axes(56, 24, 500, 220, (0, 4.5), (0, 1.05))
    ax.frame(xticks=(0, 1, 2, 3, 4), yticks=(0, 0.5, 1.0), xlabel="temperature T / J (k = 1)", ylabel=None)
    ts = [0.05 + 0.01 * i for i in range(440)]
    f.poly([(ax.X(t), ax.Y(mf(t))) for t in ts if t < 4.0], "f-b-line")
    f.poly([(ax.X(t), ax.Y(exact(t))) for t in ts if t < TC - 1e-4], "f-a-line")
    ax.vline(TC, 0, 1.05)
    ax.vline(4.0, 0, 1.05)
    f.legend(590, 50, [("mean field, Tc = 4", "f-b-line"), ("exact (Onsager)", "f-a-line")])
    f.text(590, 120, f"Exact Tc = {TC:.3f} J.", "f-muted", 12.5)
    f.text(590, 138, "Mean field overshoots by", "f-muted", 12.5)
    f.text(590, 156, f"{(4 / TC - 1) * 100:.0f}% and bends as (Tc−T)^½;", "f-muted", 12.5)
    f.text(590, 174, "the exact curve is (Tc−T)^⅛.", "f-muted", 12.5)
    return f
