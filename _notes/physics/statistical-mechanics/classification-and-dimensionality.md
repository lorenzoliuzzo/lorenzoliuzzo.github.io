---
collection: notes
title: 'Classifying Transitions: Range and Dimension'
date: '2026-10-27'
excerpt: First-order and continuous transitions, the role of the range of interactions, and the lower critical dimension from a domain-wall free energy.
hook: Whether a system orders depends on the kind of transition, on how far its interactions reach and on the dimension of space, and a domain-wall estimate explains the dimension.
goals:
- distinguish first-order and continuous transitions by what is discontinuous
- explain why infinite-range interactions make mean field exact
- derive the lower critical dimension of discrete and continuous symmetry from a domain-wall energy
requires:
- phase-transition
- peierls-argument
- transfer-matrix
- critical-exponent
- continuous-symmetry
defines:
- id: first-order-transition
  name: first-order transition
  anchor: first-order-and-continuous
- id: continuous-transition
  name: continuous transition
  anchor: first-order-and-continuous
- id: lower-critical-dimension
  name: lower critical dimension
  anchor: def-lower-critical-dimension
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The Ising chain, the Ising square lattice and the van der Waals gas each show a different aspect of phase transitions. This note puts them in order {% cite kardar-2007 %}.

# First order and continuous

A transition is **first order** if a first derivative of the free energy is discontinuous: the entropy, and so the energy, jumps, giving a latent heat, and the order parameter jumps as well. Two phases coexist at the transition, with a finite correlation length. The liquid-gas transition below the critical point is of this kind.

A transition is **continuous** if the first derivatives are continuous and only second derivatives, such as the heat capacity or the susceptibility, are singular. The order parameter goes to zero smoothly, and the correlation length diverges, so there is no scale left. The Ising transition at zero field and the liquid-gas critical point are continuous. Only continuous transitions have critical exponents and universality.

{% capture t %}
| | First order | Continuous |
|---|---|---|
| Order parameter at $T_c$ | jumps | goes to zero |
| Latent heat | yes | none |
| Correlation length | finite | diverges |
| Phases at $T_c$ | coexist | become identical |
| Exponents | none | universal |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-transition-types" caption="First-order and continuous transitions compared." body=t %}

# The role of the range of interactions

Mean field treats each spin as feeling the average of the others. That is exact when every spin interacts with every other, with the coupling scaled as $J/N$ so that the energy stays extensive, the Curie-Weiss model. Each spin then has $N$ neighbours and the fluctuations of their sum are smaller by $1/\sqrt N$. For short-range interactions, with $z$ finite, the neighbours fluctuate, and mean field is an approximation whose quality improves as $z$ grows. In high enough dimension $z=2d$ is large and the approximation becomes exact for the exponents, which is the Ginzburg criterion at work in the last note of this part.

# The role of dimension

The domain-wall argument gives a threshold dimension. Consider a system of linear size $L$ in $d$ dimensions and a domain wall that splits it in two.

For a discrete symmetry such as Ising, the wall is sharp, with energy per unit area $\sigma$, so $E_{\rm wall}\sim\sigma L^{d-1}$. Its entropy comes from where it can be placed, which is about $k\ln L$ in one dimension and grows at most as the wall's area in higher ones. Order survives when the energy beats the entropy: this holds for $d>1$ and fails in $d=1$.

> The **lower critical dimension** of the Ising model is $d_\ell=1$.
{: .definition #def-lower-critical-dimension title="Lower critical dimension"}

For a continuous symmetry, the wall is not sharp. The direction of the order parameter can rotate gradually across the system, a twist by an angle $\pi$ spread over the length $L$. The gradient is then $\sim1/L$, the energy density is $\sim J/L^2$, and integrating over the volume $L^d$ gives $E_{\rm wall}\sim JL^{d-2}$. For $d=2$ this is independent of $L$, like the energy of a wall in the Ising chain, and it grows with $L$ only for $d>2$. Order against thermal fluctuations is therefore possible only for $d>2$: the lower critical dimension for a continuous symmetry is $d_\ell=2$.

{% capture t2 %}
| Symmetry | Wall energy | $d_\ell$ | Example |
|---|---|---|---|
| Discrete, $\mathbb Z_2$ | $\sim L^{d-1}$ | $1$ | Ising |
| Continuous, $O(n\ge2)$ | $\sim L^{d-2}$ | $2$ | XY, Heisenberg |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-lower-critical" caption="Lower critical dimensions from the energy of a domain wall." body=t2 %}

> The lower critical dimension is where fluctuations first destroy order. At $d=d_\ell$ there is no transition at finite temperature, while for $d>d_\ell$ there is.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What distinguishes a first-order transition from a continuous one?</summary>

A first-order transition has a jump in the energy and order parameter and finite correlation length, and phases coexist. A continuous one has a diverging correlation length and continuous first derivatives.
</details>

<details class="qa" markdown="1">
<summary>When is mean field exact?</summary>

For infinite-range interactions, where each spin feels an average of $N$ neighbours. For finite range it becomes exact for the exponents above an upper critical dimension.
</details>

<details class="qa" markdown="1">
<summary>Why does a continuous symmetry have a higher lower critical dimension than a discrete one?</summary>

A discrete symmetry forces a sharp wall of energy $L^{d-1}$. A continuous symmetry lets the twist spread out, lowering the energy to $L^{d-2}$, so entropy wins up to $d=2$.
</details>
