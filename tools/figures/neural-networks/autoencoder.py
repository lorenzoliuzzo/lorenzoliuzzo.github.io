"""An autoencoder squeezes the input through a narrow code; with linear units its best code is the projection on the principal axes."""
import math
import random

from kit import Fig


def node(f, x, y, kind):
    fill, line = {"in": ("f-c-fill", "f-c-line"), "code": ("f-a-fill", "f-a-line"), "out": ("f-b-fill", "f-b-line")}[kind]
    f.circle(x, y, 13, fill)
    f.circle(x, y, 13, line)


def link(f, a, b):
    d = math.hypot(b[0] - a[0], b[1] - a[1])
    ux, uy = (b[0] - a[0]) / d, (b[1] - a[1]) / d
    f.arrow(a[0] + ux * 13, a[1] + uy * 13, b[0] - ux * 15, b[1] - uy * 15, "f-line")


def data(seed=3, n=40):
    """Elongated cloud, rotated 35 degrees; the seed gives a typical draw."""
    rng = random.Random(seed)
    c, s = math.cos(math.radians(35)), math.sin(math.radians(35))
    pts = []
    for _ in range(n):
        u, v = rng.gauss(0, 1.0), rng.gauss(0, 0.22)
        pts.append((c * u - s * v, s * u + c * v))
    mx, my = sum(p[0] for p in pts) / n, sum(p[1] for p in pts) / n
    return [(x - mx, y - my) for x, y in pts]


def principal_axis(pts):
    sxx = sum(x * x for x, _ in pts)
    syy = sum(y * y for _, y in pts)
    sxy = sum(x * y for x, y in pts)
    ang = 0.5 * math.atan2(2 * sxy, sxx - syy)
    return math.cos(ang), math.sin(ang)


def build():
    f = Fig(760, 290)
    f.text(36, 26, "network: 4 inputs, 2 code units, 4 outputs", "f-ink", 13.5, weight=600)
    layers = [[(70, y) for y in (80, 130, 180, 230)], [(190, y) for y in (105, 205)], [(310, y) for y in (80, 130, 180, 230)]]
    for a, b in zip(layers, layers[1:]):
        for p in a:
            for q in b:
                link(f, p, q)
    for p in layers[0]:
        node(f, *p, "in")
    for p in layers[1]:
        node(f, *p, "code")
    for p in layers[2]:
        node(f, *p, "out")
    f.text(130, 268, "encoder", "f-muted", 12, "middle")
    f.text(250, 268, "decoder", "f-muted", 12, "middle")
    f.text(190, 66, "code", "f-a", 12.5, "middle")

    f.text(430, 26, "linear code of one unit", "f-ink", 13.5, weight=600)
    ax = f.axes(430, 46, 300, 220, (-2.4, 2.4), (-1.8, 1.8))
    pts = data()
    ux, uy = principal_axis(pts)
    f.line(ax.X(-2.4 * ux), ax.Y(-2.4 * uy), ax.X(2.4 * ux), ax.Y(2.4 * uy), "f-a-line")
    err = 0.0
    for x, y in pts:
        t = x * ux + y * uy
        rx, ry = t * ux, t * uy
        err += (x - rx) ** 2 + (y - ry) ** 2
        f.line(ax.X(x), ax.Y(y), ax.X(rx), ax.Y(ry), "f-line f-dash")
        f.circle(ax.X(rx), ax.Y(ry), 3, "f-a-solid")
        f.circle(ax.X(x), ax.Y(y), 3.5, "f-box")
        f.circle(ax.X(x), ax.Y(y), 3.5, "f-line")
    f.text(430, 284, f"Open: inputs. Filled: reconstructions on the first principal axis. Mean squared error {err / len(pts):.3f}.", "f-muted", 12)
    return f
