"""Steps needed to reach the exit of a 4x4 grid per episode of tabular Q-learning, averaged over seeds."""
import random
from kit import Fig

N = 4
GOAL = (3, 3)
A = [(-1, 0), (1, 0), (0, -1), (0, 1)]


def run(seed, episodes=120, alpha=0.5, gamma=0.9, eps=0.1, cap=200):
    rng = random.Random(seed)
    Q = {((r, c), a): 0.0 for r in range(N) for c in range(N) for a in range(4)}
    out = []
    for _ in range(episodes):
        s = (0, 0)
        steps = 0
        while s != GOAL and steps < cap:
            if rng.random() < eps:
                a = rng.randrange(4)
            else:
                m = max(Q[(s, b)] for b in range(4))
                a = rng.choice([b for b in range(4) if Q[(s, b)] == m])
            r, c = s[0] + A[a][0], s[1] + A[a][1]
            s2 = (r, c) if 0 <= r < N and 0 <= c < N else s
            rew = 1.0 if s2 == GOAL else 0.0
            target = rew + (0.0 if s2 == GOAL else gamma * max(Q[(s2, b)] for b in range(4)))
            Q[(s, a)] += alpha * (target - Q[(s, a)])
            s = s2
            steps += 1
        out.append(steps)
    return out


def build():
    runs = [run(i) for i in range(40)]
    mean = [sum(r[e] for r in runs) / len(runs) for e in range(120)]
    f = Fig(760, 290)
    ax = f.axes(56, 24, 520, 220, (0, 120), (0, 100))
    ax.frame(xticks=range(0, 121, 20), yticks=(0, 25, 50, 75, 100), xlabel="episode", ylabel=None)
    f.poly([(ax.X(e), ax.Y(min(m, 100))) for e, m in enumerate(mean)], "f-a-line")
    ax.vline(0, 0, 0)
    f.line(ax.X(0), ax.Y(6), ax.X(120), ax.Y(6), "f-line f-dash")
    f.legend(600, 50, [("steps per episode", "f-a-line"), ("shortest path: 6", "f-line f-dash")])
    f.text(600, 130, "Mean of 40 seeds.", "f-muted", 12.5)
    f.text(600, 148, "ε = 0.1 keeps a few", "f-muted", 12.5)
    f.text(600, 166, "random moves, so the", "f-muted", 12.5)
    f.text(600, 184, "curve sits above 6.", "f-muted", 12.5)
    return f
