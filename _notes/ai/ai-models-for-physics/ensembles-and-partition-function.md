---
collection: notes
title: Ensembles and the Partition Function
date: '2026-10-27'
excerpt: Microcanonical and canonical ensembles, the Boltzmann distribution and free energy for spin systems.
hook: Fixing the temperature instead of the energy turns the uniform distribution on a shell into the Boltzmann distribution, and all the thermodynamics sits in one sum, the partition function.
goals:
- derive the Boltzmann distribution from the microcanonical one
- compute a partition function by enumeration for small N
requires:
- ising-model
- free-energy
defines:
- id: boltzmann-distribution
  name: Boltzmann distribution
  anchor: def-boltzmann-distribution
- id: partition-function
  name: partition function
  anchor: def-partition-function
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

Thermodynamics asks for averages over configurations. This note derives the weights from one assumption about an isolated system, and shows that a single sum, the partition function, holds all of them.

# From the microcanonical to the canonical ensemble

An isolated system with fixed energy $E$ is described by the **microcanonical ensemble**: all accessible microstates are equally likely, and their number is the density of states $\Omega(E)$. A system in contact with a much larger reservoir is not isolated. Let the pair have total energy $E_{\rm tot}$ and the system be in a specific microstate with energy $E$. The reservoir then has energy $E_{\rm tot}-E$, and the probability of that microstate is proportional to the number of reservoir microstates, $\Omega_R(E_{\rm tot}-E)$. Because the reservoir is large, expanding $\ln\Omega_R$ to first order in $E$ gives

$$ P(\sigma) = \frac{e^{-\beta E(\sigma)}}{Z}, \qquad \beta = \frac{1}{k_BT}, $$

> The **Boltzmann distribution** of a system in contact with a reservoir at temperature $T$ gives the microstate $\sigma$ the probability $P(\sigma)=e^{-\beta E(\sigma)}/Z$, with $\beta=1/k_BT$.
{: .definition #def-boltzmann-distribution title="Boltzmann distribution"}

The temperature is the derivative of the reservoir entropy with respect to energy, $\beta = \partial\ln\Omega_R/\partial E$, which is how a number enters the formula without any property of the system other than its energy function.

> Low-energy configurations are favoured by the factor $e^{-\beta E}$, and the number of configurations at each energy competes with it. The temperature sets the exchange rate between the two.
{: .idea}

# The partition function

> The normalization $Z = \sum_\sigma e^{-\beta E(\sigma)}$ is the **partition function**.
{: .definition #def-partition-function title="Partition function"}

It is more than a normalizer: averages are derivatives of $\ln Z$, for example

$$ \langle E\rangle = -\frac{\partial\ln Z}{\partial\beta}, \qquad F = -k_BT\ln Z, $$

with $F$ the free energy defined in thermodynamics. A phase transition is a non-analyticity of $\ln Z$ per site in the limit of an infinite lattice. For a few spins $Z$ is a finite sum that can be enumerated, which gives a ground truth for sampling methods, and for $N$ spins it has $2^N$ terms, which is the reason sampling methods exist.

{% include fig.html src="ai-models-for-physics/boltzmann-levels" id="fig-boltzmann-levels" alt="Three bar charts of the probability of each energy level of a four-spin chain at low, medium and high temperature." caption="Probability of each energy level of an open chain of four Ising spins with $J=1$. At low $T$ almost all weight is on the aligned states; at high $T$ the weight follows the degeneracy of each level." %}

The figure shows the competition: at $T=3$ the middle levels dominate because there are more configurations there, although each is individually less likely than an aligned one.

# Why the sum is the problem

Every computation in the following notes is a way around the sum. Mean-field theory replaces $P$ by a product distribution and minimizes a bound on $F$. Markov chain Monte Carlo draws configurations from $P$ without computing $Z$, using only ratios $e^{-\beta\Delta E}$, in which $Z$ cancels. Learning in an energy-based model is the same problem in reverse: its gradient contains an average over $P$, which is the term that sampling approximates.

> The ratio $P(\sigma')/P(\sigma) = e^{-\beta[E(\sigma')-E(\sigma)]}$ is available even when $Z$ is not. Any algorithm that uses only such ratios can sample the distribution it cannot normalize.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why does the Boltzmann factor appear for a system coupled to a reservoir?</summary>

The probability of a system microstate is proportional to the number of reservoir states left over, and for a large reservoir the logarithm of that number is linear in the energy given to the system, which produces $e^{-\beta E}$.
</details>

<details class="qa" markdown="1">
<summary>How can the mean energy be obtained from $Z$ without enumerating states again?</summary>

$\langle E\rangle = -\partial\ln Z/\partial\beta$, since differentiating $Z$ with respect to $\beta$ brings down a factor $-E$ in each term.
</details>
