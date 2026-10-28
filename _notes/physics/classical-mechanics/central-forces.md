---
collection: notes
title: Central Forces and Kepler
date: '2026-10-27'
excerpt: Motion in a central potential, the effective potential and the Kepler problem.
hook: Angular momentum conservation reduces a three-dimensional orbit to a one-dimensional problem in an effective potential.
goals:
- reduce a central-force problem to one dimension
- derive the shape of Kepler orbits and Kepler's laws
requires:
- angular-momentum
- potential-energy
defines:
- id: effective-potential
  name: effective potential
  anchor: effective-potential
- id: kepler-problem
  name: Kepler problem
  anchor: kepler-problem
tags:
- Physics
- Classical Mechanics
read_time: true
---

A planet moves under a force that always points to the Sun. That one fact, with conservation of angular momentum, reduces a problem in three dimensions to a one-dimensional one.

# Effective potential

A **central force** points along the line to a fixed centre and depends only on the distance, $\mathbf F=-\nabla V(r)$. Its torque about the centre is zero, so the angular momentum $\mathbf L$ is constant and the motion stays in a plane. Use polar coordinates $(r,\varphi)$ in it, with the mass $m$. The conserved angular momentum is $L=mr^2\dot\varphi$, and the energy is
$$ E=\tfrac12m\dot r^2+\tfrac12mr^2\dot\varphi^2+V(r)=\tfrac12m\dot r^2+\underbrace{\frac{L^2}{2mr^2}+V(r)}_{U_{\mathrm{eff}}(r)}. $$
The angle has been eliminated, and the radial motion is that of a particle in one dimension with the **effective potential** $U_{\mathrm{eff}}(r)=V(r)+L^2/(2mr^2)$. The extra term, the **centrifugal barrier**, repels from the centre and grows with $L$. The radial motion is confined to the region where $E\ge U_{\mathrm{eff}}$, with **turning points** at equality, and a circular orbit sits at a minimum of $U_{\mathrm{eff}}$.

The area swept by the radius vector grows at the rate $\tfrac12r^2\dot\varphi=L/2m$, a constant. This is Kepler's second law, and it holds for every central force, not only gravity.

# Kepler problem

For gravity, or the Coulomb force between opposite charges, $V=-k/r$ with $k=GMm$. Then $U_{\mathrm{eff}}=L^2/(2mr^2)-k/r$ has a minimum at $r_0=L^2/(mk)$, with value $-mk^2/(2L^2)$. For $E$ below zero and above this minimum, $r$ oscillates between two turning points. For $E\ge0$ the orbit comes in from infinity and leaves again.

{% include fig.html src="classical-mechanics/kepler-orbit" id="fig-kepler-orbit" alt="On the left the effective potential of the Kepler problem with a minimum at r equal one and a dashed horizontal energy line cutting it at two turning points. On the right an ellipse with the centre of force at one focus." caption="The Kepler effective potential for $m=k=L=1$ and the orbit at $E=-0.32$. The turning points $r_{\min}=0.62$ and $r_{\max}=2.50$ are the closest and farthest distances; the force centre sits at the focus of the ellipse, whose eccentricity is $e=\sqrt{1+2E}=0.60$." %}

To find the shape, write $u=1/r$ and use $\varphi$ in place of time as the variable, via $\dot\varphi=L/mr^2$. The radial equation becomes the equation of a harmonic oscillator with a constant source,
$$ \frac{d^2u}{d\varphi^2}+u=\frac{mk}{L^2}, $$
whose solution is $u=\dfrac{mk}{L^2}\big(1+e\cos\varphi\big)$. Hence
$$ r(\varphi)=\frac{p}{1+e\cos\varphi},\qquad p=\frac{L^2}{mk},\qquad e=\sqrt{1+\frac{2EL^2}{mk^2}}. $$
This is a conic section with the centre of force at a focus. For $E<0$, $e<1$ and the orbit is an **ellipse**, with semi-major axis $a=p/(1-e^2)=k/(2|E|)$, depending only on the energy. For $E=0$, $e=1$ is a parabola, and for $E>0$, $e>1$ is a hyperbola. Circles have $e=0$, at $E=-mk^2/(2L^2)$. With $m=k=L=1$ and $E=-0.32$ the formulas give $e=0.60$, $p=1$, $r_{\min}=p/(1+e)=0.625$ and $r_{\max}=p/(1-e)=2.5$, as in the figure.

The three **Kepler laws** follow:

1. orbits are ellipses with the Sun at a focus (the formula above);
2. the radius vector sweeps equal areas in equal times (angular momentum conservation);
3. the period satisfies $\tau^2\propto a^3$.

For the third law, the area of the ellipse is $\pi ab$ and it is swept at the rate $L/2m$, so $\tau=2m\pi ab/L$. With $b=a\sqrt{1-e^2}$ and $L^2=mkp=mka(1-e^2)$ this gives
$$ \tau^2=\frac{4\pi^2m}{k}\,a^3=\frac{4\pi^2}{GM}\,a^3, $$
because $k=GMm$. The mass of the orbiting body drops out, to the extent that it is small compared with $M$.

> The inverse-square force is special: for most other central forces the orbits are not closed. Bertrand's theorem says that only $V\propto1/r$ and $V\propto r^2$ give closed orbits for all bound motion.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>How does angular momentum reduce a central-force problem to one dimension?</summary>

$L=mr^2\dot\varphi$ is constant, so the energy becomes $\tfrac12m\dot r^2+U_{\mathrm{eff}}(r)$ with $U_{\mathrm{eff}}=V+L^2/(2mr^2)$, a one-dimensional problem in $r$.
</details>

<details class="qa" markdown="1">
<summary>What is the shape of a Kepler orbit?</summary>

A conic, $r=p/(1+e\cos\varphi)$ with $p=L^2/mk$ and $e=\sqrt{1+2EL^2/mk^2}$: an ellipse for $E<0$, a parabola for $E=0$ and a hyperbola for $E>0$.
</details>

<details class="qa" markdown="1">
<summary>What are Kepler's laws and where do they come from?</summary>

Elliptical orbits (the $1/r$ potential), equal areas in equal times (angular momentum conservation), and $\tau^2\propto a^3$ (the area of the ellipse divided by the constant rate of area sweep).
</details>
