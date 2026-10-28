"""The action of a thrown ball over perturbed paths: it is stationary, and here minimal, at the true path."""
import math
from kit import Fig

M, G, T = 1.0, 9.81, 2.0


def action(eps, n=2000):
    s = 0.0
    dt = T / n
    for i in range(n):
        t = (i + 0.5) * dt
        y = 0.5 * G * t * (T - t) + eps * math.sin(math.pi * t / T)
        v = 0.5 * G * (T - 2 * t) + eps * math.pi / T * math.cos(math.pi * t / T)
        s += (0.5 * M * v * v - M * G * y) * dt
    return s


def build():
    f = Fig(760, 300)
    s0 = action(0)
    ax = f.axes(70, 20, 470, 230, (-2, 2), (-0.4, 6))
    vals = [(e / 20.0, action(e / 20.0) - s0) for e in range(-40, 41)]
    ax.frame(xticks=(-2, -1, 0, 1, 2), yticks=(0, 2, 4, 6), xlabel="perturbation size ε (m)", ylabel="*S*(ε) − *S*(0)  (J s)")
    f.poly([(ax.X(e), ax.Y(v)) for e, v in vals], "f-a-line")
    ax.point(0, 0, 4.5)
    f.text(570, 60, "*y* = *y*_{true} + ε sin(π*t*/*T*)", "f-muted", 12.5)
    f.text(570, 84, "*m* = 1 kg, *T* = 2 s, *g* = 9.81 m/s^{2}", "f-muted", 12.5)
    f.text(570, 102, f"*S*(0) = {s0:.2f} J s", "f-muted", 12.5)
    f.text(570, 120, f"*S*(2) − *S*(0) = {action(2) - s0:.2f} J s", "f-muted", 12.5)
    return f
