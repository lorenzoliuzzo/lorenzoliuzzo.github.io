"""A Mexican-hat potential: the radial direction costs energy, the angular direction along the ring of minima costs none."""
import math
from kit import Fig


def V(x):
    return -x * x + 0.5 * x ** 4


def build():
    f = Fig(760, 300)
    ax = f.axes(50, 30, 300, 220, (-1.6, 1.6), (-0.7, 1.2))
    ax.frame(xticks=(-1, 0, 1), yticks=(-0.5, 0, 0.5, 1.0), xlabel="φ₁ (with φ₂ = 0)", ylabel=None)
    ax.curve(V, -1.6, 1.6, "f-a-line")
    ax.point(-1, V(1), 4.5, "f-b-solid")
    ax.point(1, V(1), 4.5, "f-b-solid")
    cx, cy, R = 560, 140, 80
    pts = [(cx + R * math.cos(2 * math.pi * i / 90), cy + R * math.sin(2 * math.pi * i / 90)) for i in range(91)]
    f.poly(pts, "f-b-line")
    for r in (40, 105):
        f.poly([(cx + r * math.cos(2 * math.pi * i / 90), cy + r * math.sin(2 * math.pi * i / 90)) for i in range(91)], "f-line f-dash")
    a = math.radians(-40)
    px, py = cx + R * math.cos(a), cy + R * math.sin(a)
    f.circle(px, py, 5, "f-b-solid")
    f.arrow(px, py, px + 45 * (-math.sin(a)), py + 45 * math.cos(a), "f-a-line")
    f.arrow(px, py, px + 42 * math.cos(a), py + 42 * math.sin(a), "f-c-line")
    f.text(cx, 268, "Along the ring: Goldstone mode, no cost.", "f-ink", 12, "middle")
    f.text(cx, 286, "Radial: restoring force, a massive mode.", "f-muted", 12, "middle")
    return f
