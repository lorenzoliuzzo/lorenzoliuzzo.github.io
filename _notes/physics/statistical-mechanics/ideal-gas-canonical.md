---
collection: notes
title: The Ideal Gas in the Canonical Ensemble
date: '2026-10-27'
excerpt: The single-particle partition function, the thermal wavelength, the factor 1/N!, and the equation of state and entropy that follow.
hook: Evaluating one partition function for a classical ideal gas produces its equation of state, its energy and the Sackur-Tetrode entropy, together with the length scale that says when it stops being classical.
goals:
- compute the partition function of one particle in a box and introduce the thermal wavelength
- assemble the N-particle partition function with the 1/N! factor
- derive the equation of state, the energy and the entropy of the ideal gas
requires:
- canonical-ensemble
- partition-function
- ideal-gas
- gibbs-paradox
- maxwell-boltzmann
defines:
- id: thermal-wavelength
  name: thermal wavelength
  anchor: def-thermal-wavelength
- id: ideal-gas-partition-function
  name: ideal-gas partition function
  anchor: def-ideal-gas-partition-function
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The ideal gas is the system in which every claim of the previous notes can be checked, because the partition function is a product and every sum is a Gaussian integral {% cite kardar-2007 %}.

# One particle in a box

A particle of mass $m$ in a volume $V$ has Hamiltonian $H=p^2/2m$ and a classical phase-space integral

$$ Z_1=\frac{1}{h^3}\int d^3x\int d^3p\,e^{-\beta p^2/2m}=\frac{V}{h^3}\Big(\frac{2\pi m}{\beta}\Big)^{3/2}=\frac{V}{\lambda^3}. $$

The division by Planck's constant $h^3$ makes the number of states dimensionless, and it is the quantum input of the classical calculation. The length

$$ \lambda=\frac{h}{\sqrt{2\pi mkT}} $$

> The length $\lambda=h/\sqrt{2\pi mkT}$ is the **thermal wavelength**, the de Broglie wavelength of a particle with thermal momentum.
{: .definition #def-thermal-wavelength title="Thermal wavelength"}

So $Z_1$ counts how many thermal cells of volume $\lambda^3$ fit in the box.

# From one particle to N

For $N$ non-interacting particles the Hamiltonian is a sum, and the partition function of distinguishable particles would be $Z_1^N$. Identical particles are not distinguishable, and the Gibbs paradox says to divide by $N!$,

$$ Z_N=\frac{1}{N!}\Big(\frac V{\lambda^3}\Big)^N. $$

> The **ideal-gas partition function** of $N$ identical, non-interacting particles in a volume $V$ is $Z_N=\frac1{N!}\big(V/\lambda^3\big)^N$.
{: .definition #def-ideal-gas-partition-function title="Ideal-gas partition function"}

With Stirling's formula $\ln N!\approx N\ln N-N$, the free energy is

$$ F=-kT\ln Z_N=-NkT\Big[\ln\frac{V}{N\lambda^3}+1\Big], $$

and it is extensive: doubling $N$ and $V$ together doubles $F$. Without the $N!$ the argument of the logarithm would be $V/\lambda^3$ and extensivity would be lost.

# The thermodynamics

Everything follows by differentiating $F$ at fixed $N$:

$$ p=-\frac{\partial F}{\partial V}=\frac{NkT}{V},\qquad U=-\frac{\partial\ln Z_N}{\partial\beta}=\frac32NkT,\qquad S=-\frac{\partial F}{\partial T}=Nk\Big[\ln\frac{V}{N\lambda^3}+\frac52\Big]. $$

The first is the equation of state, the second is equipartition for three translational degrees of freedom, and the third is the Sackur-Tetrode entropy. The chemical potential is $\mu=\partial F/\partial N=kT\ln(N\lambda^3/V)$, negative whenever the gas is dilute.

{% capture t %}
| Quantity | Result | Origin |
|---|---|---|
| Equation of state | $pV=NkT$ | $\partial F/\partial V$ |
| Energy | $\tfrac32NkT$ | $-\partial\ln Z/\partial\beta$ |
| Heat capacity | $C_V=\tfrac32Nk$ | $\partial U/\partial T$ |
| Entropy | $Nk[\ln(V/N\lambda^3)+\tfrac52]$ | $-\partial F/\partial T$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-ideal-gas" caption="Thermodynamics of the classical ideal gas from the canonical partition function." body=t %}

> The argument of the logarithm in the entropy is $V/N\lambda^3$, the number of thermal cells per particle. The classical formula needs it to be much larger than one.
{: .idea}

# When the classical gas stops working

The classical treatment assumes $n\lambda^3\ll1$ with $n=N/V$: the thermal wavelengths of neighbouring particles do not overlap. Lowering the temperature or raising the density makes the criterion fail, the sum over states must keep their quantum statistics, and the Sackur-Tetrode entropy would become negative, which no entropy of a discrete system can be. For a gas of helium at room temperature and atmospheric pressure, $n\lambda^3\sim10^{-6}$ and the classical result is excellent, while for electrons in a metal $n\lambda^3\gg1$ and it fails completely.

> The ideal gas has no interactions and so cannot condense: its pressure is $NkT/V$ at every density and temperature, down to the point where quantum statistics intervenes. The next note adds the minimum of interaction that makes it condense.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>What is the thermal wavelength and what does $Z_1$ count?</summary>

$\lambda=h/\sqrt{2\pi mkT}$ is the de Broglie wavelength of a particle with thermal momentum. $Z_1=V/\lambda^3$ is the number of thermal cells of volume $\lambda^3$ in the box.
</details>

<details class="qa" markdown="1">
<summary>Why does $Z_N$ contain $1/N!$?</summary>

Identical particles are indistinguishable, so permutations of them do not give new states. Without the factor the free energy would not be extensive.
</details>

<details class="qa" markdown="1">
<summary>When does the classical ideal gas fail?</summary>

When the thermal wavelength becomes comparable to the interparticle spacing, $n\lambda^3\gtrsim1$. Quantum statistics then matters and the classical entropy is no longer valid.
</details>
