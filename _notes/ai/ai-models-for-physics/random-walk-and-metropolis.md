---
collection: notes
title: Random Walks and the Metropolis Algorithm
date: '2026-10-27'
excerpt: Random walks on graphs, and sampling the Boltzmann distribution of spins with Metropolis.
hook: Metropolis is a random walk whose acceptance rule is chosen so that the Boltzmann distribution is its stationary distribution.
goals:
- sample the Ising model with single-spin Metropolis
- measure autocorrelation time near the critical point
requires:
- markov-process
- stationary-distribution
- metropolis
- detailed-balance
- autocorrelation-time
- boltzmann-distribution
defines:
- id: random-walk
  name: random walk
  anchor: def-random-walk
- id: critical-slowing-down
  name: critical slowing down
  anchor: def-critical-slowing-down
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

A random walk is the simplest Markov chain. Metropolis turns it into a sampler for a chosen distribution by changing one thing: which moves it accepts.

# Random walks and their stationary law

> A **random walk** on a graph moves, at each step, to a neighbour chosen uniformly.
{: .definition #def-random-walk title="Random walk"}

Its stationary distribution is proportional to the degree of the node, $\pi_i = k_i/\sum_jk_j$, so a hub is visited more often than a leaf. Nothing in the walk refers to a target distribution: it samples whichever law its geometry produces. To sample a prescribed $\pi$, the walk needs a correction.

# Metropolis for the Ising model

The Metropolis rule keeps a symmetric proposal and accepts a move with probability $\min(1, \pi(\sigma')/\pi(\sigma))$. For the Boltzmann distribution that ratio is $e^{-\beta\Delta E}$, so the algorithm for a spin model is short: pick a spin, compute the energy change $\Delta E$ of flipping it from its neighbours, accept if $\Delta E\le 0$, otherwise accept with probability $e^{-\beta\Delta E}$. The rule satisfies detailed balance, $\pi(\sigma)P(\sigma\to\sigma') = \pi(\sigma')P(\sigma'\to\sigma)$, which is sufficient for $\pi$ to be stationary, and $Z$ never appears.

> Detailed balance is a sufficient condition and not a necessary one, but it is the one that is easy to verify and the reason Metropolis is correct for any energy function.
{: .rule}

Correct does not mean efficient. Successive configurations are correlated, and the number of effectively independent samples in a run of length $M$ is about $M/(2\tau_{\rm int})$, where $\tau_{\rm int}$ is the integrated autocorrelation time of the observable of interest.

# Critical slowing down

Single-spin updates change the magnetization by $2/N$ at a time. Away from the transition this is enough, because correlations are short. Near $T_c$ the correlation length $\xi$ grows and the chain must reshape clusters of size $\xi$ one spin at a time, so $\tau_{\rm int}\sim\xi^z$ with a **dynamic exponent** $z\approx2$ for local updates.

> This is **critical slowing down**: the sampler becomes slowest where the physics is most interesting.
{: .definition #def-critical-slowing-down title="Critical slowing down"}

{% include fig.html src="ai-models-for-physics/metropolis-autocorrelation" id="fig-metropolis-autocorrelation" alt="Autocorrelation of the absolute magnetization against sweeps for three temperatures; the curve at the critical temperature decays much more slowly." caption="Autocorrelation of $|m|$ for single-spin Metropolis on a $16\times16$ lattice. The decay time at $T_c$ is an order of magnitude longer than away from it." %}

The same slowing appears whenever a distribution has regions of high probability separated by regions of low probability, which local moves cross rarely: sampling a multimodal posterior is the machine-learning form of the problem.

> Reporting the standard error of a Monte Carlo average as $\sigma/\sqrt M$ treats correlated samples as independent. Near criticality the true error can be several times larger.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does Metropolis need no partition function?</summary>

The acceptance probability depends on the ratio $\pi(\sigma')/\pi(\sigma)$, in which the normalization cancels, and for a Boltzmann distribution the ratio is $e^{-\beta\Delta E}$.
</details>

<details class="qa" markdown="1">
<summary>Why is a long Metropolis run near $T_c$ less informative than the same run far from it?</summary>

The autocorrelation time grows as $\xi^z$ with $z\approx2$ for local updates, so the same number of sweeps contains far fewer independent configurations.
</details>
