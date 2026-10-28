"""Weight gamma^k given to a reward k steps ahead, for three discount factors."""
from kit import Fig


def build():
    f = Fig(760, 280)
    ax = f.axes(56, 24, 500, 200, (0, 40), (0, 1.0))
    ax.frame(xticks=range(0, 41, 10), yticks=(0, 0.25, 0.5, 0.75, 1.0), xlabel="steps ahead k", ylabel=None)
    for g, c in ((0.5, "a"), (0.9, "b"), (0.97, "c")):
        f.poly([(ax.X(k), ax.Y(g ** k)) for k in range(41)], f"f-{c}-line")
    ax.vline(10, 0, 1.0)
    f.legend(590, 50, [("γ = 0.5", "f-a-line"), ("γ = 0.9", "f-b-line"), ("γ = 0.97", "f-c-line")])
    f.text(590, 140, "Dashed line: the horizon", "f-muted", 12.5)
    f.text(590, 158, "1/(1−γ) = 10 of γ = 0.9.", "f-muted", 12.5)
    f.text(590, 176, "Beyond it a reward weighs", "f-muted", 12.5)
    f.text(590, 194, "less than e⁻¹ of its face value.", "f-muted", 12.5)
    return f
