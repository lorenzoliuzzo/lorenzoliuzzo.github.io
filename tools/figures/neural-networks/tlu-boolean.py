"""Three Boolean functions of two inputs as points of the unit square: a single threshold unit separates the first two with a line and cannot separate the third."""
from kit import Fig

PANELS = [
    ("x_{1} ∧ x_{2}", "w = (1, 1),  θ = 3/2", [0, 0, 0, 1], (1, 1, 1.5)),
    ("x_{1} → x_{2}", "w = (−2, 2),  θ = −1", [1, 1, 0, 1], (-2, 2, -1)),
    ("x_{1} ↔ x_{2}", "no line separates them", [1, 0, 0, 1], None),
]
POINTS = [(0, 0), (0, 1), (1, 0), (1, 1)]
LIM = (-0.3, 1.3)


def clip(ax, a, b, t):
    """Segment of the line a x_1 + b x_2 = t inside the plotted box."""
    pts = []
    for x in LIM:
        if b:
            y = (t - a * x) / b
            if LIM[0] <= y <= LIM[1]:
                pts.append((x, y))
    for y in LIM:
        if a:
            x = (t - b * y) / a
            if LIM[0] <= x <= LIM[1]:
                pts.append((x, y))
    return pts[0], pts[1]


def build():
    f = Fig(760, 270)
    for i, (title, sub, outs, unit) in enumerate(PANELS):
        ax = f.axes(40 + i * 245, 62, 180, 180, LIM, LIM)
        f.text(ax.x0, 26, title, "f-ink", 14, weight=600)
        f.text(ax.x0, 46, sub, "f-muted", 12.5)
        ax.frame(xticks=(0, 1), yticks=(0, 1), grid=False)
        f.line(ax.x0, ax.y0, ax.x0 + ax.w, ax.y0, "f-grid")
        if unit:
            a, b, t = unit
            p, q = clip(ax, a, b, t)
            f.line(ax.X(p[0]), ax.Y(p[1]), ax.X(q[0]), ax.Y(q[1]), "f-a-line")
            mx, my = (p[0] + q[0]) / 2, (p[1] + q[1]) / 2
            n = (a * a + b * b) ** 0.5
            f.arrow(ax.X(mx), ax.Y(my), ax.X(mx + 0.28 * a / n), ax.Y(my + 0.28 * b / n), "f-a-line")
        else:
            f.line(ax.X(0), ax.Y(0), ax.X(1), ax.Y(1), "f-b-line f-dash")
            f.line(ax.X(0), ax.Y(1), ax.X(1), ax.Y(0), "f-c-line f-dash")
            f.text(ax.X(0.5) + 8, ax.Y(0.5) - 8, "hulls meet", "f-muted", 12)
        for (x, y), o in zip(POINTS, outs):
            if o:
                ax.point(x, y, 7, "f-a-solid")
            else:
                f.circle(ax.X(x), ax.Y(y), 7, "f-box")
                f.circle(ax.X(x), ax.Y(y), 7, "f-line")
    f.text(40, 266, "Filled points have output 1, open points output 0. The arrow is w, pointing to the side where the unit outputs 1.", "f-muted", 12.5)
    return f
