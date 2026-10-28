"""One vector drawn against the standard basis and against a skew basis, with the coordinates in each."""
import math
from kit import Fig

B1, B2 = (2.0, 1.0), (-1.0, 1.0)
W = (3.0, 2.0)


def coords():
    det = B1[0] * B2[1] - B2[0] * B1[1]
    a = (W[0] * B2[1] - B2[0] * W[1]) / det
    b = (B1[0] * W[1] - W[0] * B1[1]) / det
    return a, b


def panel(f, ox, oy, s, basis, labels, comps, title, text):
    f.text(ox - 20, oy - 150, title, "f-muted", 13)
    f.line(ox - 30, oy, ox + 4.4 * s, oy, "f-grid")
    f.line(ox, oy + 30, ox, oy - 3.4 * s, "f-grid")
    a, b = comps
    mid = (a * basis[0][0], a * basis[0][1])
    f.line(ox, oy, ox + mid[0] * s, oy - mid[1] * s, "f-b-line f-dash")
    f.line(ox + mid[0] * s, oy - mid[1] * s, ox + W[0] * s, oy - W[1] * s, "f-b-line f-dash")
    f.arrow(ox, oy, ox + basis[0][0] * s, oy - basis[0][1] * s, "f-c-line")
    f.arrow(ox, oy, ox + basis[1][0] * s, oy - basis[1][1] * s, "f-c-line")
    f.arrow(ox, oy, ox + W[0] * s, oy - W[1] * s, "f-a-line")
    f.text(ox + basis[0][0] * s + 6, oy - basis[0][1] * s + 14, labels[0], "f-ink", 13)
    f.text(ox + basis[1][0] * s - 8, oy - basis[1][1] * s - 8, labels[1], "f-ink", 13, "end" if basis[1][0] < 0 else "start")
    f.text(ox + W[0] * s + 8, oy - W[1] * s - 4, "*w*", "f-ink", 14)
    f.text(ox - 20, oy + 40, text, "f-muted", 12.5)


def build():
    f = Fig(760, 290)
    a, b = coords()
    panel(f, 70, 200, 56, ((1, 0), (0, 1)), ("*e*_{1}", "*e*_{2}"), (3, 2), "standard basis", "*w* = 3*e*_{1} + 2*e*_{2}")
    panel(f, 470, 200, 56, (B1, B2), ("*b*_{1}", "*b*_{2}"), (a, b), "skew basis *b*_{1} = (2, 1), *b*_{2} = (−1, 1)", "*w* = (5/3) *b*_{1} + (1/3) *b*_{2}")
    return f
