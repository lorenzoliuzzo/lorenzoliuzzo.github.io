"""Average training and test error against polynomial degree: training only falls, test error bottoms out at degree 3 and rises again."""
import math
import random
from kit import Fig
from linalg import lstsq

N, SIGMA, REPS, DEGREES = 20, 0.3, 200, range(1, 13)


def target(x):
    return math.sin(2 * math.pi * x)


def basis(x, d):
    t = 2 * x - 1
    P = [1.0, t]
    for k in range(1, d):
        P.append(((2 * k + 1) * t * P[k] - k * P[k - 1]) / (k + 1))
    return P[: d + 1]


def errors():
    rng = random.Random(11)
    xs = [i / (N - 1) for i in range(N)]
    grid = [i / 100 for i in range(101)]
    train = {d: 0.0 for d in DEGREES}
    test = {d: 0.0 for d in DEGREES}
    Xfull = {d: [basis(x, d) for x in xs] for d in DEGREES}
    Xgrid = {d: [basis(x, d) for x in grid] for d in DEGREES}
    for _ in range(REPS):
        ys = [target(x) + rng.gauss(0, SIGMA) for x in xs]
        for d in DEGREES:
            w = lstsq(Xfull[d], ys)
            train[d] += sum((sum(c * b for c, b in zip(w, row)) - y) ** 2 for row, y in zip(Xfull[d], ys)) / N / REPS
            # expected squared error on a fresh noisy label: error against the true curve plus the noise variance
            test[d] += (sum((sum(c * b for c, b in zip(w, row)) - target(x)) ** 2 for row, x in zip(Xgrid[d], grid)) / len(grid) + SIGMA ** 2) / REPS
    return train, test


def build():
    train, test = errors()
    f = Fig(760, 300)
    ax = f.axes(60, 24, 470, 228, (0.6, 12.4), (0.0, 0.34))
    ax.frame(xticks=range(1, 13), yticks=(0, 0.1, 0.2, 0.3), xlabel="polynomial degree", ylabel="mean squared error")
    ax.curve(lambda x: SIGMA ** 2, cls="f-line f-dash")
    ax.text(12.3, SIGMA ** 2 + 0.012, "noise floor σ² = 0.09", "f-muted", 12, "end")
    for series, cls, solid in ((train, "f-a-line", "f-a-solid"), (test, "f-b-line", "f-b-solid")):
        f.poly([(ax.X(d), ax.Y(series[d])) for d in DEGREES], cls)
        for d in DEGREES:
            ax.point(d, series[d], 3.2, solid)
    best = min(DEGREES, key=lambda d: test[d])
    ax.vline(best, 0, test[best], "f-line f-dash")
    f.legend(572, 70, [("training error", "f-a-line"), ("test error", "f-b-line")])
    f.text(572, 120, "Training error keeps falling.", "f-muted", 12.5)
    f.text(572, 138, f"Test error is lowest at", "f-muted", 12.5)
    f.text(572, 155, f"degree {best}, then rises as", "f-muted", 12.5)
    f.text(572, 172, "the model fits the noise.", "f-muted", 12.5)
    return f
