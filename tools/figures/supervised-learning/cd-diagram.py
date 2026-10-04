"""A critical difference diagram for four classifiers on 30 data sets: A beats everything, D loses to everything, B and C cannot be told apart."""
import math
from kit import Fig

RANKS = {"A": 1.2, "B": 2.45, "C": 2.55, "D": 3.8}
K, N, Q = 4, 30, 2.569


def build():
    cd = Q * math.sqrt(K * (K + 1) / (6 * N))
    f = Fig(760, 250)
    ax = f.axes(70, 96, 560, 10, (1, 4), (0, 1))
    X = ax.X
    f.line(X(1), 96, X(4), 96, "f-axis")
    for v in (1, 2, 3, 4):
        f.line(X(v), 96, X(v), 90, "f-axis")
        f.text(X(v), 80, str(v), "f-muted", 12.5, "middle")
    f.text(X(2.5), 62, "average rank (1 is best)", "f-muted", 12.5, "middle")
    # scale bar of length CD
    f.line(X(1), 30, X(1 + cd), 30, "f-b-line")
    f.line(X(1), 25, X(1), 35, "f-b-line")
    f.line(X(1 + cd), 25, X(1 + cd), 35, "f-b-line")
    f.text(X(1 + cd) + 10, 34, f"CD = {cd:.2f}", "f-b", 12.5)
    # algorithms: labels hang below the axis, left half to the left, right half to the right
    order = sorted(RANKS, key=RANKS.get)
    for i, name in enumerate(order):
        r = RANKS[name]
        left = i < 2
        y_label = 138 + (i if left else 3 - i) * 24
        f.line(X(r), 96, X(r), y_label, "f-line")
        f.circle(X(r), 96, 4, "f-a-solid")
        if left:
            f.line(X(r), y_label, X(1) - 14, y_label, "f-line")
            f.text(X(1) - 20, y_label + 4, f"{name}   {r:.2f}", "f-ink", 13, "end")
        else:
            f.line(X(r), y_label, X(4) + 14, y_label, "f-line")
            f.text(X(4) + 20, y_label + 4, f"{r:.2f}   {name}", "f-ink", 13, "start")
    # bar joining the algorithms that are not significantly different
    f.line(X(RANKS["B"]) - 4, 108, X(RANKS["C"]) + 4, 108, "f-b-line")
    f.text(X(2.5), 214, "B and C are not significantly different:", "f-muted", 12.5, "middle")
    f.text(X(2.5), 232, "their ranks differ by less than CD.", "f-muted", 12.5, "middle")
    return f
