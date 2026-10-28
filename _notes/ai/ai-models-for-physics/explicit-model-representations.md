---
collection: notes
title: Models Written as Energy Functions
date: '2026-10-27'
excerpt: A probability model written as an energy over the nodes of a graph, and why the graph tells which variables are conditionally independent.
hook: A model written as a sum of local energies defines a probability whose conditional independences can be read off the graph.
goals:
- write a probability model as a normalized exponential of an energy
- read conditional independence from the edges of a graph
- identify the Ising model as a pairwise model on a lattice
requires:
- graph
- adjacency-matrix
defines:
- id: energy-based-model
  name: energy-based model
  anchor: def-energy-based-model
- id: markov-random-field
  name: Markov random field
  anchor: def-markov-random-field
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

The graph part of the course ends with a way of putting a probability model on a graph, and the physics part begins with the same construction. The Ising energy, a Hopfield network and a Boltzmann machine are all instances.

# An energy in place of a probability

> An **energy-based model** specifies an energy function $E_\theta(x)$ over configurations $x$ and defines
{: .definition #def-energy-based-model title="Energy-based model"}

$$ p_\theta(x) = \frac{e^{-E_\theta(x)}}{Z_\theta}, \qquad Z_\theta = \sum_xe^{-E_\theta(x)}. $$

Writing the model by its energy has two advantages. Any function can be an energy, because the exponential makes the weights positive and $Z$ normalizes them, so there is no constraint on $E$ that it integrate to anything. And energies add: combining two independent sources of evidence adds their energies and multiplies their probabilities. The price is the normalization $Z_\theta$, a sum over all configurations that is rarely computable.

# Local energies and the graph

When the variables sit on the nodes of a graph, a natural class of energy functions is a sum of terms that each involve a small group of connected variables, $E(x)=\sum_cE_c(x_c)$ over cliques $c$ of the graph. Then

$$ p(x)\ \propto\ \prod_c e^{-E_c(x_c)}, $$

> A **Markov random field** is a distribution $p(x)\propto\prod_ce^{-E_c(x_c)}$ whose energy is a sum of terms $E_c$, one for each clique $c$ of a graph.
{: .definition #def-markov-random-field title="Markov random field"}

The graph carries a statement about conditional independence: given its neighbours, a variable is independent of all the others, so its conditional distribution depends only on the neighbours' values. A result named after Hammersley and Clifford states that for positive distributions the two descriptions are equivalent.

{% include fig.html src="ai-models-for-physics/markov-blanket" id="fig-markov-blanket" alt="A grid of nodes with one node highlighted and its four neighbours in a second colour; the remaining nodes are plain." caption="In a Markov random field on a grid, the conditional distribution of the highlighted node given every other node depends only on its four neighbours (shaded)." %}

The Ising model is the pairwise case on a lattice, $E(\sigma)=-J\sum_{\langle ij\rangle}\sigma_i\sigma_j-h\sum_i\sigma_i$, with one term per edge and per node. Its conditionals are exactly the heat-bath probabilities used later for Gibbs sampling, which depend on the four neighbours of a spin and nothing else.

> The graph is part of the model, not just its input. Choosing which pairs interact decides which conditional distributions are simple, and so which sampling and learning methods are cheap.
{: .idea}

# Learning and the normalization

The parameters of an energy-based model are fitted by maximizing the likelihood of data, and the gradient contains the average of the energy derivative under the model itself, because $Z_\theta$ depends on $\theta$. This averaging is the only difficult step. Everything that follows in this course is a way of approaching it: exact enumeration for a few units, mean-field approximations for large ones, and Markov chain sampling in between.

> A model with a tractable energy does not have a tractable probability. Evaluating $p_\theta(x)$ needs $Z_\theta$, while comparing two configurations needs only the difference in energy.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is an energy a convenient way to define a probability model?</summary>

The exponential makes any real-valued function a positive weight, normalization handles the rest, and energies of independent contributions simply add, so the model can be assembled from local terms.
</details>

<details class="qa" markdown="1">
<summary>What does an edge in a Markov random field assert?</summary>

A missing edge asserts that the two variables are conditionally independent given the rest. A variable depends on the others only through its neighbours.
</details>
