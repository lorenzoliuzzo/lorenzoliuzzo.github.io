---
collection: notes
title: Ensembles from Maximum Entropy
date: '2026-10-27'
excerpt: The microcanonical, canonical and grand canonical ensembles as maximum entropy distributions under three different sets of constraints.
hook: 'An ensemble is the answer to the question of what an experimenter controls: fix the energy, the mean energy or the mean energy and particle number, and maximum entropy gives the probabilities.'
goals:
- derive the canonical distribution from maximum entropy with a fixed mean energy
- identify the multiplier with the inverse temperature
- write the grand canonical distribution and its partition function
requires:
- maximum-entropy-principle
- shannon-entropy
- boltzmann-distribution
- partition-function
- free-energy
defines:
- id: canonical-ensemble
  name: canonical ensemble
  anchor: def-canonical-ensemble
- id: grand-canonical-ensemble
  name: grand canonical ensemble
  anchor: def-grand-canonical-ensemble
- id: chemical-potential
  name: chemical potential
  anchor: def-chemical-potential
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The probability of a microstate depends on what the experimenter holds fixed. Maximum entropy turns each choice of constraints into an ensemble with one derivation {% cite jaynes-1957 %}, and the result agrees with the route through a reservoir taken in the course on AI models for physics.

# Fixed energy: the microcanonical ensemble

An isolated system has a fixed energy $E$, so only the microstates of that energy are allowed, and their number is $\Omega(E)$. There is no other constraint, so maximum entropy gives the uniform distribution on that shell, $p_i=1/\Omega(E)$. The entropy is $S=k\ln\Omega(E)$, and the temperature follows from $1/T=\partial S/\partial E$.

# Fixed mean energy: the canonical ensemble

A system in contact with a large reservoir exchanges energy with it, so its energy fluctuates and only the mean $\langle E\rangle=U$ is fixed. Maximise $S=-k\sum_ip_i\ln p_i$ subject to $\sum_ip_i=1$ and $\sum_ip_iE_i=U$. Following the previous note, the stationary distribution is exponential in the constrained quantity,

$$ p_i=\frac{e^{-\beta E_i}}{Z},\qquad Z=\sum_ie^{-\beta E_i}, $$

> The **canonical ensemble** is the distribution $p_i=e^{-\beta E_i}/Z$, with $Z=\sum_ie^{-\beta E_i}$, that maximises the entropy at a fixed mean energy.
{: .definition #def-canonical-ensemble title="Canonical ensemble"}

The multiplier $\beta$ is fixed by $U=-\partial\ln Z/\partial\beta$. To identify it, evaluate the entropy on this distribution: $S=k\beta U+k\ln Z$. Differentiating at fixed energy levels and using $\partial\ln Z/\partial\beta=-U$ gives $\partial S/\partial U=k\beta$. Comparing with the thermodynamic definition $\partial S/\partial U=1/T$ gives $\beta=1/(kT)$. The free energy $F=-kT\ln Z$ then satisfies $F=U-TS$.

> The temperature is the multiplier that enforces a mean energy. It becomes a property of the reservoir only when the constraint is read as contact with one.
{: .idea}

# Fixed mean energy and particle number: the grand canonical ensemble

When particles can also be exchanged, the particle number $N$ becomes a random variable and only its mean is fixed. A second multiplier appears for it. Writing it as $-\beta\mu$, the stationary distribution for a state with energy $E_i$ and $N_i$ particles is

$$ p_i=\frac{e^{-\beta(E_i-\mu N_i)}}{\Xi},\qquad \Xi=\sum_ie^{-\beta(E_i-\mu N_i)}. $$

> This is the **grand canonical ensemble**, and $\Xi$ is its partition function.
{: .definition #def-grand-canonical-ensemble title="Grand canonical ensemble"}

> The multiplier $\mu$ is the **chemical potential**: by the same argument as for $\beta$, $\mu=-T\,\partial S/\partial N$ at fixed energy and volume, the energy cost, per unit temperature, of adding a particle.
{: .definition #def-chemical-potential title="Chemical potential"}

The grand potential $\Phi=-kT\ln\Xi$ equals $F-\mu N$ evaluated at the mean particle number.

{% capture t %}
| Ensemble | Fixed | Fluctuates | Weight | Potential |
|---|---|---|---|---|
| Microcanonical | $E,V,N$ | nothing | $1/\Omega(E)$ | $S=k\ln\Omega$ |
| Canonical | $T,V,N$ | $E$ | $e^{-\beta E}/Z$ | $F=-kT\ln Z$ |
| Grand canonical | $T,V,\mu$ | $E,N$ | $e^{-\beta(E-\mu N)}/\Xi$ | $\Phi=-kT\ln\Xi$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-ensembles" caption="The three ensembles, what each fixes, and the potential that generates its thermodynamics." body=t %}

Each ensemble in the table is a Legendre transform of the previous one: the multiplier replaces the constrained variable, and the logarithm of the partition function replaces the entropy. The next note asks when the choice among them does not matter.

> The canonical ensemble is not an approximation to the microcanonical one. It is a different physical situation, and the two agree for large systems only for reasons that need to be checked.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>How does the canonical distribution follow from maximum entropy?</summary>

Maximise the entropy under normalisation and a fixed mean energy. The multiplier of the energy constraint appears in an exponential, $p_i\propto e^{-\beta E_i}$, and is identified with $1/(kT)$ by comparing $\partial S/\partial U$ with the thermodynamic definition of temperature.
</details>

<details class="qa" markdown="1">
<summary>What does the chemical potential do in the grand canonical ensemble?</summary>

It is the multiplier of the mean particle number. It sets the weight $e^{\beta\mu N}$ of a state with $N$ particles and measures the cost of adding one.
</details>

<details class="qa" markdown="1">
<summary>What is fixed and what fluctuates in each of the three ensembles?</summary>

Microcanonical: energy, volume and particle number are fixed. Canonical: temperature replaces energy, and the energy fluctuates. Grand canonical: temperature and chemical potential are fixed, and both energy and particle number fluctuate.
</details>
