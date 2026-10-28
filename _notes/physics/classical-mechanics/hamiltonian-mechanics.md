---
collection: notes
title: "Hamiltonian Mechanics"
date: 2026-10-27
excerpt: "The Legendre transform, Hamilton's equations, phase space and Poisson brackets."
hook: "The Hamiltonian turns the second-order equations of motion into a flow in phase space, which is the form that statistical and quantum mechanics build on."
goals:
  - write the Hamiltonian of a system and its equations
  - use Poisson brackets and Liouville's theorem
requires:
  - lagrangian
  - noether-theorem
defines:
  - {id: hamiltonian, name: "Hamiltonian", anchor: def-hamiltonian}
  - {id: phase-space, name: "phase space", anchor: def-phase-space}
  - {id: poisson-bracket, name: "Poisson bracket", anchor: def-poisson-bracket}
read_time: true
tags:
  - Physics
  - Classical Mechanics
---

The Lagrangian formulation uses positions and velocities and gives second-order equations. Replacing the velocities by momenta turns them into first-order equations for the points of a larger space, and that space is where statistical mechanics counts states and quantum mechanics finds its commutators.

# The Hamiltonian

For a system with generalized coordinates $q_i$, the canonical momenta are $p_i=\partial L/\partial\dot q_i$. Solving these for the velocities in terms of $p$ makes it possible to describe the system by $(q,p)$ instead of $(q,\dot q)$. The function that does it is the Legendre transform of $L$ with respect to the velocities, the same operation that produced the free energies.

