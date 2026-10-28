---
collection: notes
title: Broken Symmetry and the Order Parameter
date: '2026-10-27'
excerpt: Why a finite system never breaks a symmetry, the order of limits that defines spontaneous symmetry breaking, and how an order parameter encodes what is broken.
hook: The Hamiltonian of a magnet is symmetric under flipping all spins and the equilibrium state below Tc is not, and the way this is possible is that the thermodynamic limit is taken before the field is switched off.
goals:
- explain why spontaneous symmetry breaking needs an infinite system
- state the order of limits that defines it
- choose an order parameter that transforms nontrivially under the broken symmetry
requires:
- order-parameter
- ising-model
- ergodic-hypothesis
- xy-model
- thermodynamic-limit
defines:
- id: spontaneous-symmetry-breaking
  name: spontaneous symmetry breaking
  anchor: def-spontaneous-symmetry-breaking
- id: symmetry-breaking-field
  name: symmetry-breaking field
  anchor: def-symmetry-breaking-field
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The Ising Hamiltonian at zero field is unchanged by flipping every spin. Yet a magnet below its critical temperature has a magnetisation, which the flip reverses. The state has less symmetry than the law that governs it, and the way this can be consistent is worth stating exactly {% cite kardar-2007 %}.

# A symmetric Hamiltonian, an asymmetric state

For a finite system the canonical average of the magnetisation at zero field is exactly zero. The Boltzmann weights of a configuration and its flipped partner are equal, so the contributions to $\langle M\rangle=\sum_sM(s)e^{-\beta\mathcal H(s)}/Z$ cancel in pairs. The sum is finite, the symmetry is exact, and nothing is broken, even at very low temperature: the system spends half of its time in each of the two ordered states, as the ergodic hypothesis requires.

This is the finite-size picture. In a macroscopic magnet the time to flip from one ordered state to the other grows exponentially with the system size, and the observed system is in one of them. A real magnet is described by the ensemble restricted to that state.

> **Spontaneous symmetry breaking** is the situation in which the equilibrium state of a large system has less symmetry than the Hamiltonian, so that the symmetry is realised by a family of equivalent states and not by each state.
{: .definition #def-spontaneous-symmetry-breaking title="Spontaneous symmetry breaking"}

# The order of limits

The precise definition adds a small field and takes limits in a fixed order.

> Add a **symmetry-breaking field** $h$ coupled to the order parameter, and define
{: .definition #def-symmetry-breaking-field title="Symmetry-breaking field"}

$$ m_0=\lim_{h\to0^+}\ \lim_{N\to\infty}\ \frac{\langle M\rangle_{h}}{N}. $$

The limit $N\to\infty$ is taken first at fixed $h$, which selects the state favoured by the field. Only afterwards is $h\to0$. The result is non-zero below $T_c$. Taking the limits in the other order, $h\to0$ at fixed finite $N$ first, gives zero, because for any finite $N$ the magnetisation is an analytic odd function of $h$.

{% capture t %}
| Order | Procedure | Result below $T_c$ |
|---|---|---|
| $N\to\infty$, then $h\to0$ | thermodynamic limit at $h\neq0$, then remove the field | $m_0\neq0$ |
| $h\to0$, then $N\to\infty$ | remove the field in a finite system | $0$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-order-of-limits" caption="The two orders of limits and what they give for the magnetisation." body=t %}

> Symmetry breaking is a statement about infinite systems, not about a given sample. It is the reason phase transitions need the thermodynamic limit: singularities of the free energy appear only there.
{: .idea}

# What the order parameter records

The **order parameter** is a quantity that is zero in the symmetric phase and non-zero in the broken one. It is chosen so that it transforms under the broken symmetry: the Ising magnetisation changes sign under the spin flip, and the planar magnetisation of the XY model rotates through the same angle as the spins. The order parameter's symmetry thus says which symmetry was broken, and the set of its values in the ordered phase is the set of equivalent ground states, called the **vacuum manifold**.

{% capture t2 %}
| System | Broken symmetry | Order parameter | Values in the ordered phase |
|---|---|---|---|
| Ising magnet | $\mathbb Z_2$ | scalar $m$ | two points |
| XY magnet | $O(2)$ | planar vector | a circle |
| Heisenberg magnet | $O(3)$ | vector $\mathbf m$ | a sphere |
| Liquid-gas | none | density difference | two points (for $T<T_c$) |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-order-parameters" caption="Order parameters and their ordered-phase values for common systems." body=t2 %}

The liquid-gas case has no broken symmetry, which is why its order parameter is not tied to a symmetry; it shares the critical behaviour of the Ising model because the effective description has the same $\mathbb Z_2$ form near $T_c$. The ordered phase of a continuous-symmetry system has a manifold of equivalent states, and moving along that manifold costs no energy. The consequences, the Goldstone modes, are the subject of the part on continuous symmetry.

> The order parameter is not unique. Any function that is zero in the symmetric phase and transforms like $m$ will serve. What is fixed is its symmetry.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does a finite system never break a symmetry?</summary>

The Boltzmann weights of a configuration and its image under the symmetry are equal, so the canonical average of any order parameter that changes sign is exactly zero.
</details>

<details class="qa" markdown="1">
<summary>What is the order of limits in the definition of spontaneous symmetry breaking?</summary>

First the thermodynamic limit at a small fixed symmetry-breaking field, then the field to zero. The opposite order gives zero.
</details>

<details class="qa" markdown="1">
<summary>What does the order parameter tell us about the broken symmetry?</summary>

Its transformation under the symmetry shows what was broken, and the set of its ordered-phase values is the vacuum manifold of equivalent states.
</details>
