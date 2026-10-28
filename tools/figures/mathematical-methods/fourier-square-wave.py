"""Partial sums of the Fourier series of the square wave sign(x) with 2, 8 and 40 terms (odd harmonics): they converge to the wave away from the jump, and overshoot it near the jump by about 9 percent of the jump however many terms are used."""
import math
from kit import Fig


def partial(n_terms):
    def s(x):
        return 4 / math.pi * sum(math.sin((2 * k + 1) * x) / (2 * k + 1) for k in range(n_terms))
    return s


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 520, 232, (-math.pi, math.pi), (-1.5, 1.5))
    ax.frame(xticks=(-math.pi, -math.pi / 2, 0, math.pi / 2, math.pi), yticks=(-1, 0, 1), xlabel="*x*",
             xfmt=lambda v: {-3.14: "−π", -1.57: "−π/2", 0: "0", 1.57: "π/2", 3.14: "π"}.get(round(v, 2), f"{v:g}"))
    ax.curve(lambda x: -1.0 if x < 0 else 1.0, -math.pi, -1e-6, "f-line f-dash", 2)
    ax.curve(lambda x: 1.0, 1e-6, math.pi, "f-line f-dash", 2)
    for n, cls in ((2, "f-c-line"), (8, "f-b-line"), (40, "f-a-line")):
        ax.curve(partial(n), -math.pi, math.pi, cls, 600)
    f.legend(600, 60, [("2 terms (*k* = 1, 3)", "f-c-line"), ("8 terms", "f-b-line"), ("40 terms", "f-a-line")])
    f.text(600, 150, "The target is the square wave at ±1.", "f-muted", 12.5)
    f.text(600, 174, "Near the jump every partial", "f-muted", 12.5)
    f.text(600, 192, "sum overshoots, by about 9%", "f-muted", 12.5)
    f.text(600, 210, "of the jump (Gibbs).", "f-muted", 12.5)
    return f
