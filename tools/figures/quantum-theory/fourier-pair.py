"""Gaussian wavepackets: |psi(x)|^2 has standard deviation s, |phi(p)|^2 has standard deviation hbar/(2 s). Two widths, s = 0.5 and s = 1.5 (units of a, hbar = 1)."""
import math
from kit import Fig


def gauss(s):
    return lambda v: math.exp(-v * v / (2 * s * s)) / (s * math.sqrt(2 * math.pi))


def build():
    f = Fig(760, 330)
    ax = f.axes(40, 40, 300, 200, (-4, 4), (0, 1.3))
    ax2 = f.axes(400, 40, 300, 200, (-4, 4), (0, 1.3))
    ax.frame(xticks=(-4, -2, 0, 2, 4), yticks=(), xlabel="position *x*", yaxis=False)
    ax2.frame(xticks=(-4, -2, 0, 2, 4), yticks=(), xlabel="momentum *p*", yaxis=False)
    for s, cls in ((0.5, "f-b-line"), (1.5, "f-a-line")):
        ax.curve(gauss(s), cls=cls)
        ax2.curve(gauss(0.5 / s), cls=cls)
    f.text(40, 26, "|ψ(*x*)|²", "f-ink", 13)
    f.text(400, 26, "|φ(*p*)|²", "f-ink", 13)
    f.text(40, 312, "Narrow in *x* (Δ*x* = 0.5, orange) is wide in *p* (Δ*p* = 1); wide in *x* (Δ*x* = 1.5, blue) is narrow in *p* (Δ*p* = 0.33).", "f-muted", 12.5)
    return f
