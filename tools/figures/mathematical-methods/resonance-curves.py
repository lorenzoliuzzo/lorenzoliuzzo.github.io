"""Steady-state amplitude of the driven damped oscillator y'' + g y' + y = F cos(w t), in units of the static response F, for damping g = 0.1, 0.3 and 1.0: weak damping gives a tall narrow peak near w = 1, strong damping no peak."""
import math
from kit import Fig


def amp(g):
    return lambda w: 1 / math.sqrt((1 - w * w) ** 2 + (g * w) ** 2)


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 520, 232, (0, 2), (0, 11))
    ax.frame(xticks=(0, 0.5, 1, 1.5, 2), yticks=(0, 5, 10), xlabel="driving frequency ω / ω_{0}", ylabel="amplitude / static response")
    for g, cls in ((1.0, "f-c-line"), (0.3, "f-b-line"), (0.1, "f-a-line")):
        ax.curve(amp(g), 0.001, 2, cls, 400)
    f.legend(600, 60, [("γ = 0.1 ω_{0}, *Q* = 10", "f-a-line"), ("γ = 0.3 ω_{0}", "f-b-line"), ("γ = 1.0 ω_{0}", "f-c-line")])
    f.text(600, 150, "Peak height ≈ *Q* = ω_{0}/γ,", "f-muted", 12.5)
    f.text(600, 168, "width ≈ γ: weaker damping,", "f-muted", 12.5)
    f.text(600, 186, "taller and sharper peak.", "f-muted", 12.5)
    return f
