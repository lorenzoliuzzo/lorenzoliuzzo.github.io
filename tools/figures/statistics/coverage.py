"""Twenty 95% intervals for a mean: about one in twenty misses the truth."""
import math
import random
from kit import Fig


def build():
    n, T = 10, 2.262  # t critical value, 9 df
    for seed in range(500):  # a seed that shows the typical case: exactly one miss
        rng = random.Random(seed)
        rows = []
        for _ in range(20):
            xs = [rng.gauss(0, 1) for _ in range(n)]
            m = sum(xs) / n
            s = math.sqrt(sum((x - m) ** 2 for x in xs) / (n - 1))
            h = T * s / math.sqrt(n)
            rows.append((m, h))
        misses = sum(1 for m, h in rows if abs(m) > h)
        if misses == 1:
            break
    f = Fig(760, 330)
    ax = f.axes(60, 14, 480, 270, (-1.7, 1.7), (0, 21))
    ax.frame(xticks=(-1.5, -1, -0.5, 0, 0.5, 1, 1.5), yticks=(), xlabel="interval for the mean (true mean = 0)", grid=False, yaxis=False)
    ax.vline(0, 0, 21, "f-c-line")
    for i, (m, h) in enumerate(rows):
        y = 20 - i
        hit = abs(m) <= h
        cls = "f-a-line" if hit else "f-b-line"
        f.line(ax.X(m - h), ax.Y(y), ax.X(m + h), ax.Y(y), cls)
        f.circle(ax.X(m), ax.Y(y), 3, "f-a-solid" if hit else "f-b-solid")
    f.text(580, 62, "20 samples of size 10", "f-ink", 13, weight=600)
    f.text(580, 84, "Green: the true mean.", "f-c", 12.5)
    f.text(580, 104, "Blue: interval covers it.", "f-a", 12.5)
    f.text(580, 124, "Orange: interval misses.", "f-b", 12.5)
    f.text(580, 162, "The 95% describes the", "f-muted", 12.5)
    f.text(580, 179, "procedure, not any one", "f-muted", 12.5)
    f.text(580, 196, "interval.", "f-muted", 12.5)
    return f
