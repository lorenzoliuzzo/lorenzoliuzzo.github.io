"""The epsilon-delta definition drawn for sin(x)/x at x = 0."""
import math
from kit import Fig

EPS = 0.1


def g(x):
    return 1.0 if x == 0 else math.sin(x) / x


def delta(eps=EPS):
    lo, hi = 0.0, 3.0
    for _ in range(60):
        mid = (lo + hi) / 2
        if 1 - g(mid) < eps:
            lo = mid
        else:
            hi = mid
    return lo


def build():
    d = delta()
    f = Fig(760, 300)
    ax = f.axes(60, 20, 480, 220, (-2, 2), (0.4, 1.1))
    ax.frame(xticks=(-2, -1, 0, 1, 2), yticks=(0.4, 0.6, 0.8, 0.9, 1.0), xlabel="*x*")
    f.rect(ax.X(-2), ax.Y(1 + EPS), ax.w, ax.Y(1 - EPS) - ax.Y(1 + EPS), "f-b-fill")
    f.rect(ax.X(-d), ax.Y(1.1), ax.X(d) - ax.X(-d), ax.h, "f-a-fill")
    ax.curve(lambda x: g(x), -2, 2, "f-a-line")
    f.circle(ax.X(0), ax.Y(1), 4.5, "f-box")
    f.line(ax.X(0) - 4.5, ax.Y(1), ax.X(0) + 4.5, ax.Y(1), "f-line") if False else None
    f.text(560, 70, "sin(*x*)/*x*, *L* = 1", "f-ink", 13)
    f.text(560, 100, f"band: *L* ± ε, ε = {EPS:g}", "f-muted", 12.5)
    f.text(560, 120, f"window: |*x*| < δ = {d:.2f}", "f-muted", 12.5)
    f.text(560, 150, "Inside the window every", "f-muted", 12.5)
    f.text(560, 168, "point of the graph lies", "f-muted", 12.5)
    f.text(560, 186, "inside the band. The value", "f-muted", 12.5)
    f.text(560, 204, "at *x* = 0 is not used.", "f-muted", 12.5)
    return f
