"""The effective potential of the Kepler problem and the orbit of one bound energy (m = k = L = 1)."""
import math
from kit import Fig


def Ueff(r):
    return 0.5 / (r * r) - 1 / r


def build():
    f = Fig(760, 326)
    ax = f.axes(60, 20, 330, 230, (0.3, 6), (-0.7, 0.8))
    ax.frame(xticks=(1, 2, 3, 4, 5, 6), yticks=(-0.5, 0, 0.5), xlabel="*r*")
    ax.curve(Ueff, 0.45, 6, "f-a-line")
    E = -0.32
    f.line(ax.X(0.3), ax.Y(E), ax.X(6), ax.Y(E), "f-b-line f-dash")
    e = math.sqrt(1 + 2 * E)
    rmin, rmax = 1 / (1 + e), 1 / (1 - e)
    ax.point(rmin, E, 4, "f-b-solid")
    ax.point(rmax, E, 4, "f-b-solid")
    ax.point(1.0, -0.5, 4)
    ox, oy, s = 570, 135, 44
    pts = [(ox + (1 / (1 + e * math.cos(t))) * math.cos(t) * s, oy - (1 / (1 + e * math.cos(t))) * math.sin(t) * s) for t in [i * 2 * math.pi / 200 for i in range(201)]]
    f.poly(pts, "f-a-line")
    f.circle(ox, oy, 5, "f-c-solid")
    f.text(ox - 40, oy + 120, f"*e* = {e:.2f}, *E* = {str(E).replace('-', '−')}", "f-muted", 12.5)
    f.text(ox - 40, oy + 138, f"*r*_{{min}} = {rmin:.2f}, *r*_{{max}} = {rmax:.2f}", "f-muted", 12.5)
    f.text(60, 318, "*U*_{eff} = *L*^{2}/(2*mr*^{2}) − *k*/*r*; the minimum at *r* = 1 is the circular orbit", "f-muted", 12)
    return f
