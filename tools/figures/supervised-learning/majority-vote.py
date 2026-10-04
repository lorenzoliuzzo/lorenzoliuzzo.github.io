"""Error of a majority vote of T independent classifiers against T, exact and by the Hoeffding bound, for individual errors 0.3 and 0.4."""
import math
from kit import Fig

TS = list(range(1, 102, 2))


def exact(t, eps):
    # at most floor(T/2) of the T classifiers are right
    return sum(math.comb(t, k) * (1 - eps) ** k * eps ** (t - k) for k in range(t // 2 + 1))


def bound(t, eps):
    return math.exp(-0.5 * t * (1 - 2 * eps) ** 2)


def build():
    f = Fig(760, 300)
    ax = f.axes(70, 24, 460, 228, (0, 101), (-5, 0))
    labels = {0: "1", -1: "0.1", -2: "10⁻²", -3: "10⁻³", -4: "10⁻⁴", -5: "10⁻⁵"}
    ax.frame(xticks=(1, 21, 41, 61, 81, 101), yticks=(0, -1, -2, -3, -4, -5), yfmt=lambda v: labels[int(v)],
             xlabel="number of classifiers T", ylabel="error of the vote")
    for eps, solid in ((0.3, "a"), (0.4, "b")):
        ex = [(ax.X(t), ax.Y(max(-5, math.log10(exact(t, eps))))) for t in TS]
        bd = [(ax.X(t), ax.Y(max(-5, math.log10(bound(t, eps))))) for t in TS]
        f.poly(ex, f"f-{solid}-line")
        f.poly(bd, f"f-{solid}-line f-dash")
    f.legend(564, 70, [("ε = 0.3, exact", "f-a-line"), ("ε = 0.3, bound", "f-a-line f-dash"),
                       ("ε = 0.4, exact", "f-b-line"), ("ε = 0.4, bound", "f-b-line f-dash")])
    f.text(564, 170, "Both fall as a straight line", "f-muted", 12.5)
    f.text(564, 187, "on a log scale: exponentially", "f-muted", 12.5)
    f.text(564, 204, "in T. Weaker learners (ε", "f-muted", 12.5)
    f.text(564, 221, "nearer ½) need far more of them.", "f-muted", 12.5)
    return f
