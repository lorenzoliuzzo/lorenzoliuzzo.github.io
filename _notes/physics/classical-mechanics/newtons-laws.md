---
collection: notes
title: Newton's Laws and Kinematics
date: '2026-10-27'
excerpt: Kinematics, the three laws, forces and inertial frames.
hook: A force changes motion in proportion to itself, and the laws only hold in frames that do not themselves accelerate.
goals:
- write the equation of motion of a system from its forces
- solve one-dimensional motion with constant and variable force
defines:
- id: newtons-laws
  name: Newton's laws
  anchor: the-three-laws
- id: inertial-frame
  name: inertial frame
  anchor: inertial-frames
plan:
  sources: []
  figures:
  - free-body diagram for a block on an incline
  - trajectory under constant and linear drag force
  verify:
  - terminal speed with linear drag is mg/b
tags:
- Physics
- Classical Mechanics
read_time: true
---

Mechanics begins with a rule that turns forces into motion: given the forces on a body and where it starts, the future follows. The rule is short, and most of the work is in using it well.

# Kinematics

Describe a point particle by its position $\mathbf r(t)$. The **velocity** is $\mathbf v=\dot{\mathbf r}$ and the **acceleration** is $\mathbf a=\dot{\mathbf v}=\ddot{\mathbf r}$, derivatives with respect to time. In one dimension, constant acceleration gives
$$ v=v_0+at,\qquad x=x_0+v_0t+\tfrac12at^2,\qquad v^2=v_0^2+2a(x-x_0). $$
These are integrals of $a$, and they stop applying once the acceleration changes with time, position or velocity, which is the usual situation.

# The three laws

The **first law** says that a body on which no net force acts keeps its velocity. The **second law** says that the momentum $\mathbf p=m\mathbf v$ changes at a rate equal to the net force,
$$ \mathbf F=\dot{\mathbf p},\qquad\text{so}\qquad m\ddot{\mathbf r}=\mathbf F(\mathbf r,\dot{\mathbf r},t) $$
for constant mass. The **third law** says forces between two bodies are equal and opposite, $\mathbf F_{12}=-\mathbf F_{21}$. It is what makes the total momentum of an isolated system constant.

The second law is a differential equation. Given $\mathbf F$ as a function of position, velocity and time, and the initial position and velocity, the trajectory is determined. This is the sense in which classical mechanics is deterministic: two initial conditions, not one, because the equation is of second order.

> The first law is not a special case of the second. It says that inertial frames exist, which is a statement about nature and not about algebra.
{: .idea}

# Inertial frames

The laws cannot hold in every frame. If we describe a free particle from a frame that accelerates with acceleration $\mathbf A$, the particle appears to accelerate by $-\mathbf A$ with no force acting. An **inertial frame** is one in which a free particle moves with constant velocity; the first law asserts that such frames exist. Any frame moving at constant velocity relative to an inertial frame is again inertial, which is the Galilean principle of relativity: the second law has the same form in all of them. A frame fixed to the ground is inertial only to a good approximation, and a later note treats the corrections when the rotation of the Earth matters.

# Solving the equation of motion

The recipe is the same each time. Draw a diagram and list the forces, one per interaction. Choose axes. Write $m\ddot{\mathbf r}$ component by component, solve, and fix the constants by the initial conditions.

For a block of mass $m$ on a frictionless incline at angle $\theta$, the two forces are gravity $m\mathbf g$ and the normal force $\mathbf N$ perpendicular to the surface. Along the incline the equation is $m\ddot x=mg\sin\theta$, so $a=g\sin\theta$ and the motion is the constant-acceleration case. Perpendicular to the incline there is no acceleration, which gives $N=mg\cos\theta$.

Variable forces need the equation itself. A body falling with a linear drag force $-b\mathbf v$ obeys, with $v$ the downward speed,
$$ m\dot v=mg-bv. $$
At large $t$ the acceleration vanishes and the speed approaches $v_t=mg/b$, the terminal speed. The exact solution is $v(t)=v_t(1-e^{-t/\tau})$ with $\tau=m/b$, which is checked by substitution: $\dot v=(v_t/\tau)e^{-t/\tau}$ and $mg-bv=bv_te^{-t/\tau}$, and these agree because $v_t/\tau=bv_t/m$. For $m=1\ \mathrm{kg}$ and $b=1\ \mathrm{kg/s}$ this gives $v_t=9.81\ \mathrm{m/s}$ and, after one time constant $\tau=1$ s, $v=0.63v_t=6.2\ \mathrm{m/s}$. Without drag the speed would be $9.81\ \mathrm{m/s}$ already.

{% include fig.html src="classical-mechanics/drag-speed" id="fig-drag-speed" alt="Speed against time. A straight line rises steadily; a second curve rises with the same initial slope and flattens towards a dashed horizontal line at 9.81 metres per second. A marked point shows the speed after one time constant." caption="Speed of a falling body without drag (straight line) and with linear drag (curve), for $m=1\ \mathrm{kg}$ and $b=1\ \mathrm{kg/s}$. The dashed line is the terminal speed $mg/b$; the point marks $t=\tau$, where the speed is $63\%$ of it." %}

{% capture t %}
| Quantity | Symbol | Unit |
|:--|:--|:--|
| velocity | $\mathbf v=\dot{\mathbf r}$ | m/s |
| acceleration | $\mathbf a=\ddot{\mathbf r}$ | m/s$^2$ |
| momentum | $\mathbf p=m\mathbf v$ | kg m/s |
| force | $\mathbf F=\dot{\mathbf p}$ | N = kg m/s$^2$ |
{% endcapture %}
{% include tab.html id="tab-kinematics" caption="Quantities and units of Newtonian mechanics." body=t %}
{: .booktabs}

# Recap

<details class="qa" markdown="1">
<summary>What do the three laws say?</summary>

Without net force the velocity is constant; the net force equals the rate of change of momentum; and the forces two bodies exert on each other are equal and opposite.
</details>

<details class="qa" markdown="1">
<summary>What is an inertial frame?</summary>

A frame in which a free particle moves with constant velocity. Frames moving uniformly relative to one are inertial too; accelerating frames are not.
</details>

<details class="qa" markdown="1">
<summary>What is the terminal speed with linear drag, and how fast is it approached?</summary>

$v_t=mg/b$, approached as $1-e^{-t/\tau}$ with $\tau=m/b$.
</details>
