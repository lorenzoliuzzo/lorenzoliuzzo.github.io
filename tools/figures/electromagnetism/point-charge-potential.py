"""Equipotentials of a point charge at equal steps of V crowd toward the charge (left); the same levels on the curve V = 1/r (right), where the slope is the field."""
import math
from kit import Fig

LEVELS = (1, 2, 3, 4, 5, 6)


def build():
    f = Fig(760, 290)
    cx, cy, s = 170, 145, 118
    for k in range(12):
        a = k * math.pi / 6
        f.line(cx + 14 * math.cos(a), cy - 14 * math.sin(a), cx + 140 * math.cos(a), cy - 140 * math.sin(a), "f-grid")
    for v in LEVELS:
        pts = [(cx + s / v * math.cos(t * math.pi / 60), cy - s / v * math.sin(t * math.pi / 60)) for t in range(120)]
        f.poly(pts, "f-a-line", close=True)
    for v in (1, 2):
        d = s / v * math.sqrt(0.5)
        f.text(cx + d + 4, cy - d - 3, f"*V* = {v}", "f-muted", 11.5)
    f.circle(cx, cy, 4, "f-b-solid")
    f.text(cx, 282, "equipotentials, equal steps in *V*", "f-muted", 12.5, "middle")
    ax = f.axes(400, 24, 330, 226, (0, 1.25), (0, 6.6))
    ax.frame(xticks=(0, 0.5, 1.0), yticks=(0, 2, 4, 6), xlabel="distance *r*", ylabel="potential *V*")
    ax.curve(lambda r: 1 / r, 0.155, 1.25, "f-a-line")
    for v in LEVELS:
        ax.vline(1 / v, 0, v, "f-line f-dash")
        ax.point(1 / v, v, 3.5, "f-b-solid")
    ax.text(0.55, 5.4, "steepest where the", "f-muted", 12)
    ax.text(0.55, 4.8, "equipotentials crowd", "f-muted", 12)
    return f
