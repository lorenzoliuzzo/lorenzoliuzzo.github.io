---
title: Restricted Boltzmann Machines
date: 2026-08-24
collection: notes
read_time: true
toc: true
toc_sticky: true
tags:
- Artificial Intelligence
- AI Models For Physics
goals:
- write the energy and the joint distribution of a restricted Boltzmann machine
- derive the factorized conditionals of a layer given the other
- explain what the hidden units add to the model of the visible ones
defines:
- id: boltzmann-machine
  name: Boltzmann machine
  anchor: def-boltzmann-machine
- id: restricted-boltzmann-machine
  name: restricted Boltzmann machine
  anchor: the-restriction-that-makes-it-usable
requires:
- ising-model
- boltzmann-distribution
- partition-function
- energy-based-model
excerpt: A bipartite energy-based model of binary units, whose conditionals factorize and whose marginal over the visible units is a Boltzmann distribution over a free energy.
hook: A Boltzmann machine is an Ising model whose spins are split into data and hidden units, and the restriction to a bipartite graph makes the conditionals exact.
---

Hopfield's network gave the Ising energy a job, which is to hold memories. The Boltzmann machine keeps the energy and changes what the model is trying to do: it assigns a probability to data, and the probability is learned {% cite ackley-1985 %}.

# From Ising spins to units

> A **Boltzmann machine** is a set of binary units $s_i\in\{0,1\}$ with the Ising-type energy $E(s) = -\sum_{i<j}w_{ij}s_is_j - \sum_ib_is_i$ and the distribution $P(s)\propto e^{-E(s)}$.
{: .definition #def-boltzmann-machine title="Boltzmann machine"}

The couplings $w_{ij}$ and biases $b_i$ are the parameters; units can be written as spins through $\sigma = 2s-1$. Some units are **visible**, clamped to the data, and the others are **hidden**, free to take whatever values help explain it. The distribution of the data is the marginal over the hidden units, $P(v) = \sum_hP(v,h)$, so hidden units model structure that the visible ones show only through their correlations.

With couplings between all pairs, every quantity of interest is a sum over exponentially many states and the model cannot be trained at scale.

# The restriction that makes it usable

The **restricted Boltzmann machine** (RBM) allows couplings only between a visible and a hidden unit:

$$ E(v,h) = -a^{\top}v - b^{\top}h - v^{\top}Wh, \qquad P(v,h) = \frac{e^{-E(v,h)}}{Z}. $$

The graph is bipartite, so given $v$ the hidden units are independent, and given $h$ the visible units are independent:

$$ P(h_j=1\mid v) = \sigma\!\Big(b_j + \sum_iv_iW_{ij}\Big), \qquad P(v_i=1\mid h) = \sigma\!\Big(a_i + \sum_jW_{ij}h_j\Big), $$

with $\sigma$ the logistic function. Each layer can therefore be resampled in one parallel step, which is the basis of the training methods in the following notes.

{% include fig.html src="ai-models-for-physics/rbm-graph" id="fig-rbm-graph" alt="Two rows of circles, visible units below and hidden units above, with a line between every visible and every hidden unit and none within a row." caption="The RBM graph. Every visible unit couples to every hidden unit through $W$; units in one layer do not couple, so each layer is conditionally independent given the other." %}

> The visible marginal has a closed form up to $Z$: $P(v)\propto e^{a^{\top}v}\prod_j\big(1+e^{b_j+(W^{\top}v)_j}\big)$. Summing out the hidden units is exact, and only the normalization $Z$ remains intractable.
{: .idea}

# What the hidden units add

A model of the visible units alone, with pairwise couplings, can represent only second-order correlations. A hidden unit that connects to several visible units acts as a feature detector: it turns on when a pattern of visible units appears, and the product over hidden units in $P(v)$ then represents higher-order structure. The number of hidden units sets the capacity, and the model class is rich enough that an RBM with enough hidden units can represent any distribution over binary vectors.

The partition function remains the obstacle. It is a sum over all $(v,h)$, so for realistic sizes the likelihood cannot be evaluated and the gradient of the log-likelihood has to be estimated by sampling.

> A trained RBM does not memorize examples. Its probability is spread over every configuration that activates the learned features, including combinations that were never in the training set.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does restricting the couplings to a bipartite graph help?</summary>

Units in one layer then have no direct couplings among themselves, so their conditional distribution given the other layer factorizes and a whole layer can be sampled at once. It also allows the hidden units to be summed out exactly.
</details>

<details class="qa" markdown="1">
<summary>What is the role of the hidden units in modelling the data?</summary>

They represent features that explain correlations among the visible units, and summing them out produces a visible distribution with interactions of higher order than the pairwise couplings of the energy.
</details>
