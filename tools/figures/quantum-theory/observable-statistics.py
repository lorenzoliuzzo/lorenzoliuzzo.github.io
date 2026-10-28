"""A three-outcome observable with eigenvalues -1, 0, 2 in a state with Born probabilities 0.2, 0.5, 0.3: mean 0.4, <A^2> = 1.4, variance 1.24, spread 1.11."""
import math
from kit import Fig

VALS = (-1, 0, 2)
P = (0.2, 0.5, 0.3)
MEAN = sum(v * p for v, p in zip(VALS, P))
SD = math.sqrt(sum(v * v * p for v, p in zip(VALS, P)) - MEAN ** 2)


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (-2, 3), (0, 0.7))
    ax.frame(xticks=(-1, 0, 1, 2), yticks=(0, 0.25, 0.5), xlabel="outcome (eigenvalue of *A*)", ylabel="probability")
    ax.bars(VALS, P, 44)
    ax.vline(MEAN, 0, 0.62, "f-a-line")
    f.line(ax.X(MEAN - SD), ax.Y(0.62), ax.X(MEAN + SD), ax.Y(0.62), "f-a-line")
    f.text(ax.X(MEAN), ax.Y(0.665), f"⟨*A*⟩ = {MEAN:.1f}, Δ*A* = {SD:.2f}", "f-a", 12.5, "middle")
    f.text(560, 70, "Bars: |⟨*a*|ψ⟩|², the Born", "f-muted", 12.5)
    f.text(560, 88, "probabilities of each eigenvalue.", "f-muted", 12.5)
    f.text(560, 122, "⟨*A*⟩ = Σ *a* *p*(*a*) = ⟨ψ|*A*|ψ⟩", "f-ink", 12.5)
    f.text(560, 146, "Δ*A*² = ⟨*A*²⟩ − ⟨*A*⟩² = 1.24", "f-ink", 12.5)
    f.text(560, 180, "The spread is zero only if the state", "f-muted", 12.5)
    f.text(560, 198, "is an eigenvector of *A*.", "f-muted", 12.5)
    return f
