"""Error of the backward reconstruction x(0) from a perturbed x(T): dissipative fields amplify the perturbation, a conservative one does not."""
import math
from kit import Fig


def rk4(f, v, h):
    k1 = f(v)
    k2 = f([a + h / 2 * b for a, b in zip(v, k1)])
    k3 = f([a + h / 2 * b for a, b in zip(v, k2)])
    k4 = f([a + h * b for a, b in zip(v, k3)])
    return [a + h / 6 * (p + 2 * q + 2 * r + s) for a, p, q, r, s in zip(v, k1, k2, k3, k4)]


def err(field, T, delta=1e-6, h=0.002):
    x0 = [1.0, 0.0]
    v = x0[:]
    n = int(round(T / h))
    for _ in range(n):
        v = rk4(field, v, h)
    v = [v[0] + delta, v[1]]
    back = lambda u: [-c for c in field(u)]
    for _ in range(n):
        v = rk4(back, v, h)
    return math.sqrt((v[0] - x0[0]) ** 2 + (v[1] - x0[1]) ** 2)


def build():
    fields = {
        "a": ("damped, rate 1", lambda u: [u[1], -u[0] - 2 * u[1]]),
        "b": ("damped, rate 3", lambda u: [u[1], -u[0] - 6 * u[1]]),
        "c": ("conservative", lambda u: [u[1], -u[0]]),
    }
    Ts = [0.5 * k for k in range(0, 9)]
    f = Fig(760, 300)
    ax = f.axes(56, 24, 520, 220, (0, 4), (-8, 5))
    ax.frame(xticks=range(0, 5), yticks=(-8, -6, -4, -2, 0, 2, 4), xlabel="integration time T", ylabel=None)
    for k, (name, fld) in fields.items():
        pts = []
        for T in Ts:
            e = err(fld, T) if T > 0 else 1e-6
            pts.append((ax.X(T), ax.Y(math.log10(max(e, 1e-8)))))
        f.poly(pts, f"f-{k}-line")
    f.legend(600, 50, [(v[0], f"f-{k}-line") for k, v in fields.items()])
    f.text(600, 130, "log₁₀ of the error in x(0)", "f-muted", 12.5)
    f.text(600, 148, "after integrating back from a", "f-muted", 12.5)
    f.text(600, 166, "state perturbed by 10⁻⁶.", "f-muted", 12.5)
    f.text(600, 184, "Damping amplifies it.", "f-muted", 12.5)
    return f
