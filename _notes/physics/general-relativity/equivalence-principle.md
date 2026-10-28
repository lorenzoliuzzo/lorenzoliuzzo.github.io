---
collection: notes
title: The Equivalence Principle
date: '2026-10-27'
excerpt: Inertial and gravitational mass, free fall, local inertial frames and the case for a geometric theory of gravity.
hook: In a freely falling laboratory gravity disappears locally, so gravity cannot be a force like the others; it has to be a property of spacetime itself.
goals:
- state the weak and strong equivalence principles
- explain gravitational redshift and light bending from the principle alone
defines:
- id: equivalence-principle
  name: equivalence principle
  anchor: equivalence-principle
- id: local-inertial-frame
  name: local inertial frame
  anchor: local-inertial-frame
tags:
- Physics
- General Relativity
read_time: true
---

In a lift whose cable has snapped, a dropped coin floats beside you. Einstein took this seriously: gravity cannot be felt in free fall, so it cannot be a force like the others.

# Equivalence principle

Newton's theory has two masses. **Inertial mass** $m_i$ appears in $\mathbf F=m_i\mathbf a$ and measures resistance to acceleration; **gravitational mass** $m_g$ appears in the weight $\mathbf F=m_g\mathbf g$ and measures coupling to the field. If they were independent, bodies of different composition would fall differently. In fact
$$ \mathbf a=\frac{m_g}{m_i}\,\mathbf g $$
is the same for all bodies, and so $m_g/m_i$ is a universal constant that can be set to $1$. This is Galileo's observation, made precise by Eötvös-type torsion-balance experiments, which find that $m_g/m_i$ is the same for different materials to better than a part in $10^{13}$ (a value to check against the literature).

The **weak equivalence principle** states this: the trajectory of a freely falling test body does not depend on its mass or composition. The **Einstein equivalence principle** goes further: in a small enough freely falling laboratory, *all* non-gravitational physics, mechanical, electromagnetic and nuclear, is the same as in special relativity, whatever the position and the time. The **strong** version extends this to gravitational physics, including the body's own gravity.

For Newtonian gravity the weak principle is natural, since $m_g$ cancels in the acceleration. It is the question of why the cancellation is exact that gives the principle content, and Einstein's answer is that gravity is the same thing as acceleration of the frame.

# Local inertial frame

In a freely falling box, all objects fall alike, so relative to the box they feel no force: the box is a **local inertial frame**, in which the laws of special relativity hold. The word local is essential. If the box is large, tidal effects appear: two stones released at the sides of the box fall toward the centre of the Earth along converging lines, and two stones released one above the other separate, because the field is not uniform. These residual effects cannot be removed by any choice of frame and they are the true signature of gravity. In the limit of a small region and short time they vanish.

The converse is also true. In a rocket far from any mass, accelerating with $a=g$, an observer inside sees dropped objects fall with acceleration $g$ and stands on the floor with weight $mg$. The two situations, a uniform gravitational field and a uniformly accelerating frame, cannot be told apart by local experiments.

# Consequences without a theory of gravity

The principle alone implies two effects.

**Light bends.** In the accelerating rocket, a light beam crossing the width $x$ of the cabin takes $t=x/c$, during which the floor moves up by $\tfrac12g(x/c)^2$. So the beam appears to fall along $y=-gx^2/(2c^2)$ relative to the cabin. By the principle the same happens in a gravitational field: light falls. Over $1\ \mathrm m$ the drop is $5.5\times10^{-17}\ \mathrm m$, far too small to see, but for light grazing the Sun the principle alone gives a deflection of $0.87''$, half of the $1.75''$ that full general relativity predicts (both values to be checked against a reference), the other half coming from the curvature of space.

{% include fig.html src="general-relativity/elevator-light" id="fig-elevator-light" alt="A box with a horizontal dashed line across it, a curved beam that drops below the line as it crosses the box, and an upward arrow labelled with the acceleration." caption="In a box accelerating upward at $a=g$ a horizontal light beam follows $y=-gx^2/(2c^2)$. The picture is a sketch with the curvature exaggerated; over $1\ \mathrm m$ the drop is $5.5\times10^{-17}\ \mathrm m$." %}

**Clocks run at different rates.** A light pulse emitted upward in the accelerating rocket reaches the ceiling, a height $h$ above, after $h/c$, when the ceiling is moving faster by $g h/c$. A receiver moving away at that speed sees the frequency lowered by the Doppler shift, so
$$ \frac{\Delta f}{f}=-\frac{gh}{c^2}. $$
Light climbing out of a gravitational field loses frequency, the **gravitational redshift**. For $h=22.5\ \mathrm m$, the height of the Harvard tower in the Pound and Rebka experiment, the shift is $gh/c^2=2.46\times10^{-15}$, which they measured (a figure to verify in the original paper). Clocks higher up run faster, and GPS satellites must be corrected for it.

These two results are the argument for a geometric theory. If clocks and light rays respond to gravity in a way that does not depend on what they are made of, then the response belongs to spacetime, and free fall is motion along the straightest possible path in a curved geometry.

# Recap

<details class="qa" markdown="1">
<summary>What do the weak and Einstein equivalence principles say?</summary>

Weak: the motion of a freely falling test body is independent of its mass and composition ($m_g=m_i$). Einstein: in a small freely falling frame, all non-gravitational physics is that of special relativity.
</details>

<details class="qa" markdown="1">
<summary>What is a local inertial frame, and why only local?</summary>

A freely falling frame in which gravity vanishes. Over larger regions the non-uniformity of the field appears as tidal effects, which no frame removes.
</details>

<details class="qa" markdown="1">
<summary>What follows from the equivalence principle alone?</summary>

Light is deflected by gravity and clocks at different heights run at different rates: $\Delta f/f=gh/c^2$.
</details>
