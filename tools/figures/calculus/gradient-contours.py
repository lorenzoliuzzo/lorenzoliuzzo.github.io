"""Level curves of f = x^2 + 2 y^2 with the gradient at points on two of them: it is perpendicular to the level curve and points uphill, longer where the curves crowd."""
import math
from kit import Fig


def build():
    f = Fig(760, 340)
    ax = f.axes(52, 20, 470, 270, (-3.2, 3.2), (-2.2, 2.2))
    ax.frame(xticks=(-3, -2, -1, 0, 1, 2, 3), yticks=(-2, -1, 0, 1, 2), xlabel="*x*", ylabel="*y*")
    for c in (1, 2, 4, 6, 8):
        pts = [(ax.X(math.sqrt(c) * math.cos(t * math.pi / 60)), ax.Y(math.sqrt(c / 2) * math.sin(t * math.pi / 60))) for t in range(120)]
        f.poly(pts, "f-a-line", close=True)
    k = 0.11
    for c, cls in ((2, "f-b-line"), (4, "f-b-line")):
        for a in (0.4, 1.1, 2.0, 2.9, 3.8, 5.0):
            x, y = math.sqrt(c) * math.cos(a), math.sqrt(c / 2) * math.sin(a)
            gx, gy = 2 * x, 4 * y
            f.arrow(ax.X(x), ax.Y(y), ax.X(x + k * gx), ax.Y(y + k * gy), cls)
            f.circle(ax.X(x), ax.Y(y), 2.5, "f-b-solid")
    f.text(555, 70, "*f* = *x*^{2} + 2*y*^{2}", "f-ink", 13)
    f.text(555, 100, "Blue: level curves.", "f-muted", 12.5)
    f.text(555, 118, "Orange: ∇*f* = (2*x*, 4*y*),", "f-muted", 12.5)
    f.text(555, 136, "normal to the curve,", "f-muted", 12.5)
    f.text(555, 154, "pointing uphill, longer", "f-muted", 12.5)
    f.text(555, 172, "where curves crowd.", "f-muted", 12.5)
    return f
