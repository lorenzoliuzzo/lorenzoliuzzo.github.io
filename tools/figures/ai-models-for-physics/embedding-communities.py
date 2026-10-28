"""A shallow 2D embedding trained by gradient descent on ||ZZ^T - A||^2 for a graph with two dense groups."""
import random
from kit import Fig
from graphutil import sbm


def build():
    A, grp = sbm([10, 10], 0.7, 0.05, 3)
    n = len(A)
    rng = random.Random(5)
    Z = [[rng.gauss(0, 0.5), rng.gauss(0, 0.5)] for _ in range(n)]
    lr = 0.02
    for _ in range(3000):
        G = [[0.0, 0.0] for _ in range(n)]
        for i in range(n):
            for j in range(n):
                if i == j:
                    continue
                r = Z[i][0] * Z[j][0] + Z[i][1] * Z[j][1] - A[i][j]
                G[i][0] += 4 * r * Z[j][0]
                G[i][1] += 4 * r * Z[j][1]
        for i in range(n):
            Z[i][0] -= lr * G[i][0] / n
            Z[i][1] -= lr * G[i][1] / n
    xs = [z[0] for z in Z]
    ys = [z[1] for z in Z]
    px, py = 0.1 * (max(xs) - min(xs)), 0.1 * (max(ys) - min(ys))
    f = Fig(760, 300)
    ax = f.axes(150, 20, 260, 260, (min(xs) - px, max(xs) + px), (min(ys) - py, max(ys) + py))
    f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
    for i in range(n):
        for j in range(i + 1, n):
            if A[i][j]:
                f.line(ax.X(Z[i][0]), ax.Y(Z[i][1]), ax.X(Z[j][0]), ax.Y(Z[j][1]), "f-grid")
    for i in range(n):
        f.circle(ax.X(Z[i][0]), ax.Y(Z[i][1]), 6, "f-a-solid" if grp[i] == 0 else "f-b-solid")
    f.text(440, 120, "Blue and orange: the two", "f-muted", 12.5)
    f.text(440, 138, "dense groups of the graph.", "f-muted", 12.5)
    f.text(440, 168, "Axes are the two embedding", "f-muted", 12.5)
    f.text(440, 186, "coordinates.", "f-muted", 12.5)
    return f
