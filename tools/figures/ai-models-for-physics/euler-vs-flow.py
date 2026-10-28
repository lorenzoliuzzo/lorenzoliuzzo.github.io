"""Euler steps of a residual network against the exact flow of the logistic field x' = x(1-x)."""
import math
from kit import Fig


def euler(x0, T, n):
    h = T / n
    xs = [x0]
    for _ in range(n):
        x = xs[-1]
        xs.append(x + h * x * (1 - x))
    return xs


def build():
    T, x0 = 8.0, 0.05
    f = Fig(760, 290)
    ax = f.axes(56, 24, 520, 220, (0, T), (0, 1.3))
    ax.frame(xticks=range(0, 9, 2), yticks=(0, 0.5, 1.0), xlabel="depth t", ylabel=None)
    ax.curve(lambda t: 1 / (1 + (1 / x0 - 1) * math.exp(-t)), 0, T, "f-line")
    for n, c in ((4, "b"), (8, "c"), (32, "a")):
        xs = euler(x0, T, n)
        f.poly([(ax.X(i * T / n), ax.Y(v)) for i, v in enumerate(xs)], f"f-{c}-line")
        for i, v in enumerate(xs):
            ax.point(i * T / n, v, 2.5, f"f-{c}-solid")
    f.legend(600, 50, [("exact flow", "f-line"), ("4 blocks", "f-b-line"), ("8 blocks", "f-c-line"), ("32 blocks", "f-a-line")])
    f.text(600, 150, "Each block adds h·f(x) to its", "f-muted", 12.5)
    f.text(600, 168, "input. More, smaller blocks", "f-muted", 12.5)
    f.text(600, 186, "approach the flow of the field.", "f-muted", 12.5)
    return f
