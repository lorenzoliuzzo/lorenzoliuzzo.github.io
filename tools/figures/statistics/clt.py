"""Standardized mean of n i.i.d. Exp(1) variables against the standard normal."""
import math
from kit import Fig
from dist import gamma_pdf, norm_pdf


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 22, 520, 232, (-3, 3.5), (0, 0.6))
    ax.frame(xticks=range(-3, 4), yticks=(0, 0.2, 0.4, 0.6), xlabel="standardized mean", ylabel="density")

    def std_mean(n):
        s = math.sqrt(n)
        return lambda z: gamma_pdf(1 + z / s, n, n) / s

    series = [(2, "f-b-line", "n = 2"), (5, "f-d-line", "n = 5"), (30, "f-a-line", "n = 30")]
    for n, cls, _ in series:
        g = std_mean(n)
        ax.curve(g, -math.sqrt(n) + 1e-6, 3.5, cls)
    ax.curve(norm_pdf, cls="f-line f-dash")
    f.legend(600, 70, [(label, cls) for _, cls, label in series] + [("normal", "f-line f-dash")])
    f.text(600, 190, "A skewed variable's mean", "f-muted", 12.5)
    f.text(600, 207, "is already close to normal", "f-muted", 12.5)
    f.text(600, 224, "by n = 30.", "f-muted", 12.5)
    return f
