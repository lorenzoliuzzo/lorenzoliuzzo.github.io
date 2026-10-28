---
collection: notes
title: "Potential Wells and Tunnelling"
date: 2026-10-27
excerpt: "Bound states of a box and a finite well, scattering from a step and a barrier."
hook: "Confinement quantizes energy, and a wavefunction does not stop at a finite wall, so a particle can cross a barrier its energy would classically forbid."
goals:
  - find the energy levels of the infinite and finite well
  - estimate the transmission probability through a barrier
requires:
  - wavefunction
  - stationary-state
defines:
  - {id: bound-state, name: "bound state", anchor: def-bound-state}
  - {id: tunnelling, name: "tunnelling", anchor: def-tunnelling}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

Solving the Schrödinger equation for a piecewise-constant potential needs only two facts: the wavefunction is oscillatory where the particle has energy to spare and exponential where it does not, and the pieces must join smoothly. These produce quantised energies and tunnelling.

# Bound states

For a time-independent potential the stationary states satisfy
$$ -\frac{\hbar^2}{2m}\psi''+V(x)\psi=E\psi. $$
Where $E>V$ the solution oscillates with wave number $k=\sqrt{2m(E-V)}/\hbar$, and where $E<V$ it grows and decays as $e^{\pm\kappa x}$ with $\kappa=\sqrt{2m(V-E)}/\hbar$. The wavefunction and its derivative are continuous at any finite jump of $V$.

> A **bound state** is a stationary state that is normalisable because it decays at infinity, which happens when $E$ is below the potential at infinity. Bound states have discrete energies.
{: .definition #def-bound-state title="Bound state"}

For the infinite well of width $L$ the wavefunction must vanish at the walls, so $\psi_n=\sqrt{2/L}\sin(n\pi x/L)$ with
$$ E_n=\frac{n^2\pi^2\hbar^2}{2mL^2},\qquad n=1,2,3,\dots $$
Quantisation is a consequence of the boundary conditions: only whole numbers of half wavelengths fit. For an electron in a well of width $1$ nm the ground state is $0.376$ eV, and the levels grow as $n^2$. Narrowing the well raises all energies as $1/L^2$, the same trade-off as in the uncertainty relation.

A finite well of depth $V_0$ has wavefunctions that leak into the walls with decay constant $\kappa$. The levels lie below those of the infinite well, there are only finitely many, and a symmetric one-dimensional well always has at least one bound state.

# Tunnelling

> **Tunnelling** is the passage of a particle through a region where its energy is below the potential, which is classically forbidden. The wavefunction decays but does not vanish inside the barrier, so there is a nonzero probability of emerging on the other side.
{: .definition #def-tunnelling title="Tunnelling"}

For a rectangular barrier of height $V_0$ and width $a$, matching the solutions at the two edges gives, for $E<V_0$,
$$ T=\Big[1+\frac{V_0^2\sinh^2\kappa a}{4E(V_0-E)}\Big]^{-1}\approx16\,\frac{E}{V_0}\Big(1-\frac E{V_0}\Big)e^{-2\kappa a}\quad(\kappa a\gg1). $$
The exponential makes tunnelling sensitive to the width: increasing $a$ by $1/\kappa$ cuts the probability by $e^{-2}$. Define $\beta=a\sqrt{2mV_0}/\hbar$; for $E=V_0/2$ it gives $T=0.21$ for $\beta=2$ and $0.014$ for $\beta=4$.

{% include fig.html src="quantum-theory/barrier-transmission" id="fig-barrier-transmission" alt="Transmission against energy over barrier height for a thin and a thick barrier. Both rise smoothly through the barrier height, and the thick one overshoots to one before dipping." caption="Transmission through a rectangular barrier, for $\beta=a\sqrt{2mV_0}/\hbar=2$ and $4$. Below $E=V_0$ the transmission is small and exponentially sensitive to the width; above it the barrier still reflects, and $T=1$ only at resonances." %}

Above the barrier, $E>V_0$, the result is the same with $\sinh\to\sin$ and $\kappa\to k'$, so the transmission oscillates and reaches exactly $1$ whenever $k'a$ is a multiple of $\pi$, because reflections from the two edges cancel.

> In a scanning tunnelling microscope the current between a metal tip and a surface follows $e^{-2\kappa d}$ with the tip distance $d$. For a barrier of $1$ eV, $\kappa=5.1\ \mathrm{nm^{-1}}$, so the current drops by a factor of ten for every $0.22$ nm of extra separation. That sensitivity is what allows atomic resolution.
{: .application title="Scanning tunnelling microscope"}

> Tunnelling is not a particle borrowing energy. The particle never has negative kinetic energy: the wavefunction in the barrier is an amplitude, not a trajectory, and what is measured is the probability to find the particle beyond the barrier.
{: .trap}

> For a quick estimate of a tunnelling probability use $T\sim e^{-2\kappa a}$ and check which exponent dominates. For the levels of a confining potential, count half wavelengths between the walls.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the energy of a bound state quantised?</summary>

Only energies for which the oscillating solution joins smoothly onto decaying ones on both sides give a normalisable wavefunction. For the infinite well, whole numbers of half wavelengths fit: $E_n\propto n^2$.
</details>

<details class="qa" markdown="1">
<summary>What controls the tunnelling probability?</summary>

The factor $e^{-2\kappa a}$: it falls exponentially with barrier width $a$ and with $\sqrt{V_0-E}$.
</details>

<details class="qa" markdown="1">
<summary>Is a particle with $E>V_0$ always transmitted?</summary>

No. There is partial reflection from the edges, and $T=1$ only at resonance, when $k'a$ is a multiple of $\pi$.
</details>
