"""Transmission through a rectangular barrier of height V0 and width a, beta = a sqrt(2 m V0)/hbar = 2 and 4. For E < V0: T = 1/(1 + V0^2 sinh^2(kappa a)/(4E(V0-E))), kappa a = beta sqrt(1 - E/V0); for E > V0: T = 1/(1 + V0^2 sin^2(k a)/(4E(E-V0))), k a = beta sqrt(E/V0 - 1)."""
import math
from kit import Fig


def T(beta, e):
    if abs(e - 1) < 1e-9:
        return 1 / (1 + beta * beta / 4)
    if e < 1:
        k = beta * math.sqrt(1 - e)
        return 1 / (1 + math.sinh(k) ** 2 / (4 * e * (1 - e)))
    k = beta * math.sqrt(e - 1)
    return 1 / (1 + math.sin(k) ** 2 / (4 * e * (e - 1)))


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0, 2.5), (0, 1.1))
    ax.frame(xticks=(0, 0.5, 1, 1.5, 2, 2.5), yticks=(0, 0.5, 1), xlabel="energy *E* / barrier height *V*₀", ylabel="transmission *T*")
    ax.curve(lambda e: T(2, max(e, 1e-4)), 0.005, 2.5, "f-b-line", 400)
    ax.curve(lambda e: T(4, max(e, 1e-4)), 0.005, 2.5, "f-a-line", 400)
    ax.vline(1.0, cls="f-line f-dash")
    f.legend(560, 50, [("thin barrier, β = 2", "f-b-line"), ("thick barrier, β = 4", "f-a-line")])
    f.text(560, 120, f"At *E* = *V*₀/2: *T* = {T(2, 0.5):.2f} (β = 2),", "f-muted", 12.5)
    f.text(560, 138, f"{T(4, 0.5):.3f} (β = 4). Below the dashed", "f-muted", 12.5)
    f.text(560, 156, "line the particle tunnels; above it", "f-muted", 12.5)
    f.text(560, 174, "the barrier still reflects, except at", "f-muted", 12.5)
    f.text(560, 192, "resonances where *T* = 1.", "f-muted", 12.5)
    return f
