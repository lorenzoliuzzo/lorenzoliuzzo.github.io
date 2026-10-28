"""Two elongated classes projected onto the line through their means (heavy overlap) and onto Fisher's direction (clean separation)."""
import math
import random
from kit import Fig
from linalg import inverse


def sample(rng, mean, n):
    # shared covariance: long axis along (1, 1), short axis across
    pts = []
    for _ in range(n):
        a, b = rng.gauss(0, 1.7), rng.gauss(0, 0.45)
        pts.append((mean[0] + (a - b) / math.sqrt(2), mean[1] + (a + b) / math.sqrt(2)))
    return pts


def cov(P):
    m = [sum(p[i] for p in P) / len(P) for i in (0, 1)]
    return m, [[sum((p[i] - m[i]) * (p[j] - m[j]) for p in P) / (len(P) - 1) for j in (0, 1)] for i in (0, 1)]


def hist(vals, lo, hi, bins):
    h = [0] * bins
    for v in vals:
        h[min(bins - 1, max(0, int((v - lo) / (hi - lo) * bins)))] += 1
    return h


def build():
    rng = random.Random(4)
    pos = sample(rng, (1.2, -0.6), 70)
    neg = sample(rng, (-1.2, 0.6), 70)
    (mp, Sp), (mn, Sn) = cov(pos), cov(neg)
    Sw = [[Sp[i][j] + Sn[i][j] for j in (0, 1)] for i in (0, 1)]
    Si = inverse(Sw)
    d = (mp[0] - mn[0], mp[1] - mn[1])
    w = (Si[0][0] * d[0] + Si[0][1] * d[1], Si[1][0] * d[0] + Si[1][1] * d[1])
    unit = lambda v: (v[0] / math.hypot(*v), v[1] / math.hypot(*v))
    # ink for the naive direction, violet for Fisher's: the class colours (blue, orange) stay for the classes
    dirs = [("mean difference", unit(d), "f-line f-dash", "f-ink"), ("Fisher direction", unit(w), "f-d-line f-dash", "f-d")]

    f = Fig(760, 300)
    ax = f.axes(24, 28, 320, 240, (-5, 5), (-4, 4))
    ax.frame(xticks=(), yticks=(), grid=False, yaxis=False)
    f.line(ax.x0, ax.y0, ax.x0, ax.y0 + ax.h, "f-axis")
    for p in pos:
        ax.point(p[0], p[1], 2.8, "f-a-solid")
    for p in neg:
        ax.point(p[0], p[1], 2.8, "f-b-solid")
    for (name, u, line_cls, _) in dirs:
        ax.fig.line(ax.X(-4.6 * u[0]), ax.Y(-4.6 * u[1]), ax.X(4.6 * u[0]), ax.Y(4.6 * u[1]), line_cls)
    f.text(24, 18, "two classes, one shared shape", "f-ink", 13, weight=600)

    for k, (name, u, _, cls) in enumerate(dirs):
        top = 52 + k * 120
        pa = [p[0] * u[0] + p[1] * u[1] for p in pos]
        pb = [p[0] * u[0] + p[1] * u[1] for p in neg]
        lo, hi = -5.5, 5.5
        bins = 22
        ha, hb = hist(pa, lo, hi, bins), hist(pb, lo, hi, bins)
        top_h = max(ha + hb)
        bx, bw, bh = 400, 330, 72
        for b in range(bins):
            x = bx + b * bw / bins
            for hh, c in ((ha, "f-a-fill"), (hb, "f-b-fill")):
                hgt = hh[b] / top_h * bh
                f.rect(x, top + bh - hgt, bw / bins - 1, hgt, c)
        f.line(bx, top + bh, bx + bw, top + bh, "f-axis")
        f.text(bx, top - 10, f"projection on the {name}", cls, 13, weight=600)
    return f
