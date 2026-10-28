"""Two configurations of an XY spin field with winding number +1 around the centre."""
import math
from kit import Fig


def panel(f, cx, cy, off):
    n = 5
    s = 26
    for i in range(-n, n + 1):
        for j in range(-n, n + 1):
            x, y = i * s, j * s
            if i == 0 and j == 0:
                f.circle(cx, cy, 3, "f-b-solid")
                continue
            th = math.atan2(-y, x) + off
            ux, uy = math.cos(th), -math.sin(th)
            px, py = cx + x, cy + y
            f.arrow(px - 8 * ux, py - 8 * uy, px + 8 * ux, py + 8 * uy, "f-a-line")


def build():
    f = Fig(760, 360)
    panel(f, 190, 160, math.pi / 2)
    panel(f, 560, 160, 0.0)
    f.text(190, 322, "spins circulate: φ = θ + π/2", "f-muted", 12.5, "middle")
    f.text(560, 322, "spins radiate: φ = θ", "f-muted", 12.5, "middle")
    f.text(375, 346, "Both configurations wind once around the centre.", "f-ink", 13, "middle")
    return f
