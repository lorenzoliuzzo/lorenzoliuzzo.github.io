"""Field lines of an electric dipole, traced numerically from the positive charge."""
import math
from kit import Fig

Q = [(-1.0, 0.0, 1.0), (1.0, 0.0, -1.0)]


def field(x, y):
    ex = ey = 0.0
    for qx, qy, q in Q:
        dx, dy = x - qx, y - qy
        r3 = (dx * dx + dy * dy) ** 1.5
        ex += q * dx / r3
        ey += q * dy / r3
    return ex, ey


def unit(x, y):
    ex, ey = field(x, y)
    n = math.hypot(ex, ey)
    return ex / n, ey / n


def trace(a):
    x, y = -1.0 + 0.08 * math.cos(a), 0.08 * math.sin(a)
    pts = [(x, y)]
    h = 0.03
    for _ in range(4000):
        k1 = unit(x, y)
        k2 = unit(x + h / 2 * k1[0], y + h / 2 * k1[1])
        k3 = unit(x + h / 2 * k2[0], y + h / 2 * k2[1])
        k4 = unit(x + h * k3[0], y + h * k3[1])
        x += h / 6 * (k1[0] + 2 * k2[0] + 2 * k3[0] + k4[0])
        y += h / 6 * (k1[1] + 2 * k2[1] + 2 * k3[1] + k4[1])
        pts.append((x, y))
        if math.hypot(x - 1, y) < 0.08 or abs(x) > 4.6 or abs(y) > 1.95:
            break
    return pts


def axis_ratio(r=20.0):
    """On-axis field times r^3 over 2p with p = 2 (two unit charges 2 apart)."""
    ex, _ = field(r, 0)
    return abs(ex) * r ** 3 / (2 * 2.0)


def build():
    f = Fig(760, 326)
    s, ox, oy = 78, 380, 160
    for k in range(16):
        a = 2 * math.pi * (k + 0.5) / 16
        pts = trace(a)
        P = [(ox + x * s, oy - y * s) for x, y in pts]
        f.poly(P, "f-a-line")
        i = len(P) // 2
        j = min(i + 3, len(P) - 1)
        f.arrow(P[i][0], P[i][1], P[j][0], P[j][1], "f-a-line")
    f.circle(ox - s, oy, 9, "f-b-solid")
    f.circle(ox + s, oy, 9, "f-c-solid")
    f.text(ox - s, oy + 4, "+", "f-ink", 14, "middle")
    f.text(ox + s, oy + 4, "-", "f-ink", 14, "middle")
    f.text(560, 40, "*Er*^{3} / (2*p*) on the axis", "f-muted", 12.5)
    f.text(560, 58, f"= {axis_ratio():.3f} at *r* = 10*d*", "f-muted", 12.5)
    return f
