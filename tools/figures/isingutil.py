"""Stdlib Ising simulation shared by figure scripts (periodic square lattice, J = 1, k_B = 1)."""
import math
import random

TC = 2 / math.log(1 + math.sqrt(2))


def lattice(L, up=False, rng=None):
    rng = rng or random.Random(0)
    return [[1 if up else rng.choice((-1, 1)) for _ in range(L)] for _ in range(L)]


def metropolis_sweep(s, T, rng):
    L = len(s)
    w = {d: math.exp(-d / T) for d in (4, 8)}
    for _ in range(L * L):
        i, j = rng.randrange(L), rng.randrange(L)
        nb = s[(i + 1) % L][j] + s[(i - 1) % L][j] + s[i][(j + 1) % L] + s[i][(j - 1) % L]
        d = 2 * s[i][j] * nb
        if d <= 0 or rng.random() < w[d]:
            s[i][j] = -s[i][j]


def wolff_step(s, T, rng):
    """One Wolff cluster flip; returns the cluster size."""
    L = len(s)
    p = 1 - math.exp(-2 / T)
    i, j = rng.randrange(L), rng.randrange(L)
    spin = s[i][j]
    s[i][j] = -spin
    stack, size = [(i, j)], 1
    while stack:
        x, y = stack.pop()
        for a, b in (((x + 1) % L, y), ((x - 1) % L, y), (x, (y + 1) % L), (x, (y - 1) % L)):
            if s[a][b] == spin and rng.random() < p:
                s[a][b] = -spin
                stack.append((a, b))
                size += 1
    return size


def abs_mag(s):
    L = len(s)
    return abs(sum(map(sum, s))) / (L * L)


def autocorr(series, tmax):
    n = len(series)
    mean = sum(series) / n
    x = [v - mean for v in series]
    var = sum(v * v for v in x) / n
    out = []
    for t in range(tmax + 1):
        out.append(sum(x[i] * x[i + t] for i in range(n - t)) / ((n - t) * var))
    return out
