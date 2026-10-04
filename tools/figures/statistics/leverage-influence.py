"""The same outlier, in the middle and at the edge of the x range: only the edge one tilts the fitted line."""
import random
from kit import Fig
from linalg import lstsq


def fit(xs, ys):
    b0, b1 = lstsq([[1, x] for x in xs], ys)
    return b0, b1


def build():
    rng = random.Random(7)
    xs = [1 + 0.5 * i + rng.uniform(-0.15, 0.15) for i in range(0, 17, 2)] + [2.2, 3.9, 5.6, 6.9]
    ys = [1.0 + 0.6 * x + rng.gauss(0, 0.45) for x in xs]
    f = Fig(760, 280)
    panels = ((52, 5.0, "outlier in the middle"), (372, 12.2, "same outlier at the edge"))
    for left, ox, title in panels:
        ax = f.axes(left, 30, 280, 200, (0, 13), (0, 14))
        ax.frame(xticks=(0, 4, 8, 12), yticks=(0, 5, 10), xlabel="x", ylabel="y")
        oy = 1.0 + 0.6 * ox + 4.2
        b0, b1 = fit(xs, ys)
        c0, c1 = fit(xs + [ox], ys + [oy])
        ax.curve(lambda x: b0 + b1 * x, 0.2, 12.8, "f-a-line f-dash", n=2)
        ax.curve(lambda x: c0 + c1 * x, 0.2, 12.8, "f-b-line", n=2)
        for x, y in zip(xs, ys):
            ax.point(x, y, 3.2, "f-a-solid")
        ax.point(ox, oy, 5, "f-b-solid")
        allx = xs + [ox]
        xb = sum(allx) / len(allx)
        sxx = sum((x - xb) ** 2 for x in allx)
        h = 1 / len(allx) + (ox - xb) ** 2 / sxx
        f.text(left, 20, title, "f-ink", 13.5, weight=600)
        f.text(left + 12, 58, f"leverage h = {h:.2f}", "f-b", 13, "start", 600)
        f.text(left + 12, 76, f"slope {b1:.2f} → {c1:.2f}", "f-muted", 12.5)
    f.legend(672, 120, [("without", "f-a-line f-dash"), ("with", "f-b-line")], size=12)
    return f
