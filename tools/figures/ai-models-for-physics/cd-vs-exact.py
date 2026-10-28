"""A 4-visible, 3-hidden RBM trained on four patterns: exact likelihood gradient against CD-1 and CD-10 (average log-likelihood per epoch)."""
import itertools
import math
import random
from kit import Fig

NV, NH = 4, 3
DATA = [(0, 0, 0, 0), (1, 1, 1, 1), (1, 0, 1, 0), (0, 1, 0, 1)]
VS = list(itertools.product((0, 1), repeat=NV))
HS = list(itertools.product((0, 1), repeat=NH))
EPOCHS, LR = 800, 0.5


def sig(x):
    return 1 / (1 + math.exp(-x))


def energy(v, h, a, b, W):
    return -sum(a[i] * v[i] for i in range(NV)) - sum(b[j] * h[j] for j in range(NH)) - sum(v[i] * W[i][j] * h[j] for i in range(NV) for j in range(NH))


def exact_stats(a, b, W):
    """Return log Z and model expectations <v>, <h>, <vh>."""
    ws = {(v, h): math.exp(-energy(v, h, a, b, W)) for v in VS for h in HS}
    z = sum(ws.values())
    ev = [sum(w * v[i] for (v, h), w in ws.items()) / z for i in range(NV)]
    eh = [sum(w * h[j] for (v, h), w in ws.items()) / z for j in range(NH)]
    evh = [[sum(w * v[i] * h[j] for (v, h), w in ws.items()) / z for j in range(NH)] for i in range(NV)]
    return math.log(z), ev, eh, evh


def mean_loglik(a, b, W):
    lz, *_ = exact_stats(a, b, W)
    tot = 0.0
    for v in DATA:
        s = sum(math.exp(-energy(v, h, a, b, W)) for h in HS)
        tot += math.log(s) - lz
    return tot / len(DATA)


def data_stats(a, b, W):
    dv = [sum(v[i] for v in DATA) / len(DATA) for i in range(NV)]
    ph = [[sig(b[j] + sum(v[i] * W[i][j] for i in range(NV))) for j in range(NH)] for v in DATA]
    dh = [sum(p[j] for p in ph) / len(DATA) for j in range(NH)]
    dvh = [[sum(DATA[n][i] * ph[n][j] for n in range(len(DATA))) / len(DATA) for j in range(NH)] for i in range(NV)]
    return dv, dh, dvh


def cd_stats(a, b, W, k, rng, reps=40):
    mv = [0.0] * NV
    mh = [0.0] * NH
    mvh = [[0.0] * NH for _ in range(NV)]
    n = 0
    for v0 in DATA:
        for _ in range(reps):
            v = list(v0)
            for _ in range(k):
                h = [1 if rng.random() < sig(b[j] + sum(v[i] * W[i][j] for i in range(NV))) else 0 for j in range(NH)]
                v = [1 if rng.random() < sig(a[i] + sum(W[i][j] * h[j] for j in range(NH))) else 0 for i in range(NV)]
            ph = [sig(b[j] + sum(v[i] * W[i][j] for i in range(NV))) for j in range(NH)]
            for i in range(NV):
                mv[i] += v[i]
                for j in range(NH):
                    mvh[i][j] += v[i] * ph[j]
            for j in range(NH):
                mh[j] += ph[j]
            n += 1
    return [x / n for x in mv], [x / n for x in mh], [[x / n for x in row] for row in mvh]


def train(mode, seed=1):
    rng = random.Random(seed)
    a = [0.0] * NV
    b = [0.0] * NH
    W = [[rng.gauss(0, 0.3) for _ in range(NH)] for _ in range(NV)]
    curve = [mean_loglik(a, b, W)]
    for ep in range(EPOCHS):
        dv, dh, dvh = data_stats(a, b, W)
        if mode == "exact":
            _, mv, mh, mvh = exact_stats(a, b, W)
        else:
            mv, mh, mvh = cd_stats(a, b, W, mode, rng)
        for i in range(NV):
            a[i] += LR * (dv[i] - mv[i])
            for j in range(NH):
                W[i][j] += LR * (dvh[i][j] - mvh[i][j])
        for j in range(NH):
            b[j] += LR * (dh[j] - mh[j])
        curve.append(mean_loglik(a, b, W))
    return curve


def build():
    runs = [("exact gradient", "f-a-line", train("exact")), ("CD-10", "f-c-line", train(10)), ("CD-1", "f-b-line", train(1))]
    best = -math.log(len(DATA))
    f = Fig(760, 300)
    ax = f.axes(56, 20, 520, 230, (0, EPOCHS), (-3.0, 0.0))
    ax.frame(xticks=range(0, EPOCHS + 1, 100), yticks=(-3, -2, -1, 0), xlabel="epochs", ylabel=None)
    ax.vline(0, 0, 0)
    f.line(ax.X(0), ax.Y(best), ax.X(EPOCHS), ax.Y(best), "f-line f-dash")
    for name, cls, c in runs:
        f.poly([(ax.X(e), ax.Y(max(v, -3.0))) for e, v in enumerate(c)], cls)
    f.legend(600, 50, [(n, c) for n, c, _ in runs] + [("best possible (ln 4)", "f-line f-dash")])
    f.text(600, 160, "Average log-likelihood of", "f-muted", 12.5)
    f.text(600, 178, "the four training patterns.", "f-muted", 12.5)
    for name, cls, c in runs:
        print(name, round(c[-1], 3), "best", round(best, 3))
    return f
