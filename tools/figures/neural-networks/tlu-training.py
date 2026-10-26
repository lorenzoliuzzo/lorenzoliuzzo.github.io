"""Corrections the delta rule makes in each epoch: they stop for the conjunction and never stop for the biimplication."""
from kit import Fig

POINTS = [(0, 0), (0, 1), (1, 0), (1, 1)]
EPOCHS = 12


def corrections(outs):
    """Online delta rule, eta = 1, start w = (0, 0), θ = 0, patterns in the order above."""
    w, theta, counts = [0, 0], 0, []
    for _ in range(EPOCHS):
        n = 0
        for x, o in zip(POINTS, outs):
            y = int(w[0] * x[0] + w[1] * x[1] >= theta)
            if y != o:
                n += 1
                d = o - y
                theta -= d
                w = [w[0] + d * x[0], w[1] + d * x[1]]
        counts.append(n)
    return counts


def build():
    f = Fig(760, 280)
    ax = f.axes(60, 24, 480, 200, (0.5, EPOCHS + 0.5), (-0.3, 4.6))
    ax.frame(xticks=range(1, EPOCHS + 1), yticks=range(0, 5), xlabel="epoch", ylabel="corrections")
    for outs, cls, solid in [([0, 0, 0, 1], "f-a", "f-a-solid"), ([1, 0, 0, 1], "f-b", "f-b-solid")]:
        c = corrections(outs)
        f.poly([(ax.X(i + 1), ax.Y(v)) for i, v in enumerate(c)], cls + "-line")
        for i, v in enumerate(c):
            ax.point(i + 1, v, 3.5, solid)
    f.legend(570, 80, [("x_{1} ∧ x_{2}", "f-a-line"), ("x_{1} ↔ x_{2}", "f-b-line")])
    f.text(570, 130, "The conjunction needs five", "f-muted", 12.5)
    f.text(570, 148, "epochs of corrections, then", "f-muted", 12.5)
    f.text(570, 166, "none. The biimplication is", "f-muted", 12.5)
    f.text(570, 184, "corrected four times per", "f-muted", 12.5)
    f.text(570, 202, "epoch, forever.", "f-muted", 12.5)
    return f
