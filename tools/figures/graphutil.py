"""Small graph helpers for figure scripts (stdlib only)."""
import math
import random


def sbm(sizes, p_in, p_out, seed):
    rng = random.Random(seed)
    n = sum(sizes)
    grp = [g for g, s in enumerate(sizes) for _ in range(s)]
    A = [[0] * n for _ in range(n)]
    for i in range(n):
        for j in range(i + 1, n):
            if rng.random() < (p_in if grp[i] == grp[j] else p_out):
                A[i][j] = A[j][i] = 1
    return A, grp


def laplacian(A):
    n = len(A)
    return [[(sum(A[i]) if i == j else 0) - A[i][j] for j in range(n)] for i in range(n)]


def jacobi_eigh(M, sweeps=60):
    """Eigenvalues (ascending) and eigenvectors (columns of V, as list of rows) of a symmetric matrix."""
    n = len(M)
    A = [row[:] for row in M]
    V = [[1.0 if i == j else 0.0 for j in range(n)] for i in range(n)]
    for _ in range(sweeps):
        off = sum(A[i][j] ** 2 for i in range(n) for j in range(n) if i != j)
        if off < 1e-18:
            break
        for p in range(n - 1):
            for q in range(p + 1, n):
                if abs(A[p][q]) < 1e-14:
                    continue
                th = (A[q][q] - A[p][p]) / (2 * A[p][q])
                t = (1 if th >= 0 else -1) / (abs(th) + math.sqrt(th * th + 1))
                c = 1 / math.sqrt(t * t + 1)
                s = t * c
                for k in range(n):
                    akp, akq = A[k][p], A[k][q]
                    A[k][p], A[k][q] = c * akp - s * akq, s * akp + c * akq
                for k in range(n):
                    apk, aqk = A[p][k], A[q][k]
                    A[p][k], A[q][k] = c * apk - s * aqk, s * apk + c * aqk
                for k in range(n):
                    vkp, vkq = V[k][p], V[k][q]
                    V[k][p], V[k][q] = c * vkp - s * vkq, s * vkp + c * vkq
    order = sorted(range(n), key=lambda i: A[i][i])
    vals = [A[i][i] for i in order]
    vecs = [[V[r][i] for r in range(n)] for i in order]  # vecs[k] is the k-th eigenvector
    return vals, vecs
