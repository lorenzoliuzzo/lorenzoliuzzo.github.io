"""A maximum-margin line: the margin is set by three support vectors, and the other points could move without changing it."""
from kit import Fig

# (x1, x2, is_support_vector); the margin edges are x1 + x2 = 3 and x1 + x2 = 7
POS = [(4, 3, True), (2.5, 4.5, True), (5, 3.2, False), (3.6, 5.2, False), (6, 2, False), (4.6, 4.2, False)]
NEG = [(1, 2, True), (0.5, 1.5, False), (2, 0.6, False), (1.2, 0.4, False), (0, 2.6, False), (2.8, 0, False)]
XLIM, YLIM = (-0.5, 7), (-0.5, 6)


def build():
    f = Fig(760, 330)
    ax = f.axes(40, 20, 440, 280, XLIM, YLIM)
    ax.frame(xticks=(), yticks=(), grid=False, yaxis=False)
    f.line(ax.x0, ax.y0, ax.x0, ax.y0 + ax.h, "f-axis")

    # the band between x1 + x2 = 3 and x1 + x2 = 7, clipped to the frame
    band = [(-0.5, 3.5), (3.5, -0.5), (7, -0.5), (7, 0), (1, 6), (-0.5, 6)]
    f.poly([(ax.X(x), ax.Y(y)) for x, y in band], "f-c-fill", close=True)

    def line(c, cls):
        x0, x1 = max(XLIM[0], c - YLIM[1]), min(XLIM[1], c - YLIM[0])
        f.line(ax.X(x0), ax.Y(c - x0), ax.X(x1), ax.Y(c - x1), cls)

    line(3, "f-c-line")
    line(7, "f-c-line")
    line(5, "f-line f-dash")
    for pts, solid in ((POS, "f-a-solid"), (NEG, "f-b-solid")):
        for x, y, sv in pts:
            ax.point(x, y, 5, solid)
            if sv:
                f.circle(ax.X(x), ax.Y(y), 10, "f-line")
    f.text(520, 62, "w·x + b = 0", "f-ink", 13, weight=600)
    f.text(520, 82, "the separating line", "f-muted", 12.5)
    f.text(520, 118, "w·x + b = ±1", "f-c", 13, weight=600)
    f.text(520, 138, "edges of the margin", "f-muted", 12.5)
    f.text(520, 174, "margin width = 2 / ‖w‖", "f-ink", 13, weight=600)
    f.text(520, 194, "Circled points are the", "f-muted", 12.5)
    f.text(520, 211, "support vectors: they alone", "f-muted", 12.5)
    f.text(520, 228, "fix the line.", "f-muted", 12.5)
    return f
