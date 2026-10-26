"""A two-layer network of threshold units solves the biimplication by moving its four inputs to coordinates where one line separates them."""
from kit import Fig

LIM = (-0.3, 1.3)


def seg(f, ax, a, b, t, cls):
    pts = []
    for x in LIM:
        y = (t - a * x) / b if b else None
        if y is not None and LIM[0] <= y <= LIM[1]:
            pts.append((x, y))
    for y in LIM:
        x = (t - b * y) / a if a else None
        if x is not None and LIM[0] <= x <= LIM[1]:
            pts.append((x, y))
    f.line(ax.X(pts[0][0]), ax.Y(pts[0][1]), ax.X(pts[1][0]), ax.Y(pts[1][1]), cls)


def dot(f, ax, x, y, on):
    if on:
        ax.point(x, y, 7, "f-a-solid")
    else:
        f.circle(ax.X(x), ax.Y(y), 7, "f-box")
        f.circle(ax.X(x), ax.Y(y), 7, "f-line")


def build():
    f = Fig(760, 290)
    left = f.axes(50, 62, 190, 190, LIM, LIM)
    f.text(50, 26, "inputs: two lines cut off two corners", "f-ink", 13.5, weight=600)
    f.text(50, 46, "h₁ fires at (1,1), h₂ at (0,0)", "f-muted", 12.5)
    left.frame(xticks=(0, 1), yticks=(0, 1), grid=False, xlabel="x_{1}", ylabel="x_{2}")
    seg(f, left, 1, 1, 1.5, "f-b-line")
    seg(f, left, 1, 1, 0.5, "f-c-line")
    for (x, y), on in zip([(0, 0), (0, 1), (1, 0), (1, 1)], [1, 0, 0, 1]):
        dot(f, left, x, y, on)
    left.text(1.0, 0.62, "h_{1}", "f-b", 13)
    left.text(0.62, 0.02, "h_{2}", "f-c", 13)

    f.arrow(262, 160, 352, 160, "f-line")
    f.text(307, 148, "hidden layer", "f-muted", 12, "middle")

    right = f.axes(420, 62, 190, 190, LIM, LIM)
    f.text(420, 26, "hidden outputs: one line suffices", "f-ink", 13.5, weight=600)
    f.text(420, 46, "the output unit cuts h₁ + h₂ = 1/2", "f-muted", 12.5)
    right.frame(xticks=(0, 1), yticks=(0, 1), grid=False, xlabel="h_{1}", ylabel="h_{2}")
    seg(f, right, 1, 1, 0.5, "f-a-line")
    for (x, y), on in [((0, 1), 1), ((1, 0), 1), ((0, 0), 0)]:
        dot(f, right, x, y, on)
    f.text(640, 150, "Filled: output 1.", "f-muted", 12.5)
    f.text(640, 170, "Open: output 0.", "f-muted", 12.5)
    f.text(640, 200, "The open point is both", "f-muted", 12.5)
    f.text(640, 218, "(0,1) and (1,0).", "f-muted", 12.5)
    return f
