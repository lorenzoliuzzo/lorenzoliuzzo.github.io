"""Gaussian radial units centred on a grid, output weights found by least squares: each unit adds a local bump, and more units follow the function more closely."""
import math

from kit import Fig


def target(x):
    return 0.5 + 0.35 * math.sin(2 * math.pi * x) + 0.1 * x


def solve(a, b):
    """Gauss elimination with partial pivoting for the small normal equations."""
    n = len(b)
    m = [row[:] + [b[i]] for i, row in enumerate(a)]
    for c in range(n):
        p = max(range(c, n), key=lambda r: abs(m[r][c]))
        m[c], m[p] = m[p], m[c]
        for r in range(c + 1, n):
            t = m[r][c] / m[c][c]
            m[r] = [u - t * v for u, v in zip(m[r], m[c])]
    w = [0.0] * n
    for r in range(n - 1, -1, -1):
        w[r] = (m[r][n] - sum(m[r][j] * w[j] for j in range(r + 1, n))) / m[r][r]
    return w


def fit(k, samples=80):
    """k Gaussian units with radius 0.6 times the centre spacing; weights and bias by least squares on the samples (the pseudo-inverse solution)."""
    centres = [i / (k - 1) for i in range(k)]
    sigma = 0.6 / (k - 1)
    unit = lambda x, c: math.exp(-((x - c) ** 2) / (2 * sigma**2))
    xs = [i / (samples - 1) for i in range(samples)]
    rows = [[1.0] + [unit(x, c) for c in centres] for x in xs]
    ata = [[sum(r[i] * r[j] for r in rows) for j in range(k + 1)] for i in range(k + 1)]
    atb = [sum(r[i] * target(x) for r, x in zip(rows, xs)) for i in range(k + 1)]
    w = solve(ata, atb)
    out = lambda x: w[0] + sum(wi * unit(x, c) for wi, c in zip(w[1:], centres))
    return out, [(lambda x, wi=wi, c=c: w[0] + wi * unit(x, c)) for wi, c in zip(w[1:], centres)]


def build():
    f = Fig(760, 300)
    for j, k in enumerate((4, 9)):
        out, bumps = fit(k)
        ax = f.axes(50 + j * 370, 46, 300, 190, (0, 1), (-0.6, 1.4))
        err = max(abs(out(i / 400) - target(i / 400)) for i in range(401))
        f.text(ax.x0, 26, f"{k} Gaussian units", "f-ink", 14, weight=600)
        ax.frame(xticks=(0, 0.5, 1), yticks=(0, 0.5, 1), grid=False)
        for b in bumps:
            ax.curve(b, cls="f-line f-dash", n=120)
        ax.curve(target, cls="f-c-line")
        ax.curve(out, cls="f-a-line", n=300)
        ax.text(0.97, -0.45, f"largest error {err:.2f}", "f-muted", 12.5, "end")
    f.text(50, 284, "Green: the function. Blue: the network. Dashes: the bias plus one weighted unit each. Weights by least squares.", "f-muted", 12.5)
    return f
