"""Energy of a unit harmonic oscillator under explicit Euler, symplectic Euler and RK4 with the same step."""
import math
from kit import Fig


def run(kind, h, n):
    q, p = 1.0, 0.0
    E = [0.5 * (q * q + p * p)]
    for _ in range(n):
        if kind == "euler":
            q, p = q + h * p, p - h * q
        elif kind == "symp":
            p = p - h * q
            q = q + h * p
        else:
            def fld(u):
                return (u[1], -u[0])
            k1 = fld((q, p))
            k2 = fld((q + h / 2 * k1[0], p + h / 2 * k1[1]))
            k3 = fld((q + h / 2 * k2[0], p + h / 2 * k2[1]))
            k4 = fld((q + h * k3[0], p + h * k3[1]))
            q += h / 6 * (k1[0] + 2 * k2[0] + 2 * k3[0] + k4[0])
            p += h / 6 * (k1[1] + 2 * k2[1] + 2 * k3[1] + k4[1])
        E.append(0.5 * (q * q + p * p))
    return E


def build():
    h, n = 0.2, 300
    f = Fig(760, 290)
    ax = f.axes(56, 24, 520, 220, (0, n * h), (0.4, 2.6))
    ax.frame(xticks=range(0, 61, 10), yticks=(0.5, 1.0, 1.5, 2.0, 2.5), xlabel="time", ylabel=None)
    for kind, c in (("euler", "b"), ("rk4", "c"), ("symp", "a")):
        E = run(kind, h, n)
        f.poly([(ax.X(i * h), ax.Y(min(2.6, e))) for i, e in enumerate(E)], f"f-{c}-line")
    f.legend(600, 50, [("explicit Euler", "f-b-line"), ("RK4", "f-c-line"), ("symplectic Euler", "f-a-line")])
    f.text(600, 140, "Same step h = 0.2. The true", "f-muted", 12.5)
    f.text(600, 158, "energy is 0.5; Euler is clipped.", "f-muted", 12.5)
    f.text(600, 176, "Symplectic Euler oscillates", "f-muted", 12.5)
    f.text(600, 194, "around its own level.", "f-muted", 12.5)
    return f
