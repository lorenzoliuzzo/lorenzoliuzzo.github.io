---
collection: notes
title: Landau and Ginzburg-Landau Theory
date: '2026-10-27'
excerpt: A free energy built from the order parameter and its symmetry, the mean-field exponents it gives, the Ornstein-Zernike correlation length, and the Ginzburg criterion that sets where it holds.
hook: Near a continuous transition the order parameter is small and slowly varying, so the free energy can be expanded in it with only the terms the symmetry allows, and that expansion explains the mean-field exponents.
goals:
- write the Landau free energy for a scalar order parameter and minimise it
- add a gradient term and derive the correlation length
- state the Ginzburg criterion and the upper critical dimension
requires:
- order-parameter
- spontaneous-symmetry-breaking
- mean-field-exponents
- correlation-length
- taylor-expansion
defines:
- id: landau-free-energy
  name: Landau free energy
  anchor: expanding-in-the-order-parameter
- id: ginzburg-criterion
  name: Ginzburg criterion
  anchor: def-ginzburg-criterion
- id: upper-critical-dimension
  name: upper critical dimension
  anchor: when-fluctuations-can-be-ignored
tags:
- Physics
- Statistical Mechanics
read_time: true
---

Mean-field theory of the Ising model needed the model. Landau's idea was that near a continuous transition the behaviour is fixed by symmetry alone, so a free energy can be written for the order parameter with no reference to the microscopic details {% cite kardar-2007 %}.

# Expanding in the order parameter

Let $m$ be a scalar order parameter, small near $T_c$. The free energy density is a function of $m$ that must respect the symmetry of the Hamiltonian. For the $\mathbb Z_2$ symmetry $m\to-m$ only even powers appear:

$$ f(m)=f_0+\tfrac12r\,m^2+\tfrac14u\,m^4-hm,\qquad r=a\,t,\ a>0,\ u>0. $$

The coefficient $r$ changes sign at $T_c$, and $u$ is positive so that the free energy is bounded. The magnetisation is the minimum of $f$. For $t>0$ the only minimum is $m=0$. For $t<0$ there are two, at $m=\pm\sqrt{-r/u}$, and the symmetric point becomes a maximum.

{% include fig.html src="statistical-mechanics/landau-free-energy" id="fig-landau" alt="Three curves of the free energy against the order parameter. For positive reduced temperature a single minimum at zero, at zero reduced temperature a flat quartic, and for negative reduced temperature a double well with minima at plus and minus one." caption="Landau free energy $f(m)=\tfrac12tm^2+\tfrac14m^4$ for $t>0$, $t=0$ and $t<0$. The symmetry of $f$ is the symmetry of the Hamiltonian, while each minimum below $T_c$ has less symmetry." %}

The exponents follow at once. The minimum gives $m\sim(-t)^{1/2}$, so $\beta=1/2$. At $t=0$ the field enters as $um^3=h$, so $\delta=3$. The susceptibility is the inverse curvature at the minimum, $\chi=1/f''(m)=1/(a|t|)$ above $T_c$ and half of that below, so $\gamma=1$. The discontinuity of the heat capacity at $T_c$ follows from the quartic term. These are the mean-field exponents again, now justified by symmetry and not by an approximation to the Ising model. The expansion breaks down only where the assumptions fail, which is why the criterion below matters.

# The gradient term and the correlation length

For a slowly varying $m(\mathbf x)$ the free energy gains a gradient term, with a positive coefficient so that uniform states are preferred:

$$ F[m]=\int d^dx\,\Big[\tfrac12c\,|\nabla m|^2+\tfrac12r\,m^2+\tfrac14u\,m^4-hm\Big]. $$

This is the **Ginzburg-Landau** form. Above $T_c$ with $m$ small, drop the quartic term and expand in Fourier modes. Each mode has weight $\exp[-\beta\tfrac12(ck^2+r)|m_{\mathbf k}|^2]$, so by equipartition $\langle|m_{\mathbf k}|^2\rangle\propto kT/(ck^2+r)$: the Ornstein-Zernike form. Its transform decays as $e^{-r/\xi}$ with

$$ \xi=\sqrt{\frac{c}{r}}=\sqrt{\frac{c}{a}}\,t^{-1/2}, $$

so the correlation length diverges with exponent $\nu=1/2$, and the correlation function at $T_c$ decays as $r^{-(d-2)}$, which is $\eta=0$.

# When fluctuations can be ignored

The theory neglects fluctuations of $m$ about the minimum. Compare them with the mean value. Summing the Gaussian modes up to the wavenumber $1/\xi$ gives a variance of $m$ averaged over a correlation volume of order $\langle\delta m^2\rangle\sim kT\,\xi^{2-d}/c$, to be compared with $m^2\sim|t|$. With $\xi\sim|t|^{-1/2}$ the ratio is

$$ \frac{\langle\delta m^2\rangle}{m^2}\sim|t|^{(d-4)/2}. $$

As $t\to0$ this goes to zero when $d>4$ and diverges when $d<4$.

> The **Ginzburg criterion** is the condition that this ratio be small, and it defines the **upper critical dimension** $d_u=4$.
{: .definition #def-ginzburg-criterion title="Ginzburg criterion"}

Above four dimensions the mean-field exponents are exact. Below four they are not: fluctuations change the exponents, which is why three-dimensional systems have $\beta\approx0.33$ and not $1/2$. In $d=3$ the criterion also gives a temperature window, $|t|\gtrsim t_G$, outside of which Landau theory works, and for superconductors $t_G$ is so small that the theory holds almost to $T_c$.

{% capture t %}
| Dimension | Fluctuations near $T_c$ | Exponents |
|---|---|---|
| $d>4$ | negligible | mean field, exact |
| $d=4$ | logarithmic corrections | mean field with logs |
| $d<4$ | dominate | non-mean-field, universal |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-upper-critical" caption="The upper critical dimension $d_u=4$ separates mean-field from fluctuation-dominated critical behaviour." body=t %}

> A cubic term $m^3$ in $f$ is forbidden by the $m\to-m$ symmetry. When the symmetry allows it, the transition is first order, which is why symmetry decides the order of a transition.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why does the Landau free energy contain only even powers of $m$ for an Ising-like system?</summary>

The free energy must be invariant under the symmetry $m\to-m$ of the Hamiltonian, which removes all odd powers at zero field.
</details>

<details class="qa" markdown="1">
<summary>What does the gradient term add?</summary>

A cost for spatial variation of the order parameter, which gives the correlation function its Ornstein-Zernike form and a correlation length $\xi\sim|t|^{-1/2}$.
</details>

<details class="qa" markdown="1">
<summary>What is the Ginzburg criterion and its consequence?</summary>

Fluctuations are small compared with the mean order parameter near $T_c$ only if $d>4$, so $d_u=4$ is the upper critical dimension. Below it the mean-field exponents fail.
</details>
