---
collection: notes
title: The Ising-Lenz Model
date: '2026-10-27'
excerpt: Spins on a lattice, the energy function, the ordered and disordered phases and the order parameter.
hook: Binary spins with a nearest-neighbour coupling are the smallest model that has a phase transition, and the same energy function reappears later as a neural network.
goals:
- write the energy of a spin configuration
- describe the ordered and disordered phases through the magnetisation
defines:
- id: ising-model
  name: Ising model
  anchor: def-ising-model
- id: spin-configuration
  name: spin configuration
  anchor: def-spin-configuration
- id: order-parameter
  name: order parameter
  anchor: def-order-parameter
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

The simplest model of a magnet is a lattice of arrows that can point up or down. Lenz proposed it as a thesis problem {% cite lenz-1920 %} and Ising solved the one-dimensional case {% cite ising-1925 %}. The same energy function comes back later in this course as a neural network.

# The energy of a configuration

> A **spin configuration** assigns $\sigma_i = \pm 1$ to each site $i$ of a lattice.
{: .definition #def-spin-configuration title="Spin configuration"}

> The **Ising model** gives a spin configuration the energy $E(\sigma)$ below, with a coupling $J$ between neighbouring spins and a field $h$.
{: .definition #def-ising-model title="Ising model"}

$$ E(\sigma) = -J\sum_{\langle ij\rangle}\sigma_i\sigma_j - h\sum_i\sigma_i, $$

where the first sum runs over nearest-neighbour pairs. For $J>0$ a pair of parallel spins lowers the energy, so the ground state has all spins aligned, and the field $h$ favours one sign. The model is deliberately crude: spins have no dynamics of their own, and all the physics is in which configurations are cheap.

> The model is a function from $2^N$ configurations to energies. Every question about it, from magnetization to phase transitions, is a question about that table and how it is weighted at a given temperature.
{: .idea}

# The order parameter and the transition

At temperature $T$ the system visits configurations with a probability that favours low energy, the weighting made precise in the next note.

> The useful summary is the **order parameter**, the magnetization per site $m = \frac1N\sum_i\sigma_i$.
{: .definition #def-order-parameter title="Order parameter"}

Aligned neighbours want a large $|m|$ and thermal noise wants $m\approx 0$, and which wins depends on the dimension of the lattice.

In one dimension there is no transition at any $T>0$: a single misaligned domain costs a fixed energy $2J$ but can sit anywhere on the chain, so entropy always wins {% cite ising-1925 %}. In two dimensions a domain wall costs energy proportional to its length, which grows with the domain, and the ordered phase survives up to the critical temperature found by Onsager, $k_BT_c = 2J/\ln(1+\sqrt2)\approx 2.269\,J$ {% cite onsager-1944 %}.

{% include fig.html src="ai-models-for-physics/ising-snapshots" id="fig-ising-snapshots" alt="Three square lattices of black and white cells at three temperatures: one almost all black, one with large clusters of both colours, one a fine salt-and-pepper mixture." caption="Equilibrium samples of a $24\times24$ lattice below, at and above $T_c$. Below, one orientation fills the lattice; at $T_c$ clusters of every size appear; above, correlations die within a few sites." %}

At $T_c$ the clusters have no characteristic size, and this scale-free structure is the reason that algorithms for sampling the model slow down there, which the later notes return to. The 2D result also needs a symmetry-breaking field to select a sign: with $h=0$ the energy is invariant under flipping all spins, so each sign of $m$ is equally likely and $\langle m\rangle = 0$ on a finite lattice. The quantity that distinguishes the phases is then $\langle|m|\rangle$.

{% capture t %}
| Lattice | Transition at $T>0$ | $k_BT_c/J$ |
|---|---|---:|
| Chain ($d=1$) | none | n/a |
| Square ($d=2$) | yes, exact solution | $2.269$ |
| Cubic ($d=3$) | yes, numerical | about $4.51$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-ising-tc" caption="Critical temperature of the nearest-neighbour Ising model by dimension." body=t %}

> A finite lattice never has a sharp transition. The curve of $\langle|m|\rangle$ against $T$ is rounded, and it sharpens as the lattice grows.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does the one-dimensional Ising chain have no ordered phase at finite temperature?</summary>

A domain wall costs a fixed energy but can be placed at any of the $N$ bonds, so the free-energy gain from entropy, proportional to $\ln N$, beats the fixed cost for any $T>0$ and breaks the order apart.
</details>

<details class="qa" markdown="1">
<summary>Why is $\langle|m|\rangle$ used and not $\langle m\rangle$ to detect order at $h=0$?</summary>

Flipping every spin leaves the energy unchanged, so up and down orderings are equally probable and the signed average vanishes on a finite lattice even in the ordered phase.
</details>
