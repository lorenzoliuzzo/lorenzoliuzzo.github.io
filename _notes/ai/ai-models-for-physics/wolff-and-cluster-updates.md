---
collection: notes
title: Cluster Updates and Critical Slowing Down
date: '2026-10-27'
excerpt: Why single-spin updates slow down at criticality and how cluster moves recover speed.
hook: Near the critical point correlated regions are large, and an update rule that moves a whole correlated cluster beats one that moves a single spin.
goals:
- describe the Wolff cluster update and say why it is always accepted
- measure the dynamic exponent of two samplers from autocorrelation times
- explain why cluster moves help near a critical point
requires:
- random-walk
- critical-slowing-down
- ising-model
defines:
- id: wolff-algorithm
  name: Wolff algorithm
  anchor: def-wolff-algorithm
- id: dynamic-exponent
  name: dynamic exponent
  anchor: measuring-the-dynamic-exponent
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

Near the critical point correlated regions are large, and a single spin flip inside one costs energy at its boundary and changes little. A sampler that moves the whole region at once avoids this, provided it can do so without breaking detailed balance.

# A cluster instead of a spin

> The **Wolff algorithm** {% cite wolff-1989 %} builds a cluster of aligned spins and flips it as a unit.
{: .definition #def-wolff-algorithm title="Wolff algorithm"}

Pick a random seed spin. Visit each neighbour; if it is parallel to the seed, add it to the cluster with probability $p = 1 - e^{-2\beta J}$, and continue from every added spin. When no new spin can be added, flip the whole cluster.

The probability $p$ is chosen so that the ratio of the probability of building a given cluster in the old state and in the new one is exactly the inverse of the Boltzmann ratio, since only the bonds on the cluster boundary differ. The acceptance probability is then identically 1, and every proposed move is taken. At low temperature $p\to1$ and the cluster is a whole domain; at high temperature $p\to0$ and it is a single spin.

> The cluster size follows the physics. It is large when correlations are, which is the situation in which single-spin moves are slow, and small when they are not.
{: .idea}

# Measuring the dynamic exponent

To compare samplers the time unit has to be common. One Metropolis sweep updates every spin once. A Wolff step flips a cluster of mean size $\bar c$, so the cost of one step in sweeps is $\bar c/L^2$. The figure uses this scaling on $L = 4$ to $16$ at $T_c$ and fits $\tau_{\rm int}\propto L^z$ for the magnetization $|m|$.

{% include fig.html src="ai-models-for-physics/wolff-scaling" id="fig-wolff-scaling" alt="Log-log plot of autocorrelation time against lattice size from 4 to 16: the Metropolis curve rises steeply and the Wolff curve is almost flat." caption="Integrated autocorrelation time of $|m|$ at $T_c$. Metropolis grows by a factor of 15 between $L=4$ and $L=16$; Wolff by about 1.6. The fitted exponents come from five small lattices and are only indicative." %}

The Metropolis exponent is near 2, in agreement with the value for local updates quoted in the previous note, and the Wolff exponent is a few tenths. The practical consequence is that the gap between the two grows with the lattice: at $L=16$ a cluster step costs a fraction of a sweep and produces nearly independent samples of $|m|$ every few steps.

# What transfers to machine learning

A sampler pays for rare transitions between modes of the target. Cluster moves are a case of designing the proposal around the structure of the distribution, and the same idea underlies parallel tempering, where copies at several temperatures exchange states so that a high-temperature copy carries the chain over barriers. The method is specific to models whose structure allows a cluster rule, spin models with ferromagnetic couplings above all; it does not apply as stated to a frustrated model such as a Hopfield network above its capacity.

> A cluster algorithm removes critical slowing down for the Ising model. It says nothing about how well the same model is sampled once a field or frustration is added, where clusters lose their meaning.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why can the Wolff update always be accepted?</summary>

The bond probability $1-e^{-2\beta J}$ makes the probability of building a cluster in the old configuration and in the new one compensate the Boltzmann ratio, so detailed balance holds with an acceptance of 1.
</details>

<details class="qa" markdown="1">
<summary>Why is the Wolff update better than single-spin Metropolis exactly near $T_c$?</summary>

Correlated regions there are large, and flipping one spin changes a boundary but not the region. A cluster move changes the region as a whole, so successive configurations decorrelate in far fewer steps.
</details>
