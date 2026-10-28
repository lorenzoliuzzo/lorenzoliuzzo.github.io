"""Share of corrupted patterns restored by a Hopfield network of 100 neurons as the load p/N grows; recall collapses near 0.14 (finite size smooths the drop)."""
import random
from kit import Fig

N, TRIALS, FLIPS = 100, 40, 10
LOADS = [0.02, 0.04, 0.06, 0.08, 0.10, 0.12, 0.14, 0.16, 0.18, 0.20, 0.24, 0.28]


def recall_rate(alpha, rng):
    p = max(1, round(alpha * N))
    ok = 0
    for _ in range(TRIALS):
        xi = [[rng.choice((-1, 1)) for _ in range(N)] for _ in range(p)]
        target = xi[0]
        s = target[:]
        for i in rng.sample(range(N), FLIPS):
            s[i] = -s[i]
        m = [sum(xi[mu][j] * s[j] for j in range(N)) for mu in range(p)]
        for _ in range(12):
            changed = False
            order = list(range(N))
            rng.shuffle(order)
            for i in order:
                h = sum(xi[mu][i] * m[mu] for mu in range(p)) - p * s[i]  # no self-coupling
                new = 1 if h > 0 else (-1 if h < 0 else s[i])
                if new != s[i]:
                    for mu in range(p):
                        m[mu] += 2 * new * xi[mu][i]
                    s[i] = new
                    changed = True
            if not changed:
                break
        overlap = sum(a * b for a, b in zip(s, target)) / N
        ok += overlap >= 0.95
    return ok / TRIALS


def build():
    rng = random.Random(5)
    rates = [recall_rate(a, rng) for a in LOADS]
    f = Fig(760, 290)
    ax = f.axes(56, 30, 520, 206, (0, 0.3), (0, 1.05))
    ax.frame(xticks=(0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3), yticks=(0, 0.5, 1), xlabel="load p / N", ylabel="share restored")
    f.poly([(ax.X(a), ax.Y(r)) for a, r in zip(LOADS, rates)], "f-a-line")
    for a, r in zip(LOADS, rates):
        ax.point(a, r, 4, "f-a-solid")
    ax.vline(0.138, cls="f-c-line f-dash")
    ax.text(0.143, 0.96, "α_c ≈ 0.138", "f-c", 12.5)
    f.text(600, 80, "N = 100 neurons, 40 trials", "f-muted", 12.5)
    f.text(600, 98, "per load, 10 bits flipped.", "f-muted", 12.5)
    f.text(600, 128, "Restored: final overlap", "f-muted", 12.5)
    f.text(600, 146, "with the pattern at least 0.95.", "f-muted", 12.5)
    return f
