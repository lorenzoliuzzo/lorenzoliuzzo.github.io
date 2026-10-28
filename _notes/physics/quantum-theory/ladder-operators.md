---
collection: notes
title: "The Oscillator by Ladder Operators"
date: 2026-10-27
excerpt: "Creation and annihilation operators, number states and coherent states."
hook: "The harmonic oscillator is solved by algebra alone: a lowering operator with a simple commutator generates the whole ladder of equally spaced levels."
goals:
  - derive the oscillator spectrum from the commutator of a and its adjoint
  - compute matrix elements of position and momentum
requires:
  - commutator
  - hamiltonian-operator
defines:
  - {id: ladder-operators, name: "ladder operators", anchor: def-ladder-operators}
  - {id: number-state, name: "number state", anchor: def-number-state}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

The harmonic oscillator is the model of almost everything near an equilibrium: molecular vibrations, a mode of the electromagnetic field, a trapped atom. Its spectrum can be found without solving a differential equation, from one commutation relation.

# Raising and lowering

The Hamiltonian of a mass $m$ in the potential $\frac12m\omega^2x^2$ is $H=\frac{p^2}{2m}+\frac12m\omega^2x^2$. Define a dimensionless combination of position and momentum:
$$ a=\sqrt{\frac{m\omega}{2\hbar}}\Big(x+\frac{ip}{m\omega}\Big),\qquad a^\dagger=\sqrt{\frac{m\omega}{2\hbar}}\Big(x-\frac{ip}{m\omega}\Big). $$
From $[x,p]=i\hbar$ it follows that $[a,a^\dagger]=1$, and the Hamiltonian becomes
$$ H=\hbar\omega\Big(a^\dagger a+\tfrac12\Big). $$

> The operators $a$ and $a^\dagger$ are the **ladder operators** of the oscillator. If $H|E\rangle=E|E\rangle$, then $a^\dagger|E\rangle$ has energy $E+\hbar\omega$ and $a|E\rangle$ has energy $E-\hbar\omega$, because $[H,a^\dagger]=\hbar\omega\,a^\dagger$ and $[H,a]=-\hbar\omega\,a$.
{: .definition #def-ladder-operators title="Ladder operators"}

The spectrum follows. The operator $N=a^\dagger a$ is Hermitian and positive, since $\langle\psi|N|\psi\rangle=\|a\psi\|^2\ge0$. Applying $a$ repeatedly lowers the energy by $\hbar\omega$ each time, which cannot continue below a state with $a|0\rangle=0$, or the norm would become negative. That state has $N=0$, and it fixes the whole ladder.

> The **number states** $|n\rangle=\dfrac{(a^\dagger)^n}{\sqrt{n!}}|0\rangle$, $n=0,1,2,\dots$, are the orthonormal eigenstates of $N=a^\dagger a$ with $N|n\rangle=n|n\rangle$ and energy $E_n=\hbar\omega(n+\tfrac12)$. The ladder operators act as $a|n\rangle=\sqrt n\,|n-1\rangle$ and $a^\dagger|n\rangle=\sqrt{n+1}\,|n+1\rangle$.
{: .definition #def-number-state title="Number state"}

The levels are equally spaced by $\hbar\omega$, and even the lowest has the zero-point energy $\frac12\hbar\omega$, which no potential energy trade-off can remove: a narrower ground state costs momentum spread, and the uncertainty relation gives $\Delta x\Delta p\ge\hbar/2$ for it. The ground state $a|0\rangle=0$ is the Gaussian $\psi_0\propto e^{-m\omega x^2/2\hbar}$, which saturates the bound, and the excited states are polynomials of degree $n$ times the same Gaussian.

{% include fig.html src="quantum-theory/oscillator-levels" id="fig-oscillator-levels" alt="A parabola with four horizontal level lines and three probability density curves drawn on the first three levels, showing zero, one and two nodes." caption="The oscillator potential, the first levels $E_n=(n+\tfrac12)\hbar\omega$ and the densities $|\psi_n|^2$ of $n=0,1,2$ drawn on their own levels. Each step up adds one node, and the density extends past the classical turning points." %}

# Matrix elements

Inverting the definitions gives $x=\sqrt{\hbar/2m\omega}\,(a+a^\dagger)$ and $p=i\sqrt{m\hbar\omega/2}\,(a^\dagger-a)$, so $x$ and $p$ connect only neighbouring levels: $\langle n\pm1|x|n\rangle\ne0$ and every other element vanishes. Hence $\langle x\rangle=\langle p\rangle=0$ in every number state, and
$$ \langle x^2\rangle=\frac\hbar{2m\omega}(2n+1),\qquad\langle p^2\rangle=\frac{m\hbar\omega}2(2n+1). $$
For the ground state this gives $\Delta x\Delta p=\hbar/2$, and for state $n$ it gives $(n+\frac12)\hbar$. Half the energy is kinetic and half is potential in every stationary state, a quantum form of the virial theorem.

> The ladder structure is general: the same algebra describes photons in a cavity, where $a^\dagger$ creates a quantum of the field with energy $\hbar\omega$, and phonons in a crystal. The number state $|n\rangle$ is then $n$ quanta, which is why $a^\dagger$ and $a$ are called creation and annihilation operators.
{: .application title="Quanta of a mode"}

> The ladder method gives the spectrum and matrix elements but the position-space wavefunctions still need $a\psi_0=0$ solved as a first-order equation. The polynomials that multiply the Gaussian are the Hermite polynomials.
{: .remark}

> For an oscillator problem, write $x$ and $p$ in terms of $a$ and $a^\dagger$, expand, and use $a|n\rangle=\sqrt n|n-1\rangle$. Only terms with equal numbers of $a$ and $a^\dagger$ have non-zero diagonal elements.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the oscillator spectrum equally spaced?</summary>

$[H,a^\dagger]=\hbar\omega a^\dagger$, so $a^\dagger$ raises the energy by exactly $\hbar\omega$ and $a$ lowers it by the same amount.
</details>

<details class="qa" markdown="1">
<summary>Why does the ladder stop at the bottom?</summary>

The norm of $a|\psi\rangle$ is non-negative, so a state of lowest energy exists with $a|0\rangle=0$, and its energy is $\frac12\hbar\omega$.
</details>

<details class="qa" markdown="1">
<summary>What do $a$ and $a^\dagger$ do to a number state?</summary>

$a|n\rangle=\sqrt n|n-1\rangle$ and $a^\dagger|n\rangle=\sqrt{n+1}|n+1\rangle$.
</details>
