"""Root-mean-square error of Monte Carlo estimates of the integral of exp(-10 x) on [0, 1] against the number of samples N (log-log), for uniform sampling and for importance sampling with density proportional to exp(-8 x). Both fall with slope -1/2; importance sampling is about ten times lower. 200 repeats per N, seeded."""
import math
import random
from kit import Fig

EXACT = (1 - math.exp(-10)) / 10
A = 8.0
Z = 1 - math.exp(-A)
NS = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000]


def uniform(rng, n):
    return sum(math.exp(-10 * rng.random()) for _ in range(n)) / n


def importance(rng, n):
    tot = 0.0
    for _ in range(n):
        x = -math.log(1 - rng.random() * Z) / A          # inverse CDF of p(x) = A e^{-A x} / Z
        tot += math.exp(-10 * x) / (A * math.exp(-A * x) / Z)
    return tot / n


def rms(method, n, rng, reps=200):
    return math.sqrt(sum((method(rng, n) - EXACT) ** 2 for _ in range(reps)) / reps)


def build():
    rng = random.Random(7)
    f = Fig(760, 300)
    ax = f.axes(70, 20, 480, 224, (1, 4), (-4.2, -0.5))
    ax.frame(xticks=(1, 2, 3, 4), yticks=(-4, -3, -2, -1), xlabel="samples *N*", ylabel="rms error",
             xfmt=lambda v: f"10^{{{int(v)}}}", yfmt=lambda v: f"10^{{{int(v)}}}")
    for method, cls in ((uniform, "f-b-line"), (importance, "f-a-line")):
        pts = [(math.log10(n), math.log10(rms(method, n, rng))) for n in NS]
        for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
            ax.fig.line(ax.X(x0), ax.Y(y0), ax.X(x1), ax.Y(y1), cls)
        for x, y in pts:
            ax.point(x, y, 3, cls.replace("-line", "-solid"))
    ax.fig.line(ax.X(1), ax.Y(-0.5 - 0.7), ax.X(4), ax.Y(-0.5 - 0.7 - 1.5), "f-line f-dash")
    f.legend(590, 70, [("uniform", "f-b-line"), ("importance", "f-a-line"), ("slope −1/2", "f-line f-dash")])
    f.text(590, 150, "Same slope, lower line:", "f-muted", 12.5)
    f.text(590, 168, "a better density shrinks", "f-muted", 12.5)
    f.text(590, 186, "the constant, not the rate.", "f-muted", 12.5)
    return f
