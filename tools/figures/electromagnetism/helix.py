"""A charge in a uniform magnetic field: circular motion projected from an oblique view, plus drift along B."""
import math
from kit import Fig

QE, MP = 1.602176634e-19, 1.67262192e-27


def build():
    v, B = 1.0e6, 0.1
    r = MP * v / (QE * B)
    w = QE * B / MP
    f = Fig(760, 300)
    ox, oy, s = 110, 235, 120
    # velocity: perpendicular speed v, parallel speed 0.45 v; one turn takes 2 pi / w
    pts = []
    n = 400
    for i in range(n + 1):
        th = 3 * 2 * math.pi * i / n
        x, y, z = math.cos(th), math.sin(th), th / (2 * math.pi) * 0.9
        pts.append((ox + (x + 0.45 * z) * s, oy - (y * 0.45 + 0.35 * z) * s * 0.9 - z * 0.25 * s))
    f.poly(pts, "f-a-line")
    f.arrow(ox - 60, oy + 20, ox - 60, oy - 160, "f-line")
    f.text(ox - 52, oy - 150, "*B*", "f-ink", 14)
    f.text(430, 80, "The force *qvB* sets the radius and frequency:", "f-ink", 13)
    f.text(430, 106, "*r* = *mv* / (*qB*),  ω = *qB* / *m*", "f-muted", 12.5)
    f.text(430, 134, "proton, *v* = 10^{6} m/s, *B* = 0.1 T", "f-muted", 12.5)
    f.text(430, 152, f"*r* = {r:.4f} m", "f-muted", 12.5)
    f.text(430, 170, f"ω = {w/1e6:.3f}×10^{{6}} rad/s", "f-muted", 12.5)
    f.text(430, 188, f"period 2π/ω = {2 * math.pi / w * 1e9:.1f} ns", "f-muted", 12.5)
    return f
