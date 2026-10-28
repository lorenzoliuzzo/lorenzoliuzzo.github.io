"""Gibbs sampling of a bivariate Gaussian with correlation 0.95."""
import math
import random
from kit import Fig

RHO = 0.95


def build():
    rng = random.Random(4)
    sd = math.sqrt(1 - RHO ** 2)
    x, y = -2.2, -2.2
    path = [(x, y)]
    pts = []
    for t in range(3000):
        x = RHO * y + sd * rng.gauss(0, 1)
        if t < 14:
            path.append((x, y))
        y = RHO * x + sd * rng.gauss(0, 1)
        if t < 14:
            path.append((x, y))
        if t > 20 and t % 3 == 0:
            pts.append((x, y))
    f = Fig(760, 300)
    ax = f.axes(150, 20, 260, 250, (-3, 3), (-3, 3))
    f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
    for px, py in pts:
        if abs(px) < 2.9 and abs(py) < 2.9:
            ax.point(px, py, 1.6, "f-faint")
    f.poly([(ax.X(a), ax.Y(b)) for a, b in path], "f-b-line")
    ax.point(path[0][0], path[0][1], 4.5, "f-b-solid")
    f.text(440, 120, "Orange: the first 14 sweeps", "f-muted", 12.5)
    f.text(440, 138, "from the corner (dot).", "f-muted", 12.5)
    f.text(440, 168, f"Step size per move: {sd:.2f}", "f-muted", 12.5)
    f.text(440, 186, "against a spread of 1.", "f-muted", 12.5)
    return f
