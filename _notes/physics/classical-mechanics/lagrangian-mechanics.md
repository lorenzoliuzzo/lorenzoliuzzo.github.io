---
collection: notes
title: Lagrangian Mechanics
date: '2026-10-27'
excerpt: Generalized coordinates, constraints, the principle of least action and the Euler-Lagrange equations.
hook: Of all paths between two points the real one makes the action stationary, and that one statement gives the equations of motion in any coordinates.
goals:
- choose generalized coordinates and write the Lagrangian
- derive the equations of motion from the action
requires:
- newtons-laws
- potential-energy
defines:
- id: generalized-coordinates
  name: generalized coordinates
  anchor: generalized-coordinates
- id: lagrangian
  name: Lagrangian
  anchor: lagrangian
- id: principle-of-least-action
  name: principle of least action
  anchor: principle-of-least-action
tags:
- Physics
- Classical Mechanics
read_time: true
---

Newton's equations are easiest in Cartesian coordinates and hardest where the problem is not Cartesian: a bead on a hoop, a pendulum, a planet. The Lagrangian formulation gives equations of motion in any coordinates from one scalar function, and it leads to the conservation laws and to quantum mechanics.

# Generalized coordinates

A system of $N$ particles has $3N$ coordinates, but constraints may remove some. A bead on a hoop of radius $R$ is at a point of a circle; one number, the angle $\theta$, fixes it. The number of independent coordinates is the number of **degrees of freedom**, and any set $q_1,\dots,q_n$ of that many independent variables that fixes the configuration is a set of **generalized coordinates**. They need not be lengths: angles, arc lengths or amplitudes are all allowed. The positions are functions $\mathbf r_i=\mathbf r_i(q_1,\dots,q_n,t)$.

The gain is that for holonomic constraints, those that can be written as equations among the coordinates, the constraint forces drop out. The normal force of the hoop on the bead never appears in an equation for $\theta$.

# Lagrangian

Express the kinetic energy $T$ and the potential energy $V$ in the generalized coordinates and their time derivatives $\dot q_k$. The **Lagrangian** is their difference,
$$ L(q,\dot q,t)=T-V. $$
For a particle in one dimension, $L=\tfrac12m\dot x^2-V(x)$. For a pendulum of length $\ell$ and mass $m$, with $\theta$ from the downward vertical, $T=\tfrac12m\ell^2\dot\theta^2$ and $V=-mg\ell\cos\theta$, so
$$ L=\tfrac12m\ell^2\dot\theta^2+mg\ell\cos\theta. $$
The equations of motion are the **Euler-Lagrange equations**, one for each coordinate,
$$ \frac{d}{dt}\frac{\partial L}{\partial\dot q_k}-\frac{\partial L}{\partial q_k}=0. $$
For the single particle they give $m\ddot x=-V'(x)$, which is Newton's law. For the pendulum, $\partial L/\partial\dot\theta=m\ell^2\dot\theta$ and $\partial L/\partial\theta=-mg\ell\sin\theta$, so
$$ m\ell^2\ddot\theta+mg\ell\sin\theta=0\quad\Longrightarrow\quad\ddot\theta=-\frac g\ell\sin\theta. $$
The tension in the string never entered. Derivatives of $L$ also name important quantities: $p_k=\partial L/\partial\dot q_k$ is the **generalized momentum**, and if $L$ does not depend on some $q_k$, the equations say that $p_k$ is constant. For a free particle in polar coordinates, $L$ does not depend on the angle $\varphi$ and $p_\varphi=mr^2\dot\varphi$, the angular momentum, is conserved.

# Principle of least action

The equations come from a single statement. The **action** of a path $q(t)$ between times $t_1$ and $t_2$ is
$$ S[q]=\int_{t_1}^{t_2}L(q,\dot q,t)\,dt. $$
The **principle of least action** (more precisely of stationary action) says that the path actually followed, among all paths with the same ends, is one on which $S$ is stationary: $\delta S=0$ for small variations of the path that vanish at the end points. Varying $q\to q+\delta q$ and integrating the $\dot{\delta q}$ term by parts,
$$ \delta S=\int\Big(\frac{\partial L}{\partial q}-\frac d{dt}\frac{\partial L}{\partial\dot q}\Big)\delta q\,dt, $$
where the boundary term vanishes because $\delta q=0$ at the ends. Since $\delta q$ is arbitrary in between, the bracket must vanish, which is the Euler-Lagrange equation.

A numerical check makes this concrete. A ball of mass $m=1\ \mathrm{kg}$ thrown up and landing after $T=2\ \mathrm s$ follows $y(t)=\tfrac12gt(T-t)$ with $g=9.81\ \mathrm{m/s^2}$, and its action is $S=-32.08\ \mathrm{J\,s}$. Adding the perturbation $\varepsilon\sin(\pi t/T)$, which keeps the ends fixed, changes the action by exactly $\varepsilon^2\pi^2m/(4T)$: it is $4.93\ \mathrm{J\,s}$ for $\varepsilon=2\ \mathrm m$ and has no term linear in $\varepsilon$.

{% include fig.html src="classical-mechanics/action-minimum" id="fig-action-minimum" alt="A parabola in the perturbation size, with a minimum of zero at zero perturbation, plotted from minus two to two metres." caption="The action of the perturbed paths $y_{\mathrm{true}}+\varepsilon\sin(\pi t/T)$ minus its value on the true path. There is no linear term in $\varepsilon$: the true path makes $S$ stationary, here a minimum, and $S(2)-S(0)=4.93\ \mathrm{J\,s}$." %}

> Stationary does not always mean minimum. For long times the true path can be a saddle point of $S$, so the name "least action" is historical.
{: .trap}

The formulation does not use forces. It needs only $T$ and $V$, which are scalars, and it carries over unchanged to fields, to relativity with another $L$, and to quantum mechanics, where paths near the stationary one add up constructively. The next notes use it to connect symmetries to conservation laws and to move to the Hamiltonian form.

# Recap

<details class="qa" markdown="1">
<summary>What are generalized coordinates, and why are they useful?</summary>

Independent variables that fix the configuration, one per degree of freedom. For holonomic constraints the constraint forces do not appear in the equations for them.
</details>

<details class="qa" markdown="1">
<summary>What are the Lagrangian and the Euler-Lagrange equations?</summary>

$L=T-V$, and the equations $\frac d{dt}\frac{\partial L}{\partial\dot q_k}=\frac{\partial L}{\partial q_k}$, one for each coordinate. For Cartesian coordinates they reduce to Newton's second law.
</details>

<details class="qa" markdown="1">
<summary>What does the principle of least action say?</summary>

The actual path between fixed end points makes the action $S=\int L\,dt$ stationary. Setting $\delta S=0$ and integrating by parts gives the Euler-Lagrange equations.
</details>
