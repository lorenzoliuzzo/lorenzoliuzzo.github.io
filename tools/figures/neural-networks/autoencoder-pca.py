"""A one-number code: a straight line (PCA, the linear autoencoder) misses the arc that a curved decoder follows (the true curve stands in for a trained decoder)."""
import math
import random
from kit import Fig

CURVE = lambda t: 0.9 * (1 - t * t)


def build():
    rng = random.Random(11)
    ts = [rng.uniform(-1, 1) for _ in range(40)]
    pts = [(t, CURVE(t) + rng.gauss(0, 0.05)) for t in ts]
    n = len(pts)
    mx = sum(p[0] for p in pts) / n
    my = sum(p[1] for p in pts) / n
    sxx = sum((p[0] - mx) ** 2 for p in pts) / n
    syy = sum((p[1] - my) ** 2 for p in pts) / n
    sxy = sum((p[0] - mx) * (p[1] - my) for p in pts) / n
    th = 0.5 * math.atan2(2 * sxy, sxx - syy)
    ux, uy = math.cos(th), math.sin(th)
    proj = []
    for x, y in pts:
        s = (x - mx) * ux + (y - my) * uy
        proj.append((mx + s * ux, my + s * uy))
    mse_lin = sum((x - px) ** 2 + (y - py) ** 2 for (x, y), (px, py) in zip(pts, proj)) / n
    mse_cur = sum((y - CURVE(x)) ** 2 for x, y in pts) / n
    f = Fig(760, 300)
    for left, title in ((40, "linear code: PCA line"), (400, "curved code: decoder follows the arc")):
        ax = f.axes(left, 44, 300, 200, (-1.3, 1.3), (-0.4, 1.2))
        f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
        f.text(left, 28, title, "f-ink", 13.5, weight=600)
        if left == 40:
            f.line(ax.X(mx - 1.25 * ux), ax.Y(my - 1.25 * uy), ax.X(mx + 1.25 * ux), ax.Y(my + 1.25 * uy), "f-a-line")
            for (x, y), (px, py) in zip(pts, proj):
                f.line(ax.X(x), ax.Y(y), ax.X(px), ax.Y(py), "f-b-line f-dash")
            f.text(left + 150, 272, f"mean squared error {mse_lin:.3f}", "f-muted", 13, "middle")
        else:
            ax.curve(CURVE, -1.15, 1.15, "f-a-line")
            for x, y in pts:
                f.line(ax.X(x), ax.Y(y), ax.X(x), ax.Y(CURVE(x)), "f-b-line f-dash")
            f.text(left + 150, 272, f"mean squared error {mse_cur:.3f}", "f-muted", 13, "middle")
        for x, y in pts:
            ax.point(x, y, 3.2, "f-ink")
    return f
