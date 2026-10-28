"""Inverse-transform sampling of an exponential, and the lattice structure of a poor linear congruential generator."""
import math, random
from kit import Fig


def lcg(a, c, m, seed, n):
    x, out = seed, []
    for _ in range(n):
        x = (a * x + c) % m
        out.append(x / m)
    return out


def build():
    rnd = random.Random(7)
    f = Fig(760, 324)
    ax = f.axes(50, 20, 300, 220, (0, 5), (0, 1.0))
    ax.frame(xticks=(0, 1, 2, 3, 4, 5), yticks=(0, 0.5, 1.0), xlabel="*x* = −ln(1 − *u*)")
    bins = 25
    cnt = [0] * bins
    N = 20000
    for _ in range(N):
        x = -math.log(1 - rnd.random())
        k = int(x / 5 * bins)
        if k < bins:
            cnt[k] += 1
    w = 5 / bins
    ax.bars([(i + 0.5) * w for i in range(bins)], [c / N / w for c in cnt], (ax.X(w) - ax.X(0)) * 0.9)
    ax.curve(lambda x: math.exp(-x), 0, 5, "f-b-line")
    a2 = f.axes(440, 20, 220, 220, (0, 1), (0, 1))
    a2.frame(xticks=(0, 0.5, 1), yticks=(0, 0.5, 1), xlabel="*u*_{n} against *u*_{n+1}", grid=False)
    u = lcg(65, 1, 2048, 1, 2000)
    for x, y in zip(u, u[1:]):
        a2.point(x, y, 1.4)
    f.text(50, 316, "20000 samples (bars) against the exact density e^{−x} (line)", "f-muted", 12)
    return f
