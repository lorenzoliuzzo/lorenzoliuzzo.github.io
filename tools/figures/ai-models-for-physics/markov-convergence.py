"""Distribution of a three-state Markov chain against the number of steps, with its stationary values and the |lambda_2|^n envelope."""
import math
from kit import Fig

P = [[0.6, 0.3, 0.1], [0.2, 0.5, 0.3], [0.1, 0.4, 0.5]]


def step(mu):
    return [sum(mu[i] * P[i][j] for i in range(3)) for j in range(3)]


def build():
    mu = [1.0, 0.0, 0.0]
    hist = [mu]
    for _ in range(14):
        mu = step(mu)
        hist.append(mu)
    pi = hist[-1]
    for _ in range(200):
        pi = step(pi)
    # |lambda_2| from the late geometric decay of the distance to pi
    dist = [max(abs(m[i] - pi[i]) for i in range(3)) for m in hist]
    lam = dist[12] / dist[11]
    f = Fig(760, 290)
    ax = f.axes(56, 24, 520, 220, (0, 14), (0, 1.0))
    ax.frame(xticks=range(0, 15, 2), yticks=(0, 0.25, 0.5, 0.75, 1.0), xlabel="steps n", ylabel=None)
    cols = ("a", "b", "c")
    for i in range(3):
        ax.vline(0, 0, 0)
        f.poly([(ax.X(n), ax.Y(hist[n][i])) for n in range(15)], f"f-{cols[i]}-line")
        f.line(ax.X(0), ax.Y(pi[i]), ax.X(14), ax.Y(pi[i]), f"f-{cols[i]}-line f-dash")
    f.poly([(ax.X(n), ax.Y(dist[0] * lam ** n)) for n in range(15)], "f-line f-dash")
    f.legend(600, 50, [("state 1", "f-a-line"), ("state 2", "f-b-line"), ("state 3", "f-c-line"), ("distance to π", "f-line f-dash")])
    f.text(600, 150, f"Decay factor per step: {lam:.2f}.", "f-muted", 12.5)
    f.text(600, 168, "The second eigenvalue", "f-muted", 12.5)
    f.text(600, 186, "of P sets it.", "f-muted", 12.5)
    return f
