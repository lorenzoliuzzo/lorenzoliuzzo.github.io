"""Light crossing a box that accelerates upward appears to fall: the shape is exaggerated and the picture is a sketch."""
from kit import Fig


def build():
    f = Fig(760, 300)
    x0, x1, y0, y1 = 90, 470, 40, 250
    f.rect(x0, y0, x1 - x0, y1 - y0, "f-box")
    f.line(x0, y0, x0, y1, "f-line")
    pts = []
    for i in range(41):
        u = i / 40
        pts.append((x0 + u * (x1 - x0), 110 + 110 * u * u))
    f.poly(pts, "f-a-line")
    f.line(x0, 110, x1, 110, "f-line f-dash")
    f.arrow(280, 245, 280, 205, "f-b-line")
    f.text(290, 232, "*a* = *g*", "f-ink", 13)
    f.text(520, 80, "Equivalence principle:", "f-ink", 13)
    f.text(520, 106, "in the accelerating box the beam", "f-muted", 12.5)
    f.text(520, 124, "bends as *y* = −*ax*^{2} / (2*c*^{2}).", "f-muted", 12.5)
    f.text(520, 150, "A frame at rest in a gravitational", "f-muted", 12.5)
    f.text(520, 168, "field *g* cannot tell the difference,", "f-muted", 12.5)
    f.text(520, 186, "so light falls there too.", "f-muted", 12.5)
    f.text(520, 220, "Not to scale: over 1 m the drop", "f-muted", 12.5)
    f.text(520, 238, "is 5.5×10^{−17} m.", "f-muted", 12.5)
    return f
