"""Two paths with equal amplitude 1/sqrt2 and relative phase phi: the probability is |a1 + a2|^2 = 1 + cos(phi) over 2 ... normalised so that the classical sum of the two probabilities is 1. Quantum: P = (1 + cos phi)/2 * 2 / 2 = cos^2(phi/2)."""
import math
from kit import Fig


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0, 2 * math.pi), (0, 1.1))
    ax.frame(xticks=(0, math.pi / 2, math.pi, 3 * math.pi / 2, 2 * math.pi), yticks=(0, 0.5, 1),
             xlabel="relative phase φ between the two paths",
             xfmt=lambda v: {0: "0", 1: "π/2", 2: "π", 3: "3π/2", 4: "2π"}[round(v / (math.pi / 2))])
    ax.curve(lambda p: math.cos(p / 2) ** 2, cls="f-b-line")
    ax.curve(lambda p: 0.5, cls="f-a-line f-dash")
    f.legend(560, 50, [("amplitudes added: cos²(φ/2)", "f-b-line"), ("probabilities added: ½", "f-a-line f-dash")])
    f.text(560, 130, "Each route alone gives probability ¼.", "f-muted", 12.5)
    f.text(560, 148, "Together they give 0 to 1,", "f-muted", 12.5)
    f.text(560, 166, "set by the phase: amplitudes", "f-muted", 12.5)
    f.text(560, 184, "add, then the sum is squared.", "f-muted", 12.5)
    return f
