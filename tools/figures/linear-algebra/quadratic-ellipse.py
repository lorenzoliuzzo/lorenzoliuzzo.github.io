"""The level curve x^T A x = 1 of A = [[2, 1], [1, 2]] is an ellipse whose semi-axes lie along the eigenvectors (1, 1) and (1, -1) with lengths 1/sqrt(3) and 1."""
import math
from kit import Fig

R = math.sqrt(0.5)


def build():
    f = Fig(760, 300)
    ox, oy, s = 220, 150, 120
    f.line(ox - 150, oy, ox + 150, oy, "f-grid")
    f.line(ox, oy + 130, ox, oy - 130, "f-grid")
    pts = []
    for t in range(121):
        a = t * math.pi / 60
        # coordinates in the eigenbasis: y1 along (1,1)/sqrt2 with a = 1/sqrt3, y2 along (1,-1)/sqrt2 with b = 1
        y1, y2 = math.cos(a) / math.sqrt(3), math.sin(a)
        x = R * y1 + R * y2
        y = R * y1 - R * y2
        pts.append((ox + s * x, oy - s * y))
    f.poly(pts, "f-a-fill", close=True)
    f.poly(pts, "f-a-line", close=True)
    a1 = 1 / math.sqrt(3)
    f.arrow(ox, oy, ox + s * a1 * R, oy - s * a1 * R, "f-b-line")
    f.arrow(ox, oy, ox + s * R, oy + s * R, "f-c-line")
    f.line(ox - 1.15 * s * R, oy + 1.15 * s * R, ox + 1.15 * s * R, oy - 1.15 * s * R, "f-b-line f-dash")
    f.line(ox - 1.15 * s * R, oy - 1.15 * s * R, ox + 1.15 * s * R, oy + 1.15 * s * R, "f-c-line f-dash")
    f.text(ox + s * a1 * R + 6, oy - s * a1 * R - 6, "1/√3", "f-b", 12.5)
    f.text(ox + s * R + 6, oy + s * R + 14, "1", "f-c", 12.5)
    f.text(480, 90, "*x*^{T}*A**x* = 2*x*^{2} + 2*xy* + 2*y*^{2} = 1", "f-ink", 13)
    f.text(480, 126, "Orange: eigenvector (1, 1), λ = 3,", "f-muted", 12.5)
    f.text(480, 144, "semi-axis 1/√3, the short one.", "f-muted", 12.5)
    f.text(480, 172, "Green: eigenvector (1, −1), λ = 1,", "f-muted", 12.5)
    f.text(480, 190, "semi-axis 1, the long one.", "f-muted", 12.5)
    f.text(480, 224, "A larger eigenvalue means a", "f-muted", 12.5)
    f.text(480, 242, "steeper form and a shorter axis.", "f-muted", 12.5)
    return f
