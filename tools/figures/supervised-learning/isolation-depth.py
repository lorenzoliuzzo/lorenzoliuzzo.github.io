"""Average isolation depth of points on a line under random splits: the lone point is cut off in about two splits, the points in the crowd need many more."""
import random
from kit import Fig

TREES = 600


def depths(points, rng):
    """Depth at which each point ends up alone, in one tree of uniformly random cuts."""
    out = {}

    def grow(group, depth):
        if len(group) == 1:
            out[group[0]] = depth
            return
        lo, hi = min(points[i] for i in group), max(points[i] for i in group)
        if lo == hi:  # identical points can never be separated
            for i in group:
                out[i] = depth
            return
        cut = rng.uniform(lo, hi)
        for part in ([i for i in group if points[i] <= cut], [i for i in group if points[i] > cut]):
            if part:
                grow(part, depth + 1)

    grow(list(range(len(points))), 0)
    return out


def build():
    rng = random.Random(5)
    points = [round(rng.gauss(2.0, 0.7), 2) for _ in range(14)] + [9.0]
    total = [0.0] * len(points)
    for _ in range(TREES):
        for i, d in depths(points, rng).items():
            total[i] += d / TREES
    f = Fig(760, 290)
    ax = f.axes(60, 24, 470, 214, (0, 10), (0, 8))
    ax.frame(xticks=(0, 2, 4, 6, 8, 10), yticks=(0, 2, 4, 6, 8), xlabel="position of the point", ylabel="average depth")
    for x, d in zip(points, total):
        out = x > 8
        f.line(ax.X(x), ax.Y(0), ax.X(x), ax.Y(d), "f-b-line" if out else "f-a-line")
        ax.point(x, d, 4.5, "f-b-solid" if out else "f-a-solid")
    f.text(ax.X(9.0) - 10, ax.Y(total[-1]) - 12, "isolated at depth %.1f" % total[-1], "f-b", 12.5, "end")
    f.text(572, 70, "%d random trees." % TREES, "f-ink", 13, weight=600)
    f.text(572, 96, "A point in the crowd needs", "f-muted", 12.5)
    f.text(572, 113, "about %.0f cuts to be alone;" % (sum(total[:-1]) / (len(total) - 1)), "f-muted", 12.5)
    f.text(572, 130, "the outlier needs %.1f." % total[-1], "f-muted", 12.5)
    f.text(572, 156, "Shallow means unusual.", "f-muted", 12.5)
    return f
