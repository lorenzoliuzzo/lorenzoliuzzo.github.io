"""Data-only and physics-informed fits of u'' = -u from five noisy points on [0, 2], extrapolated to [0, 6]."""
import math
import random
from kit import Fig

T1 = 6.0
S = 2.0 / T1
DEG = 14


def basis(t):
    x = 2 * t / T1 - 1
    T, d1, d2 = [1.0, x], [0.0, 1.0], [0.0, 0.0]
    for n in range(1, DEG):
        T.append(2 * x * T[n] - T[n - 1])
        d1.append(2 * T[n] + 2 * x * d1[n] - d1[n - 1])
        d2.append(4 * d1[n] + 2 * x * d2[n] - d2[n - 1])
    return T, [S * v for v in d1], [S * S * v for v in d2]


def solve(A, b):
    n = len(A)
    M = [A[i][:] + [b[i]] for i in range(n)]
    for i in range(n):
        p = max(range(i, n), key=lambda r: abs(M[r][i]))
        M[i], M[p] = M[p], M[i]
        for r in range(i + 1, n):
            fac = M[r][i] / M[i][i]
            M[r] = [x - fac * y for x, y in zip(M[r], M[i])]
    w = [0.0] * n
    for i in reversed(range(n)):
        w[i] = (M[i][n] - sum(M[i][j] * w[j] for j in range(i + 1, n))) / M[i][i]
    return w


def fit(rows, targets, weights, ridge=1e-8):
    n = DEG + 1
    A = [[0.0] * n for _ in range(n)]
    b = [0.0] * n
    for r, y, w in zip(rows, targets, weights):
        for i in range(n):
            b[i] += w * r[i] * y
            for j in range(n):
                A[i][j] += w * r[i] * r[j]
    for i in range(n):
        A[i][i] += ridge
    return solve(A, b)


def build():
    rng = random.Random(4)
    td = [0.2, 0.6, 1.0, 1.4, 1.8]
    yd = [math.sin(t) + rng.gauss(0, 0.03) for t in td]
    Bd = [basis(t)[0] for t in td]
    wd = fit(Bd, yd, [1.0] * 5, ridge=1e-3)
    col = [i * T1 / 60 for i in range(61)]
    rows, tg, wt = list(Bd), list(yd), [1.0] * 5
    for t in col:
        _, _, d2 = basis(t)
        b0 = basis(t)[0]
        rows.append([d2[i] + b0[i] for i in range(DEG + 1)])
        tg.append(0.0)
        wt.append(0.05)
    wp = fit(rows, tg, wt, ridge=1e-8)

    def ev(w, t):
        return sum(a * b for a, b in zip(w, basis(t)[0]))

    f = Fig(760, 300)
    ax = f.axes(56, 24, 520, 220, (0, T1), (-2, 2))
    ax.frame(xticks=range(0, 7), yticks=(-2, -1, 0, 1, 2), xlabel="t", ylabel=None)
    ts = [i * T1 / 240 for i in range(241)]
    f.poly([(ax.X(t), ax.Y(math.sin(t))) for t in ts], "f-line")
    f.poly([(ax.X(t), ax.Y(max(-2, min(2, ev(wd, t))))) for t in ts], "f-b-line")
    f.poly([(ax.X(t), ax.Y(max(-2, min(2, ev(wp, t))))) for t in ts], "f-a-line")
    for t, y in zip(td, yd):
        ax.point(t, y, 4, "f-c-solid")
    ax.vline(2.0, -2, 2)
    f.legend(600, 50, [("exact sin t", "f-line"), ("data only", "f-b-line"), ("data + residual", "f-a-line"), ("noisy data", "f-c-line")])
    f.text(600, 150, "Degree-14 polynomial, both", "f-muted", 12.5)
    f.text(600, 168, "fits. The residual of u″+u", "f-muted", 12.5)
    f.text(600, 186, "is penalised at 61 points", "f-muted", 12.5)
    f.text(600, 204, "on [0, 6], with no labels.", "f-muted", 12.5)
    return f
