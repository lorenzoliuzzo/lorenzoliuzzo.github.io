"""The Bloch sphere: |0> at the north pole, |1> at the south pole, the equator holds equal superpositions with relative phase phi; a state is the point (sin t cos p, sin t sin p, cos t) for polar angle t = 60 degrees and azimuth p = 50 degrees."""
import math
from kit import Fig

R = 118
CX, CY = 210, 166
KX, KZ = 0.35, 0.30     # oblique projection: the x axis points down and to the left


def P(x, y, z):
    return (CX + R * (y - KX * x), CY - R * (z - KZ * x))


def build():
    f = Fig(760, 318)
    f.poly([P(math.cos(a * math.pi / 60), math.sin(a * math.pi / 60), 0) for a in range(121)], "f-grid")
    f.poly([P(math.sin(a * math.pi / 60), 0, math.cos(a * math.pi / 60)) for a in range(121)], "f-grid")
    f.poly([P(0, math.sin(a * math.pi / 60), math.cos(a * math.pi / 60)) for a in range(121)], "f-grid")
    f.poly([(CX + R * math.cos(a * math.pi / 60), CY - R * math.sin(a * math.pi / 60)) for a in range(121)], "f-line")
    # axes
    for v, lab, dx, dy in (((1.2, 0, 0), "*x*", -14, 14), ((0, 1.2, 0), "*y*", 8, 4), ((0, 0, 1.2), "", 0, 0)):
        x, y = P(*v)
        f.arrow(CX, CY, x, y, "f-line")
        if lab:
            f.text(x + dx, y + dy, lab, "f-muted", 13)
    f.text(CX + 6, CY - R * 1.2 - 6, "|0⟩", "f-ink", 14)
    f.text(CX + 6, CY + R + 18, "|1⟩", "f-ink", 14)
    t, p = math.radians(60), math.radians(50)
    v = (math.sin(t) * math.cos(p), math.sin(t) * math.sin(p), math.cos(t))
    foot = P(v[0], v[1], 0)
    tip = P(*v)
    f.line(tip[0], tip[1], foot[0], foot[1], "f-line f-dash")
    f.line(CX, CY, foot[0], foot[1], "f-line f-dash")
    f.arrow(CX, CY, tip[0], tip[1], "f-b-line")
    f.circle(tip[0], tip[1], 4, "f-b-solid")
    f.text(tip[0] + 8, tip[1] - 4, "|ψ⟩", "f-b", 14)
    f.text(CX + 22, CY - 40, "θ", "f-b", 13)
    f.text(foot[0] - 18, foot[1] + 16, "φ", "f-b", 13)
    f.text(440, 70, "|ψ⟩ = cos(θ/2)|0⟩ + *e*^{iφ} sin(θ/2)|1⟩", "f-ink", 13)
    f.text(440, 108, "Poles: |0⟩ and |1⟩, the two", "f-muted", 12.5)
    f.text(440, 126, "values of a classical bit.", "f-muted", 12.5)
    f.text(440, 156, "Equator: equal weights, with", "f-muted", 12.5)
    f.text(440, 174, "relative phase φ; *x* axis |±⟩,", "f-muted", 12.5)
    f.text(440, 192, "*y* axis |±*i*⟩.", "f-muted", 12.5)
    f.text(440, 222, "Orthogonal states are antipodal.", "f-muted", 12.5)
    return f
