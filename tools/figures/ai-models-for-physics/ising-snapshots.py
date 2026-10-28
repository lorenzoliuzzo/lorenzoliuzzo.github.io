"""Equilibrium samples of a 24x24 Ising lattice below, at and above the critical temperature."""
import random
from kit import Fig
from isingutil import TC, lattice, metropolis_sweep

L = 24


def sample(T, up, seed):
    rng = random.Random(seed)
    s = lattice(L, up, rng)
    for _ in range(400):
        metropolis_sweep(s, T, rng)
    return s


def build():
    f = Fig(760, 270)
    panels = [(1.8, True, 1, "below: T = 1.8"), (TC, False, 5, "at: T = 2.27 (T_{c})"), (3.6, False, 2, "above: T = 3.6")]
    cell = 8
    for k, (T, up, seed, title) in enumerate(panels):
        x0 = 24 + k * 248
        s = sample(T, up, seed)
        f.text(x0, 22, title, "f-ink", 13.5, weight=600)
        for i in range(L):
            j = 0
            while j < L:
                v = s[i][j]
                k2 = j
                while k2 < L and s[i][k2] == v:
                    k2 += 1
                f.rect(x0 + j * cell, 34 + i * cell, (k2 - j) * cell, cell, "f-a-solid" if v > 0 else "f-b-solid")
                j = k2
        for a,b,c,d in ((x0,34,x0+L*cell,34),(x0,34+L*cell,x0+L*cell,34+L*cell),(x0,34,x0,34+L*cell),(x0+L*cell,34,x0+L*cell,34+L*cell)):
            f.line(a,b,c,d,"f-line")
    return f
