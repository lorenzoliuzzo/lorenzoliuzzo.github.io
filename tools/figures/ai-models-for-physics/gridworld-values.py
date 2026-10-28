"""Optimal values of a 4x4 grid with one rewarding exit, and the geometric error of value iteration."""
from kit import Fig

N = 4
G = 0.9
GOAL = (3, 3)
MOVES = {"u": (-1, 0), "d": (1, 0), "l": (0, -1), "r": (0, 1)}


def nxt(s, a):
    r, c = s[0] + MOVES[a][0], s[1] + MOVES[a][1]
    return (r, c) if 0 <= r < N and 0 <= c < N else s


def sweep(V):
    W = {}
    for r in range(N):
        for c in range(N):
            s = (r, c)
            if s == GOAL:
                W[s] = 0.0
                continue
            W[s] = max((1.0 if nxt(s, a) == GOAL else 0.0) + G * V[nxt(s, a)] for a in MOVES)
    return W


def build():
    V = {(r, c): 0.0 for r in range(N) for c in range(N)}
    hist = [V]
    for _ in range(14):
        V = sweep(V)
        hist.append(V)
    star = hist[-1]
    err = [max(abs(h[s] - star[s]) for s in star) for h in hist]
    f = Fig(760, 300)
    x0, y0, cell = 40, 30, 58
    for r in range(N):
        for c in range(N):
            s = (r, c)
            x, y = x0 + c * cell, y0 + r * cell
            f.rect(x, y, cell, cell, "f-a-fill f-line" if s == GOAL else "f-line")
            if s == GOAL:
                f.text(x + cell / 2, y + cell / 2 + 5, "exit", "f-ink", 13, "middle")
                continue
            f.text(x + cell / 2, y + 24, f"{star[s]:.2f}", "f-ink", 13, "middle")
            best = [a for a in MOVES if (1.0 if nxt(s, a) == GOAL else 0.0) + G * star[nxt(s, a)] >= max((1.0 if nxt(s, b) == GOAL else 0.0) + G * star[nxt(s, b)] for b in MOVES) - 1e-9]
            glyph = {"u": "↑", "d": "↓", "l": "←", "r": "→"}
            f.text(x + cell / 2, y + 46, "".join(glyph[a] for a in best), "f-muted", 13, "middle")
    ax = f.axes(340, 30, 360, 220, (0, 14), (0, max(err)))
    ax.frame(xticks=range(0, 15, 2), yticks=(0, 0.25, 0.5, 0.75, 1.0), xlabel="sweeps k", ylabel=None)
    f.poly([(ax.X(k), ax.Y(err[k])) for k in range(15)], "f-a-line")
    f.poly([(ax.X(k), ax.Y(G ** k)) for k in range(15)], "f-line f-dash")
    f.legend(520, 60, [("max error of V_k", "f-a-line"), ("bound γᵏ", "f-line f-dash")])
    return f
