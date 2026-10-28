---
collection: notes
title: "Commutators and Uncertainty"
date: 2026-10-27
excerpt: "Commutators, compatible observables and the Robertson uncertainty relation."
hook: "Two observables that do not commute cannot both be sharp, and the product of their spreads is bounded below by the size of their commutator."
goals:
  - compute a commutator and decide whether observables can be measured together
  - derive and apply the Robertson uncertainty relation
requires:
  - observable
  - hermitian-operator
defines:
  - {id: commutator, name: "commutator", anchor: def-commutator}
  - {id: compatible-observables, name: "compatible observables", anchor: def-compatible-observables}
  - {id: uncertainty-relation, name: "uncertainty relation", anchor: def-uncertainty-relation}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

Two observables are not always measurable together. Whether they are is decided by one algebraic object, the commutator, and the same object bounds how sharp both can be at once.

# Commutators

> The **commutator** of two operators is $[A,B]=AB-BA$. It vanishes exactly when the order of the operators does not matter.
{: .definition #def-commutator title="Commutator"}

Some properties are used constantly: $[A,B]=-[B,A]$, linearity, the Leibniz rule $[A,BC]=[A,B]C+B[A,C]$, and $[A,B]^\dagger=[B^\dagger,A^\dagger]$, so the commutator of two Hermitian operators is anti-Hermitian and $-i[A,B]$ is Hermitian. For the Pauli operators, $[X,Y]=2iZ$ and cyclic permutations, which is the algebra of rotations.

> Two observables are **compatible** if they commute. Then they have a common eigenbasis, can be measured in either order without disturbing each other, and a state can have a sharp value for both.
{: .definition #def-compatible-observables title="Compatible observables"}

The argument is the spectral theorem for commuting Hermitian matrices: $B$ maps each eigenspace of $A$ into itself, so it can be diagonalised inside each one, giving a joint basis. This is why the labels of a hydrogen state, energy, angular momentum and its projection, are quantum numbers that can be quoted together.

# The uncertainty relation

> **Robertson uncertainty relation.** For observables $A,B$ and any state, $\Delta A\,\Delta B\ge\frac12\big|\langle[A,B]\rangle\big|$.
{: .theorem #def-uncertainty-relation title="Robertson uncertainty relation"}

> Apply the Cauchy-Schwarz inequality to the deviation vectors $|a\rangle=(A-\langle A\rangle)|\psi\rangle$ and $|b\rangle=(B-\langle B\rangle)|\psi\rangle$, whose norms are $\Delta A$ and $\Delta B$:
> $$ \Delta A^2\Delta B^2=\langle a|a\rangle\langle b|b\rangle\ge|\langle a|b\rangle|^2\ge\big(\mathrm{Im}\langle a|b\rangle\big)^2=\tfrac14\big|\langle[A,B]\rangle\big|^2. $$
> The last step uses that the imaginary part of $\langle a|b\rangle$ is $\frac1{2i}\langle[A,B]\rangle$.
{: .proof}

For position and momentum, $[x,p]=i\hbar$ gives $\Delta x\,\Delta p\ge\hbar/2$. A Gaussian wavepacket reaches equality; other states lie above it. In an infinite well of width $L$ the $n$th state has $\Delta x\,\Delta p=\frac\hbar2\sqrt{n^2\pi^2/3-2}$, which is $0.568\,\hbar$ for $n=1$, $1.67\,\hbar$ for $n=2$ and $2.63\,\hbar$ for $n=3$.

{% include fig.html src="quantum-theory/uncertainty-bound" id="fig-uncertainty-bound" alt="Plot of momentum spread against position spread with a hyperbola marking the minimum, a shaded forbidden region below it, a point on the curve for a Gaussian and three points above for the well states." caption="The uncertainty plane. The shaded region $\Delta x\,\Delta p<\hbar/2$ is forbidden. A Gaussian packet lies on the boundary, and the states of an infinite well lie above it with a product that grows with $n$." %}

> The bound depends on the state when the commutator is an operator: for spin, $[S_x,S_y]=i\hbar S_z$ gives $\Delta S_x\Delta S_y\ge\frac\hbar2|\langle S_z\rangle|$, which vanishes in a state with $\langle S_z\rangle=0$. There the relation allows both spreads to be small.
{: .remark}

> The relation is not about measurement disturbing the system. It is a statement about the spreads of results in identically prepared copies, each measured once for $A$ or for $B$. A state with small $\Delta x$ has large $\Delta p$ in its own right, as the Fourier relation of the next note shows.
{: .trap}

> To decide whether two quantities can be sharp together, compute their commutator. To bound their spreads, evaluate $\frac12|\langle[A,B]\rangle|$ in the state.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What does it mean for two observables to commute?</summary>

They share an eigenbasis, so there are states with a definite value of both and their measurements do not disturb one another.
</details>

<details class="qa" markdown="1">
<summary>State and justify the Robertson relation.</summary>

$\Delta A\Delta B\ge\frac12|\langle[A,B]\rangle|$. It follows from the Cauchy-Schwarz inequality applied to the deviation vectors $(A-\langle A\rangle)|\psi\rangle$ and $(B-\langle B\rangle)|\psi\rangle$.
</details>

<details class="qa" markdown="1">
<summary>Does a Gaussian wavepacket saturate $\Delta x\Delta p\ge\hbar/2$?</summary>

Yes, it is the minimum-uncertainty state. A particle in an infinite well does not: its product is $0.568\hbar$ in the ground state and grows with the level.
</details>
