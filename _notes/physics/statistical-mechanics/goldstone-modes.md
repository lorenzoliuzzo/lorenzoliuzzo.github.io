---
collection: notes
title: Goldstone Modes
date: '2026-10-27'
excerpt: Why breaking a continuous symmetry leaves gapless excitations, seen in the Mexican-hat free energy and in the spin waves of an XY or Heisenberg magnet.
hook: If the ordered state can be rotated at no energy cost, then a slow rotation costs almost none, and the result is an excitation whose energy goes to zero as its wavelength goes to infinity.
goals:
- show with a Mexican-hat free energy that a broken continuous symmetry has a flat direction
- derive the energy of a long-wavelength twist and the resulting spin-wave stiffness
- state how many Goldstone modes there are and what they imply for the ordered phase
requires:
- continuous-symmetry
- spontaneous-symmetry-breaking
- landau-free-energy
- normal-modes
- xy-model
defines:
- id: goldstone-mode
  name: Goldstone mode
  anchor: a-flat-direction-in-the-free-energy
- id: spin-stiffness
  name: spin stiffness
  anchor: def-spin-stiffness
tags:
- Physics
- Statistical Mechanics
read_time: true
---

When a continuous symmetry is broken, the order parameter has a whole manifold of equivalent values. Moving along it costs nothing, and this has a precise dynamical consequence {% cite kardar-2007 %}.

# A flat direction in the free energy

Take an XY order parameter with two components, a complex number $\psi=|\psi|e^{i\theta}$. The Landau free energy invariant under rotations of $\theta$ depends only on $|\psi|$:

$$ f(\psi)=\tfrac12r|\psi|^2+\tfrac14u|\psi|^4. $$

For $r<0$ the minimum is on the ring $|\psi|=\sqrt{-r/u}$, so the free energy has the shape of a Mexican hat. Choosing a point on the ring breaks the symmetry. Two directions in the field space are then different. The radial direction has a restoring force, with a curvature set by $|r|$: the excitation is massive and costs a finite energy at any wavelength. The angular direction along the ring is flat: shifting the phase $\theta$ uniformly changes nothing.

{% include fig.html src="statistical-mechanics/goldstone-ring" id="fig-goldstone-ring" alt="On the left a double-well potential in one component. On the right a circle of minima with a radial arrow and an arrow along the circle." caption="The Mexican-hat free energy. Left: a cross-section through the centre, a double well. Right: the ring of minima. Motion along the ring is free, a Goldstone mode; motion across it has a restoring force." %}

# The cost of a slow twist

A uniform rotation costs nothing, but a spatially varying $\theta(\mathbf x)$ does, because the gradient term couples neighbouring regions. For slow variation, the free energy to second order in the gradient is

$$ F[\theta]=\frac{\rho_s}{2}\int d^dx\,|\nabla\theta|^2, $$

> The coefficient $\rho_s$ in $F[\theta]=\frac{\rho_s}{2}\int d^dx\,|\nabla\theta|^2$ is the **spin stiffness**: the free-energy cost of a twist per unit gradient squared.
{: .definition #def-spin-stiffness title="Spin stiffness"}

In the lattice model with coupling $J$ and neighbour spacing $a$, $\rho_s=J\,a^{2-d}$ at zero temperature. Writing the angle in Fourier modes, each has energy $\tfrac12\rho_sk^2|\theta_{\mathbf k}|^2$. The energy goes to zero as $k\to0$: the excitations have no gap. By equipartition the mean square amplitude of a mode is

$$ \langle|\theta_{\mathbf k}|^2\rangle=\frac{kT}{\rho_s\,k^2}\,\frac1V. $$

For an XY or Heisenberg ferromagnet these excitations are spin waves, the long-wavelength deviations of the spin direction, and in the ferromagnet their frequency grows as $\omega\propto k^2$, while in antiferromagnets and in superfluids it grows linearly with $k$. The type of dispersion depends on the dynamics, not on the thermodynamics.

# Counting modes and consequences

For a symmetry group $G$ broken down to a subgroup $H$, there is a Goldstone mode for every broken generator, in the usual case, so the number is $\dim G-\dim H$. Breaking $O(2)$ completely leaves one mode, the phase $\theta$. Breaking $O(3)$ to $O(2)$ in the Heisenberg magnet leaves two, the two angles of the spin direction. In a ferromagnet the two modes pair into one with $\omega\propto k^2$, so the counting of physical modes then needs care.

{% capture t %}
| Broken symmetry | Remaining | Broken generators | Example |
|---|---|---|---|
| $O(2)\to$ nothing | none | 1 | XY magnet, superfluid |
| $O(3)\to O(2)$ | rotations about $\mathbf m$ | 2 | Heisenberg magnet |
| $\mathbb Z_2\to$ nothing | none | 0 (discrete) | Ising magnet |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-goldstone-count" caption="Goldstone modes for common patterns of symmetry breaking." body=t %}

The Ising case has no Goldstone mode: the broken symmetry is discrete, nothing is continuous to rotate, and the domain wall is sharp. The gapless modes of the continuous case carry a thermal weight at all wavelengths, which is why they matter for the heat capacity at low temperature, $C\propto T^{d/2}$ for ferromagnetic magnons, and why, as the next note shows, they can destroy order in low dimensions.

> Goldstone modes are massless only if the interactions are short-range. With long-range forces, as for the Coulomb interaction in a superconductor, the mode is gapped, which is the Higgs mechanism in its condensed-matter form.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is the angular direction of the Mexican hat flat?</summary>

The free energy depends only on $|\psi|$, so any value of the phase $\theta$ on the ring is a minimum. Shifting the phase costs no energy.
</details>

<details class="qa" markdown="1">
<summary>What is the spin stiffness?</summary>

The coefficient $\rho_s$ in $F=\tfrac{\rho_s}2\int|\nabla\theta|^2$, the energy cost of a slow twist of the order parameter. A mode of wavenumber $k$ costs $\tfrac12\rho_sk^2$ per unit amplitude squared.
</details>

<details class="qa" markdown="1">
<summary>How many Goldstone modes are there?</summary>

One per broken generator of a continuous symmetry, for example one for $O(2)$ and two for $O(3)\to O(2)$. None for a discrete symmetry.
</details>
