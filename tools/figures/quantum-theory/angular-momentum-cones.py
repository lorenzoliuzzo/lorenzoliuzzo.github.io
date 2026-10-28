"""Vector model for j = 1: |J| = sqrt(j(j+1)) = sqrt2 = 1.414 (units hbar); the z component takes m = -1, 0, 1. The x and y components are not sharp, so the vector lies on a cone, drawn in side view as an arrow to the circle."""
import math
from kit import Fig

CX, CY, S = 200, 150, 90


def build():
    f = Fig(760, 300)
    R = math.sqrt(2)
    f.poly([(CX + S * R * math.cos(a * math.pi / 60), CY - S * R * math.sin(a * math.pi / 60)) for a in range(121)], "f-line")
    f.line(CX, CY - S * 1.75, CX, CY + S * 1.75, "f-axis")
    for m, cls in ((1, "f-a"), (0, "f-b"), (-1, "f-c")):
        x = math.sqrt(2 - m * m)
        f.line(CX - S * x, CY - S * m, CX + S * x, CY - S * m, cls + "-line f-dash")
        f.arrow(CX, CY, CX + S * x, CY - S * m, cls + "-line")
        f.text(CX + S * x + 8, CY - S * m + 4, f"*m* = {m}" if m >= 0 else f"*m* = −1", cls, 13)
    f.text(CX + 6, CY - S * 1.75 - 6, "*z*", "f-muted", 13)
    f.text(430, 70, "Spin or orbital angular momentum with *j* = 1", "f-ink", 13)
    f.text(430, 108, "Length of the vector: √(*j*(*j*+1)) ħ = 1.41 ħ.", "f-muted", 12.5)
    f.text(430, 132, "Allowed *J* along *z*: −ħ, 0, ħ. Even in the extreme", "f-muted", 12.5)
    f.text(430, 150, "case *m* = *j* the vector (1.41 ħ) is longer than", "f-muted", 12.5)
    f.text(430, 168, "its *z* component (ħ), so the other two components cannot", "f-muted", 12.5)
    f.text(430, 186, "vanish: the cone is the picture of that.", "f-muted", 12.5)
    return f
