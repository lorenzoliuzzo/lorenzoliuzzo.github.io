"""Energy error of Euler, Runge-Kutta 4 and leapfrog on the harmonic oscillator with the same step."""
import math
from kit import Fig

H = 0.1
TMAX = 100.0


def energy(x, v):
    return 0.5 * (x * x + v * v)


def euler(x, v):
    return x + H * v, v - H * x


def rk4(x, v):
    def a(x, v):
        return v, -x
    k1 = a(x, v)
    k2 = a(x + H / 2 * k1[0], v + H / 2 * k1[1])
    k3 = a(x + H / 2 * k2[0], v + H / 2 * k2[1])
    k4 = a(x + H * k3[0], v + H * k3[1])
    return x + H / 6 * (k1[0] + 2 * k2[0] + 2 * k3[0] + k4[0]), v + H / 6 * (k1[1] + 2 * k2[1] + 2 * k3[1] + k4[1])


def leap(x, v):
    v2 = v - H / 2 * x
    x2 = x + H * v2
    return x2, v2 - H / 2 * x2


def run(step):
    x, v = 1.0, 0.0
    e0 = energy(x, v)
    out = []
    for i in range(int(TMAX / H) + 1):
        if i % 10 == 0:
            out.append((i * H, math.log10(max(abs(energy(x, v) / e0 - 1), 1e-17))))
        x, v = step(x, v)
    return out


def build():
    f = Fig(760, 300)
    ax = f.axes(70, 20, 470, 230, (0, 100), (-17, 5))
    ax.frame(xticks=(0, 25, 50, 75, 100), yticks=(-16, -12, -8, -4, 0, 4), xlabel="time *t* (period 2π = 6.28)", ylabel="|Δ*E* / *E*_{0}|", yfmt=lambda v: f"10^{{{int(v)}}}".replace("-", "−"))
    for fn, cls in ((euler, "f-c-line"), (rk4, "f-b-line"), (leap, "f-a-line")):
        f.poly([(ax.X(t), ax.Y(y)) for t, y in run(fn)], cls)
    f.legend(570, 50, [("Euler", "f-c-line"), ("Runge-Kutta 4", "f-b-line"), ("leapfrog", "f-a-line")])
    f.text(570, 130, "step *h* = 0.1.", "f-muted", 12.5)
    f.text(570, 148, "Euler grows without bound,", "f-muted", 12.5)
    f.text(570, 166, "leapfrog oscillates, RK4 drifts.", "f-muted", 12.5)
    return f
