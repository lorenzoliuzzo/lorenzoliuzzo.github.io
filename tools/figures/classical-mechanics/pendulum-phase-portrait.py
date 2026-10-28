"""Phase portrait of the pendulum H = p^2/2 - cos q: closed orbits (libration) inside the separatrix E = 1, open orbits (rotation) outside, level curves of H."""
import math
from kit import Fig


def branch(E, sign):
    return lambda q: sign * math.sqrt(max(0.0, 2 * (E + math.cos(q))))


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 20, 480, 236, (-math.pi, math.pi), (-3.2, 3.2))
    ax.frame(xticks=(-math.pi, 0, math.pi), yticks=(-2, 0, 2), xlabel="angle *q*", ylabel="momentum *p*", xfmt=lambda v: {-3.14159: "−π", 0: "0", 3.14159: "π"}.get(round(v, 5), f"{v:g}"))
    for E in (-0.6, -0.1, 0.5):
        qm = math.acos(-E)
        for s in (1, -1):
            ax.curve(branch(E, s), -qm, qm, "f-a-line", 160)
    for s in (1, -1):
        ax.curve(lambda q, s=s: s * 2 * math.cos(q / 2), -math.pi, math.pi, "f-b-line", 160)
    for E in (1.8, 3.0):
        for s in (1, -1):
            ax.curve(branch(E, s), -math.pi, math.pi, "f-c-line", 160)
    f.legend(580, 60, [("libration, *E* < 1", "f-a-line"), ("separatrix, *E* = 1", "f-b-line"), ("rotation, *E* > 1", "f-c-line")])
    f.text(580, 150, "Level curves of *H*: the", "f-muted", 12.5)
    f.text(580, 168, "flow follows them, and the", "f-muted", 12.5)
    f.text(580, 186, "phase-space area is conserved.", "f-muted", 12.5)
    return f
