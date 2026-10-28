"""Gradient descent and heavy-ball momentum on f = (x^2 + 10 y^2)/2 from (8, 1.5): plain steps zigzag across the narrow valley, momentum smooths them and reaches the minimum sooner. Plain: eta = 0.18; momentum: eta = 0.1, beta = 0.5."""
import math
from kit import Fig

H = (1.0, 10.0)


def grad(p):
    return (H[0] * p[0], H[1] * p[1])


def path(eta, beta, n):
    x = (8.0, 1.5)
    prev = x
    pts = [x]
    for _ in range(n):
        g = grad(x)
        new = (x[0] - eta * g[0] + beta * (x[0] - prev[0]), x[1] - eta * g[1] + beta * (x[1] - prev[1]))
        prev, x = x, new
        pts.append(x)
    return pts


def build():
    f = Fig(760, 310)
    ax = f.axes(52, 20, 480, 240, (-1, 9), (-2.2, 2.2))
    ax.frame(xticks=(0, 2, 4, 6, 8), yticks=(-2, 0, 2), xlabel="*x*", ylabel="*y*")
    for c in (1, 4, 12, 24):
        for half in (range(0, 61), range(60, 121)):
            pts = [(math.sqrt(2 * c) * math.cos(t * math.pi / 60), math.sqrt(2 * c / 10) * math.sin(t * math.pi / 60)) for t in half]
            pts = [(ax.X(x), ax.Y(y)) for x, y in pts if x >= -0.95]   # keep the part inside the frame
            f.poly(pts, "f-grid")
    for pts, cls in ((path(0.18, 0, 14), "f-b-line"), (path(0.1, 0.5, 14), "f-a-line")):
        f.poly([(ax.X(x), ax.Y(y)) for x, y in pts], cls)
        for x, y in pts:
            f.circle(ax.X(x), ax.Y(y), 2.6, cls.replace("-line", "-solid"))
    f.legend(560, 60, [("plain gradient descent", "f-b-line"), ("with momentum", "f-a-line")])
    f.text(560, 120, "14 steps from (8, 1.5): loss", "f-muted", 12.5)
    f.text(560, 138, "0.145 plain, 0.004 with momentum.", "f-muted", 12.5)
    f.text(560, 168, "Plain steps cross the valley", "f-muted", 12.5)
    f.text(560, 186, "back and forth; momentum", "f-muted", 12.5)
    f.text(560, 204, "averages the zigzag out.", "f-muted", 12.5)
    return f
