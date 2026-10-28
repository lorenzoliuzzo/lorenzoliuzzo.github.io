"""Cayley tables of the integers mod 6 (commutative) and the symmetries of a triangle (not)."""
from kit import Fig
from itertools import product


def s3():
    els = [(0, 1, 2), (1, 2, 0), (2, 0, 1), (0, 2, 1), (2, 1, 0), (1, 0, 2)]
    names = ["e", "r", "r^{2}", "s", "sr", "sr^{2}"]
    idx = {e: i for i, e in enumerate(els)}

    def mul(a, b):
        return tuple(els[a][els[b][k]] for k in range(3))
    return names, [[idx[mul(a, b)] for b in range(6)] for a in range(6)]


def table(f, ox, oy, names, T, title, hilite):
    c = 36
    f.text(ox, oy - 14, title, "f-muted", 13)
    for i in range(6):
        f.text(ox + (i + 1.5) * c, oy + 14, names[i], "f-muted", 12, "middle")
        f.text(ox + c / 2, oy + (i + 1) * c + 22, names[i], "f-muted", 12, "middle")
    for i, j in product(range(6), range(6)):
        x, y = ox + (j + 1) * c, oy + (i + 1) * c - 2 + 0
        f.rect(x + 1, y + 4, c - 2, c - 2, "f-a-fill" if hilite(i, j, T) else "f-box")
        f.text(x + c / 2, y + c / 2 + 8, names[T[i][j]], "f-ink", 12, "middle")


def build():
    f = Fig(760, 336)
    z = [str(i) for i in range(6)]
    Tz = [[(i + j) % 6 for j in range(6)] for i in range(6)]
    names, Ts = s3()
    table(f, 20, 40, z, Tz, "integers mod 6 under addition", lambda i, j, T: T[i][j] == 0)
    table(f, 400, 40, names, Ts, "symmetries of a triangle", lambda i, j, T: T[i][j] != T[j][i])
    f.text(20, 328, "shaded: the identity", "f-muted", 12)
    f.text(400, 328, "shaded: *ab* ≠ *ba*", "f-muted", 12)
    return f
