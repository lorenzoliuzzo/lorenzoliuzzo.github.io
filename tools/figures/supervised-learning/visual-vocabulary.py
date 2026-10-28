"""Clustering descriptors gives a visual vocabulary; an image is then the histogram of the words its descriptors fall on."""
import math
import random
from kit import Fig

CENTRES = [(2.2, 6.4), (6.6, 6.8), (4.6, 2.0)]
NAMES = ["W₁", "W₂", "W₃"]


def build():
    rng = random.Random(9)
    f = Fig(760, 300)
    ax = f.axes(40, 44, 330, 210, (0, 9), (0, 9))
    ax.frame(xticks=(), yticks=(), grid=False, yaxis=False)
    f.line(ax.x0, ax.y0, ax.x0, ax.y0 + ax.h, "f-axis")
    f.text(ax.x0, 28, "descriptor space and its three centres", "f-ink", 13, weight=600)
    for (cx, cy), solid in zip(CENTRES, ("f-a-solid", "f-b-solid", "f-d-solid")):
        for _ in range(22):
            ax.point(rng.gauss(cx, 0.75), rng.gauss(cy, 0.75), 2.8, solid)
    for (cx, cy), name in zip(CENTRES, NAMES):
        f.circle(ax.X(cx), ax.Y(cy), 9, "f-line")
        f.text(ax.X(cx) + 12, ax.Y(cy) - 12, name, "f-ink", 13, weight=600)
    # one image: ten descriptors, each counted for its nearest centre
    counts = [4, 2, 4]
    bx = f.axes(430, 44, 290, 210, (0.4, 3.6), (0, 0.5))
    bx.frame(xticks=(), yticks=(0, 0.2, 0.4), grid=True, yfmt=lambda v: f"{v:.1f}")
    f.text(430, 28, "one image: 10 descriptors → histogram", "f-ink", 13, weight=600)
    for i, (c, solid) in enumerate(zip(counts, ("f-a-fill", "f-b-fill", "f-d-fill"))):
        bx.bars([i + 1], [c / 10], 62, cls=solid)
        f.text(bx.X(i + 1), bx.Y(0) + 18, NAMES[i], "f-ink", 13, "middle")
        f.text(bx.X(i + 1), bx.Y(c / 10) - 6, f"{c / 10:.1f}", "f-ink", 12.5, "middle")
    return f
