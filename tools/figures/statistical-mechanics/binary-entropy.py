"""Shannon entropy of a two-outcome distribution in bits, with its maximum at p = 1/2."""
import math
from kit import Fig


def H(p):
    return 0.0 if p in (0.0, 1.0) else -p * math.log2(p) - (1 - p) * math.log2(1 - p)


def build():
    f = Fig(760, 280)
    ax = f.axes(56, 24, 500, 200, (0, 1), (0, 1.05))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1.0), yticks=(0, 0.5, 1.0), xlabel="probability p of one outcome", ylabel=None)
    ax.curve(H, 0, 1, "f-a-line")
    ax.vline(0.5, 0, 1.0)
    ax.point(0.5, 1.0, 4)
    ax.point(0.1, H(0.1), 4, "f-b-solid")
    f.legend(590, 50, [("H(p) in bits", "f-a-line")])
    f.text(590, 110, "H(1/2) = 1 bit: the", "f-muted", 12.5)
    f.text(590, 128, "uniform choice is the", "f-muted", 12.5)
    f.text(590, 146, f"most uncertain. H(0.1) = {H(0.1):.2f}.", "f-muted", 12.5)
    return f
