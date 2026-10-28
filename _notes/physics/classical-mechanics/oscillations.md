---
collection: notes
title: "Oscillations"
date: 2026-10-27
excerpt: "The harmonic oscillator, damping, driving and resonance, and coupled oscillators."
hook: "Near a stable equilibrium every system is a harmonic oscillator, which is why the oscillator is the most reused model in physics."
goals:
  - solve the free, damped and driven oscillator
  - find the normal modes of two coupled oscillators
requires:
  - potential-energy
defines:
  - {id: harmonic-oscillator, name: "harmonic oscillator", anchor: def-harmonic-oscillator}
  - {id: normal-modes, name: "normal modes", anchor: def-normal-modes}
read_time: true
tags:
  - Physics
  - Classical Mechanics
---

Any smooth potential looks like a parabola near its minimum, so small motion about a stable equilibrium is the same motion everywhere: a harmonic oscillation. Coupling two of them splits the motion into modes that each have a single frequency.

# The harmonic oscillator

Around an equilibrium $x_0$ where $V'(x_0)=0$, expand the potential to second order (Taylor's theorem): $V(x)\approx V(x_0)+\tfrac12V''(x_0)(x-x_0)^2$. With $V''(x_0)=k>0$ the equation of motion for the displacement $x$ from equilibrium is $m\ddot x=-kx$.

