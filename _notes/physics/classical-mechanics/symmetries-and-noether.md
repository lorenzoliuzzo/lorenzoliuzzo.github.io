---
collection: notes
title: "Symmetries and Noether's Theorem"
date: 2026-10-27
excerpt: "Cyclic coordinates, Noether's theorem and the link between symmetry and conservation."
hook: "Every continuous symmetry of the Lagrangian gives a conserved quantity: translation gives momentum, rotation gives angular momentum, time shift gives energy."
goals:
  - find the conserved quantity of a symmetry
  - recognize cyclic coordinates
requires:
  - lagrangian
  - momentum-conservation
  - angular-momentum
defines:
  - {id: noether-theorem, name: "Noether's theorem", anchor: def-noether-theorem}
read_time: true
tags:
  - Physics
  - Classical Mechanics
---

The conservation of momentum, angular momentum and energy are three separate facts in Newtonian mechanics. In the Lagrangian picture they are one fact seen three times: each is the shadow of a symmetry.

# Cyclic coordinates

For generalized coordinates $q_i$, the **canonical momentum** is $p_i=\partial L/\partial\dot q_i$, and the Euler-Lagrange equations read $\dot p_i=\partial L/\partial q_i$. A coordinate that does not appear in $L$ is called **cyclic**.

> If $L$ does not depend on $q_k$, then $p_k=\partial L/\partial\dot q_k$ is constant in time.
{: .property title="A cyclic coordinate gives a conserved momentum"}

The proof is the Euler-Lagrange equation itself: $\dot p_k=\partial L/\partial q_k=0$. What matters is what "not appearing" means. Shifting $q_k\to q_k+s$ leaves $L$ unchanged, so a cyclic coordinate is a symmetry of the system, and the conserved momentum belongs to it.

Two familiar cases. For a particle in a potential $V(x,z)$ that does not depend on $y$, the coordinate $y$ is cyclic and $p_y=m\dot y$ is conserved. For a particle in a central potential, polar coordinates give $L=\tfrac12m(\dot r^2+r^2\dot\theta^2)-V(r)$; the angle $\theta$ is cyclic, and $p_\theta=mr^2\dot\theta$ is the angular momentum about the axis, which is why central forces conserve it.

{% include fig.html src="classical-mechanics/noether-translation" id="fig-noether-translation" alt="Two curves against time. One is a sine wave labelled p_x, not conserved. The other is a flat line labelled p_y, conserved." caption="A particle in $V=\tfrac12x^2$, which does not depend on $y$. The momentum along $x$ oscillates, but $p_y$ stays at its initial value $0.6$ for all time." %}

# Noether's theorem

Cyclic coordinates need the symmetry to be a shift of a coordinate. Noether's theorem removes that restriction: any continuous symmetry, in any coordinates, gives a conserved quantity.

