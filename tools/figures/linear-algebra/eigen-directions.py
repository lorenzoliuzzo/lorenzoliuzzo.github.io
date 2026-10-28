"""The unit circle under A = [[2, 1], [1, 2]] becomes an ellipse whose axes lie along the eigenvectors (1, 1) and (1, -1), stretched by 3 and 1."""
import math
from kit import Fig

R = math.sqrt(0.5)
E1, E2 = (R, R), (R, -R)   # unit eigenvectors, eigenvalues 3 and 1


def A(x, y):
    return (2 * x + y, x + 2 * y)


def panel(f, ox, oy, s, pts, title):
    f.text(ox - 90, oy - 120, title, "f-muted", 13)
    f.line(ox - 105, oy, ox + 105, oy, "f-grid")
    f.line(ox, oy + 105, ox, oy - 105, "f-grid")
    f.poly([(ox + x * s, oy - y * s) for x, y in pts], "f-a-fill", close=True)
    f.poly([(ox + x * s, oy - y * s) for x, y in pts], "f-a-line", close=True)


def build():
    f = Fig(760, 270)
    circle = [(math.cos(t * math.pi / 60), math.sin(t * math.pi / 60)) for t in range(120)]
    s = 34
    ox1, ox2, oy = 170, 560, 140
    panel(f, ox1, oy, s, circle, "unit circle")
    panel(f, ox2, oy, s, [A(x, y) for x, y in circle], "image under *A*")
    # eigenvectors: same direction before and after, length scaled by the eigenvalue
    f.arrow(ox1, oy, ox1 + E1[0] * s, oy - E1[1] * s, "f-b-line")
    f.arrow(ox1, oy, ox1 + E2[0] * s, oy - E2[1] * s, "f-c-line")
    f.arrow(ox2, oy, ox2 + 3 * E1[0] * s, oy - 3 * E1[1] * s, "f-b-line")
    f.arrow(ox2, oy, ox2 + 1 * E2[0] * s, oy - 1 * E2[1] * s, "f-c-line")
    f.text(ox2 + 3 * E1[0] * s + 8, oy - 3 * E1[1] * s + 4, "λ = 3", "f-b", 13)
    f.text(ox2 + E2[0] * s + 8, oy - E2[1] * s + 16, "λ = 1", "f-c", 13)
    f.arrow(300, 140, 430, 140, "f-line")
    f.text(365, 128, "*A*", "f-ink", 20, "middle")
    return f
