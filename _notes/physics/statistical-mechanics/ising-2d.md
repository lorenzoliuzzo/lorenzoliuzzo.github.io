---
collection: notes
title: The Two-Dimensional Ising Model
date: '2026-10-27'
excerpt: The Peierls domain-wall argument for order at low temperature, Onsager's exact solution, and how its exponents and critical temperature compare with mean field.
hook: In two dimensions a domain wall costs energy proportional to its length, and that is enough to keep the ordered state alive at low temperature, which Onsager's exact solution then confirms.
goals:
- make the domain-wall argument for order in two dimensions
- state the Onsager critical temperature and the exact exponent beta
- compare the exact results with the mean-field ones
requires:
- transfer-matrix
- mean-field-exponents
- critical-exponent
defines:
- id: peierls-argument
  name: Peierls argument
  anchor: the-domain-wall-argument
- id: onsager-solution
  name: Onsager solution
  anchor: onsagers-solution
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The one-dimensional chain shows that short-range interactions need not order. On the square lattice they do. Two arguments show it, one that is physical and one that is exact {% cite peierls-1936 %}.

# The domain-wall argument

Start with all spins up at low temperature and flip those inside a region. The result is a droplet of down spins in an up background. Every bond between an up and a down spin costs $2J$ more than an aligned bond. The droplet is bounded by a closed curve, the **domain wall**, on the dual lattice, and its energy is $2J\ell$ with $\ell$ the length of the wall in bonds.

{% include fig.html src="statistical-mechanics/peierls-droplet" id="fig-peierls" alt="A square lattice of plus signs with a block of minus signs in shaded cells and the boundary between plus and minus drawn in a thick line." caption="A droplet of flipped spins. The energy cost is $2J$ times the length of its boundary, here 24 bonds." %}

The Peierls argument compares this cost with the entropy of the wall. A closed wall of length $\ell$ can be drawn in at most about $3^\ell$ ways, since at each step it can go straight or turn either way. The free energy of a wall of length $\ell$ is therefore at least

$$ \Delta F\gtrsim\ell\,(2J-kT\ln3). $$

For $kT<2J/\ln3\approx1.82J$ every long wall is costly, and the probability that a given spin is flipped can be bounded and made small. The up background survives and the system has long-range order. The contrast with one dimension is clear: there a wall is a single point, with energy independent of the system size; in two dimensions its energy grows with its length, and it wins against the entropy.

# Onsager's solution

The exact solution of the model on the square lattice at zero field was found by Onsager with the transfer-matrix method generalised to a strip of width $L$ {% cite onsager-1944 %}. The critical temperature satisfies $\sinh(2J/kT_c)=1$, which gives

$$ kT_c=\frac{2J}{\ln(1+\sqrt2)}\approx2.269J, $$

and the spontaneous magnetisation is $m=\big[1-\sinh^{-4}(2J/kT)\big]^{1/8}$ for $T<T_c$. The heat capacity diverges logarithmically, which is $\alpha=0$ in its logarithmic form.

{% include fig.html src="statistical-mechanics/mean-field-vs-onsager" id="fig-onsager" alt="Spontaneous magnetisation against temperature. The exact curve falls to zero near 2.27 with a very steep end, while the mean-field curve stays near one until much higher temperature and goes to zero at 4." caption="Spontaneous magnetisation of the square-lattice Ising model: mean field (critical temperature $4J$) and the exact Onsager result (critical temperature $2.269J$)." %}

# Mean field against exact

{% capture t %}
| | Mean field ($z=4$) | Exact, 2D |
|---|---|---|
| $kT_c/J$ | $4$ | $2.269$ |
| $\beta$ | $1/2$ | $1/8$ |
| $\gamma$ | $1$ | $7/4$ |
| $\nu$ | $1/2$ | $1$ |
| $\alpha$ | jump | log divergence |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-mf-vs-exact" caption="Mean-field and exact results for the square-lattice Ising model." body=t %}

Mean field overestimates the critical temperature by about 76 percent, because it ignores the fluctuations that disorder the system before the mean field would. The exponents are wrong in a different way: the magnetisation curve is far more sharply peaked than a square root. The two failures are the same one, which is that near the transition the spins are correlated over a distance $\xi$ and the independent-spin approximation does not hold. In one dimension the error is total, since mean field predicts a transition where there is none.

> The Peierls estimate $1.82J$ is a lower bound on the temperature up to which the argument works, not a prediction of $T_c$. The true $T_c=2.269J$ lies above it, and below the mean-field value $4J$.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does the domain-wall argument give order in two dimensions but not in one?</summary>

The wall energy is $2J$ times its length, so in two dimensions it grows with the wall. In one dimension a wall is a point of fixed energy $2J$, and its entropy $k\ln N$ wins at any positive temperature.
</details>

<details class="qa" markdown="1">
<summary>What are the exact critical temperature and magnetisation exponent of the square-lattice Ising model?</summary>

$kT_c=2J/\ln(1+\sqrt2)\approx2.269J$ and $\beta=1/8$.
</details>

<details class="qa" markdown="1">
<summary>Why is mean field poor in two dimensions?</summary>

It ignores the correlations of the spins over distances of order $\xi$, which become large near $T_c$. It overestimates $T_c$ and gives exponents that differ from the exact ones.
</details>
