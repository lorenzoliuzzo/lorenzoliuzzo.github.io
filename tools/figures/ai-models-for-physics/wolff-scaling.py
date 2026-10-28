"""Integrated autocorrelation time of |m| at T_c against lattice size: single-spin Metropolis and Wolff clusters (stdlib, small lattices)."""
import math
import random
from kit import Fig
from isingutil import TC, lattice, metropolis_sweep, wolff_step, abs_mag, autocorr

SIZES = (4, 6, 8, 12, 16)


def tau_int(series):
    n = len(series)
    c = autocorr(series, min(n // 20, 400))
    tau = 0.5
    for t in range(1, len(c)):
        tau += c[t]
        if t >= 6 * tau:
            break
    return tau


def run_metropolis(L, rng):
    s = lattice(L, False, rng)
    for _ in range(300):
        metropolis_sweep(s, TC, rng)
    out = []
    for _ in range(15000):
        metropolis_sweep(s, TC, rng)
        out.append(abs_mag(s))
    return tau_int(out)


def run_wolff(L, rng):
    s = lattice(L, False, rng)
    for _ in range(300):
        wolff_step(s, TC, rng)
    out, sizes = [], 0
    n = 20000
    for _ in range(n):
        sizes += wolff_step(s, TC, rng)
        out.append(abs_mag(s))
    return tau_int(out) * (sizes / n) / (L * L)


def slope(xs, ys):
    lx = [math.log(x) for x in xs]
    ly = [math.log(y) for y in ys]
    mx, my = sum(lx) / len(lx), sum(ly) / len(ly)
    return sum((a - mx) * (b - my) for a, b in zip(lx, ly)) / sum((a - mx) ** 2 for a in lx)


def build():
    rng = random.Random(11)
    tm = [run_metropolis(L, rng) for L in SIZES]
    tw = [run_wolff(L, rng) for L in SIZES]
    zm, zw = slope(SIZES, tm), slope(SIZES, tw)
    print("metropolis", [round(t, 2) for t in tm], "z =", round(zm, 2))
    print("wolff", [round(t, 3) for t in tw], "z =", round(zw, 2))
    f = Fig(760, 300)
    lo, hi = -1.5, 2.0
    ax = f.axes(56, 20, 520, 230, (math.log10(3.5), math.log10(19)), (lo, hi))
    ax.frame(xticks=[math.log10(x) for x in SIZES], yticks=(-1, 0, 1, 2), xlabel="lattice size L", ylabel=None, xfmt=lambda v: f"{10 ** v:.0f}", yfmt=lambda v: f"10^{{{int(v)}}}")
    for ys, cls in ((tm, "f-b"), (tw, "f-a")):
        pts = [(ax.X(math.log10(L)), ax.Y(math.log10(y))) for L, y in zip(SIZES, ys)]
        f.poly(pts, cls + "-line")
        for x, y in pts:
            f.circle(x, y, 4, cls + "-solid")
    f.legend(600, 50, [(f"Metropolis, z ≈ {zm:.1f}", "f-b-line"), (f"Wolff, z ≈ {zw:.1f}", "f-a-line")])
    f.text(600, 130, "Time in sweeps (Wolff: cluster", "f-muted", 12.5)
    f.text(600, 148, "flips scaled to sweeps). Slopes", "f-muted", 12.5)
    f.text(600, 166, "are fits to five small lattices.", "f-muted", 12.5)
    return f