> A **harmonic oscillator** is a system whose restoring force is proportional to the displacement from equilibrium, $m\ddot x=-kx$. Its motion is $x(t)=A\cos(\omega_0t+\phi)$ with angular frequency $\omega_0=\sqrt{k/m}$, and $A$, $\phi$ are fixed by the initial position and velocity.
{: .definition #def-harmonic-oscillator title="Harmonic oscillator"}

> The period $T=2\pi/\omega_0$ does not depend on the amplitude. The energy is $E=\tfrac12m\dot x^2+\tfrac12kx^2=\tfrac12m\omega_0^2A^2$, constant in time, and it flows back and forth between kinetic and potential.
{: .property title="Isochronism and energy"}

> A pendulum of length $\ell=1$ m has $\omega_0=\sqrt{g/\ell}=3.13$ rad/s and $T=2.01$ s. The harmonic result needs $\sin\theta\approx\theta$; for a swing of amplitude $30^\circ$ the true period is longer by about $\theta_0^2/16\approx1.7\%$, the first correction in the expansion of the exact period.
{: .example title="The small-angle pendulum"}

# Damping and driving

Real oscillators lose energy. A drag force $-b\dot x$ and a periodic push $F\cos\omega t$ give $m\ddot x+b\dot x+kx=F\cos\omega t$. The solution method, characteristic roots and steady-state response, is worked out in the note on linear ODEs ([Linear ODEs]({{ '/notes/mathematics/mathematical-methods/linear-odes/' | relative_url }})); the physical content is as follows.

{% include fig.html src="classical-mechanics/damping-regimes" id="fig-damping-regimes" alt="Displacement against time for three damping strengths, all released from rest at one. The weakly damped curve oscillates with shrinking amplitude. The critically damped curve decays to zero without crossing it, fastest of the three. The strongly damped curve decays more slowly without crossing." caption="Release from rest with $\gamma=b/m$ equal to $0.4$, $2$ and $4$ in units of $\omega_0$. Critical damping ($\gamma=2\omega_0$) brings the oscillator back to rest fastest without overshoot." %}

With light damping the oscillation continues at a slightly lower frequency, $\omega_d=\sqrt{\omega_0^2-\gamma^2/4}$, inside an envelope $e^{-\gamma t/2}$, and the energy decays as $e^{-\gamma t}$. The **quality factor** $Q=\omega_0/\gamma$ equals $2\pi$ times the energy stored divided by the energy lost per cycle, so it counts how many cycles the motion lasts. Under periodic driving, the long-time motion is at the driving frequency with an amplitude that peaks near $\omega_0$ at about $Q$ times the static displacement $F/k$: resonance.

> Critical damping is a design target for things that must settle quickly, such as a door closer or a measuring needle. Too little damping rings, too much creeps.
{: .rule}

# Coupled oscillators and normal modes

Now put two identical masses $m$ between two walls, each attached to its wall by a spring $k$ and to each other by a spring $\kappa$. The displacements $x_1,x_2$ obey
$$ m\ddot x_1=-kx_1-\kappa(x_1-x_2),\qquad m\ddot x_2=-kx_2-\kappa(x_2-x_1). $$
Neither equation can be solved alone, but their sum and difference can, since adding gives an equation for $x_1+x_2$ and subtracting gives one for $x_1-x_2$:
$$ \omega_+=\sqrt{\frac km}\ \ (x_1=x_2),\qquad \omega_-=\sqrt{\frac{k+2\kappa}m}\ \ (x_1=-x_2). $$

> A **normal mode** of a system of coupled oscillators is a motion in which every coordinate oscillates at the same frequency with a fixed ratio of amplitudes. A system with $N$ degrees of freedom has $N$ normal modes, and every motion is a superposition of them.
{: .definition #def-normal-modes title="Normal modes"}

In the in-phase mode the middle spring is never stretched, so the frequency is that of a single mass; in the antiphase mode it is stretched twice as much as either end, so the frequency is higher. For $N$ masses the same steps become a matrix problem: with $\mathbf x$ the vector of displacements, $m\ddot{\mathbf x}=-K\mathbf x$ and the modes are the eigenvectors of $K/m$, with $\omega^2$ the eigenvalues. This is the eigenvalue problem of [Eigenvalues and diagonalization]({{ '/notes/mathematics/linear-algebra/eigenvalues-and-diagonalization/' | relative_url }}), and because $K$ is symmetric the modes are orthogonal.

> Pull mass 1 aside and release both from rest. Then $x_1=\tfrac A2(\cos\omega_+t+\cos\omega_-t)$ and $x_2=\tfrac A2(\cos\omega_+t-\cos\omega_-t)$. When $\kappa\ll k$ the two frequencies are close, and the sum is a fast oscillation modulated by a slow envelope with angular frequency $(\omega_--\omega_+)/2$: the energy passes completely from mass 1 to mass 2 and back, with a period of $2\pi/(\omega_--\omega_+)$ per full exchange.
{: .example title="Beats between two masses"}

> The mode frequencies of coupled systems are the same for any choice of coordinates, but the coordinates that decouple the equations are not the obvious ones: positions of single masses mix, and the useful variables are the mode coordinates $x_1\pm x_2$. Look for the symmetry of the system first; symmetric and antisymmetric combinations usually decouple it.
{: .trap}

The same reduction is behind the vibrations of molecules and crystals, where a lattice of $N$ atoms has $3N$ modes (phonons), and behind the way an electric circuit with several loops rings at a few frequencies.

# Recap

<details class="qa" markdown="1">
<summary>Why is the harmonic oscillator the default model near an equilibrium?</summary>

A smooth potential is a parabola to second order at its minimum, and $V\approx\tfrac12kx^2$ gives a linear restoring force, with a frequency set by the curvature $V''(x_0)$.
</details>

<details class="qa" markdown="1">
<summary>What does the quality factor $Q$ measure?</summary>

How weakly the oscillator is damped: $Q=\omega_0/\gamma$ is about the number of radians of oscillation before the energy falls by a factor $e$, and also the height of the resonance peak in units of the static response.
</details>

<details class="qa" markdown="1">
<summary>How do you find the normal modes of coupled oscillators?</summary>

Write the equations as $m\ddot{\mathbf x}=-K\mathbf x$ and find the eigenvectors of $K/m$: each eigenvector is a mode shape and its eigenvalue is $\omega^2$. For symmetric systems the sum and difference of coordinates already decouple the equations.
</details>
