"""Two-level system with coupling g, detuning D, starting in |0>: P1(t) = 4g^2/(D^2 + 4g^2) sin^2(Omega t/2), Omega = sqrt(D^2 + 4 g^2). On resonance P1 = sin^2(g t); with D = 2g the amplitude drops to 1/2 and the oscillation speeds up by sqrt2."""
import math
from kit import Fig


def p1(g, d):
    om = math.sqrt(d * d + 4 * g * g)
    return lambda t: 4 * g * g / om ** 2 * math.sin(om * t / 2) ** 2


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0, 2 * math.pi), (0, 1.1))
    ax.frame(xticks=(0, math.pi, 2 * math.pi), yticks=(0, 0.5, 1), xlabel="time *gt*", xfmt=lambda v: {0: "0", 1: "π", 2: "2π"}[round(v / math.pi)], ylabel="probability of |1⟩")
    ax.curve(p1(1, 0), cls="f-b-line")
    ax.curve(p1(1, 2), cls="f-a-line")
    f.legend(560, 50, [("resonance, Δ = 0", "f-b-line"), ("detuned, Δ = 2*g*", "f-a-line")])
    f.text(560, 120, "On resonance the population", "f-muted", 12.5)
    f.text(560, 138, "is transferred completely.", "f-muted", 12.5)
    f.text(560, 164, "Detuning lowers the peak to 1/2", "f-muted", 12.5)
    f.text(560, 182, "and speeds up the oscillation", "f-muted", 12.5)
    f.text(560, 200, "by √2.", "f-muted", 12.5)
    return f
