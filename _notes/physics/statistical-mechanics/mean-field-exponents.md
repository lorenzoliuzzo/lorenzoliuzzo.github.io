---
collection: notes
title: Mean-Field Critical Exponents
date: '2026-10-27'
excerpt: Weiss mean-field theory of a magnet in a field, its critical temperature kTc = zJ, and the exponents alpha, beta, gamma and delta that follow from expanding the self-consistency equation.
hook: Expanding the self-consistency equation of mean field near the transition yields every critical exponent in a few lines, and they are the same for any lattice.
goals:
- write the Weiss self-consistency equation with a field
- derive the mean-field exponents beta, delta and gamma by expansion
- state the mean-field heat-capacity jump and what the exponents leave out
requires:
- self-consistency-equation
- mean-field-approximation
- critical-exponent
- xy-model
defines:
- id: mean-field-exponents
  name: mean-field exponents
  anchor: expanding-near-the-transition
- id: magnetic-susceptibility
  name: magnetic susceptibility
  anchor: def-magnetic-susceptibility
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The mean-field treatment of the Ising model, set out in the AI-models course as a variational family, is the Weiss theory of the ferromagnet. This note works out what it predicts at the critical point and tests it against the exponents of the previous note {% cite kardar-2007 %}.

# The equation in a field

Each spin feels an effective field made of the applied field $h$ and the average of its $z$ neighbours, $h_{\rm eff}=h+zJm$, with $m=\langle s\rangle$. A single spin in a field has $\langle s\rangle=\tanh(\beta h_{\rm eff})$, so the self-consistency equation is

$$ m=\tanh\big(\beta zJm+\beta h\big). $$

At $h=0$ the equation has the solution $m=0$ for all $T$ and a pair of solutions $\pm m_0$ when $\beta zJ>1$, so the mean-field critical temperature is $kT_c=zJ$. For the square lattice with $z=4$ this is $4J$, much higher than the exact value, as the next notes show.

# Expanding near the transition

Write $\theta=T_c/T$, so $\beta zJ=\theta$, and use $\tanh x\approx x-x^3/3$ for small $m$.

**Order parameter, $\beta$.** At $h=0$: $m=\theta m-\theta^3m^3/3$, so $m^2=3(\theta-1)/\theta^3$. Just below $T_c$, $\theta-1\approx-t$ with $t=(T-T_c)/T_c$, and

$$ m\simeq\sqrt3\,(-t)^{1/2}, $$

so the exponent is $\beta=1/2$.

**Critical isotherm, $\delta$.** At $T=T_c$, $\theta=1$, and with a field $m=m+\beta h-m^3/3$ to leading order, hence $\beta h=m^3/3$ and $m\propto h^{1/3}$, which is $\delta=3$.

**Susceptibility, $\gamma$.** Differentiate the self-consistency equation with respect to $h$ at $h=0$ and $T>T_c$, where $m=0$. With $\chi=\partial m/\partial h$ this gives $\chi=\beta+\theta\chi$ to first order, so

$$ \chi=\frac{\beta}{1-\theta}=\frac{1}{k(T-T_c)}, $$

> The **magnetic susceptibility** $\chi=\partial m/\partial h$ follows the Curie-Weiss law $\chi=1/k(T-T_c)$ above $T_c$, which is the exponent $\gamma=1$.
{: .definition #def-magnetic-susceptibility title="Magnetic susceptibility"}

{% include fig.html src="ai-models-for-physics/mean-field-solution" id="fig-mf-solution" alt="The left side of the self-consistency equation, a straight line, and the right side, a tanh curve, for several temperatures, with intersections moving from the origin to nonzero values as the temperature falls below the critical one." caption="Solutions of the mean-field equation $m=\tanh(\beta zJm)$. The non-zero intersections appear when the slope of the tanh at the origin exceeds one, that is when $T<T_c$." %}

# The heat capacity and what is left out

The energy per spin in mean field is $-\tfrac12zJm^2$ below $T_c$ and zero above. With $m^2\propto(-t)$ the energy is linear in $t$ just below $T_c$, so the heat capacity jumps at the transition and has no divergence: $\alpha=0$ with a finite step, which is $3k/2$ per spin.

{% capture t %}
| Quantity | Mean-field law | Exponent |
|---|---|---|
| Magnetisation below $T_c$ | $m\sim(-t)^{1/2}$ | $\beta=\tfrac12$ |
| Susceptibility above $T_c$ | $\chi\sim t^{-1}$ | $\gamma=1$ |
| Critical isotherm | $m\sim h^{1/3}$ | $\delta=3$ |
| Heat capacity | finite jump | $\alpha=0$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-mf-exponents" caption="The mean-field critical exponents, which hold for every lattice and every $n$." body=t %}

The exponents do not depend on $z$, on the lattice, or on the number of spin components $n$. Only $T_c$ does. That is both the appeal of the theory, a universal set of exponents from one line of algebra, and its flaw: the true exponents depend on the dimension and on $n$, and the theory cannot see this because it replaces the fluctuating neighbours by their average.

> The mean-field value of $T_c$ is an upper bound on the true one for the Ising model. Ignoring fluctuations makes the ordered state too stable.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>How does $\beta=1/2$ arise from the self-consistency equation?</summary>

Expanding $\tanh$ to cubic order at $h=0$ gives $m^2=3(\theta-1)/\theta^3$, and near $T_c$ this is proportional to $-t$, so $m\sim(-t)^{1/2}$.
</details>

<details class="qa" markdown="1">
<summary>What law does mean field give for the susceptibility above $T_c$?</summary>

The Curie-Weiss law $\chi=1/k(T-T_c)$, so $\gamma=1$.
</details>

<details class="qa" markdown="1">
<summary>Why are the mean-field exponents the same on every lattice?</summary>

The theory replaces the neighbours by their average, so the lattice enters only through the number of neighbours $z$, which sets $T_c$ and nothing else.
</details>
