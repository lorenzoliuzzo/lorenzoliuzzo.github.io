"""The SIFT descriptor: a 16x16 window cut into 4x4 cells, each summarized by an 8-bin histogram of gradient orientations, 4 x 4 x 8 = 128 numbers."""
import math
import random
from kit import Fig


def build():
    rng = random.Random(2)
    f = Fig(760, 300)
    x0, y0, cell = 40, 30, 62
    for i in range(5):
        f.line(x0 + i * cell, y0, x0 + i * cell, y0 + 4 * cell, "f-grid")
        f.line(x0, y0 + i * cell, x0 + 4 * cell, y0 + i * cell, "f-grid")
    f.rect(x0, y0, 4 * cell, 4 * cell, "f-line")
    # a dominant gradient direction that drifts across the window, plus noise, then Gaussian weighting
    for r in range(4):
        for c in range(4):
            cx, cy = x0 + (c + 0.5) * cell, y0 + (r + 0.5) * cell
            fade = math.exp(-(((c - 1.5) ** 2 + (r - 1.5) ** 2) / 4.0))
            lead = (r + c) % 8
            for b in range(8):
                ang = b * math.pi / 4
                v = (0.25 + 1.0 * math.exp(-min((b - lead) % 8, (lead - b) % 8) ** 2 / 2) + rng.random() * 0.2) * fade
                L = 28 * v / 1.3
                f.line(cx, cy, cx + L * math.cos(ang), cy - L * math.sin(ang), "f-a-line")
            f.circle(cx, cy, 2.2, "f-a-solid")
    f.text(x0, 20, "16 × 16 window, 4 × 4 cells", "f-ink", 13, weight=600)
    f.text(330, 70, "Each cell holds 8 spokes,", "f-muted", 12.5)
    f.text(330, 87, "one per gradient orientation;", "f-muted", 12.5)
    f.text(330, 104, "the length is the magnitude", "f-muted", 12.5)
    f.text(330, 121, "summed over the cell, faded", "f-muted", 12.5)
    f.text(330, 138, "away from the keypoint.", "f-muted", 12.5)
    f.text(330, 176, "16 cells × 8 orientations", "f-ink", 13, weight=600)
    f.text(330, 196, "= 128 numbers, then", "f-ink", 13, weight=600)
    f.text(330, 216, "normalized, clipped at 0.2", "f-muted", 12.5)
    f.text(330, 233, "and normalized again.", "f-muted", 12.5)
    return f
