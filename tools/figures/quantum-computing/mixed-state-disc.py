"""The x-z plane of the Bloch ball. Pure states sit on the circle. An equal mixture of |0> (top) and |+> (right) is the midpoint of the chord, at radius 0.707, with purity (1 + r^2)/2 = 0.75; the maximally mixed state is the centre, purity 1/2."""
import math
from kit import Fig

CX, CY, R = 190, 150, 120


def build():
    f = Fig(760, 300)
    f.poly([(CX + R * math.cos(a * math.pi / 60), CY - R * math.sin(a * math.pi / 60)) for a in range(121)], "f-line")
    f.line(CX - R - 10, CY, CX + R + 10, CY, "f-grid")
    f.line(CX, CY - R - 10, CX, CY + R + 10, "f-grid")
    p0, pp = (CX, CY - R), (CX + R, CY)
    mid = ((p0[0] + pp[0]) / 2, (p0[1] + pp[1]) / 2)
    f.line(p0[0], p0[1], pp[0], pp[1], "f-line f-dash")
    for p, lab, dx, dy in ((p0, "|0⟩", 8, -4), (pp, "|+⟩", 8, 4)):
        f.circle(p[0], p[1], 4.5, "f-b-solid")
        f.text(p[0] + dx, p[1] + dy, lab, "f-b", 14)
    f.circle(mid[0], mid[1], 5, "f-a-solid")
    f.text(mid[0] + 10, mid[1] - 6, "½|0⟩⟨0| + ½|+⟩⟨+|", "f-a", 12.5)
    f.circle(CX, CY, 4.5, "f-c-solid")
    f.text(CX - 8, CY + 20, "*I*/2", "f-c", 13, "end")
    f.text(440, 70, "Cross-section of the Bloch ball", "f-ink", 13)
    f.text(440, 108, "Pure states, purity 1: on the circle.", "f-muted", 12.5)
    f.text(440, 134, "Equal mix of |0⟩ and |+⟩: r = 0.71,", "f-muted", 12.5)
    f.text(440, 152, "purity 0.75, inside the ball.", "f-muted", 12.5)
    f.text(440, 178, "Maximally mixed: the centre,", "f-muted", 12.5)
    f.text(440, 196, "purity 1/2, no preferred axis.", "f-muted", 12.5)
    return f
