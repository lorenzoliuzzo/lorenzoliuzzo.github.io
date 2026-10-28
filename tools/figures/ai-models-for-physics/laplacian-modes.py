"""Left: lowest Laplacian eigenvectors of a 20-node path. Right: Fiedler vector sign on a graph with two dense groups."""
import math
from kit import Fig
from graphutil import sbm, laplacian, jacobi_eigh


def build():
    n = 20
    P = [[0] * n for _ in range(n)]
    for i in range(n - 1):
        P[i][i + 1] = P[i + 1][i] = 1
    vals, vecs = jacobi_eigh(laplacian(P))
    f = Fig(760, 280)
    ax = f.axes(40, 30, 330, 200, (0, n - 1), (-0.5, 0.5))
    ax.frame(xticks=(0, 5, 10, 15, 19), yticks=(-0.4, 0, 0.4), xlabel="node along the path", ylabel=None)
    for k, cls in ((1, "f-a-line"), (2, "f-b-line"), (3, "f-c-line")):
        v = vecs[k]
        s = 1 if v[0] > 0 else -1
        f.poly([(ax.X(i), ax.Y(s * v[i])) for i in range(n)], cls)
        for i in range(n):
            f.circle(ax.X(i), ax.Y(s * v[i]), 2.5, cls.replace("-line", "-solid"))
    f.text(44, 22, f"eigenvalues {vals[1]:.3f}, {vals[2]:.3f}, {vals[3]:.3f}", "f-muted", 12.5)
    A, grp = sbm([9, 9], 0.7, 0.04, 8)
    m = len(A)
    lv, lvec = jacobi_eigh(laplacian(A))
    fied = lvec[1]
    cx = 575
    import random
    rng = random.Random(2)
    pos = []
    for i in range(m):
        ang = rng.uniform(0, 2 * math.pi)
        r = 62 * math.sqrt(rng.random())
        pos.append((cx + (-85 if grp[i] == 0 else 85) + r * math.cos(ang), 130 + r * math.sin(ang)))
    for i in range(m):
        for j in range(i + 1, m):
            if A[i][j]:
                f.line(*pos[i], *pos[j], "f-grid")
    for i in range(m):
        f.circle(*pos[i], 7, "f-a-solid" if fied[i] > 0 else "f-b-solid")
    f.text(cx, 22, "colour = sign of the 2nd eigenvector", "f-muted", 12.5, "middle")
    return f
