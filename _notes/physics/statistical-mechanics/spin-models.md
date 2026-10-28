---
collection: notes
title: Spin Models and Their Symmetries
date: '2026-10-27'
excerpt: The Ising, XY and Heisenberg models as one family of nearest-neighbour spin Hamiltonians that differ only in the symmetry of the spin.
hook: Replace the two-valued spin of the Ising model by a planar or a three-dimensional unit vector and the Hamiltonian keeps its form while the symmetry group changes, and with it the physics.
goals:
- write the Ising, XY and Heisenberg Hamiltonians as one family
- name the symmetry group of each
- say how the symmetry changes what an ordered state can do
requires:
- ising-model
- spin-configuration
- order-parameter
- partition-function
defines:
- id: xy-model
  name: XY model
  anchor: def-xy-model
- id: heisenberg-model
  name: Heisenberg model
  anchor: def-heisenberg-model
- id: continuous-symmetry
  name: continuous symmetry
  anchor: what-the-symmetry-allows
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The Ising model of the AI-models course is one of a family. A spin on each site of a lattice, coupled to its neighbours, gives a different model for each choice of what a spin is, and the choice is a statement of symmetry {% cite kardar-2007 %}.

# One Hamiltonian, three symmetries

Let each site $i$ carry an $n$-component unit vector $\mathbf s_i$, and let neighbouring spins be coupled with strength $J>0$ in a field $\mathbf h$:

$$ \mathcal H=-J\sum_{\langle ij\rangle}\mathbf s_i\cdot\mathbf s_j-\mathbf h\cdot\sum_i\mathbf s_i. $$

For $n=1$ the spin is $\pm1$ and this is the **Ising model**.

> For $n=2$ the spin lies in a plane, $\mathbf s=(\cos\phi,\sin\phi)$, and $\mathbf s_i\cdot\mathbf s_j=\cos(\phi_i-\phi_j)$: this is the **XY model**.
{: .definition #def-xy-model title="XY model"}

> For $n=3$ the spin is a unit vector in space, the **Heisenberg model**.
{: .definition #def-heisenberg-model title="Heisenberg model"}

The ground state aligns all spins; it costs energy to twist them.

{% capture t %}
| Model | Spin | Symmetry at $h=0$ | Ground states |
|---|---|---|---|
| Ising, $n=1$ | $\pm1$ | $\mathbb Z_2$: flip all spins | 2, discrete |
| XY, $n=2$ | angle $\phi$ | $O(2)$: rotate all spins | a circle |
| Heisenberg, $n=3$ | unit vector | $O(3)$: rotate all spins | a sphere |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-spin-models" caption="The $O(n)$ family of nearest-neighbour spin models." body=t %}

The Hamiltonian is unchanged if every spin is transformed by the same group element, which is the symmetry in the third column. The Ising symmetry is discrete, with two elements, while the XY and Heisenberg symmetries are **continuous**: they contain rotations by arbitrarily small angles.

# What the symmetry allows

An ordered state picks one ground state out of the set in the last column, and so breaks the symmetry. For the Ising model the choice is between two states, and a local flip of a few spins costs a fixed energy that does not depend on how large the flipped region is, as long as its boundary is short. For the XY and Heisenberg models the ground states form a continuous manifold. A slow rotation of the direction across the lattice costs almost nothing, since neighbouring spins are nearly parallel everywhere. The energy of a twist of wavenumber $k$ goes as $Jk^2$ per site, and this low cost of long-wavelength twists is the source of two results later in the course: the Goldstone modes, and the absence of order in low dimensions.

{% include fig.html src="ai-models-for-physics/ising-snapshots" id="fig-spin-snapshots" alt="Three snapshots of a two-dimensional Ising model, at low, critical and high temperature, showing a nearly uniform ordered state, large clusters of both signs, and a disordered state." caption="Configurations of the two-dimensional Ising model below, at and above the critical temperature. The XY and Heisenberg models have the same three regimes in dimensions where they order." %}

The models also differ in the number of order-parameter components, $n$, which is the variable on which critical exponents depend, together with the dimension. A fourth family member, the $n\to\infty$ spherical model, is solvable and gives the mean-field exponents above four dimensions and nontrivial ones below.

> Real magnets are not exactly in any of these classes, since lattice anisotropy picks preferred axes. An easy-axis magnet behaves as Ising, and an easy-plane magnet as XY, at temperatures where the anisotropy dominates.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>What is common to the Ising, XY and Heisenberg Hamiltonians?</summary>

Each couples neighbouring unit vectors through $-J\mathbf s_i\cdot\mathbf s_j$. They differ in the number $n$ of components of the spin, which sets the symmetry group of the Hamiltonian.
</details>

<details class="qa" markdown="1">
<summary>Which of the three has a continuous symmetry?</summary>

The XY model, with symmetry $O(2)$, and the Heisenberg model, with $O(3)$. The Ising symmetry is the discrete group $\mathbb Z_2$.
</details>

<details class="qa" markdown="1">
<summary>Why do long-wavelength twists matter for the continuous models?</summary>

A slow rotation of the spin direction changes the energy only at order $Jk^2$, so there are low-energy excitations at all long wavelengths. This is the origin of the Goldstone modes.
</details>
