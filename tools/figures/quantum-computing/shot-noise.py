"""Shot noise: error of the estimate of <Z> = 0.6 from N shots. Dots are the root-mean-square error of 400 simulated experiments (seeded); the line is sqrt(1 - <Z>^2)/sqrt(N)."""
import math, random
from kit import Fig

Z = 0.6
NS = (10, 30, 100, 300, 1000, 3000)


def rms(n, reps=400, rng=random.Random(7)):
    p0 = (1 + Z) / 2
    tot = 0.0
    for _ in range(reps):
        k = sum(1 for _ in range(n) if rng.random() < p0)
        tot += (2 * k / n - 1 - Z) ** 2
    return math.sqrt(tot / reps)


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 20, 470, 232, (0.8, 3.7), (-2.0, 0.0))
    ax.frame(xticks=(1, 2, 3), yticks=(-2, -1, 0), xlabel="shots *N*", ylabel="error of ⟨*Z*⟩ estimate",
             xfmt=lambda v: f"{10 ** v:.0f}", yfmt=lambda v: f"{10 ** v:g}")
    ax.curve(lambda x: math.log10(math.sqrt(1 - Z * Z)) - 0.5 * x, 0.8, 3.7, cls="f-b-line")
    for n in NS:
        ax.point(math.log10(n), math.log10(rms(n)), cls="f-a-solid")
    f.legend(560, 50, [("0.8/√*N*", "f-b-line")])
    f.circle(570, 76, 4, "f-a-solid")
    f.text(590, 80, "simulation (400 runs)", "f-ink", 12.5)
    f.text(560, 120, "Each factor 100 in shots buys", "f-muted", 12.5)
    f.text(560, 138, "only a factor 10 in precision:", "f-muted", 12.5)
    f.text(560, 156, "shots, not amplitudes, set", "f-muted", 12.5)
    f.text(560, 174, "the cost of reading a circuit.", "f-muted", 12.5)
    return f
