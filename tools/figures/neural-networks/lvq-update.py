"""One LVQ step: the winner has the wrong class, so it is repelled and the nearest vector of the right class is attracted, and the boundary between them moves towards the point."""
import math

from kit import Fig

ETA = 0.3
R1, R2, X = (0.25, 0.5), (0.75, 0.5), (0.55, 0.75)


def move(r, x, sign):
    return (r[0] + sign * ETA * (x[0] - r[0]), r[1] + sign * ETA * (x[1] - r[1]))


def bisector(a, b):
    """End points, inside the unit square, of the perpendicular bisector of a and b."""
    mx, my = (a[0] + b[0]) / 2, (a[1] + b[1]) / 2
    nx, ny = b[0] - a[0], b[1] - a[1]
    dx, dy = -ny, nx
    pts = []
    for t in [(0 - mx) / dx if dx else None, (1 - mx) / dx if dx else None, (0 - my) / dy if dy else None, (1 - my) / dy if dy else None]:
        if t is None:
            continue
        x, y = mx + t * dx, my + t * dy
        if -1e-9 <= x <= 1 + 1e-9 and -1e-9 <= y <= 1 + 1e-9:
            pts.append((x, y))
    return pts[0], pts[-1]


def draw(f, ax, r1, r2, x, title, arrows=None):
    f.text(ax.x0, 26, title, "f-ink", 14, weight=600)
    ax.frame(xticks=(), yticks=(), grid=False, yaxis=False)
    f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
    p, q = bisector(r1, r2)
    f.line(ax.X(p[0]), ax.Y(p[1]), ax.X(q[0]), ax.Y(q[1]), "f-line f-dash")
    if arrows:
        for src, dst in arrows:
            f.circle(ax.X(src[0]), ax.Y(src[1]), 8, "f-box")
            f.circle(ax.X(src[0]), ax.Y(src[1]), 8, "f-line f-dash")
            f.arrow(ax.X(src[0]), ax.Y(src[1]), ax.X(dst[0]), ax.Y(dst[1]), "f-line")
    ax.point(*r1, 8, "f-a-solid")
    ax.point(*r2, 8, "f-b-solid")
    ax.point(*x, 5, "f-a-solid")
    f.circle(ax.X(x[0]), ax.Y(x[1]), 9, "f-a-line")
    ax.text(r1[0] - 0.02, r1[1] - 0.09, "r_{1}", "f-a", 13, "middle")
    ax.text(r2[0] + 0.02, r2[1] - 0.09, "r_{2}", "f-b", 13, "middle")
    ax.text(x[0] + 0.03, x[1] + 0.02, "x", "f-a", 13)


def build():
    f = Fig(760, 290)
    new1, new2 = move(R1, X, +1), move(R2, X, -1)
    left = f.axes(40, 46, 220, 220, (0, 1), (0, 1))
    right = f.axes(300, 46, 220, 220, (0, 1), (0, 1))
    draw(f, left, R1, R2, X, "before: x is wrongly classified")
    draw(f, right, new1, new2, X, "after: r₁ attracted, r₂ repelled", [(R1, new1), (R2, new2)])
    f.text(550, 100, "Blue: class A.", "f-muted", 12.5)
    f.text(550, 118, "Orange: class B.", "f-muted", 12.5)
    f.text(550, 150, "The point x is class A but", "f-muted", 12.5)
    f.text(550, 168, "closer to r₂, so the nearest", "f-muted", 12.5)
    f.text(550, 186, "vector has the wrong class.", "f-muted", 12.5)
    f.text(550, 214, "Dashes: the boundary between", "f-muted", 12.5)
    f.text(550, 232, "the two vectors. Step η = 0.3.", "f-muted", 12.5)
    return f
