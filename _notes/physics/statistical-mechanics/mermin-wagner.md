---
collection: notes
title: The Mermin-Wagner Theorem
date: '2026-10-27'
excerpt: Why Goldstone fluctuations diverge in one and two dimensions, so that a continuous symmetry cannot be broken at finite temperature, and the quasi-long-range order that remains.
hook: The thermal weight of the gapless Goldstone modes adds up to an infinite fluctuation of the order parameter in one and two dimensions, and the order dissolves.
goals:
- compute the fluctuation of the Goldstone field from the spin-wave free energy
- show how the integral depends on the dimension
- state the Mermin-Wagner theorem and the algebraic order it leaves in two dimensions
requires:
- goldstone-mode
- spin-stiffness
- lower-critical-dimension
- xy-model
defines:
- id: mermin-wagner-theorem
  name: Mermin-Wagner theorem
  anchor: def-mermin-wagner-theorem
- id: quasi-long-range-order
  name: quasi-long-range order
  anchor: def-quasi-long-range-order
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The earlier domain-wall estimate put the lower critical dimension of a continuous symmetry at two. The spin-wave calculation gives the same answer from the Goldstone modes themselves.

# The fluctuation integral

In the ordered state of an XY magnet at low temperature, write the spin angle as $\theta(\mathbf x)$ and take the Gaussian free energy of the previous note. The equipartition result gives the mean square angle fluctuation as a sum over modes,

$$ \langle\theta^2\rangle=\int\frac{d^dk}{(2\pi)^d}\frac{kT}{\rho_sk^2}, $$

with an upper cutoff $\sim1/a$ from the lattice and a lower cutoff $\sim1/L$ from the system size. The integrand grows towards small $k$, and the result depends on the dimension. In $d=1$, $\int dk/k^2\sim L$, so the fluctuation grows linearly with the size. In $d=2$, $\int dk/k\sim\ln L$. In $d=3$, $\int k^2dk/k^2$ converges at small $k$, so the fluctuation is finite as $L\to\infty$.

{% include fig.html src="statistical-mechanics/fluctuation-dimension" id="fig-fluct-dim" alt="Mean square fluctuation of the Goldstone field against the logarithm of the system size for dimensions 1, 2 and 3. The d equal 1 curve rises steeply, d equal 2 rises slowly and steadily, and d equal 3 is nearly flat." caption="Mean square fluctuation of the Goldstone field on a lattice of linear size $L$, computed exactly for the Gaussian model. It grows as $L$ in one dimension, as $\ln L$ in two and saturates in three." %}

# The theorem

If the fluctuation of the angle diverges, the assumption of a fixed order-parameter direction breaks down: the angle wanders over the whole circle, and the average of the order parameter is zero.

> This is the content of the **Mermin-Wagner theorem**: a continuous symmetry cannot be spontaneously broken at any positive temperature in one or two dimensions, for short-range interactions {% cite mermin-1966 %}.
{: .definition #def-mermin-wagner-theorem title="Mermin-Wagner theorem"}

The rigorous proof does not use the Gaussian approximation. It is a bound, based on an inequality, that holds for the Heisenberg model and, in the same form, for the XY model.

The theorem needs short-range interactions and a continuous symmetry. It does not apply to the Ising model, which has a sharp wall and no Goldstone modes, and it gives no obstacle to order at zero temperature, where $kT=0$ removes the integral.

> The statement is about spontaneous symmetry breaking, not about all long-range correlation. Two dimensions can still show correlations that decay slowly.
{: .trap}

# What survives in two dimensions

In $d=2$ the angle difference between two points a distance $r$ apart has a logarithmic variance, $\langle(\theta(\mathbf r)-\theta(0))^2\rangle=\frac{kT}{\pi\rho_s}\ln(r/a)$. For a Gaussian field the spin correlation function is $\langle\cos(\theta(\mathbf r)-\theta(0))\rangle=\exp[-\tfrac12\langle(\Delta\theta)^2\rangle]$, so

$$ G(r)\sim\Big(\frac ar\Big)^{\eta(T)},\qquad \eta=\frac{kT}{2\pi\rho_s}. $$

The correlation decays as a power law with a temperature-dependent exponent, and not exponentially as in the high-temperature phase.

> This is **quasi-long-range order**: no order parameter, since $G\to0$ at large $r$, but correlations that fall off slowly, and a finite stiffness.
{: .definition #def-quasi-long-range-order title="Quasi-long-range order"}

The next note shows how it ends at a temperature set by topological defects.

{% capture t %}
| Dimension | $\langle\theta^2\rangle$ | Order at $T>0$ | Correlations |
|---|---|---|---|
| $d=1$ | $\sim L$ | none | exponential |
| $d=2$ | $\sim\ln L$ | none | power law, $\eta=kT/2\pi\rho_s$ |
| $d=3$ | finite | long-range order | constant at large $r$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-mw" caption="Goldstone fluctuations and order for a continuous symmetry, by dimension." body=t %}

# Recap

<details class="qa" markdown="1">
<summary>Why do Goldstone fluctuations destroy order in $d\le2$?</summary>

The mean square angle fluctuation $\int d^dk\,kT/\rho_sk^2$ diverges at small $k$ in one and two dimensions, so the angle wanders and the order-parameter average vanishes.
</details>

<details class="qa" markdown="1">
<summary>What does the theorem not cover?</summary>

Discrete symmetries such as Ising, long-range interactions, and zero temperature.
</details>

<details class="qa" markdown="1">
<summary>What is quasi-long-range order?</summary>

Correlations that decay as a power law $r^{-\eta}$ with $\eta=kT/2\pi\rho_s$ in two dimensions, so there is no true order parameter, but correlations are far longer-ranged than in a disordered phase.
</details>
