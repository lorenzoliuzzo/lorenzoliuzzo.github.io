---
collection: notes
title: The Hopfield Network as a Spin Glass
date: '2026-10-27'
excerpt: Hebbian couplings as an Ising model, the storage capacity near 0.138 and the retrieval, glass and paramagnet phases.
hook: A Hopfield network is an Ising model whose couplings are built from stored patterns, and its capacity is a phase transition rather than an engineering limit.
goals:
- write the energy of a Hopfield network built with the Hebb rule as an Ising model
- explain why retrieval fails at a critical storage load
- describe the retrieval, spin-glass and paramagnetic phases
requires:
- hopfield-network
- storage-capacity
- ising-model
- partition-function
defines:
- id: spin-glass
  name: spin glass
  anchor: def-spin-glass
- id: retrieval-phase
  name: retrieval phase
  anchor: def-retrieval-phase
- id: replica-method
  name: replica method
  anchor: def-replica-method
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

The Hopfield network was introduced as a model of memory {% cite hopfield-1982 %}. Read as a physical system it is an Ising model whose couplings were set by the data, and the question of how many patterns it can hold becomes a question about a phase transition.

# Hebbian couplings are an Ising model

Store $p$ random patterns $\xi^\mu\in\{\pm1\}^N$ with the Hebb rule, $J_{ij} = \frac1N\sum_\mu\xi^\mu_i\xi^\mu_j$. The network state $\sigma$ has the energy

$$ E(\sigma) = -\tfrac12\sum_{i\neq j}J_{ij}\sigma_i\sigma_j, $$

so retrieving a pattern is the search for a low-energy configuration, and the dynamics that update spins are the Metropolis or heat-bath dynamics of the earlier notes at some temperature. Each stored pattern is close to a local minimum, because $J_{ij}$ contains a term that favours exactly its alignment. The ratio $\alpha = p/N$ is the storage load.

For a single pattern the couplings are ferromagnetic after a gauge change $\sigma_i\to\xi_i\sigma_i$. With many patterns the other terms act like random couplings of both signs.

# Frustration and the spin glass

A set of couplings with random signs cannot be satisfied everywhere: around a loop of spins the product of the signs may require an inconsistent assignment, a situation called **frustration**.

> A system with frustrated random couplings is a **spin glass**.
{: .definition #def-spin-glass title="Spin glass"}

Its energy landscape has a very large number of local minima that are unrelated to any stored pattern, the *spurious states* of the Hopfield network, and which the dynamics can fall into.

> Capacity is not a design flaw that a smarter learning rule removes within the Hebb rule. It is the point at which the cross-talk between stored patterns grows large enough to create a glassy landscape.
{: .idea}

# The phase diagram

The statistical mechanics of this model was solved with the replica method by Amit, Gutfreund and Sompolinsky {% cite amit-1985 %}.

> The **replica method** averages $\ln Z$ over the random patterns by computing $\overline{Z^n}$ for integer $n$ and continuing to $n\to0$ with $\ln Z = \lim_{n\to0}(Z^n-1)/n$; it is the standard tool for disordered systems, with assumptions about the structure of the solution.
{: .definition #def-replica-method title="Replica method"}

In the $(\alpha, T)$ plane there are three regions.

> In the **retrieval phase** the network has a state with a macroscopic overlap $m>0$ with a stored pattern.
{: .definition #def-retrieval-phase title="Retrieval phase"}

In the **spin-glass phase** the minima are frozen but unrelated to any pattern, $m=0$ with nonzero order. In the **paramagnetic phase** thermal motion destroys all structure. At zero temperature the retrieval phase ends at the storage capacity $\alpha_c\approx0.138$, and the paramagnetic boundary is $T_g = 1+\sqrt\alpha$ in units where the pattern coupling is 1.

{% include fig.html src="ai-models-for-physics/hopfield-phase-diagram" id="fig-hopfield-phase-diagram" alt="Plane of storage load on the horizontal axis and temperature on the vertical axis with a curve rising from one at zero load, a shaded retrieval region near zero load and a vertical dashed line at 0.138." caption="Sketch of the Hopfield phase diagram. The curve is $T_g=1+\sqrt\alpha$ of Amit, Gutfreund and Sompolinsky. The retrieval region is bounded on the right by $\alpha_c\approx0.138$; its upper boundary is drawn only schematically." %}

The transition at $\alpha_c$ is discontinuous: just below it the network retrieves with overlap close to 1, and just above it the retrieval states have disappeared and nothing smooth takes their place. This matches the simulated drop in the recall rate of the neural-network note.

# A hard limit and a use for it

Because the limit comes from the Hebb rule and the landscape it produces, not from the dynamics, no local update rule recovers patterns past $\alpha_c$. A method that crosses barriers instead of climbing around them is the only place left to look, which is the role quantum tunnelling plays in the annealing experiments of the project that goes with this course.

# Recap

<details class="qa" markdown="1">
<summary>Why do the stored patterns stop being retrievable above the critical load?</summary>

The cross-talk between patterns acts as random couplings, and when there are enough of them the landscape turns into a spin glass with many minima unrelated to the patterns. The retrieval states cease to be local minima.
</details>

<details class="qa" markdown="1">
<summary>What distinguishes the spin-glass phase from the paramagnet?</summary>

In the spin glass the spins are frozen into a disordered pattern with no overlap with any memory, while in the paramagnet thermal fluctuations destroy that freezing as well.
</details>
