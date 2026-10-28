---
collection: notes
title: Fluctuations and the Thermodynamic Limit
date: '2026-10-27'
excerpt: Fluctuations in an ensemble are set by response functions, they shrink as one over the square root of the system size, and that is why ensembles agree for large systems.
hook: The variance of the energy in the canonical ensemble is a heat capacity, so the same number says how the system responds and how much it fluctuates.
goals:
- show that the energy variance equals kT squared times the heat capacity
- explain why relative fluctuations vanish in the thermodynamic limit
- name two situations where ensembles fail to be equivalent
requires:
- canonical-ensemble
- grand-canonical-ensemble
- variance
- central-limit-theorem
- heat-capacity
defines:
- id: fluctuation-response-relation
  name: fluctuation-response relation
  anchor: def-fluctuation-response-relation
- id: thermodynamic-limit
  name: thermodynamic limit
  anchor: def-thermodynamic-limit
- id: ensemble-equivalence
  name: ensemble equivalence
  anchor: when-ensembles-disagree
tags:
- Physics
- Statistical Mechanics
read_time: true
---

In the canonical ensemble the energy is not fixed, and a first question is how far it wanders from its mean. The answer is not a new quantity: it is a response function that thermodynamics already knows {% cite kardar-2007 %}.

# Fluctuations are responses

Write $Z(\beta)=\sum_ie^{-\beta E_i}$. The first derivative gives the mean energy and the second gives the variance:

$$ \langle E\rangle=-\frac{\partial\ln Z}{\partial\beta},\qquad \langle E^2\rangle-\langle E\rangle^2=\frac{\partial^2\ln Z}{\partial\beta^2}=-\frac{\partial\langle E\rangle}{\partial\beta}=kT^2C_V, $$

where the last step uses $\partial/\partial\beta=-kT^2\,\partial/\partial T$ and the definition of the heat capacity $C_V=\partial\langle E\rangle/\partial T$.

> This is a **fluctuation-response relation**: the spontaneous fluctuation of the energy at equilibrium is tied to how the mean energy responds to a change in temperature.
{: .definition #def-fluctuation-response-relation title="Fluctuation-response relation"}

Because a variance is non-negative, $C_V\ge0$ in the canonical ensemble.

The same structure holds for other variables. If a field $h$ couples to the magnetisation as $-hM$, then $\langle M^2\rangle-\langle M\rangle^2=kT\,\chi$, with $\chi=\partial\langle M\rangle/\partial h$ the susceptibility, and in the grand canonical ensemble the variance of $N$ is proportional to the compressibility. A diverging response at a critical point therefore means diverging fluctuations, which is the content of critical opalescence. This is the equilibrium form of the relation; its dynamical form, which links the decay of fluctuations to dissipation, is a separate theorem.

> To measure a susceptibility it is enough to measure a variance at equilibrium. Simulations use this: the heat capacity and the susceptibility of a spin model are computed from the fluctuations in a single run.
{: .rule}

# Relative fluctuations vanish

For $N$ weakly interacting parts the energy is a sum of $N$ contributions with comparable variance, and $kT^2C_V$ grows in proportion to $N$. The standard deviation therefore grows as $\sqrt N$ while the mean grows as $N$, so

$$ \frac{\sqrt{\langle E^2\rangle-\langle E\rangle^2}}{\langle E\rangle}\sim\frac1{\sqrt N}. $$

This is the central limit theorem at work.

> In the **thermodynamic limit**, $N\to\infty$ with the density fixed, the canonical energy distribution becomes sharp, and the system behaves as if its energy were fixed.
{: .definition #def-thermodynamic-limit title="Thermodynamic limit"}

{% include fig.html src="statistical-mechanics/energy-fluctuations" id="fig-energy-fluctuations" alt="Three bell-shaped curves of the energy per unit, centred at 0.3 and growing narrower and taller for N equal to 10, 100 and 1000." caption="Distribution of the energy per unit of $N$ independent two-level systems, each excited with probability $0.3$. The distribution sharpens as $1/\sqrt N$, so for a macroscopic system the energy of the canonical ensemble is effectively fixed." %}

# When ensembles disagree

Sharp fluctuations are the reason the ensembles give the same thermodynamics, when they do. The equivalence is a statement about large systems with short-range interactions and a smooth entropy, and it can fail.

{% capture t %}
| Situation | What goes wrong | Where it appears |
|---|---|---|
| First-order coexistence | $S(E)$ has a convex part; the microcanonical $T(E)$ is not monotonic | the interval between two phases |
| Long-range interactions | energy is not extensive; $C_V<0$ is possible microcanonically | self-gravitating systems |
| Critical point | fluctuations do not shrink as $1/\sqrt N$ | large susceptibility near $T_c$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-ensemble-failures" caption="Three situations in which the usual ensemble equivalence needs care." body=t %}

A negative heat capacity is impossible in the canonical ensemble, since it would make a variance negative, and possible in the microcanonical one for a system such as a star. The two descriptions then give different answers to the same question.

# Recap

<details class="qa" markdown="1">
<summary>Why does the variance of the energy equal $kT^2C_V$?</summary>

The second derivative of $\ln Z$ with respect to $\beta$ is the variance of $E$, and it is also minus the derivative of the mean energy with respect to $\beta$. Converting $\beta$ to $T$ gives $kT^2$ times the heat capacity.
</details>

<details class="qa" markdown="1">
<summary>Why do the canonical and microcanonical ensembles agree for large systems?</summary>

Relative energy fluctuations fall as $1/\sqrt N$, so the canonical energy is effectively fixed. The agreement needs short-range interactions and a concave entropy.
</details>

<details class="qa" markdown="1">
<summary>What does a diverging susceptibility say about fluctuations?</summary>

The variance of the conjugate quantity is $kT\chi$, so a diverging response means large equilibrium fluctuations, as at a critical point.
</details>
