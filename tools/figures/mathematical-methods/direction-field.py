"""Direction field of dx/dt = x(1 - x) with solution curves approaching the stable point x = 1."""
import math
from kit import Fig


def rhs(x):
    return x * (1 - x)


def logistic(t, x0):
    return 1 / (1 + (1 / x0 - 1) * math.exp(-t))


def build():
    f = Fig(760, 310)
    ax = f.axes(60, 20, 480, 250, (0, 6), (-0.4, 1.6))
    ax.frame(xticks=(0, 1, 2, 3, 4, 5, 6), yticks=(0, 0.5, 1.0, 1.5), xlabel="time *t*", ylabel="*x*")
    for i in range(0, 25):
        for j in range(-1, 9):
            t, x = i * 0.25, -0.2 + j * 0.2
            m = rhs(x)
            n = math.hypot(1, m)
            dx, dy = 0.09 / n * 1, 0.09 * m / n
            f.line(ax.X(t - dx), ax.Y(x - dy * 0.9), ax.X(t + dx), ax.Y(x + dy * 0.9), "f-grid")
    for x0 in (0.05, 0.2, 0.5, 1.4):
        ax.curve(lambda t, x0=x0: logistic(t, x0), 0, 6, "f-a-line")
    ax.curve(lambda t: 1.0, 0, 6, "f-b-line f-dash", 2)
    ax.curve(lambda t: 0.0, 0, 6, "f-c-line f-dash", 2)
    f.text(570, 60, "d*x*/d*t* = *x* (1 − *x*)", "f-ink", 13)
    f.text(570, 90, "*x* = 1: stable", "f-muted", 12.5)
    f.text(570, 108, "*x* = 0: unstable", "f-muted", 12.5)
    f.text(570, 138, "*x*(*t*) = 1 / (1 + (1/*x*_{0} − 1) e^{−t})", "f-muted", 12.5)
    return f
