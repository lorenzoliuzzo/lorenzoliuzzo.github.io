"""Secant lines of x^2 at x = 1 with shrinking step h, approaching the tangent of slope 2."""
from kit import Fig


def f_(x):
    return x * x


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 20, 480, 230, (0, 3.2), (0, 7))
    ax.frame(xticks=(0, 1, 2, 3), yticks=(0, 2, 4, 6), xlabel="*x*")
    ax.curve(f_, 0, 2.6, "f-a-line")
    rows = []
    for h, cls in ((1.0, "f-c-line"), (0.5, "f-b-line")):
        m = (f_(1 + h) - f_(1)) / h
        ax.curve(lambda x, m=m: 1 + m * (x - 1), 0.2, 3.2, cls, 2)
        ax.point(1 + h, f_(1 + h), 3.5)
        rows.append((h, m, cls))
    ax.curve(lambda x: 1 + 2 * (x - 1), 0.2, 3.2, "f-ink-line" if False else "f-line", 2)
    ax.point(1, 1, 4.5)
    f.legend(570, 50, [("*h* = 1, slope 3", "f-c-line"), ("*h* = 0.5, slope 2.5", "f-b-line"), ("tangent, slope 2", "f-line")])
    f.text(570, 130, "slope = (*f*(1+*h*) − *f*(1)) / *h*", "f-muted", 12.5)
    f.text(570, 148, "= 2 + *h* for *f*(*x*) = *x*^{2}", "f-muted", 12.5)
    return f
