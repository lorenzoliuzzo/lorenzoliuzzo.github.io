"""A six-node graph with its adjacency matrix and the matrix of its square."""
from kit import Fig

EDGES = [(0, 1), (0, 2), (1, 2), (2, 3), (3, 4), (3, 5), (4, 5)]
POS = [(50, 70), (50, 170), (120, 120), (200, 120), (270, 70), (270, 170)]


def build():
    n = 6
    A = [[0] * n for _ in range(n)]
    for a, b in EDGES:
        A[a][b] = A[b][a] = 1
    A2 = [[sum(A[i][k] * A[k][j] for k in range(n)) for j in range(n)] for i in range(n)]
    f = Fig(760, 250)
    for a, b in EDGES:
        f.line(*POS[a], *POS[b], "f-line")
    for i, (x, y) in enumerate(POS):
        f.circle(x, y, 13, "f-a-solid")
        f.text(x, y + 5, str(i + 1), "f-ink", 12, "middle")
    cell = 28
    for k, (M, x0, title) in enumerate(((A, 340, "A"), (A2, 560, "A^{2}"))):
        f.text(x0, 36, title, "f-ink", 14, weight=600)
        for i in range(n):
            for j in range(n):
                hi = k == 1 and (i, j) == (0, 3)
                f.rect(x0 + j * cell, 46 + i * cell, cell, cell, "f-b-fill" if hi else "f-box")
                f.text(x0 + j * cell + cell / 2, 46 + i * cell + 19, str(M[i][j]), "f-b" if hi else ("f-ink" if M[i][j] else "f-faint"), 13, "middle")
    f.text(560, 238, "highlight: 2-step walks 1 to 4", "f-muted", 12.5)
    return f
