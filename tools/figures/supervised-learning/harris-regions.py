"""The Harris response over the plane of the two eigenvalues of M: flat near the origin, edges along the axes, corners where both are large."""
import math
from kit import Fig

K, T = 0.05, 3.0


def corner_branch(l1, sign):
    # solve K l2^2 - (1 - 2K) l1 l2 + K l1^2 + T = 0 for l2
    disc = ((1 - 2 * K) * l1) ** 2 - 4 * K * (K * l1 ** 2 + T)
    return ((1 - 2 * K) * l1 + sign * math.sqrt(max(disc, 0))) / (2 * K)


def build():
    f = Fig(760, 330)
    ax = f.axes(60, 20, 300, 270, (0, 10), (0, 10))
    ax.frame(xticks=(0, 5, 10), yticks=(0, 5, 10), xlabel="λ₁", ylabel="λ₂", grid=False)
    lo = math.sqrt(12 * K / (1 - 4 * K))
    xs = [lo + (10 - lo) * i / 80 for i in range(81)]
    corner = [(ax.X(x), ax.Y(min(10, corner_branch(x, -1)))) for x in xs] + [(ax.X(x), ax.Y(min(10, corner_branch(x, 1)))) for x in reversed(xs)]
    f.poly(corner, "f-a-fill", close=True)
    f.poly(corner, "f-a-line", close=True)
    r = (0.9 - math.sqrt(0.81 - 4 * K * K)) / (2 * K)
    f.poly([(ax.X(0), ax.Y(0)), (ax.X(10), ax.Y(10 * r)), (ax.X(10), ax.Y(0))], "f-b-fill", close=True)
    f.poly([(ax.X(0), ax.Y(0)), (ax.X(10 * r), ax.Y(10)), (ax.X(0), ax.Y(10))], "f-b-fill", close=True)
    ax.text(6.1, 6.1, "corner", "f-a", 13, "middle", 600)
    f.text(ax.X(10) + 8, ax.Y(0.3) + 4, "edge", "f-b", 13, weight=600)
    f.text(ax.X(0.3), ax.y0 - 6, "edge", "f-b", 13, "middle", 600)
    ax.text(0.9, 0.9, "flat", "f-muted", 13, "start", 600)
    f.text(404, 70, "R = λ₁λ₂ − k(λ₁ + λ₂)²", "f-ink", 13.5, weight=600)
    f.text(404, 94, "Both eigenvalues large: R is large", "f-muted", 12.5)
    f.text(404, 111, "and positive, a corner.", "f-muted", 12.5)
    f.text(404, 137, "One large, one small: R < 0, an edge.", "f-muted", 12.5)
    f.text(404, 163, "Both small: |R| is small, a flat patch.", "f-muted", 12.5)
    f.text(404, 197, "Drawn for k = 0.05; the corner", "f-muted", 12.5)
    f.text(404, 214, "boundary is R = 3.", "f-muted", 12.5)
    return f
