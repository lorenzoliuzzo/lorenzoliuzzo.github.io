"""Why the lasso lands on an axis and ridge does not: the elliptical error contours meet a diamond at a corner and a disc in the open."""
import math
from kit import Fig

A = ((1.0, 0.5), (0.5, 1.2))
BH = (2.4, 0.5)
T = 1.5


def rss(b1, b2):
    d1, d2 = b1 - BH[0], b2 - BH[1]
    return A[0][0] * d1 * d1 + 2 * A[0][1] * d1 * d2 + A[1][1] * d2 * d2


def argmin_on(points):
    return min(points, key=lambda p: rss(*p))


def ellipse_pts(level, n=90):
    # contour A(d,d) = level, from the eigen-decomposition of A
    tr, det = A[0][0] + A[1][1], A[0][0] * A[1][1] - A[0][1] ** 2
    l1, l2 = tr / 2 + math.sqrt(tr * tr / 4 - det), tr / 2 - math.sqrt(tr * tr / 4 - det)
    th = 0.5 * math.atan2(2 * A[0][1], A[0][0] - A[1][1])
    out = []
    for i in range(n + 1):
        a = 2 * math.pi * i / n
        u, v = math.sqrt(level / l1) * math.cos(a), math.sqrt(level / l2) * math.sin(a)
        out.append((BH[0] + u * math.cos(th) - v * math.sin(th), BH[1] + u * math.sin(th) + v * math.cos(th)))
    return out


def build():
    f = Fig(760, 292)
    circle = [(T * math.cos(a / 400 * 2 * math.pi), T * math.sin(a / 400 * 2 * math.pi)) for a in range(400)]
    diamond = []
    for i in range(800):
        s = 4 * T * i / 800
        k, r = divmod(s, T)
        pts = ((T - r, r), (-r, T - r), (-T + r, -r), (r, -T + r))[int(k) % 4]
        diamond.append(pts)
    for left, shape, title, _ in ((40, circle, "ridge: b₁² + b₂² ≤ t²", "ridge"), (400, diamond, "lasso: |b₁| + |b₂| ≤ t", "lasso")):
        ax = f.axes(left, 34, 300, 206, (-2.2, 3.6), (-2.2, 2.1))
        ax.frame(xticks=(-2, 0, 2), yticks=(), grid=False, yaxis=False, xlabel="b₁")
        f.line(ax.X(0), ax.Y(-2.2), ax.X(0), ax.Y(2.1), "f-axis")
        best = argmin_on(shape)
        for k in (1.6, 1.0):
            f.poly([(ax.X(x), ax.Y(y)) for x, y in ellipse_pts(rss(*best) * k)], "f-a-line f-dash")
        f.poly([(ax.X(x), ax.Y(y)) for x, y in ellipse_pts(rss(*best))], "f-a-line")
        f.poly([(ax.X(x), ax.Y(y)) for x, y in shape], "f-b-fill", close=True)
        f.poly([(ax.X(x), ax.Y(y)) for x, y in shape], "f-b-line", close=True)
        ax.point(*BH, 4, "f-a-solid")
        ax.point(*best, 5, "f-b-solid")
        f.text(ax.X(BH[0]) + 2, ax.Y(BH[1]) + 24, "least squares", "f-a", 12.5, "middle", 600)
        f.text(left, 22, title, "f-ink", 13.5, weight=600)
        f.text(ax.X(0) + 7, ax.Y(2.0), "b₂", "f-muted", 13)
    return f
