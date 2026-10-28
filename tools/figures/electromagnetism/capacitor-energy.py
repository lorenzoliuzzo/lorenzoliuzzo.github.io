"""Parallel plates, A = 100 cm^2, spacing d. At fixed charge Q the energy Q^2 d / (2 eps0 A) grows with d; at fixed voltage V the energy eps0 A V^2 / (2 d) falls. Values: Q = 8.85 nC (the charge at 100 V and 1 mm) and V = 100 V, energies in microjoules."""
from kit import Fig

EPS0, A = 8.854e-12, 1e-2
Q = EPS0 * A / 1e-3 * 100
V = 100.0


def uq(d):
    return Q * Q * d * 1e-3 / (2 * EPS0 * A) * 1e6


def uv(d):
    return EPS0 * A * V * V / (2 * d * 1e-3) * 1e6


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0.5, 3.0), (0, 1.0))
    ax.frame(xticks=(0.5, 1, 1.5, 2, 2.5, 3), yticks=(0, 0.5, 1.0), xlabel="plate spacing *d* (mm)", ylabel="stored energy (μJ)")
    ax.curve(uq, 0.5, 3.0, "f-a-line")
    ax.curve(uv, 0.5, 3.0, "f-b-line")
    ax.point(1.0, uq(1.0), cls="f-line")
    f.legend(560, 50, [("fixed charge *Q*", "f-a-line"), ("fixed voltage *V*", "f-b-line")])
    f.text(560, 120, f"At 1 mm both give {uq(1.0):.2f} μJ.", "f-muted", 12.5)
    f.text(560, 146, "Pulling the plates apart costs", "f-muted", 12.5)
    f.text(560, 164, "work if charge is fixed (the", "f-muted", 12.5)
    f.text(560, 182, "energy rises) and releases it", "f-muted", 12.5)
    f.text(560, 200, "if the battery stays on.", "f-muted", 12.5)
    return f
