"""One-dimensional data no threshold can separate becomes linearly separable after the map x -> (x, x²)."""
from kit import Fig

INNER = [-1.4, -0.9, -0.4, 0.1, 0.6, 1.2]
OUTER = [-3.2, -2.6, -2.2, 2.0, 2.5, 3.1]


def build():
    f = Fig(760, 300)
    ax = f.axes(40, 150, 300, 10, (-3.6, 3.6), (0, 1))
    f.line(ax.X(-3.6), 150, ax.X(3.6), 150, "f-axis")
    for v in (-3, 0, 3):
        f.line(ax.X(v), 150, ax.X(v), 155, "f-axis")
        f.text(ax.X(v), 170, f"{v}", "f-muted", 12, "middle")
    for x in INNER:
        f.circle(ax.X(x), 150, 5.5, "f-a-solid")
    for x in OUTER:
        f.circle(ax.X(x), 150, 5.5, "f-b-solid")
    f.text(40, 24, "input space: one feature", "f-ink", 13, weight=600)
    f.text(40, 46, "no single threshold separates the colours", "f-muted", 12.5)
    f.text(ax.X(3.6), 192, "x", "f-muted", 12.5, "end")

    bx = f.axes(430, 84, 300, 170, (-3.6, 3.6), (-0.4, 11))
    bx.frame(xticks=(-3, 0, 3), yticks=(0, 5, 10), xlabel="x", ylabel="x²")
    f.text(430, 24, "feature space: (x, x²)", "f-ink", 13, weight=600)
    f.text(430, 46, "a horizontal line now separates them", "f-muted", 12.5)
    bx.curve(lambda x: x * x, x0=-3.3, x1=3.3, cls="f-line f-dash")
    for x in INNER:
        bx.point(x, x * x, 5.5, "f-a-solid")
    for x in OUTER:
        bx.point(x, x * x, 5.5, "f-b-solid")
    f.line(bx.X(-3.6), bx.Y(4.5), bx.X(3.6), bx.Y(4.5), "f-c-line")
    f.text(bx.X(0), bx.Y(4.5) - 6, "linear boundary", "f-c", 12.5, "middle")
    f.arrow(352, 150, 416, 150, "f-line")
    f.text(384, 140, "φ", "f-muted", 13, "middle")
    return f