> The **Hamiltonian** is $H(q,p,t)=\sum_ip_i\dot q_i-L$, written as a function of the coordinates and momenta. When the kinetic energy is quadratic in the velocities and the potential does not depend on them, $H=T+V$ is the total energy.
{: .definition #def-hamiltonian title="Hamiltonian"}

Differentiating $H$ and using the Euler-Lagrange equations $\dot p_i=\partial L/\partial q_i$, the terms with $\delta\dot q_i$ cancel and one is left with a pair of equations that treat $q$ and $p$ almost symmetrically.

> **Hamilton's equations.** For each coordinate, $\dot q_i=\dfrac{\partial H}{\partial p_i}$ and $\dot p_i=-\dfrac{\partial H}{\partial q_i}$. If $H$ has no explicit time dependence, $H$ is constant along every solution.
{: .theorem #thm-hamilton-equations title="Hamilton's equations"}

> With $p_i=\partial L/\partial\dot q_i$ and $H=\sum_ip_i\dot q_i-L$, the differential is $dH=\sum_i(\dot q_i\,dp_i+p_i\,d\dot q_i)-\sum_i\big(\partial_{q_i}L\,dq_i+p_i\,d\dot q_i\big)-\partial_tL\,dt$. The Euler-Lagrange equation says $\partial_{q_i}L=\dot p_i$, so $dH=\sum_i(\dot q_i\,dp_i-\dot p_i\,dq_i)-\partial_tL\,dt$, and reading off the coefficients gives both equations. If $H$ has no explicit time dependence, $\dot H=\sum_i(\partial_{q_i}H\,\dot q_i+\partial_{p_i}H\,\dot p_i)=0$.
{: .proof}

Take the harmonic oscillator, $H=p^2/2m+\tfrac12kq^2$. Then $\dot q=p/m$ and $\dot p=-kq$, which combine to $m\ddot q=-kq$. For the pendulum, $H=p^2/(2m\ell^2)-mg\ell\cos q$ and $\dot p=-mg\ell\sin q$ is the torque. The procedure is mechanical: write $T$ and $V$, find $p_i$, build $H$, differentiate. Its virtue is not easier solving but a different structure.

# Phase space

> The **phase space** of a system with $N$ degrees of freedom is the $2N$-dimensional space with coordinates $(q_1,\dots,q_N,p_1,\dots,p_N)$. A point is a complete state, and Hamilton's equations define a flow on it.
{: .definition #def-phase-space title="Phase space"}

Because the state determines the future, two trajectories never cross, and the whole dynamics is a picture: a family of curves filling the space. For a conserved $H$ each trajectory stays on a level set of $H$.

{% include fig.html src="classical-mechanics/pendulum-phase-portrait" id="fig-pendulum-phase-portrait" alt="Phase portrait of a pendulum with angle on the horizontal axis and momentum on the vertical axis. Closed ovals surround the origin, a pair of crossing curves marks the boundary, and wavy open curves above and below show full rotation." caption="Phase portrait of the pendulum $H=p^2/2-\cos q$. Small energies give closed orbits around the stable point (swinging), the curve $E=1$ separates them from open orbits (rotating), and its crossing at $q=\pm\pi$ is the unstable upright position." %}

The portrait shows at once what the equations hide: the stable and unstable equilibria, the separatrix between swinging and rotating, and how the period grows as the energy approaches the separatrix. It also carries a general fact about the flow.

> **Liouville's theorem.** The flow of Hamilton's equations preserves volume in phase space: a region of initial conditions keeps its $2N$-dimensional volume as it evolves, though its shape may stretch and fold.
{: .theorem #thm-liouville title="Liouville's theorem"}

> The velocity field of the flow is $v=(\partial_pH,-\partial_qH)$, whose divergence is $\partial_q\partial_pH-\partial_p\partial_qH=0$. The volume of a region carried by the flow changes at the rate $\int\nabla\cdot v\,dV$, which is therefore zero.
{: .proof}

The zero divergence of the flow is also why the density of an ensemble of systems is constant along trajectories, the starting point of statistical mechanics.

> Friction is not Hamiltonian. A damped oscillator has $\dot p=-kq-\gamma p$, whose phase-space flow has divergence $-\gamma<0$: areas shrink, and every orbit spirals into the origin. Liouville's theorem and energy conservation hold only for the conservative part of a model.
{: .trap}

# Poisson brackets

How does a general function of the state, $f(q,p,t)$, change in time? By the chain rule and Hamilton's equations,
$$ \frac{df}{dt}=\sum_i\Big(\frac{\partial f}{\partial q_i}\dot q_i+\frac{\partial f}{\partial p_i}\dot p_i\Big)+\frac{\partial f}{\partial t}=\{f,H\}+\frac{\partial f}{\partial t}, $$
with the combination in the middle given a name.

> The **Poisson bracket** of two functions on phase space is $\{f,g\}=\displaystyle\sum_i\Big(\frac{\partial f}{\partial q_i}\frac{\partial g}{\partial p_i}-\frac{\partial f}{\partial p_i}\frac{\partial g}{\partial q_i}\Big)$. It is antisymmetric and linear, and $\{q_i,p_j\}=\delta_{ij}$.
{: .definition #def-poisson-bracket title="Poisson bracket"}

> A quantity $f$ without explicit time dependence is conserved if and only if $\{f,H\}=0$.
{: .property title="Conservation as a vanishing bracket"}

For a particle in a central potential, $H=\mathbf p^2/2m+V(r)$ and $L_z=xp_y-yp_x$, one finds $\{L_z,H\}=0$: angular momentum commutes with the Hamiltonian, the Noether result in a new form. The bracket also says how one conserved quantity generates a transformation of the others, with $L_z$ generating rotations. In quantum mechanics the same algebra survives as commutators, $[A,B]=i\hbar\{A,B\}$ for the corresponding operators, which is why the structure was worth building.

> Use the Hamiltonian form when you want to read off the structure: conserved quantities, the topology of orbits, the volume of a region of states. Use Newton or Lagrange when you just need to integrate one trajectory in awkward coordinates. For long numerical integrations, methods that respect the phase-space structure keep the energy from drifting.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What do Hamilton's equations say in words?</summary>

The velocity of each coordinate is the slope of $H$ with respect to its momentum, and the force is minus the slope of $H$ with respect to the coordinate; together they are a first-order flow on phase space that conserves $H$.
</details>

<details class="qa" markdown="1">
<summary>What does Liouville's theorem guarantee, and when does it fail?</summary>

Volumes in phase space are preserved by Hamiltonian flow, because the flow has zero divergence. It fails with dissipation, where the flow contracts volumes.
</details>

<details class="qa" markdown="1">
<summary>How do Poisson brackets express conservation?</summary>

$df/dt=\{f,H\}+\partial f/\partial t$, so a quantity with no explicit time dependence is conserved exactly when its bracket with $H$ vanishes.
</details>
