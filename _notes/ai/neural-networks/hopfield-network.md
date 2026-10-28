---
collection: notes
title: "Hopfield Network"
date: 2026-10-27
excerpt: "Patterns stored as energy minima, recall as relaxation from a corrupted cue, the Hebbian rule and the capacity limit."
hook: "A Hopfield network stores patterns as minima of an energy function, so recalling a memory is just letting the network roll downhill from a corrupted cue."
goals:
  - write the energy of a Hopfield network and show that asynchronous updates never raise it
  - store patterns with the Hebbian rule and explain the crosstalk that limits capacity
  - name the kinds of spurious states and the capacity at which recall breaks down
requires:
  - artificial-neuron
defines:
  - {id: hopfield-network, name: Hopfield network, anchor: def-hopfield-network}
  - {id: hebbian-rule, name: Hebbian rule, anchor: storing-patterns}
  - {id: storage-capacity, name: storage capacity, anchor: def-storage-capacity}
  - {id: spurious-state, name: spurious state, anchor: capacity-and-spurious-states}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

Every network so far computes an output from an input in one pass. A Hopfield network instead settles: it is a recurrent system of binary neurons whose states evolve until they stop, and the state where they stop is the answer. The physics behind it, and what it shares with the Ising model, is followed in the thread [From Spins to Memories]({{ '/threads/ising-to-boltzmann/' | relative_url }}).

# Energy and dynamics

> A **Hopfield network** has $N$ neurons with states $s_i=\pm1$ and symmetric weights $w_{ij}=w_{ji}$ with $w_{ii}=0$.
{: .definition #def-hopfield-network title="Hopfield network"}

Its energy is

$$ E(s)=-\tfrac12\sum_{i\neq j}w_{ij}s_is_j, $$

and the dynamics visit the neurons one at a time, setting $s_i\leftarrow\operatorname{sign}\big(\sum_jw_{ij}s_j\big)$. Changing $s_i$ changes the energy by $-\Delta s_i\sum_jw_{ij}s_j$, which is zero or negative when $s_i$ takes the sign of that sum, so no update raises the energy. The energy takes finitely many values, so the network cannot cycle and reaches a fixed point, a local minimum of $E$ {% cite hopfield-1982 %}. This is the form of a neuron from the [introduction]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}), a weighted vote followed by a threshold, with every neuron's output fed back to the others.

> The symmetry of the weights is what guarantees convergence. With asymmetric weights the dynamics can oscillate forever, and no energy function exists.
{: .trap}

# Storing patterns

To use the network as a memory, choose the weights so that the patterns $\xi^\mu\in\{\pm1\}^N$, $\mu=1,\dots,p$, are fixed points. The **Hebbian rule** does this approximately:

$$ w_{ij}=\frac1N\sum_{\mu=1}^p\xi_i^\mu\xi_j^\mu\quad(i\neq j). $$

With one pattern, $\sum_jw_{ij}\xi_j=\xi_i\cdot\frac1N\sum_j\xi_j^2\approx\xi_i$, so the pattern is stable, and a state with a few flipped bits is repaired because the weighted vote of the other neurons points back to the stored value. With several patterns the local field on neuron $i$ in state $\xi^\nu$ is

$$ h_i=\xi_i^\nu+\frac1N\sum_{\mu\neq\nu}\sum_j\xi_i^\mu\xi_j^\mu\xi_j^\nu, $$

the wanted term plus **crosstalk** from the other patterns. For random patterns the crosstalk has mean zero and a standard deviation of about $\sqrt{p/N}$, so it is harmless while $p\ll N$ and begins to flip bits as $p$ grows.

# Capacity and spurious states

The statistical mechanics of spin glasses makes this precise. Retrieval of a stored pattern is possible only while $p\lesssim0.14\,N$; above that the network falls into states that resemble no stored pattern {% cite amit-1985 %}.

> This number is the **storage capacity**: a network of 1,000 neurons holds about 140 random patterns, far fewer than the $2^{1000}$ states it has.
{: .definition #def-storage-capacity title="Storage capacity"}

Not every minimum of $E$ is a stored pattern. The energy is unchanged when all spins flip, so $-\xi^\mu$ is a minimum whenever $\xi^\mu$ is. Mixtures of an odd number of patterns, taking the sign of their sum, are also minima, and at larger loads there are minima unrelated to any pattern. These **spurious states** are where a corrupted cue can end up.

{% capture t %}
| Load $p/N$ | What happens |
|---|---|
| near 0 | each pattern is a deep minimum; recall is almost exact |
| about 0.05 | patterns remain minima, mixtures and reversed patterns also exist |
| above about 0.14 | retrieval fails, the network ends in spurious states |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-hopfield-load" caption="Behaviour of the Hebbian Hopfield network as the number of random patterns grows relative to the number of neurons." body=t %}

The limit is a property of the Hebbian rule and of random patterns. Correlated patterns do worse, and rules that fit the weights to the patterns directly, or networks with continuous states and sharper energies, hold more. What carries over is the picture: memory as an energy landscape and recall as descent.

> Run the simulation in the thread's script with 200 neurons and watch recall drop between 20 and 40 stored patterns, then relate the load at which it breaks to the $0.14N$ figure.
{: .try}

A direct simulation shows how storage degrades as patterns are added.

{% include fig.html src="neural-networks/hopfield-capacity" id="fig-hopfield-capacity" alt="A curve of the share of restored patterns against load p/N, near one at low load and collapsing around 0.14." caption="Recall success of a Hopfield network of 100 neurons against load. Recall is reliable up to a load of about 0.1 and falls away around the theoretical 0.138; with only 100 neurons the drop is smoothed." %}

# Recap

<details class="qa" markdown="1">
<summary>Why does asynchronous updating always end in a fixed point?</summary>

Each update leaves the energy unchanged or lowers it, the energy takes only finitely many values, and the weights are symmetric so an energy function exists. The state cannot cycle, so it reaches a local minimum.
</details>

<details class="qa" markdown="1">
<summary>Where does the capacity limit come from?</summary>

Each stored pattern adds crosstalk to the local field of every neuron. As the number of patterns grows relative to the number of neurons, the crosstalk becomes large enough to flip bits of a stored pattern, and retrieval fails near $p\approx0.14N$.
</details>
