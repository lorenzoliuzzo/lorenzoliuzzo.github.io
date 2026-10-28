"""An echo state network trained on the Lorenz x-coordinate series, then run freely: the forecast follows the true orbit for several Lyapunov times."""
import math
import random
from kit import Fig

DT = 0.02
N = 200


def lorenz(n):
    def f(v):
        x, y, z = v
        return (10 * (y - x), x * (28 - z) - y, x * y - 8 / 3 * z)
    v = (1.0, 1.0, 1.0)
    out = []
    for i in range(n + 1000):
        k1 = f(v)
        k2 = f(tuple(a + DT / 2 * b for a, b in zip(v, k1)))
        k3 = f(tuple(a + DT / 2 * b for a, b in zip(v, k2)))
        k4 = f(tuple(a + DT * b for a, b in zip(v, k3)))
        v = tuple(a + DT / 6 * (p + 2 * q + 2 * r + s) for a, p, q, r, s in zip(v, k1, k2, k3, k4))
        if i >= 1000:
            out.append(v)
    return out


def solve(A, B):
    n = len(A)
    M = [A[i][:] + B[i][:] for i in range(n)]
    m = len(B[0])
    for i in range(n):
        p = max(range(i, n), key=lambda r: abs(M[r][i]))
        M[i], M[p] = M[p], M[i]
        piv = M[i][i]
        M[i] = [x / piv for x in M[i]]
        for r in range(n):
            if r != i and M[r][i] != 0.0:
                fac = M[r][i]
                M[r] = [x - fac * y for x, y in zip(M[r], M[i])]
    return [row[n:] for row in M]


def power_radius(W):
    v = [1.0] * len(W)
    lam = 1.0
    for _ in range(200):
        w = [sum(W[i][j] * v[j] for j in range(len(v)) if W[i][j] != 0.0) for i in range(len(v))]
        lam = math.sqrt(sum(x * x for x in w)) / math.sqrt(sum(x * x for x in v))
        v = [x / lam for x in w]
    return lam


def build():
    rng = random.Random(3)
    data = lorenz(4000)
    scale = [20.0, 25.0, 25.0]
    u = [tuple(x / s for x, s in zip(p, scale)) for p in data]
    nz = 0.03
    W = [[0.0] * N for _ in range(N)]
    for i in range(N):
        for _ in range(6):
            W[i][rng.randrange(N)] = rng.uniform(-1, 1)
    rho = power_radius(W)
    W = [[x * 1.0 / rho for x in row] for row in W]
    Win = [[rng.uniform(-0.5, 0.5) for _ in range(3)] for _ in range(N)]
    nzW = [(i, [(j, W[i][j]) for j in range(N) if W[i][j] != 0.0]) for i in range(N)]

    def step(r, x):
        return [math.tanh(sum(Win[i][k] * x[k] for k in range(3)) + sum(w * r[j] for j, w in nzW[i][1])) for i in range(N)]

    r = [0.0] * N
    wash, ntr = 200, 2800
    R, Y = [], []
    for t in range(wash + ntr):
        r = step(r, u[t])
        if t >= wash:
            R.append(r[:] + [1.0])
            Y.append(list(u[t + 1]))
    M = N + 1
    A = [[0.0] * M for _ in range(M)]
    for row in R:
        for i in range(M):
            ri = row[i]
            Ai = A[i]
            for j in range(M):
                Ai[j] += ri * row[j]
    for i in range(M):
        A[i][i] += 1e-6
    B = [[sum(R[t][i] * Y[t][k] for t in range(len(R))) for k in range(3)] for i in range(M)]
    Wout = solve(A, B)
    # free run from the end of training
    x = list(u[wash + ntr])
    pred = []
    nsteps = 450
    for _ in range(nsteps):
        r = step(r, x)
        x = [sum((r + [1.0])[i] * Wout[i][k] for i in range(M)) for k in range(3)]
        pred.append(x[0] * scale[0])
    truth = [data[wash + ntr + 1 + t][0] for t in range(nsteps)]
    lt = DT * 0.906
    f = Fig(760, 300)
    ax = f.axes(56, 24, 520, 220, (0, nsteps * DT), (-25, 25))
    ax.frame(xticks=range(0, 10, 2), yticks=(-20, -10, 0, 10, 20), xlabel="time", ylabel=None)
    f.poly([(ax.X(t * DT), ax.Y(truth[t])) for t in range(nsteps)], "f-a-line")
    f.poly([(ax.X(t * DT), ax.Y(max(-25, min(25, pred[t])))) for t in range(nsteps)], "f-b-line f-dash")
    f.legend(600, 50, [("Lorenz x(t)", "f-a-line"), ("free-running ESN", "f-b-line f-dash")])
    f.text(600, 130, f"{N} units, 3 inputs, one", "f-muted", 12.5)
    f.text(600, 148, "linear readout fitted by", "f-muted", 12.5)
    f.text(600, 166, "ridge regression. One", "f-muted", 12.5)
    f.text(600, 184, "Lyapunov time is about 1.1.", "f-muted", 12.5)
    return f
