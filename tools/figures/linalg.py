"""Small dense linear algebra for the figure scripts. Standard library only."""
import math


def solve(A, b):
    """Solve A x = b by Gaussian elimination with partial pivoting."""
    n = len(A)
    M = [list(map(float, row)) + [float(b[i])] for i, row in enumerate(A)]
    for c in range(n):
        p = max(range(c, n), key=lambda r: abs(M[r][c]))
        M[c], M[p] = M[p], M[c]
        for r in range(c + 1, n):
            f = M[r][c] / M[c][c]
            for k in range(c, n + 1):
                M[r][k] -= f * M[c][k]
    x = [0.0] * n
    for r in range(n - 1, -1, -1):
        x[r] = (M[r][n] - sum(M[r][k] * x[k] for k in range(r + 1, n))) / M[r][r]
    return x


def inverse(A):
    n = len(A)
    cols = [solve(A, [1.0 if i == j else 0.0 for i in range(n)]) for j in range(n)]
    return [[cols[j][i] for j in range(n)] for i in range(n)]


def matmul(A, B):
    return [[sum(a * b for a, b in zip(row, col)) for col in zip(*B)] for row in A]


def transpose(A):
    return [list(r) for r in zip(*A)]


def lstsq(X, y, w=None):
    """Least squares coefficients via the normal equations (fine for the tiny, well-scaled designs here)."""
    w = w or [1.0] * len(y)
    p = len(X[0])
    A = [[sum(w[i] * X[i][a] * X[i][b] for i in range(len(y))) for b in range(p)] for a in range(p)]
    b = [sum(w[i] * X[i][a] * y[i] for i in range(len(y))) for a in range(p)]
    return solve(A, b)


def gauss(rng, sd=1.0):
    return rng.gauss(0.0, sd)
