"""k-nearest-neighbour error against k on two classes that are mixtures of blobs: k = 1 memorizes the training set, a very large k underfits. Seed 8 gives a clear dip; other draws of the blob centres move it but keep the shape."""
import random
from kit import Fig

N_TRAIN, N_TEST = 200, 3000
KS = list(range(1, 100, 2))


def centres(rng):
    # each class is a mixture of five blobs, so the best boundary is curved
    return {0: [(rng.gauss(0, 1.6), rng.gauss(0, 1.6)) for _ in range(5)],
            1: [(rng.gauss(2.2, 1.6), rng.gauss(2.2, 1.6)) for _ in range(5)]}


def draw(rng, mix, n):
    pts = []
    for label in (0, 1):
        for _ in range(n // 2):
            cx, cy = rng.choice(mix[label])
            pts.append((rng.gauss(cx, 0.5), rng.gauss(cy, 0.5), label))
    return pts


def errors(train, test, exclude_self):
    err = {k: 0 for k in KS}
    for i, (x, y, label) in enumerate(test):
        d = sorted(((x - a) ** 2 + (y - b) ** 2, l) for j, (a, b, l) in enumerate(train) if not (exclude_self and i == j))
        votes = 0
        for r in range(max(KS)):
            votes += d[r][1]
            if (r + 1) in err:
                k = r + 1
                err[k] += int((votes * 2 > k) != bool(label))
    return {k: v / len(test) for k, v in err.items()}


def build():
    rng = random.Random(8)
    mix = centres(rng)
    train, test = draw(rng, mix, N_TRAIN), draw(rng, mix, N_TEST)
    tr, te = errors(train, train, False), errors(train, test, False)
    f = Fig(760, 300)
    ax = f.axes(60, 24, 470, 228, (0, 100), (0, 0.3))
    ax.frame(xticks=(1, 21, 41, 61, 81, 99), yticks=(0, 0.1, 0.2, 0.3), xlabel="k, the number of neighbours", ylabel="error rate")
    for series, cls, solid in ((tr, "f-a-line", "f-a-solid"), (te, "f-b-line", "f-b-solid")):
        f.poly([(ax.X(k), ax.Y(series[k])) for k in KS], cls)
        for k in (1, 11, 31, 61, 99):
            ax.point(k, series[k], 3.2, solid)
    best = min(KS, key=lambda k: te[k])
    ax.vline(best, 0, te[best], "f-line f-dash")
    f.legend(572, 70, [("training error", "f-a-line"), ("test error", "f-b-line")])
    f.text(572, 120, "k = 1: training error 0,", "f-muted", 12.5)
    f.text(572, 137, f"test error {te[1]:.2f}.", "f-muted", 12.5)
    f.text(572, 160, f"k = {best}: test error {te[best]:.2f}.", "f-muted", 12.5)
    f.text(572, 183, f"k = 99: test error {te[99]:.2f}.", "f-muted", 12.5)
    f.text(572, 200, "The neighbourhood is half of", "f-muted", 12.5)
    f.text(572, 217, "the data, too coarse to follow", "f-muted", 12.5)
    f.text(572, 234, "the boundary.", "f-muted", 12.5)
    return f
