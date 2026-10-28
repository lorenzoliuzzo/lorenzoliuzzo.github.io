---
collection: threads
title: "From Spins to Memories: the Ising Model, Hopfield Networks and Boltzmann Machines"
date: 2026-10-27
excerpt: "How an energy function written for magnets became the way neural networks store memories and learn distributions, and what the physics predicts about both."
route:
  - {note: physics/statistical-mechanics/03, why: "The model itself, its exact solutions in one and two dimensions, and the mean-field approximation."}
  - {note: physics/statistical-mechanics/04, why: "Why interactions of long range and dimension matter, and what an order parameter is."}
  - {note: ai/ai-models-for-physics/ising-lenz-model, why: "The model seen from the machine-learning side: a distribution over binary variables defined by an energy."}
  - {note: ai/neural-networks/hopfield-network, why: "Spins become neurons, patterns become energy minima, and recall becomes relaxation."}
  - {note: ai/ai-models-for-physics/boltzmann-machines, why: "The same energy with hidden units and noise, trained to reproduce a distribution."}
cites:
  - nobel-physics-2024
tags:
  - Physics
  - Artificial Intelligence
---

Three models, one equation. A magnet, a content-addressable memory and a generative model all assign a number, an energy, to a configuration of binary variables, and all three are best understood by asking where that energy is low. This thread follows the equation from physics into machine learning, and says at each step what carried over and what had to change. The route above lists the notes it passes through.

# A model of magnets

Lenz proposed in 1920 that a magnet could be pictured as a lattice of two-state moments that interact with their neighbours {% cite lenz-1920 %}, and his student Ising solved the one-dimensional chain exactly in 1925 {% cite ising-1925 %}. With spins $s_i=\pm1$, coupling $J$ and field $h$, the energy is

$$ E(\mathbf s) = -J\sum_{\langle ij\rangle} s_i s_j - h\sum_i s_i, \qquad p(\mathbf s)\propto e^{-E(\mathbf s)/T}. $$

The chain turned out to have no ordered phase at any temperature above zero, and for a time that made the model look like a dead end. Onsager's exact solution of the square lattice in 1944 {% cite onsager-1944 %} showed that in two dimensions the model does order below a critical temperature, so dimension decides whether a transition exists at all.

> A distribution defined by an energy, $p\propto e^{-E/T}$, is called a **Boltzmann distribution**. Low-energy configurations are the likely ones, and the temperature $T$ sets how strongly the energy is enforced.
{: .definition #def-boltzmann title="Boltzmann distribution"}

# Spins become neurons

Hopfield's 1982 paper {% cite hopfield-1982 %} keeps the energy and changes the reading. Each spin is a neuron that is on or off, the couplings $w_{ij}=w_{ji}$ are synaptic weights, and the energy is $E(\mathbf s)=-\tfrac12\sum_{i\neq j}w_{ij}s_is_j$. If neurons are updated one at a time by setting $s_i\leftarrow\operatorname{sign}\left(\sum_j w_{ij}s_j\right)$, no update can raise the energy, so the state slides downhill and stops in a local minimum. Choosing the weights so that the stored patterns $\xi^\mu$ are minima, which the Hebbian rule $w_{ij}=\frac1N\sum_\mu\xi^\mu_i\xi^\mu_j$ does approximately, turns relaxation into recall: start from a corrupted pattern and the dynamics repairs it.

What the physics adds is a capacity. With random patterns the weights of a Hopfield network look like those of a spin glass, and the statistical mechanics of spin glasses predicts that recall fails abruptly once the number of patterns exceeds about $0.14N$ for $N$ neurons {% cite amit-1985 %}. That is a statement a machine-learning argument alone would not have produced.

> With symmetric weights and no self-coupling, changing one neuron changes the energy by $-\Delta s_i\sum_j w_{ij}s_j$, which is never positive when $s_i$ is set to the sign of that sum. The energy never increases, and it is bounded below, so the dynamics must reach a fixed point.
{: .proof}

# Noise, hidden units and learning

The Hopfield network is deterministic, which is the zero-temperature limit. Keeping the temperature gives a stochastic network whose states follow the Boltzmann distribution, and adding units whose values are never observed gives a Boltzmann machine {% cite ackley-1985 %}. Learning then has a clean form: to raise the probability of the data, change each weight by the difference between how often two units are on together in the data and how often they are on together when the network runs freely,

$$ \Delta w_{ij}\;\propto\;\langle s_is_j\rangle_{\text{data}}-\langle s_is_j\rangle_{\text{model}}. $$

The second average needs samples from the model, and in a general Boltzmann machine those are expensive to get. Restricting the connections to run only between visible and hidden units makes the conditional distributions easy to sample, and the approximation known as contrastive divergence made that restricted machine practical to train {% cite hinton-2002 %}.

{% capture t %}
| | Ising model | Hopfield network | Boltzmann machine |
|---|---|---|---|
| Variables | spins | visible neurons | visible and hidden units |
| Couplings | given by the material | learned, symmetric | learned, symmetric |
| Dynamics | thermal | deterministic descent | thermal sampling |
| Asks | does it order? | which patterns are stable? | which distribution fits the data? |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-three-models" caption="The same energy function in three roles. What changes is who chooses the couplings and whether the temperature is zero." body=t %}

# Why it matters now

The two people who carried this bridge furthest, Hopfield and Hinton, shared the 2024 Nobel Prize in Physics; the committee's background document tells the story from the physics side {% cite nobel-physics-2024 %}. For this site the practical point is the order of reading. The statistical mechanics notes come first because [](#def-boltzmann) and the idea of an order parameter are what make the two machine-learning notes explicable, and [](#tab-three-models) is the map to keep in mind while reading them.

> Run [`ising_hopfield.py`]({{ '/assets/notes/threads/ising-to-boltzmann/ising_hopfield.py' | relative_url }}), which needs only numpy. In one run (200 neurons, 10% of a stored pattern's bits flipped, 20 trials) the pattern was restored in 90% of trials with 20 patterns stored, 75% with 28, 15% with 40 and none with 60, which brackets the predicted $0.14N$. Change the noise level and see where the edge moves. Its `--test` mode checks that no update raises the energy and that the 2D magnetisation vanishes above $T_c=2/\ln(1+\sqrt2)\approx2.27$.
{: .try}

# Recap

<details class="qa" markdown="1">
<summary>Why does the Hopfield network's dynamics always stop?</summary>

Each single-neuron update leaves the energy the same or lowers it, and the energy takes finitely many values, so the state cannot cycle and must reach a local minimum.
</details>

<details class="qa" markdown="1">
<summary>What does temperature do in a Boltzmann machine that it does not in a Hopfield network?</summary>

It lets the state move uphill with some probability, so the network samples a distribution instead of settling into the nearest minimum.
</details>