> A **continuous symmetry** of the Lagrangian is a family of coordinate changes $q_i\to q_i(s)$, depending smoothly on a parameter $s$ with $q_i(0)=q_i$, such that $L$ is unchanged: $\dfrac{d}{ds}L\big(q(s),\dot q(s)\big)=0$.
{: .definition #def-symmetry title="Continuous symmetry"}

> **Noether's theorem.** For a continuous symmetry $q_i\to q_i(s)$ of $L$, the quantity
> $$ Q=\sum_i p_i\,\frac{dq_i}{ds}\Big|_{s=0} $$
> is conserved along every solution of the equations of motion.
{: .theorem #def-noether-theorem title="Noether's theorem"}

> Write $\delta q_i=dq_i/ds|_{0}$. Invariance means $0=\sum_i\big(\tfrac{\partial L}{\partial q_i}\delta q_i+\tfrac{\partial L}{\partial\dot q_i}\delta\dot q_i\big)$. On a solution, $\partial L/\partial q_i=\dot p_i$ and $\delta\dot q_i=\tfrac d{dt}\delta q_i$, so the sum is $\sum_i\tfrac d{dt}(p_i\,\delta q_i)=\dot Q$. Hence $\dot Q=0$.
{: .proof}

For a cyclic coordinate the transformation is $q_k\to q_k+s$, so $\delta q_k=1$ and $Q=p_k$, the previous section's result. The advantage is that the symmetry can be a rotation or any other transformation that is not a shift in the coordinates one started with.

{% capture t %}
| Symmetry of $L$ | Transformation | Conserved quantity |
|:--|:--|:--|
| translation in space | $\mathbf r\to\mathbf r+s\,\hat{\mathbf n}$ | momentum $\mathbf p\cdot\hat{\mathbf n}$ |
| rotation about an axis | $\mathbf r\to R_{\hat{\mathbf n}}(s)\mathbf r$ | angular momentum $\mathbf L\cdot\hat{\mathbf n}$ |
| translation in time | $t\to t+s$ | energy $H$ |
{% endcapture %}
{% include tab.html id="tab-noether" caption="Three symmetries and what they conserve." body=t %}
{: .booktabs}

For a rotation by a small angle $s$ about $z$, $\delta x=-y$ and $\delta y=x$, so $Q=-y\,p_x+x\,p_y=L_z$. Time translation is different, because it moves the time variable rather than the coordinates, but the result has the same shape: when $\partial L/\partial t=0$, the function $H=\sum_ip_i\dot q_i-L$ satisfies $\dot H=-\partial L/\partial t=0$, so $H$ is conserved. For $L=T-V$ with $T$ quadratic in the velocities, $H=T+V$ is the total energy.

> Two particles interact through a potential that depends only on their separation, $V(\mathbf r_1-\mathbf r_2)$. Shifting both by the same vector leaves $V$ unchanged, so $\mathbf P=\mathbf p_1+\mathbf p_2$ is conserved, while each $\mathbf p_i$ separately is not. For such interactions the equal and opposite forces of Newton's third law follow from translation symmetry instead of being assumed.
{: .implication title="Newton's third law as a symmetry"}

> Conservation laws are a way to choose a problem's coordinates. If the system is invariant under rotation about an axis, choose an angle about that axis as a coordinate; it will be cyclic, and its momentum is a constant of the motion that removes one degree of freedom.
{: .rule}

> Noether's theorem needs a symmetry of the Lagrangian, not of the equations of motion or of the potential alone. A uniform field $V=mgz$ breaks translation in $z$, so $p_z$ is not conserved, yet $L$ still has translation symmetry in $x$ and $y$, and $p_x,p_y$ are conserved. Always ask which transformations leave $L$ itself invariant.
{: .trap}

# Where this goes next

The same pattern, symmetry in and conservation out, runs through field theory, where the conserved quantities become charges and currents, and through quantum mechanics, where the generators of translations and rotations are momentum and angular momentum. In the Hamiltonian formulation the statement takes its cleanest form: a quantity conserved under the flow of another one is expressed by a vanishing Poisson bracket.

# Recap

<details class="qa" markdown="1">
<summary>Why is the momentum of a cyclic coordinate conserved?</summary>

The Euler-Lagrange equation says $\dot p_k=\partial L/\partial q_k$, and a cyclic coordinate does not appear in $L$, so the right side is zero.
</details>

<details class="qa" markdown="1">
<summary>What does Noether's theorem add to cyclic coordinates?</summary>

It does not require the symmetry to be a shift of a coordinate: any one-parameter transformation that leaves $L$ invariant, such as a rotation, gives the conserved quantity $\sum_i p_i\,\delta q_i$.
</details>

<details class="qa" markdown="1">
<summary>Which symmetry gives conservation of energy, and what must hold?</summary>

Translation in time. If $L$ has no explicit time dependence then $H=\sum p_i\dot q_i-L$ is constant along the motion.
</details>
