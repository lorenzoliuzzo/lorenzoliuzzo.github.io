"""Autocorrelation of |m| for single-spin Metropolis on a 16x16 lattice at three temperatures."""
import random
from kit import Fig
from isingutil import TC, lattice, metropolis_sweep, abs_mag, autocorr

L, TMAX = 16, 150


def series(T, seed):
    rng = random.Random(seed)
    s = lattice(L, T < TC, rng)
    for _ in range(300):
        metropolis_sweep(s, T, rng)
    out = []
    for _ in range(12000):
        metropolis_sweep(s, T, rng)
        out.append(abs_mag(s))
    return out


def build():
    f = Fig(760, 290)
    ax = f.axes(56, 24, 520, 220, (0, TMAX), (-0.1, 1.0))
    ax.frame(xticks=range(0, TMAX + 1, 30), yticks=(0, 0.5, 1.0), xlabel="lag (sweeps)", ylabel=None)
    ent = []
    for T, cls, name in ((1.8, "f-c-line", "T = 1.8"), (TC, "f-b-line", "T = T_{c}"), (3.6, "f-a-line", "T = 3.6")):
        c = autocorr(series(T, 7), TMAX)
        f.poly([(ax.X(t), ax.Y(v)) for t, v in enumerate(c)], cls)
        ent.append((name, cls))
    f.legend(600, 50, ent)
    f.text(600, 130, "Single-spin updates,", "f-muted", 12.5)
    f.text(600, 148, "16 × 16 lattice, 12000", "f-muted", 12.5)
    f.text(600, 166, "sweeps per temperature.", "f-muted", 12.5)
    return f
