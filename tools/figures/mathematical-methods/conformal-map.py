"""The map w = z^2 sends a square grid to two families of parabolas that still cross at right angles."""
import math
from kit import Fig


def build():
    f = Fig(760, 330)
    s = 62
    ox, oy = 150, 175
    P = lambda x, y: (ox + x * s, oy - y * s)
    for k in (0.5, 1.0, 1.5):
        for sgn in (1, -1):
            f.line(*P(sgn * k, -1.8), *P(sgn * k, 1.8), "f-a-line")
            f.line(*P(-1.8, sgn * k), *P(1.8, sgn * k), "f-b-line")
    f.line(*P(-1.9, 0), *P(1.9, 0), "f-grid")
    f.line(*P(0, -1.9), *P(0, 1.9), "f-grid")
    f.text(ox - 110, 22, "*z* plane: lines *x*, *y* = const", "f-muted", 12.5)
    ox2, s2 = 540, 24
    P2 = lambda u, v: (ox2 + u * s2, oy - v * s2)
    # x = k  ->  u = k^2 - y^2, v = 2 k y;  y = k -> u = x^2 - k^2, v = 2 x k
    for k in (0.5, 1.0, 1.5):
        ys = [-1.8 + 3.6 * i / 100 for i in range(101)]
        f.poly([P2(k * k - y * y, 2 * k * y) for y in ys], "f-a-line")
        f.poly([P2(-(k * k) + y * y, 2 * k * y) for y in ys], "f-a-line")
        f.poly([P2(x * x - k * k, 2 * x * k) for x in ys], "f-b-line")
        f.poly([P2(x * x - k * k, -2 * x * k) for x in ys], "f-b-line")
    f.line(*P2(-6, 0), *P2(6, 0), "f-grid")
    f.line(*P2(0, -5), *P2(0, 5), "f-grid")
    f.text(ox2 - 150, 22, "*w* = *z*^{2}: parabolas, still perpendicular", "f-muted", 12.5)
    return f
