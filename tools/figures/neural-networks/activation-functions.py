"""The logistic function and tanh flatten for large |z|, so their slopes vanish there; the rectified linear unit keeps slope 1 for z > 0."""
import math

from kit import Fig


def logistic(z):
    return 1 / (1 + math.exp(-z))


def build():
    f = Fig(760, 300)
    L = (-3, 3)
    a = f.axes(46, 46, 300, 190, L, (-1.2, 3.2))
    b = f.axes(420, 46, 300, 190, L, (0, 1.2))
    f.text(a.x0, 26, "activation", "f-ink", 14, weight=600)
    f.text(b.x0, 26, "derivative", "f-ink", 14, weight=600)
    a.frame(xticks=(-3, -2, -1, 0, 1, 2, 3), yticks=(-1, 0, 1, 2, 3), xlabel="z")
    b.frame(xticks=(-3, -2, -1, 0, 1, 2, 3), yticks=(0, 0.5, 1), xlabel="z")
    a.curve(logistic, cls="f-a-line")
    a.curve(math.tanh, cls="f-d-line")
    a.curve(lambda z: max(0.0, z), cls="f-e-line")
    b.curve(lambda z: logistic(z) * (1 - logistic(z)), cls="f-a-line")
    b.curve(lambda z: 1 - math.tanh(z) ** 2, cls="f-d-line")
    f.poly([(b.X(-3), b.Y(0)), (b.X(0), b.Y(0)), (b.X(0), b.Y(1)), (b.X(3), b.Y(1))], "f-e-line")
    f.legend(100, 276, [("logistic", "f-a-line")])
    f.legend(240, 276, [("tanh", "f-d-line")])
    f.legend(340, 276, [("ReLU", "f-e-line")])
    return f
