"""Left and right Riemann sums of x^2 on [0, 1] with eight strips, squeezing the exact value 1/3."""
from kit import Fig


def build():
    n = 8
    f = Fig(760, 300)
    ax = f.axes(60, 20, 480, 230, (0, 1), (0, 1.05))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1.0), yticks=(0, 0.5, 1.0), xlabel="*x*")
    h = 1 / n
    for i in range(n):
        x0 = i * h
        lo, hi = x0 ** 2, (x0 + h) ** 2
        f.rect(ax.X(x0), ax.Y(hi), ax.X(x0 + h) - ax.X(x0), ax.Y(lo) - ax.Y(hi), "f-b-fill")
        f.rect(ax.X(x0), ax.Y(lo), ax.X(x0 + h) - ax.X(x0), ax.Y(0) - ax.Y(lo), "f-a-fill")
    ax.curve(lambda x: x * x, 0, 1, "f-a-line")
    L = sum((i * h) ** 2 for i in range(n)) * h
    R = sum(((i + 1) * h) ** 2 for i in range(n)) * h
    f.legend(570, 50, [("*x*^{2}", "f-a-line")])
    f.text(570, 82, "blue: left sum, orange: excess to the right sum", "f-muted", 12)
    f.text(570, 104, f"*n* = {n} strips", "f-muted", 12.5)
    f.text(570, 118, f"left sum  = {L:.4f}", "f-muted", 12.5)
    f.text(570, 136, f"right sum = {R:.4f}", "f-muted", 12.5)
    f.text(570, 154, "exact     = 0.3333", "f-muted", 12.5)
    return f
