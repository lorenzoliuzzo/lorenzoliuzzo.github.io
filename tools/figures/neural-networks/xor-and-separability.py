"""AND is cut by one line, XOR by none, and two hidden neurons cut XOR into a strip."""
from kit import Fig

PTS = [(0, 0), (0, 1), (1, 0), (1, 1)]
LO, HI = -0.4, 1.4


def panel(f, left, title, labels, lines=(), strip=False, note=None):
    ax = f.axes(left, 52, 196, 176, (LO, HI), (LO, HI))
    f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
    if strip:
        pts = [(-0.4, 0.9), (-0.4, 1.4), (0.1, 1.4), (1.4, 0.1), (1.4, -0.4), (0.9, -0.4)]
        f.poly([(ax.X(x), ax.Y(y)) for x, y in pts], "f-a-fill", close=True)
    for (x1, y1), (x2, y2), cls in lines:
        f.line(ax.X(x1), ax.Y(y1), ax.X(x2), ax.Y(y2), cls)
    for (x, y), lab in zip(PTS, labels):
        ax.point(x, y, 6.5, "f-a-solid" if lab else "f-b-solid")
    f.text(left, 34, title, "f-ink", 13.5, weight=600)
    f.text(ax.X(0.5), ax.Y(-0.4) + 18, "x₁", "f-muted", 12.5, "middle")
    f.text(ax.x0 - 8, ax.Y(0.5) + 4, "x₂", "f-muted", 12.5, "end")
    if note:
        f.text(left + 98, 272, note, "f-muted", 12.5, "middle")


def build():
    f = Fig(760, 284)
    panel(f, 30, "AND: one line", [0, 0, 0, 1], [((0.1, 1.4), (1.4, 0.1), "f-b-line")], note="separable")
    panel(f, 283, "XOR: no single line", [0, 1, 1, 0], [((-0.4, 0.5), (1.4, 0.5), "f-b-line f-dash"), ((0.5, -0.4), (0.5, 1.4), "f-b-line f-dash")], note="every line misplaces a point")
    panel(f, 536, "XOR: two hidden neurons", [0, 1, 1, 0],
          [((-0.4, 0.9), (0.9, -0.4), "f-line"), ((0.1, 1.4), (1.4, 0.1), "f-line")], strip=True, note="the output selects the strip")
    f.legend(30, 22, [])
    return f
