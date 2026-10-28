"""Bloch components after R_x(theta) acting on |0>: the x component stays 0, the y and z components turn as -sin and cos, which is a rotation about the x axis."""
import math
from kit import Fig


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0, 2 * math.pi), (-1.15, 1.15))
    ax.frame(xticks=(0, math.pi / 2, math.pi, 3 * math.pi / 2, 2 * math.pi), yticks=(-1, 0, 1), xlabel="rotation angle θ",
             xfmt=lambda v: {0: "0", 1: "π/2", 2: "π", 3: "3π/2", 4: "2π"}[round(v / (math.pi / 2))])
    ax.curve(lambda t: math.cos(t), cls="f-b-line")
    ax.curve(lambda t: -math.sin(t), cls="f-a-line")
    ax.curve(lambda t: 0.0, cls="f-c-line")
    f.legend(560, 50, [("⟨*Z*⟩ = cos θ", "f-b-line"), ("⟨*Y*⟩ = −sin θ", "f-a-line"), ("⟨*X*⟩ = 0", "f-c-line")])
    f.text(560, 140, "After a rotation about *x*, the", "f-muted", 12.5)
    f.text(560, 158, "Bloch vector of |0⟩ turns about", "f-muted", 12.5)
    f.text(560, 176, "that axis: its *x* component stays", "f-muted", 12.5)
    f.text(560, 194, "0, the others trace a circle.", "f-muted", 12.5)
    return f
