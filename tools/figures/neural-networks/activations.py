"""Sigmoid, tanh and ReLU (left) and their derivatives (right): only ReLU keeps a derivative of 1."""
import math
from kit import Fig
from nnutil import sigmoid


def build():
    f = Fig(760, 300)
    A = f.axes(48, 30, 300, 200, (-4, 4), (-1.3, 2.2))
    A.frame(xticks=(-4, -2, 0, 2, 4), yticks=(-1, 0, 1, 2), xlabel="z")
    A.curve(sigmoid, cls="f-a-line")
    A.curve(math.tanh, cls="f-b-line")
    A.curve(lambda z: max(0.0, z), x0=-4, x1=2.2, cls="f-c-line")
    f.text(48, 20, "activation φ(z)", "f-ink", 13.5, weight=600)
    B = f.axes(410, 30, 300, 200, (-4, 4), (0, 1.25))
    B.frame(xticks=(-4, -2, 0, 2, 4), yticks=(0, 0.25, 0.5, 1), xlabel="z", yfmt=lambda v: f"{v:g}")
    B.curve(lambda z: sigmoid(z) * (1 - sigmoid(z)), cls="f-a-line")
    B.curve(lambda z: 1 - math.tanh(z) ** 2, cls="f-b-line")
    f.poly([(B.X(-4), B.Y(0)), (B.X(0), B.Y(0))], "f-c-line")
    f.poly([(B.X(0), B.Y(1)), (B.X(4), B.Y(1))], "f-c-line")
    B.point(0, 0.25, 3.5, "f-a-solid")
    B.text(1.1, 0.14, "max 1/4", "f-a", 12)
    f.text(410, 20, "derivative φ′(z)", "f-ink", 13.5, weight=600)
    f.legend(70, 56, [("sigmoid", "f-a-line"), ("tanh", "f-b-line"), ("ReLU", "f-c-line")])
    f.text(48, 284, "A chain of sigmoids multiplies the gradient by at most 1/4 per layer.", "f-muted", 12.5)
    return f
