---
collection: notes
title: Mean-Field Theory of the Ising Model
date: '2026-10-27'
excerpt: The product-state approximation, the self-consistency equation and what it gets wrong near the transition.
hook: Mean field is a variational family in which every spin is independent, and its failure near the critical point is exactly the failure of a fully-factored approximation to a correlated distribution.
goals:
- derive the self-consistency equation
- explain why mean field misplaces the critical point
requires:
- boltzmann-distribution
- ising-model
- free-energy
defines:
- id: mean-field-approximation
  name: mean-field approximation
  anchor: def-mean-field-approximation
- id: self-consistency-equation
  name: self-consistency equation
  anchor: the-self-consistency-equation
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

The partition function of the Ising model cannot be summed for a large lattice, so we look for the best distribution in a family whose sums are easy. The simplest such family has every spin independent.

# A factorized family

> The **mean-field approximation** replaces the Boltzmann distribution by $q(\sigma) = \prod_i q_i(\sigma_i)$, with $q_i(\sigma_i) = (1+m_i\sigma_i)/2$, so that $m_i$ is the mean of spin $i$.
{: .definition #def-mean-field-approximation title="Mean-field approximation"}

Among distributions, the Boltzmann one minimizes the variational free energy $\langle E\rangle_q - k_BT\,S[q]$, and it is therefore bounded above by the value of that functional on any $q$. Minimizing within the factorized family gives the best product distribution.

For a uniform lattice of coordination number $z$ and $m_i = m$, the energy is $\langle E\rangle = -\tfrac{N}{2}zJm^2 - Nhm$, the entropy is that of $N$ independent spins with bias $m$, and stationarity with respect to $m$ gives the result of the next section. The same statement in the language of inference: the mean-field posterior is a fully factorized approximation, which is cheap and which underestimates correlations.

# The self-consistency equation

Setting the derivative to zero yields

$$ m = \tanh\!\big[\beta(zJm + h)\big]. $$

Each spin responds to the average field of its neighbours, and the average must reproduce itself, which is why the equation is called self-consistent. At $h=0$ the trivial solution $m=0$ always exists, and a nonzero solution appears when the slope of the right-hand side at the origin, $\beta zJ$, exceeds 1, giving $k_BT_{\rm MF} = zJ$.

{% include fig.html src="ai-models-for-physics/mean-field-solution" id="fig-mean-field-solution" alt="Plot of tanh curves of different slopes against the diagonal line y equals m, intersecting at nonzero m when the slope exceeds one." caption="Graphical solution of $m=\tanh(\beta zJm)$. For slope below 1 the only intersection is $m=0$; above 1 two symmetric nonzero solutions appear and $m=0$ becomes unstable." %}

# Where it fails

The predicted $T_{\rm MF} = zJ/k_B$ is $4J/k_B$ on the square lattice, against the exact $2.269\,J/k_B$ {% cite onsager-1944 %}. In one dimension it gives $2J/k_B$ although there is no transition at all {% cite ising-1925 %}. The error is largest where fluctuations matter most. The approximation ignores correlations between neighbours, which are small at high temperature and long-ranged near the transition, and in low dimension that is exactly the region where they decide the outcome.

{% capture t %}
| Lattice | $k_BT_c/J$ exact | $k_BT_c/J$ mean field |
|---|---:|---:|
| Chain | no transition | $2$ |
| Square | $2.269$ | $4$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-mf-vs-exact" caption="Mean field overestimates the critical temperature, and more so in low dimension." body=t %}

> A mean-field prediction of a transition is evidence about the ordered phase, not about whether one exists. The one-dimensional chain is the counterexample.
{: .trap}

The failure carries over to learning. A fully factorized variational posterior misses dependence between variables, so a model fitted with it underestimates uncertainty precisely when variables are strongly coupled. Mean field is still the zeroth-order result, and exact in the limit of infinite coordination number, where each spin has so many neighbours that fluctuations of their sum average out.

# Recap

<details class="qa" markdown="1">
<summary>Why is the mean-field free energy an upper bound?</summary>

The Boltzmann distribution minimizes the variational free energy over all distributions, so any restricted family, such as products of single-spin distributions, can only give a value at or above the true free energy.
</details>

<details class="qa" markdown="1">
<summary>Why does mean field predict a transition in one dimension?</summary>

It replaces the fluctuating neighbours by their average and so removes the entropy of domain walls, which is what destroys order in a chain. With that mechanism missing, the self-consistency equation finds a magnetized solution below $T = 2J/k_B$.
</details>
