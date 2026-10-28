"""A linear map drawn as the image of the unit square: the columns of the matrix are the images of e1 and e2."""
from kit import Fig

A = ((2.0, 1.0), (1.0, 1.0))  # columns (2,1) and (1,1)


def img(x, y):
    return (A[0][0] * x + A[0][1] * y, A[1][0] * x + A[1][1] * y)


def panel(f, ox, oy, s, pts, title, labels):
    f.text(ox - 10, oy - 150, title, "f-muted", 13)
    f.line(ox - 20, oy, ox + 3.3 * s, oy, "f-grid")
    f.line(ox, oy + 20, ox, oy - 2.3 * s, "f-grid")
    f.poly([(ox + x * s, oy - y * s) for x, y in pts], "f-a-fill", close=True)
    f.poly([(ox + x * s, oy - y * s) for x, y in pts], "f-a-line", close=True)
    f.arrow(ox, oy, ox + pts[1][0] * s, oy - pts[1][1] * s, "f-b-line")
    f.arrow(ox, oy, ox + pts[3][0] * s, oy - pts[3][1] * s, "f-c-line")
    f.text(ox + pts[1][0] * s + 6, oy - pts[1][1] * s + 14, labels[0], "f-ink", 13)
    f.text(ox + pts[3][0] * s - 8, oy - pts[3][1] * s - 8, labels[1], "f-ink", 13, "end")


def build():
    f = Fig(760, 270)
    sq = [(0, 0), (1, 0), (1, 1), (0, 1)]
    panel(f, 60, 220, 62, sq, "unit square", ("*e*_{1}", "*e*_{2}"))
    im = [img(*p) for p in sq]
    panel(f, 410, 220, 62, im, "image under *A* = [[2, 1], [1, 1]]", ("*Ae*_{1} = (2, 1)", "*Ae*_{2} = (1, 1)"))
    f.text(250, 120, "*A*", "f-ink", 22, "middle")
    f.arrow(215, 135, 290, 135, "f-line")
    return f
