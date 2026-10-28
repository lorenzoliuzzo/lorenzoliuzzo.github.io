"""A smoothing spline at three effective degrees of freedom: nearly a line, about right, and chasing the noise."""
import math
from kit import Fig
from linalg import inverse, matmul, transpose, solve
import importlib.util
import pathlib

_spec = importlib.util.spec_from_file_location("rs", pathlib.Path(__file__).with_name("regression-spline.py"))
_rs = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_rs)


def reinsch(xs):
    n = len(xs)
    h = [xs[i + 1] - xs[i] for i in range(n - 1)]
    Q = [[0.0] * (n - 2) for _ in range(n)]
    R = [[0.0] * (n - 2) for _ in range(n - 2)]
    for i in range(n - 2):
        Q[i][i] = 1 / h[i]
        Q[i + 1][i] = -1 / h[i] - 1 / h[i + 1]
        Q[i + 2][i] = 1 / h[i + 1]
        R[i][i] = (h[i] + h[i + 1]) / 3
        if i + 1 < n - 2:
            R[i][i + 1] = R[i + 1][i] = h[i + 1] / 6
    K = matmul(matmul(Q, inverse(R)), transpose(Q))
    return Q, R, K


def smoother(K, lam):
    n = len(K)
    return inverse([[(1.0 if i == j else 0.0) + lam * K[i][j] for j in range(n)] for i in range(n)])


def df_of(K, lam):
    S = smoother(K, lam)
    return sum(S[i][i] for i in range(len(S)))


def lam_for(K, target):
    lo, hi = -14.0, 6.0
    for _ in range(30):
        mid = (lo + hi) / 2
        if df_of(K, 10 ** mid) > target:
            lo = mid
        else:
            hi = mid
    return 10 ** ((lo + hi) / 2)


def evaluate(xs, fv, Q, R):
    n = len(xs)
    g = [0.0] + solve(R, [sum(Q[i][j] * fv[i] for i in range(n)) for j in range(n - 2)]) + [0.0]

    def fn(x):
        i = min(max(sum(1 for t in xs if t <= x) - 1, 0), n - 2)
        h = xs[i + 1] - xs[i]
        a, b = x - xs[i], xs[i + 1] - x
        return (b * fv[i] + a * fv[i + 1]) / h - a * b / 6 * ((1 + a / h) * g[i + 1] + (1 + b / h) * g[i])
    return fn


def build():
    xs, ys = _rs.data()
    Q, R, K = reinsch(xs)
    f = Fig(760, 300)
    ax = f.axes(52, 22, 520, 232, (0, 1), (-1.6, 1.9))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1), yticks=(-1, 0, 1), xlabel="x", ylabel="y")
    for x, y in zip(xs, ys):
        ax.point(x, y, 2.8, "f-faint")
    ax.curve(_rs.truth, cls="f-c-line f-dash")
    entries = []
    for target, cls in ((2.5, "f-b-line"), (7, "f-a-line"), (22, "f-d-line")):
        lam = lam_for(K, target)
        S = smoother(K, lam)
        fv = [sum(S[i][j] * ys[j] for j in range(len(ys))) for i in range(len(ys))]
        fn = evaluate(xs, fv, Q, R)
        ax.curve(fn, xs[0], xs[-1], cls, n=300)
        entries.append((f"df ≈ {target:g}", cls))
    entries.append(("true curve", "f-c-line f-dash"))
    f.legend(600, 70, entries)
    for i, line in enumerate(("A knot at every data", "point and one number λ", "that sets how much bend", "is allowed. The trace of", "the smoother matrix is the", "effective parameter count.")):
        f.text(600, 170 + 19 * i, line, "f-muted", 12.5)
    return fn


def build():
    xs, ys = _rs.data()
    Q, R, K = reinsch(xs)
    f = Fig(760, 300)
    ax = f.axes(52, 22, 520, 232, (0, 1), (-1.6, 1.9))
    ax.frame(xticks=(0, 0.25, 0.5, 0.75, 1), yticks=(-1, 0, 1), xlabel="x", ylabel="y")
    for x, y in zip(xs, ys):
        ax.point(x, y, 2.8, "f-faint")
    ax.curve(_rs.truth, cls="f-c-line f-dash")
    entries = []
    for target, cls in ((2.5, "f-b-line"), (7, "f-a-line"), (22, "f-d-line")):
        lam = lam_for(K, target)
        S = smoother(K, lam)
        fv = [sum(S[i][j] * ys[j] for j in range(len(ys))) for i in range(len(ys))]
        fn = evaluate(xs, fv, Q, R)
        ax.curve(fn, xs[0], xs[-1], cls, n=300)
        entries.append((f"df ≈ {target:g}", cls))
    entries.append(("true curve", "f-c-line f-dash"))
    f.legend(600, 70, entries)
    for i, line in enumerate(("A knot at every data point, and", "one number λ that sets how much", "bend is tolerated. The trace of", "the smoother matrix is the", "effective number of parameters.")):
        f.text(600, 170 + 19 * i, line, "f-muted", 12.5)
    return f
