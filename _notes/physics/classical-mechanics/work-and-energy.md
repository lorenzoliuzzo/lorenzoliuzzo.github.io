---
collection: notes
title: Work, Energy and Conservation Laws
date: '2026-10-27'
excerpt: Work, kinetic and potential energy, momentum and angular momentum, and their conservation.
hook: Conservation laws let you skip the details of the motion and ask only what is conserved.
goals:
- use energy and momentum conservation to solve problems
- decide when a force has a potential
requires:
- newtons-laws
defines:
- id: potential-energy
  name: potential energy
  anchor: potential-energy
- id: momentum-conservation
  name: conservation of momentum
  anchor: conservation-of-momentum
- id: angular-momentum
  name: angular momentum
  anchor: angular-momentum
tags:
- Physics
- Classical Mechanics
read_time: true
---

Solving $m\ddot{\mathbf r}=\mathbf F$ in full is often impossible and rarely needed. Some combinations of position and velocity stay constant along the motion, and knowing them answers the usual questions, such as how fast and how high, without the path.

# Work and kinetic energy

The **work** done by a force $\mathbf F$ along a path from $A$ to $B$ is $W=\int_A^B\mathbf F\cdot d\mathbf r$. For one dimension it is $\int F\,dx$. Take the equation of motion and multiply by the velocity: $m\dot{\mathbf v}\cdot\mathbf v=\mathbf F\cdot\mathbf v$. The left side is $\frac{d}{dt}\big(\tfrac12mv^2\big)$, so integrating over the motion gives the **work-energy theorem**
$$ W=\Delta K,\qquad K=\tfrac12mv^2. $$
The net work on a body equals the change of its kinetic energy. This holds for any force, conservative or not.

# Potential energy

A force is **conservative** if the work it does between two points does not depend on the path, equivalently if the work around any closed loop is zero. Then one can define a **potential energy** $U(\mathbf r)=-\int_{\mathbf r_0}^{\mathbf r}\mathbf F\cdot d\mathbf r$ with a reference point $\mathbf r_0$, and the force is its negative gradient,
$$ \mathbf F=-\nabla U,\qquad\text{in one dimension}\quad F=-\frac{dU}{dx}. $$
The test is a vector-calculus one: in three dimensions $\mathbf F$ has a potential on a simply connected region exactly when $\nabla\times\mathbf F=0$. Gravity near the ground, $U=mgh$, springs, $U=\tfrac12kx^2$, and the inverse-square forces of gravitation and electrostatics are conservative. Kinetic friction and drag are not, because the work they do depends on the length of the path and is always negative.

With a potential, the work-energy theorem becomes the statement that the **mechanical energy** $E=K+U$ is constant along the motion. A block released from rest at height $h=5\ \mathrm{m}$ reaches the ground with $\tfrac12mv^2=mgh$, so $v=\sqrt{2gh}=9.9\ \mathrm{m/s}$, whatever the shape of the frictionless slope.

Energy also gives the qualitative motion at once. Since $K=E-U(x)\ge0$, the particle can only be where $U\le E$. A **turning point** is where $U=E$ and the particle stops and reverses.

{% include fig.html src="classical-mechanics/energy-diagram" id="fig-energy-diagram" alt="A double-well potential curve with two horizontal dashed lines. The lower line cuts the curve at four points and the particle stays in one well; the higher line cuts the curve only at two outer points, so the particle passes over the central barrier." caption="The potential $U(x)=x^4/4-x^2/2$. At $E=-0.15$ the particle is confined to one of two wells between turning points; at $E=0.40$ it has enough energy to cross the barrier and oscillates between the outer turning points." %}

# Conservation of momentum

The third law makes the internal forces of a system cancel in pairs, so the total momentum $\mathbf P=\sum_im_i\mathbf v_i$ obeys $\dot{\mathbf P}=\mathbf F_{\text{ext}}$. If the external force is zero, $\mathbf P$ is constant. This holds for collisions, where the forces are huge and brief and cannot be written down, and it holds even when energy is not conserved.

Take a one-dimensional **elastic** collision, in which kinetic energy is also conserved. A mass $m_1=1\ \mathrm{kg}$ moving at $v_1=3\ \mathrm{m/s}$ hits $m_2=2\ \mathrm{kg}$ at rest. Solving the two conservation equations gives
$$ v_1'=\frac{m_1-m_2}{m_1+m_2}v_1=-1\ \text{m/s},\qquad v_2'=\frac{2m_1}{m_1+m_2}v_1=2\ \text{m/s}. $$
The momentum is $3$ before and $-1+4=3$ after; the energy is $4.5\ \mathrm{J}$ before and $0.5+4=4.5\ \mathrm{J}$ after. The lighter body bounces back. In an **inelastic** collision momentum is still conserved and energy is not; if the bodies stick, the common speed is $P/(m_1+m_2)=1\ \mathrm{m/s}$ and $3\ \mathrm{J}$ of the $4.5\ \mathrm{J}$ is lost.

# Angular momentum

The **angular momentum** about the origin is $\mathbf L=\mathbf r\times\mathbf p$. Its rate of change is $\dot{\mathbf L}=\mathbf r\times\mathbf F=\boldsymbol\tau$, the **torque**, because $\dot{\mathbf r}\times\mathbf p=0$. For a **central force**, one that points along $\mathbf r$, the torque is zero and $\mathbf L$ is constant. Then the motion stays in the plane perpendicular to $\mathbf L$, and the area swept out by the position vector grows at the constant rate $|\mathbf L|/2m$, which is Kepler's second law.

{% capture t %}
| Conserved quantity | Condition | Origin |
|:--|:--|:--|
| energy $E=K+U$ | forces conservative | work-energy theorem |
| momentum $\mathbf P$ | no external force | third law |
| angular momentum $\mathbf L$ | no external torque, for example a central force | $\mathbf r\times\mathbf F=0$ |
{% endcapture %}
{% include tab.html id="tab-conserved" caption="The three conservation laws and when each holds." body=t %}
{: .booktabs}

The pairing of each law with a symmetry (time translation, space translation, rotation) is made exact in the Lagrangian formulation, in the note on Noether's theorem.

# Recap

<details class="qa" markdown="1">
<summary>What does the work-energy theorem say?</summary>

The net work done on a body equals the change in its kinetic energy $\tfrac12mv^2$, for any force.
</details>

<details class="qa" markdown="1">
<summary>When does a force have a potential, and what follows?</summary>

When the work between two points is path independent, equivalently $\nabla\times\mathbf F=0$ on a simply connected region. Then $\mathbf F=-\nabla U$ and $K+U$ is conserved.
</details>

<details class="qa" markdown="1">
<summary>When are momentum and angular momentum conserved?</summary>

Momentum when the net external force is zero, in any collision; angular momentum when the net external torque is zero, for example for a central force.
</details>
