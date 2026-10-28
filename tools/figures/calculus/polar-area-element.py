"""Polar coordinates: a coordinate cell between r and r + dr and between theta and theta + dtheta has area close to r dr dtheta, so cells far from the origin are larger. Drawn for dr = 0.5, dtheta = 15 degrees; the highlighted cell is at r = 2.5 to 3, theta = 30 to 45 degrees."""
import math
from kit import Fig

CX, CY, S = 190, 160, 44


def pt(r, t):
    return (CX + S * r * math.cos(t), CY - S * r * math.sin(t))


def arc(r, t0, t1, n=24):
    return [pt(r, t0 + (t1 - t0) * i / n) for i in range(n + 1)]


def build():
    f = Fig(760, 300)
    q = math.pi / 2
    for k in range(1, 7):
        f.poly(arc(k * 0.5, 0, q), "f-grid")
    f.poly(arc(3.0, 0, q), "f-line")
    for k in range(0, 7):
        t = k * math.pi / 12
        f.line(*pt(0, t), *pt(3.0, t), "f-grid")
    f.line(CX, CY, *pt(3.3, 0), "f-axis")
    f.line(CX, CY, *pt(0, 0)[:1], CY - S * 3.3, "f-axis")
    t0, t1 = math.radians(30), math.radians(45)
    cell = arc(2.5, t0, t1) + arc(3.0, t1, t0)[::1]
    f.poly(cell, "f-a-line", close=True)
    f.text(*pt(3.2, math.radians(38)), "*r* d*r* dθ", "f-a", 13)
    f.text(440, 80, "Cartesian cell: area dx dy, the same everywhere.", "f-muted", 12.5)
    f.text(440, 112, "Polar cell: area ≈ *r* d*r* dθ,", "f-muted", 12.5)
    f.text(440, 130, "four times larger at *r* = 3 than at *r* = 0.75.", "f-muted", 12.5)
    f.text(440, 168, "Jacobian of (r, θ) ↦ (x, y):  *r*", "f-ink", 13)
    f.text(440, 200, "The extra factor *r* is what makes the Gaussian", "f-muted", 12.5)
    f.text(440, 218, "integral elementary: ∫ *e*^(−r²) *r* d*r* = ½.", "f-muted", 12.5)
    return f
