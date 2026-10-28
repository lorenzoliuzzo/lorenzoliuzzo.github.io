"""Sketch of the Hopfield (alpha, T) phase diagram: the exact paramagnet boundary T = 1 + sqrt(alpha) and alpha_c = 0.138."""
import math
from kit import Fig

AC = 0.138


def build():
    f = Fig(760, 300)
    ax = f.axes(56, 20, 520, 230, (0, 0.3), (0, 1.8))
    ax.frame(xticks=(0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3), yticks=(0, 0.5, 1.0, 1.5), xlabel="storage load α = p / N", ylabel=None)
    ax.curve(lambda a: 1 + math.sqrt(a), 0, 0.3, "f-b-line")
    # schematic retrieval region: from (0, 0.0) up to T~0.5 at alpha=0 sloping to (alpha_c, 0)
    pts = [(0.0, 0.0), (0.0, 0.55), (0.04, 0.5), (0.08, 0.38), (0.115, 0.2), (AC, 0.0)]
    f.poly([(ax.X(a), ax.Y(t)) for a, t in pts], "f-a-fill", close=True)
    f.poly([(ax.X(a), ax.Y(t)) for a, t in pts[1:]], "f-a-line f-dash")
    ax.vline(AC, 0, 0.1, "f-c-line")
    ax.text(0.152, 0.1, "α_{c} ≈ 0.138", "f-c", 12.5)
    ax.text(0.012, 0.18, "retrieval", "f-a", 13)
    ax.text(0.085, 0.8, "spin glass", "f-ink", 13)
    ax.text(0.17, 1.55, "paramagnet", "f-ink", 13)
    f.legend(596, 50, [("paramagnet edge", "f-b-line"), ("retrieval edge (sketch)", "f-a-line f-dash")], gap=22)
    f.text(596, 100, "Edge: T = 1 + \u221a\u03b1.", "f-muted", 12.5)
    return f
