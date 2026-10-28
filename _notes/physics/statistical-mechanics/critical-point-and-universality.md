---
collection: notes
title: Critical Exponents and Universality
date: '2026-10-27'
excerpt: Power laws near the critical point, the magnet-fluid analogy that maps a liquid-gas critical point onto a magnet, and universality classes.
hook: Near a critical point very different systems obey the same power laws, because what matters is a few symmetries and the dimension, and not the microscopic details.
goals:
- define the critical exponents and give their mean-field values
- map the liquid-gas critical point onto the magnetic one
- explain universality and why mean field gets the exponents wrong
requires:
- van-der-waals-equation
- critical-point
- order-parameter
- mean-field-approximation
defines:
- id: critical-exponent
  name: critical exponent
  anchor: power-laws-near-the-critical-point
- id: magnet-fluid-analogy
  name: magnet-fluid analogy
  anchor: the-magnet-fluid-analogy
- id: universality-class
  name: universality class
  anchor: def-universality-class
tags:
- Physics
- Statistical Mechanics
read_time: true
---

Close to a critical point the measurable quantities of a system become power laws in the distance from it. The exponents, and not the prefactors, turn out to be shared by systems that have nothing else in common {% cite kardar-2007 %}.

# Power laws near the critical point

Let $t=(T-T_c)/T_c$ be the reduced temperature. In a magnet with order parameter $m$ and field $h$, the critical behaviour is described by a set of **critical exponents**:

$$ m\sim(-t)^{\beta}\ (t<0,\ h=0),\qquad \chi\sim|t|^{-\gamma},\qquad C\sim|t|^{-\alpha},\qquad m\sim h^{1/\delta}\ (t=0), $$

$$ \xi\sim|t|^{-\nu},\qquad G(r)\sim r^{-(d-2+\eta)}\ (t=0). $$

Here $\chi$ is the susceptibility, $C$ the heat capacity, $\xi$ the correlation length and $G(r)$ the spin correlation function in $d$ dimensions. The divergence of $\xi$ is why fluctuations are important at the critical point: there is no length scale left except the system size.

# The magnet-fluid analogy

The van der Waals gas near its critical point looks like a magnet. Take the difference $\rho_\ell-\rho_g$ between the liquid and gas densities as the order parameter: it vanishes above $T_c$ and is non-zero below, like $m$. The pressure deviation $p-p_c$ plays the part of the field $h$, and the compressibility is the susceptibility. Expanding the reduced van der Waals equation about the critical point gives, with $\phi=\tilde v-1$,

$$ \tilde p-1\approx4t-6t\phi-\tfrac32\phi^3+\dots, $$

so on the critical isotherm $\tilde p-1\propto-\phi^3$, which is $\delta=3$, and the coexistence curve follows $\phi\sim(-t)^{1/2}$, which is $\beta=1/2$. These are the mean-field values for a magnet, found independently in the Weiss theory of the Ising model.

{% capture t %}
| Exponent | Mean field | 2D Ising (exact) | 3D Ising (numerical) |
|---|---|---|---|
| $\alpha$ | $0$ (jump) | $0$ (log) | $\approx0.11$ |
| $\beta$ | $1/2$ | $1/8$ | $\approx0.33$ |
| $\gamma$ | $1$ | $7/4$ | $\approx1.24$ |
| $\delta$ | $3$ | $15$ | $\approx4.8$ |
| $\nu$ | $1/2$ | $1$ | $\approx0.63$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-exponents" caption="Critical exponents of the Ising universality class in two and three dimensions, against mean field." body=t %}

Experiments on fluids near their critical points give $\beta\approx0.33$, in agreement with the three-dimensional Ising value and not with the van der Waals $1/2$. The mean-field exponents are the same for every system, which is already a statement of universality, but they are wrong.

# Universality

> A **universality class** is a set of systems sharing the same critical exponents.
{: .definition #def-universality-class title="Universality class"}

The class is fixed by the dimension of space, the symmetry of the order parameter, and the range of the interactions, and not by the lattice, the strength of the coupling or the chemistry. A uniaxial magnet and a liquid-gas critical point share the Ising class because both have a scalar order parameter with a two-fold symmetry. A magnet with a planar order parameter belongs to the XY class and one with a three-component order parameter to the Heisenberg class, with different exponents.

The reason is that near the critical point the correlation length is much larger than any microscopic scale, so the microscopic details are averaged out and only the symmetry and dimension remain. Mean-field theory, which ignores correlations, gets the exponents right only above a certain dimension, as the Ginzburg criterion of a later note shows. Below it, fluctuations change the exponents.

> Universal exponents are not universal amplitudes. The prefactor of $m\sim(-t)^\beta$ depends on the system, and so does $T_c$. Only certain ratios of amplitudes are universal.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Which mean-field exponents does the van der Waals equation give?</summary>

$\beta=1/2$ from the shape of the coexistence curve and $\delta=3$ from the critical isotherm, with $\gamma=1$ for the compressibility. They are the same as in the mean-field theory of a magnet.
</details>

<details class="qa" markdown="1">
<summary>What is the order parameter of a liquid-gas critical point?</summary>

The density difference between liquid and gas. It is zero above $T_c$ and non-zero below, and it plays the part of the magnetisation, with the pressure deviation as the field.
</details>

<details class="qa" markdown="1">
<summary>What determines a universality class?</summary>

The dimension of space, the symmetry of the order parameter and the range of the interactions. Lattice structure and coupling strength do not enter.
</details>
