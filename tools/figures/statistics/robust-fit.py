"""Four outliers in y: least squares is pulled towards them, a Huber M-estimate stays with the bulk."""
import random
from kit import Fig
from linalg import lstsq


def mad(v):
    s = sorted(v)
    m = s[len(s) // 2] if len(s) % 2 else 0.5 * (s[len(s) // 2 - 1] + s[len(s) // 2])
    d = sorted(abs(x - m) for x in v)
    return (d[len(d) // 2] if len(d) % 2 else 0.5 * (d[len(d) // 2 - 1] + d[len(d) // 2])) / 0.6745


def huber_fit(xs, ys, k=1.345, iters=50):
    X = [[1, x] for x in xs]
    b = lstsq(X, ys)
    for _ in range(iters):
        r = [y - (b[0] + b[1] * x) for x, y in zip(xs, ys)]
        s = mad(r) or 1.0
        w = [1.0 if abs(e / s) <= k else k / abs(e / s) for e in r]
        b = lstsq(X, ys, w)
    return b


def build():
    rng = random.Random(21)
    xs = [0.5 + 9 * i / 21 for i in range(22)]
    ys = [2 + 0.8 * x + rng.gauss(0, 0.5) for x in xs]
    out = [(5.6, 10.6), (6.4, 11.5), (7.2, 12.2), (8.0, 12.9)]
    for x, y in out:
        xs.append(x)
        ys.append(y)
    ols = lstsq([[1, x] for x in xs], ys)
    hub = huber_fit(xs, ys)
    f = Fig(760, 300)
    ax = f.axes(52, 22, 520, 232, (0, 10), (0, 14))
    ax.frame(xticks=(0, 2, 4, 6, 8, 10), yticks=(0, 4, 8, 12), xlabel="x", ylabel="y")
    ax.curve(lambda x: 2 + 0.8 * x, 0.2, 9.8, "f-c-line f-dash", n=2)
    ax.curve(lambda x: ols[0] + ols[1] * x, 0.2, 9.8, "f-b-line", n=2)
    ax.curve(lambda x: hub[0] + hub[1] * x, 0.2, 9.8, "f-a-line", n=2)
    for x, y in zip(xs[:-4], ys[:-4]):
        ax.point(x, y, 3.2, "f-a-solid")
    for x, y in out:
        ax.point(x, y, 5, "f-b-solid")
    f.legend(600, 70, [("least squares", "f-b-line"), ("Huber", "f-a-line"), ("true line", "f-c-line f-dash")])
    f.text(600, 150, f"slope {ols[1]:.2f} vs {hub[1]:.2f}", "f-muted", 12.5)
    f.text(600, 169, "(true value 0.80)", "f-muted", 12.5)
    return f
