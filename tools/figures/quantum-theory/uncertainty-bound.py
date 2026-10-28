"""Position spread (units of the well width L) against momentum spread (hbar/L). The bound dp >= 1/(2 dx) is the curve; the shaded region below it is forbidden. A Gaussian lies on it (dx = 0.3 L here). The infinite well has dx dp = (hbar/2) sqrt(n^2 pi^2/3 - 2): 0.568 hbar for n = 1, 1.67 hbar for n = 2, 2.63 for n = 3, from dx = L sqrt(1/12 - 1/(2 n^2 pi^2)) and dp = n pi hbar / L."""
import math
from kit import Fig


def well(n):
    return math.sqrt(1 / 12 - 1 / (2 * n * n * math.pi ** 2)), n * math.pi


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0, 1.0), (0, 10.0))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1), yticks=(0, 2, 4, 6, 8, 10), xlabel="position spread Δ*x* (units of *L*)", ylabel="momentum spread Δ*p* (ħ/*L*)")
    ax.area(lambda x: min(10.0, 1 / (2 * x)), 0.05, 1.0, "f-c-fill")
    ax.curve(lambda x: 1 / (2 * x), 0.05, 1.0, "f-a-line")
    ax.point(0.3, 1 / 0.6, cls="f-a-solid")
    for n in (1, 2, 3):
        dx, dp = well(n)
        ax.point(dx, dp, cls="f-b-solid")
    f.legend(560, 50, [("Δ*x*Δ*p* = ħ/2", "f-a-line")])
    f.text(560, 100, "Shaded: forbidden by the", "f-muted", 12.5)
    f.text(560, 118, "uncertainty relation.", "f-muted", 12.5)
    f.text(560, 148, "Gaussian packet: on the curve.", "f-muted", 12.5)
    f.text(560, 174, "Infinite well, *n* = 1, 2, 3 (upper", "f-muted", 12.5)
    f.text(560, 192, "points): Δ*x*Δ*p* = 0.57, 1.67, 2.63 ħ.", "f-muted", 12.5)
    return f
