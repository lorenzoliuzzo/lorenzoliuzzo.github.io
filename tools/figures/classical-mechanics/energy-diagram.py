"""Potential U(x) = x^4/4 - x^2/2 with two total energies; kinetic energy is the gap and turning points bound the motion."""
import math
from kit import Fig


def U(x):
    return x ** 4 / 4 - x * x / 2


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 20, 480, 230, (-2, 2), (-0.4, 1.0))
    ax.frame(xticks=(-2, -1, 0, 1, 2), yticks=(-0.4, 0, 0.4, 0.8), xlabel="position *x*", ylabel="*U*, *E*")
    ax.curve(U, -2, 2, "f-a-line")
    E1, E2 = -0.15, 0.4
    for E, cls in ((E1, "f-b-line"), (E2, "f-c-line")):
        f.line(ax.X(-2), ax.Y(E), ax.X(2), ax.Y(E), cls + " f-dash")
    # turning points of E1: x^2 = 1 +- sqrt(1 + 4E)
    r = math.sqrt(1 + 4 * E1)
    for x in (math.sqrt(1 - r), math.sqrt(1 + r)):
        ax.point(x, E1, 4, "f-b-solid")
        ax.point(-x, E1, 4, "f-b-solid")
    xt = math.sqrt(1 + math.sqrt(1 + 4 * E2))
    ax.point(xt, E2, 4, "f-c-solid")
    ax.point(-xt, E2, 4, "f-c-solid")
    f.legend(570, 50, [("*U*(*x*) = *x*^{4}/4 − *x*^{2}/2", "f-a-line"), ("*E* = −0.15: trapped", "f-b-line"), ("*E* = 0.40: crosses", "f-c-line")])
    f.text(570, 130, "*K* = *E* − *U*(*x*) must stay", "f-muted", 12.5)
    f.text(570, 148, "non-negative, so the motion", "f-muted", 12.5)
    f.text(570, 166, "ends at the turning points.", "f-muted", 12.5)
    return f
