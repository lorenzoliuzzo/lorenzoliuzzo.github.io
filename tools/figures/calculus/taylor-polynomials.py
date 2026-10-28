"""Taylor polynomials of sin x at 0 of degree 1, 3 and 7 against sin x: each hugs the curve near 0 and peels away farther out, later for higher degree."""
import math
from kit import Fig


def taylor(n):
    def p(x):
        return sum((-1) ** k * x ** (2 * k + 1) / math.factorial(2 * k + 1) for k in range((n - 1) // 2 + 1))
    return p


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 520, 240, (-7, 7), (-2.2, 2.2))
    ax.frame(xticks=(-6, -4, -2, 0, 2, 4, 6), yticks=(-2, -1, 0, 1, 2), xlabel="*x*")
    for n, cls in ((1, "f-c-line"), (3, "f-b-line"), (7, "f-d-line")):
        p = taylor(n)
        x = 0.0
        while x < 7 and abs(p(x)) < 2.15:   # stop where the curve leaves the frame
            x += 0.01
        ax.curve(p, -x, x, cls)
    ax.curve(math.sin, -7, 7, "f-a-line")
    f.legend(600, 60, [("sin *x*", "f-a-line"), ("degree 1", "f-c-line"), ("degree 3", "f-b-line"), ("degree 7", "f-d-line")])
    f.text(600, 170, "Near 0 all agree; the", "f-muted", 12.5)
    f.text(600, 188, "error grows like |*x*|^{n+1}.", "f-muted", 12.5)
    return f
