"""MARS in one dimension: a forward pass overgrows a sum of hinge functions, the backward pass prunes it."""
import math
import random
from kit import Fig
from linalg import lstsq

N = 60


def truth(x):
    return 1.0 + 0.4 * x + 1.6 * max(x - 4, 0) - 2.6 * max(x - 7, 0)


def data():
    rng = random.Random(7)
    xs = [10 * (i + 0.5) / N for i in range(N)]
    return xs, [truth(x) + rng.gauss(0, 0.35) for x in xs]


def design(xs, terms):
    # terms: list of (knot, sign); sign +1 is (x - t)+, -1 is (t - x)+
    return [[1.0] + [max(sg * (x - t), 0.0) for t, sg in terms] for x in xs]


def rss_of(xs, ys, terms):
    b = lstsq(design(xs, terms), ys)
    X = design(xs, terms)
    return sum((y - sum(c * v for c, v in zip(b, row))) ** 2 for y, row in zip(ys, X)), b


def forward(xs, ys, pairs):
    terms, knots = [], []
    cand = xs[2:-2]
    for _ in range(pairs):
        best = min((t for t in cand if t not in knots), key=lambda t: rss_of(xs, ys, terms + [(t, 1), (t, -1)])[0])
        knots.append(best)
        terms += [(best, 1), (best, -1)]
    return terms


def backward(xs, ys, terms, d=2.0):
    cur, best, best_g = list(terms), list(terms), None
    while True:
        rss, _ = rss_of(xs, ys, cur)
        knots = len({t for t, _ in cur})
        g = (rss / N) / (1 - (len(cur) + 1 + d * knots) / N) ** 2
        if best_g is None or g < best_g:
            best, best_g = list(cur), g
        if not cur:
            return best
        cur = min((cur[:i] + cur[i + 1:] for i in range(len(cur))), key=lambda ts: rss_of(xs, ys, ts)[0])


def predict(terms, b):
    return lambda x: b[0] + sum(c * max(sg * (x - t), 0.0) for c, (t, sg) in zip(b[1:], terms))


def build():
    xs, ys = data()
    big = forward(xs, ys, 4)
    small = backward(xs, ys, big)
    f = Fig(760, 300)
    ax = f.axes(52, 22, 400, 232, (0, 10), (-1.5, 9.5))
    ax.frame(xticks=(0, 2, 4, 6, 8, 10), yticks=(0, 3, 6, 9), xlabel="x", ylabel="y")
    for x, y in zip(xs, ys):
        ax.point(x, y, 2.8, "f-faint")
    _, bb = rss_of(xs, ys, big)
    _, bs = rss_of(xs, ys, small)
    ax.curve(predict(big, bb), cls="f-b-line f-dash", n=400)
    ax.curve(predict(small, bs), cls="f-a-line", n=400)
    for t in sorted({t for t, _ in small}):
        ax.vline(t, -1.5, -0.5, "f-a-line")
    f.legend(70, 44, [("after pruning, 3 terms", "f-a-line"), ("forward pass, 9 terms", "f-b-line f-dash")], size=12)
    # the hinge pair at t = 4, in a small panel
    bx = f.axes(540, 40, 190, 120, (0, 8), (0, 4.4))
    bx.frame(xticks=(0, 4, 8), yticks=(), grid=False, yaxis=False)
    bx.curve(lambda x: max(x - 4, 0), cls="f-a-line", n=200)
    bx.curve(lambda x: max(4 - x, 0), cls="f-b-line", n=200)
    f.text(bx.X(5.0), bx.Y(0.55), "(x − t)₊", "f-a", 13, "start", 600)
    f.text(bx.X(0.5), bx.Y(4.25), "(t − x)₊", "f-b", 13, "start", 600)
    f.text(540, 28, "one pair, knot t = 4", "f-muted", 12.5)
    for i, line in enumerate(("Each hinge is zero on one", "side of its knot. Fitting adds", "pairs where the data bend;", "the sum is piecewise linear.")):
        f.text(540, 200 + 19 * i, line, "f-muted", 12.5)
    return f
