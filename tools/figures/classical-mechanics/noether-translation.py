"""A particle in V = (1/2) x^2 (no dependence on y): p_x oscillates, p_y stays constant. Mass, frequency and amplitude are 1; the initial y velocity is 0.6."""
import math
from kit import Fig


def build():
    f = Fig(760, 290)
    ax = f.axes(52, 20, 520, 220, (0, 12.6), (-1.3, 1.3))
    ax.frame(xticks=(0, 3, 6, 9, 12), yticks=(-1, 0, 1), xlabel="time *t*")
    ax.curve(lambda t: -math.sin(t), 0, 12.6, "f-b-line")
    ax.curve(lambda t: 0.6, 0, 12.6, "f-a-line")
    f.legend(600, 70, [("*p*_{y}: conserved", "f-a-line"), ("*p*_{x}: not conserved", "f-b-line")])
    f.text(600, 150, "*L* does not depend on *y*,", "f-muted", 12.5)
    f.text(600, 168, "so *y* is cyclic and *p*_{y}", "f-muted", 12.5)
    f.text(600, 186, "stays at *m**v*_{y} = 0.6.", "f-muted", 12.5)
    return f
