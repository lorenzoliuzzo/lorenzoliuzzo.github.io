"""Landau free energy f(m) = a t m^2 + b m^4 above, at and below the critical temperature."""
import math
from kit import Fig


def build():
    f = Fig(760, 290)
    ax = f.axes(56, 24, 500, 220, (-1.5, 1.5), (-0.4, 1.2))
    ax.frame(xticks=(-1.5, -1, -0.5, 0, 0.5, 1, 1.5), yticks=(-0.4, 0, 0.4, 0.8, 1.2), xlabel="order parameter m", ylabel=None)
    for t, c in ((1.0, "b"), (0.0, "c"), (-1.0, "a")):
        ax.curve(lambda m, t=t: 0.5 * t * m * m + 0.25 * m ** 4, -1.5, 1.5, f"f-{c}-line")
    for s in (-1, 1):
        ax.point(s, -0.25, 4.5, "f-a-solid")
    f.legend(590, 50, [("t > 0, disordered", "f-b-line"), ("t = 0, critical", "f-c-line"), ("t < 0, ordered", "f-a-line")])
    f.text(590, 130, "For t < 0 the minimum is at", "f-muted", 12.5)
    f.text(590, 148, "m = ±√(−t), two equivalent", "f-muted", 12.5)
    f.text(590, 166, "states. The symmetry of f", "f-muted", 12.5)
    f.text(590, 184, "is not the symmetry of one.", "f-muted", 12.5)
    return f
