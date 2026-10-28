"""Small numeric helpers for the neural-network figure scripts. Standard library only."""
import math


def solve(A, b):
    """Solve A x = b by Gaussian elimination with partial pivoting (A is a list of rows)."""
    n = len(A)
    M = [row[:] + [b[i]] for i, row in enumerate(A)]
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


def sigmoid(z):
    return 1 / (1 + math.exp(-z))


def legendre(x, m):
    """Legendre polynomials P_0..P_{m-1} at x."""
    P = [1.0, x]
    for k in range(2, m):
        P.append(((2 * k - 1) * x * P[k - 1] - (k - 1) * P[k - 2]) / k)
    return P[:m]
