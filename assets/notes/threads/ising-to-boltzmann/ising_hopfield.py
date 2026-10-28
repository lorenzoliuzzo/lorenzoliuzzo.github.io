"""Companion code for the thread "From Spins to Memories" (/threads/ising-to-boltzmann/).

Two experiments with the same energy function:

  1. A 2D Ising model sampled by Metropolis updates: the magnetisation drops to zero as
     the temperature passes the exact critical value T_c = 2 / ln(1 + sqrt(2)) (units of J/k).
  2. A Hopfield network with Hebbian weights: how often a corrupted pattern is repaired
     as the number of stored patterns P grows relative to the number of neurons N.

Run it:           python ising_hopfield.py
Check the claims: python ising_hopfield.py --test
Needs only numpy. Written to be read top to bottom; the "# %%" lines split it into cells
for Jupyter, VS Code and Colab.
"""
import sys

import numpy as np

# %% 1. The Ising model -------------------------------------------------------------------

T_C = 2.0 / np.log(1.0 + np.sqrt(2.0))  # exact, Onsager; J = k = 1


def ising_energy(spins):
    """E = -J * sum over nearest-neighbour pairs of s_i s_j, periodic boundaries, J = 1."""
    return -float(np.sum(spins * np.roll(spins, 1, axis=0)) + np.sum(spins * np.roll(spins, 1, axis=1)))


def metropolis_sweep(spins, T, rng):
    """One sweep: L*L single-spin flip proposals, accepted with min(1, exp(-dE / T))."""
    L = spins.shape[0]
    for _ in range(L * L):
        i, j = rng.integers(L, size=2)
        neighbours = (spins[(i + 1) % L, j] + spins[(i - 1) % L, j]
                      + spins[i, (j + 1) % L] + spins[i, (j - 1) % L])
        dE = 2.0 * spins[i, j] * neighbours
        if dE <= 0 or rng.random() < np.exp(-dE / T):
            spins[i, j] *= -1


def magnetisation_at(T, L=16, sweeps=400, burn=200, seed=0):
    """Mean |m| per spin after equilibrating from the all-up state."""
    rng = np.random.default_rng(seed)
    spins = np.ones((L, L), dtype=int)
    values = []
    for sweep in range(sweeps):
        metropolis_sweep(spins, T, rng)
        if sweep >= burn:
            values.append(abs(spins.mean()))
    return float(np.mean(values))


# %% 2. The Hopfield network ---------------------------------------------------------------


def hebbian_weights(patterns):
    """w_ij = (1/N) sum_mu xi_i^mu xi_j^mu with zero diagonal; patterns is P x N of +-1."""
    N = patterns.shape[1]
    w = patterns.T @ patterns / N
    np.fill_diagonal(w, 0.0)
    return w


def hopfield_energy(w, s):
    return -0.5 * float(s @ w @ s)


def relax(w, s, rng, max_sweeps=50):
    """Asynchronous updates s_i <- sign(sum_j w_ij s_j) until nothing changes."""
    s = s.copy()
    for _ in range(max_sweeps):
        changed = False
        for i in rng.permutation(len(s)):
            new = 1 if w[i] @ s >= 0 else -1
            if new != s[i]:
                s[i] = new
                changed = True
        if not changed:
            break
    return s


def recall_rate(N=200, alpha=0.05, noise=0.1, trials=20, seed=0):
    """Fraction of trials in which a stored pattern, with `noise` of its bits flipped, is
    restored to within 2% of its bits. alpha = P / N."""
    rng = np.random.default_rng(seed)
    P = max(1, int(round(alpha * N)))
    hits = 0
    for _ in range(trials):
        patterns = rng.choice([-1, 1], size=(P, N))
        w = hebbian_weights(patterns)
        target = patterns[0]
        probe = target.copy()
        flip = rng.choice(N, size=int(noise * N), replace=False)
        probe[flip] *= -1
        out = relax(w, probe, rng)
        hits += np.mean(out != target) <= 0.02
    return hits / trials


# %% Checks ---------------------------------------------------------------------------------


def test():
    rng = np.random.default_rng(1)

    # Hopfield: with symmetric weights and zero diagonal, an asynchronous update never
    # raises the energy.
    N = 60
    w = hebbian_weights(rng.choice([-1, 1], size=(5, N)))
    s = rng.choice([-1, 1], size=N)
    e = hopfield_energy(w, s)
    for i in rng.permutation(N).tolist() * 3:
        s[i] = 1 if w[i] @ s >= 0 else -1
        e_new = hopfield_energy(w, s)
        assert e_new <= e + 1e-9, "energy rose"
        e = e_new

    # Hopfield: recall is reliable well below ~0.14 N patterns and fails well above it.
    low, high = recall_rate(alpha=0.05), recall_rate(alpha=0.30)
    assert low >= 0.9, f"expected reliable recall at alpha=0.05, got {low}"
    assert high <= 0.3, f"expected recall to fail at alpha=0.30, got {high}"

    # Ising: ordered well below T_c, disordered well above it (small lattice, so loose bounds).
    cold, hot = magnetisation_at(0.6 * T_C), magnetisation_at(1.6 * T_C)
    assert cold > 0.85, f"expected order at 0.6 T_c, got {cold}"
    assert hot < 0.35, f"expected disorder at 1.6 T_c, got {hot}"
    print(f"ok  |m|(0.6 Tc)={cold:.2f}  |m|(1.6 Tc)={hot:.2f}  recall(0.05)={low:.2f}  recall(0.30)={high:.2f}")


if __name__ == "__main__":
    if "--test" in sys.argv:
        test()
    else:
        print(f"T_c = {T_C:.4f}")
        for t in (0.6, 0.9, 1.0, 1.1, 1.6):
            print(f"T = {t:.1f} T_c   |m| = {magnetisation_at(t * T_C):.2f}")
        for a in (0.02, 0.05, 0.10, 0.14, 0.20, 0.30):
            print(f"alpha = {a:.2f}   recall = {recall_rate(alpha=a):.2f}")
