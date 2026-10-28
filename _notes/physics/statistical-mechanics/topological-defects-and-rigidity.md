---
collection: notes
title: Topological Defects, Rigidity and Metastability
date: '2026-10-27'
excerpt: Vortices and their winding number, the energy and entropy balance that ends quasi-long-range order, generalized rigidity of ordered phases, and why a defect cannot simply be removed.
hook: A vortex in an XY magnet cannot be undone by any local change of the spins, because it has a winding number that is conserved, and that single fact accounts for persistent currents and for a phase transition without an order parameter.
goals:
- define the winding number of a vortex and show it is conserved
- compare the energy and entropy of a vortex to find the Kosterlitz-Thouless temperature
- explain generalized rigidity and metastability for ordered phases
requires:
- spontaneous-symmetry-breaking
- goldstone-mode
- spin-stiffness
- quasi-long-range-order
- first-order-transition
defines:
- id: topological-defect
  name: topological defect
  anchor: def-topological-defect
- id: winding-number
  name: winding number
  anchor: def-winding-number
- id: generalized-rigidity
  name: generalized rigidity
  anchor: def-generalized-rigidity
- id: metastability
  name: metastability
  anchor: def-metastability
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The Goldstone modes describe small smooth twists of the order parameter. There are also large configurations that cannot be reached by any smooth deformation, and these are the defects.

# Vortices and the winding number

In a two-dimensional XY magnet, follow the spin angle $\theta(\mathbf x)$ around a closed loop. Since the spin must come back to itself, the angle changes by a multiple of $2\pi$:

$$ \oint\nabla\theta\cdot d\mathbf l=2\pi n,\qquad n\in\mathbb Z. $$

> The integer $n$ is the **winding number** of the loop.
{: .definition #def-winding-number title="Winding number"}

> A configuration with $n\neq0$ around a point has a singular centre, a **topological defect** called a vortex.
{: .definition #def-topological-defect title="Topological defect"}

The winding number depends only on the configuration at the boundary of the loop, so it cannot change when the spins inside are modified smoothly, and shrinking the loop to a point is impossible without a singularity. The defect is protected by the topology of the order-parameter space, a circle, and it can only be removed by moving it out of the sample or annihilating it with a defect of opposite winding.

{% include fig.html src="statistical-mechanics/xy-vortex" id="fig-vortex" alt="Two grids of small arrows representing XY spins around a central point. In the left grid the arrows circulate around the centre, in the right grid they point outwards, and both have the same winding number." caption="Two vortex configurations of the XY model. They look different but both turn through $2\pi$ around the centre, so both have winding number $+1$. The winding number counts rotations, not the pattern." %}

# Energy against entropy

A vortex with winding $n$ has $|\nabla\theta|=n/r$ at distance $r$ from its core, so its energy is

$$ E=\frac{\rho_s}{2}\int_a^R\Big(\frac nr\Big)^22\pi r\,dr=\pi\rho_sn^2\ln\frac Ra, $$

which diverges logarithmically with the system size $R$. A single vortex is expensive. Its entropy is that of its position, $k\ln(R^2/a^2)=2k\ln(R/a)$. The free energy of one vortex is

$$ F=(\pi\rho_s-2kT)\ln\frac Ra, $$

which changes sign at $kT_{\rm KT}=\pi\rho_s/2$. Below this temperature isolated vortices are suppressed and appear only in bound pairs of opposite winding, whose energy is finite. Above it they unbind and proliferate, and the correlations become exponential. This is the Kosterlitz-Thouless transition {% cite kosterlitz-1973 %}: an infinite-order transition from quasi-long-range order to disorder, driven by defects and with no local order parameter, so it is outside Landau's framework. In practice the stiffness $\rho_s$ is itself reduced by thermal pairs, so the transition occurs where the renormalised stiffness equals $2kT/\pi$.

> A two-dimensional superfluid film or a thin superconducting film has this transition. The universal jump of the superfluid density at $T_{\rm KT}$ is $\rho_s=2kT/\pi$ in these units.
{: .idea}

# Rigidity

An ordered phase resists being twisted: the free energy rises as $\tfrac12\rho_s(\nabla\theta)^2$, and $\rho_s$ is a stiffness.

> Anderson called this **generalized rigidity**: the broken symmetry makes the phase respond to a gradient of the order parameter, and the response is a stiff, collective one that propagates over the whole sample.
{: .definition #def-generalized-rigidity title="Generalized rigidity"}

A solid resists shear, because the broken translation symmetry fixes the positions of the atoms. A superfluid carries a current for the same reason, since a phase gradient of the order parameter is a velocity. The rigidity is what makes a broken-symmetry phase a distinct state of matter and not merely a different value of a density.

# Metastability

A defect or a trapped twist is not the lowest-energy state, but it cannot decay by local rearrangement.

> This is **metastability**: a state that is a local and not a global minimum of the free energy, with a lifetime set by the barrier to escape.
{: .definition #def-metastability title="Metastability"}

A persistent current in a superfluid ring has a winding number $n\neq0$ around the ring, and decays only by a vortex crossing the ring, which has a large barrier. The same word covers the superheated liquid and supercooled gas of the van der Waals loop, whose lifetimes depend on the nucleation of a droplet, and the single sign of the Ising magnet below $T_c$ discussed under broken ergodicity.

{% capture t %}
| Situation | Why it persists | How it ends |
|---|---|---|
| Vortex in an XY film | winding number is topological | annihilation with an antivortex, or leaving the sample |
| Persistent current | winding around a ring | a vortex crossing the ring |
| Supercooled gas | barrier to nucleating a droplet | rare nucleation event |
| Magnet in one ordered state | barrier proportional to the system size | exponentially rare flip |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-metastable" caption="Metastable states and what keeps them from decaying." body=t %}

> Metastable states are physical and long-lived. A theory based only on the global minimum of the free energy is therefore not enough to describe a real experiment.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is the winding number conserved?</summary>

It counts how many times the order-parameter angle turns around a closed loop, which is an integer determined by the boundary. Smooth changes of the spins cannot change an integer, so only moving the defect or annihilating it with an opposite one changes it.
</details>

<details class="qa" markdown="1">
<summary>How does the balance of energy and entropy give the Kosterlitz-Thouless temperature?</summary>

A vortex has energy $\pi\rho_s\ln(R/a)$ and entropy $2k\ln(R/a)$, so its free energy changes sign at $kT=\pi\rho_s/2$. Above it, free vortices proliferate and destroy the quasi-long-range order.
</details>

<details class="qa" markdown="1">
<summary>What is generalized rigidity?</summary>

The resistance of a broken-symmetry phase to gradients of the order parameter, measured by a stiffness such as $\rho_s$. It underlies the shear resistance of solids and the supercurrents of superfluids.
</details>
