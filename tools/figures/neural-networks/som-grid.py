"""An 8 by 8 self-organizing map before and after training on points of the unit square: the grid unfolds over the data (errors computed from the trained map)."""
import math
import random
from kit import Fig

G = 8
STEPS = 5000


def train(rng):
    w = [[0.5 + rng.uniform(-0.04, 0.04), 0.5 + rng.uniform(-0.04, 0.04)] for _ in range(G * G)]
    init = [u[:] for u in w]
    for t in range(STEPS):
        frac = t / STEPS
        eta = 0.5 * (0.02 / 0.5) ** frac
        sig = 3.0 * (0.5 / 3.0) ** frac
        x = (rng.random(), rng.random())
        c = min(range(G * G), key=lambda i: (w[i][0] - x[0]) ** 2 + (w[i][1] - x[1]) ** 2)
        cr, cc = divmod(c, G)
        for i in range(G * G):
            r, q = divmod(i, G)
            h = math.exp(-((r - cr) ** 2 + (q - cc) ** 2) / (2 * sig * sig))
            w[i][0] += eta * h * (x[0] - w[i][0])
            w[i][1] += eta * h * (x[1] - w[i][1])
    return init, w


def errors(w, data):
    qe = te = 0
    for x in data:
        d = sorted(range(G * G), key=lambda i: (w[i][0] - x[0]) ** 2 + (w[i][1] - x[1]) ** 2)
        qe += math.dist(w[d[0]], x)
        a, b = divmod(d[0], G), divmod(d[1], G)
        te += abs(a[0] - b[0]) + abs(a[1] - b[1]) > 1
    return qe / len(data), te / len(data)


def draw(f, ax, w, data=None):
    for r in range(G):
        for q in range(G):
            i = r * G + q
            if q + 1 < G:
                f.line(ax.X(w[i][0]), ax.Y(w[i][1]), ax.X(w[i + 1][0]), ax.Y(w[i + 1][1]), "f-a-line")
            if r + 1 < G:
                f.line(ax.X(w[i][0]), ax.Y(w[i][1]), ax.X(w[i + G][0]), ax.Y(w[i + G][1]), "f-a-line")
    for u in w:
        ax.point(u[0], u[1], 3.4, "f-a-solid")


def build():
    rng = random.Random(2)
    init, w = train(rng)
    data = [(rng.random(), rng.random()) for _ in range(500)]
    qe, te = errors(w, data)
    f = Fig(760, 310)
    for left, title, units in ((40, "start: units bunched at the centre", init), (400, f"after {STEPS} samples", w)):
        ax = f.axes(left, 40, 300, 220, (0, 1), (0, 1))
        f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
        f.text(left, 26, title, "f-ink", 13.5, weight=600)
        draw(f, ax, units)
    f.text(550, 288, f"quantization error {qe:.3f}, topographic error {te:.2f}", "f-muted", 13, "middle")
    f.text(190, 288, "grid lines join units that are neighbours on the map", "f-muted", 13, "middle")
    return f
