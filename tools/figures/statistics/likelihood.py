"""Likelihood of a success probability: 7/10 and 70/100, scaled to peak at 1."""
import math
from kit import Fig


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 22, 520, 232, (0, 1), (0, 1.08))

    def rel(k, n):
        p0 = k / n
        top = k * math.log(p0) + (n - k) * math.log(1 - p0)
        return lambda p: math.exp(k * math.log(p) + (n - k) * math.log(1 - p) - top) if 0 < p < 1 else 0.0

    ax.frame(xticks=(0, 0.2, 0.4, 0.6, 0.8, 1.0), yticks=(0, 0.5, 1), xlabel="p", ylabel="L(p) / L(p̂)")
    ax.vline(0.7, 0, 1.08, "f-c-line f-dash")
    ax.curve(rel(7, 10), cls="f-b-line", n=300)
    ax.curve(rel(70, 100), cls="f-a-line", n=300)
    ax.point(0.7, 1, 4.5, "f-c-solid")
    f.text(ax.X(0.7) + 8, ax.Y(1.0) - 2, "p̂ = 0.7", "f-c", 13, weight=600)
    f.legend(600, 70, [("7 successes in 10", "f-b-line"), ("70 in 100", "f-a-line")])
    f.text(600, 135, "Same maximum, sharper peak:", "f-muted", 12.5)
    f.text(600, 152, "ten times the data pins p", "f-muted", 12.5)
    f.text(600, 169, "down about three times", "f-muted", 12.5)
    f.text(600, 186, "more tightly.", "f-muted", 12.5)
    return f
