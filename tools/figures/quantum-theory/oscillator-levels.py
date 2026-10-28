"""Harmonic oscillator in units hbar = m = omega = 1: parabola x^2/2, levels E_n = n + 1/2, and the probability densities of n = 0, 1, 2 drawn on their levels (scaled by 0.9)."""
import math
from kit import Fig


def psi2(n):
    if n == 0:
        return lambda x: math.exp(-x * x) / math.sqrt(math.pi)
    if n == 1:
        return lambda x: 2 * x * x * math.exp(-x * x) / math.sqrt(math.pi)
    return lambda x: (2 * x * x - 1) ** 2 * math.exp(-x * x) / (2 * math.sqrt(math.pi))


def build():
    f = Fig(760, 340)
    ax = f.axes(52, 14, 440, 280, (-3.2, 3.2), (0, 3.6))
    ax.frame(xticks=(-3, -2, -1, 0, 1, 2, 3), yticks=(), xlabel="position *x*", yaxis=False)
    ax.curve(lambda x: x * x / 2, cls="f-line")
    for n in (0, 1, 2, 3):
        e = n + 0.5
        half = math.sqrt(2 * e)
        f.line(ax.X(-half), ax.Y(e), ax.X(half), ax.Y(e), "f-grid")
        f.text(ax.X(3.2) + 6, ax.Y(e) + 4, f"*n* = {n}", "f-muted", 12)
    for n, cls in ((0, "f-b"), (1, "f-a"), (2, "f-c")):
        e = n + 0.5
        fn = psi2(n)
        pts = [(ax.X(-3 + 6 * i / 240), ax.Y(e + 0.9 * fn(-3 + 6 * i / 240))) for i in range(241)]
        f.poly(pts, cls + "-line")
    f.text(570, 50, "Levels *E*ₙ = (*n* + ½)ħω.", "f-muted", 12.5)
    f.text(570, 90, "Curves: |ψₙ(*x*)|² on each level.", "f-muted", 12.5)
    f.text(570, 108, "The ground state has no node,", "f-muted", 12.5)
    f.text(570, 126, "each level up adds one. Probability", "f-muted", 12.5)
    f.text(570, 144, "leaks past the parabola, into", "f-muted", 12.5)
    f.text(570, 162, "the classically forbidden region.", "f-muted", 12.5)
    return f
