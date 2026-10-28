---
collection: notes
title: "Multiple Integrals"
date: 2026-10-27
excerpt: "Double and triple integrals, iterated integration, and change of variables in polar, cylindrical and spherical coordinates."
hook: "A volume or a total charge is an integral over a region, and the right coordinates turn a hard region into a box."
goals:
  - set up and evaluate a double or triple integral
  - change variables using the Jacobian
requires:
  - riemann-integral
  - jacobian
defines:
  - {id: multiple-integral, name: "multiple integral", anchor: def-multiple-integral}
  - {id: change-of-variables, name: "change of variables", anchor: def-change-of-variables}
read_time: true
tags:
  - Mathematics
  - Calculus
---

A mass, a charge or a probability spread over a plane or a solid is a sum of tiny contributions, one per piece of the region. That sum is a multiple integral, and most of the work in evaluating it is choosing coordinates in which the region is simple.

# Integrals over a region

> The **multiple integral** of $f$ over a region $D\subset\mathbb R^n$ is the limit of the Riemann sums $\sum_if(\mathbf x_i)\,\Delta V_i$ over finer and finer partitions of $D$ into small cells of volume $\Delta V_i$. It is written $\iint_Df\,dA$ in the plane and $\iiint_Df\,dV$ in space.
{: .definition #def-multiple-integral title="Multiple integral"}

For $f=1$ it gives the area or volume of $D$; for a density $\rho$ it gives the total mass. For a continuous $f$ on a reasonable region the limit exists.

> **Fubini's theorem.** If $f$ is continuous on $D=[a,b]\times[c,d]$, the double integral equals the iterated integrals in either order: $\iint_Df\,dA=\int_a^b\Big(\int_c^df\,dy\Big)dx=\int_c^d\Big(\int_a^bf\,dx\Big)dy$.
{: .theorem #thm-fubini title="Fubini's theorem"}

> For continuous $f$ the inner integral $F(x)=\int_c^df(x,y)\,dy$ is a continuous function of $x$. A Riemann sum of the double integral can be grouped by rows, which gives a Riemann sum of $F$, or by columns, which gives one for $G(y)=\int_a^bf\,dx$. Both converge to the double integral as the cells shrink.
{: .derive}

For a non-rectangular region the inner limits depend on the outer variable: over the triangle $0\le y\le x\le1$, $\iint x\,dA=\int_0^1x\Big(\int_0^xdy\Big)dx=\int_0^1x^2dx=\frac13$. Drawing the region first and reading off the limits from the picture is the step where errors enter, so it is worth swapping the order when one of them gives a simpler inner integral.

> Over an unbounded region or for an integrand that changes sign, the order of integration can change the answer. Fubini needs absolute integrability, $\iint|f|\,dA<\infty$.
{: .trap}

# Changing variables

Cartesian cells are rectangles of the same area everywhere, but a region with circular symmetry is a rectangle in polar coordinates $(r,\theta)$. A polar cell between $r$ and $r+dr$ and between $\theta$ and $\theta+d\theta$ is nearly a rectangle with sides $dr$ and $r\,d\theta$, so its area is $r\,dr\,d\theta$.

> **Change of variables.** If $\mathbf x=\mathbf x(\mathbf u)$ maps a region $D'$ one-to-one onto $D$ with continuous derivatives, then $\int_Df(\mathbf x)\,d\mathbf x=\int_{D'}f(\mathbf x(\mathbf u))\,\Big|\det\frac{\partial\mathbf x}{\partial\mathbf u}\Big|\,d\mathbf u$. The determinant is that of the Jacobian matrix of the map.
{: .theorem #def-change-of-variables title="Change of variables"}

> On a small cell the map is close to its linear approximation $\mathbf x\approx\mathbf x_0+J\,\Delta\mathbf u$, and a linear map takes a box of volume $\Delta V_u$ to a parallelepiped of volume $|\det J|\,\Delta V_u$. Summing over cells and letting them shrink gives the formula. A full proof also bounds the error of the linear approximation.
{: .derive}

The Jacobian determinant is the local factor by which the map stretches volumes, which is why it appears. In polar coordinates $x=r\cos\theta,\ y=r\sin\theta$ give $\det=r$; in cylindrical coordinates it is again $r$, and in spherical coordinates $r^2\sin\theta$.

{% include fig.html src="calculus/polar-area-element" id="fig-polar-area-element" alt="A quarter disc drawn with a polar grid of circles and rays. One cell between two neighbouring circles and two neighbouring rays is outlined and labelled r dr d theta." caption="Polar cells grow with the radius: the highlighted cell has area close to $r\,dr\,d\theta$, and the factor $r$ is the Jacobian of the change from Cartesian coordinates." %}

# Two classic evaluations

> The Gaussian integral $\int_{-\infty}^{\infty}e^{-x^2}dx=\sqrt\pi$ cannot be found with an antiderivative, but its square can be computed over the plane: $\Big(\int e^{-x^2}dx\Big)^2=\iint e^{-(x^2+y^2)}dx\,dy=\int_0^{2\pi}\!\!\int_0^\infty e^{-r^2}\,r\,dr\,d\theta=2\pi\cdot\tfrac12=\pi$.
{: .example title="The Gaussian integral"}

The extra factor $r$ is what makes the radial integral elementary. The volume of a ball of radius $R$ in spherical coordinates is $\int_0^{2\pi}d\varphi\int_0^\pi\sin\theta\,d\theta\int_0^Rr^2dr=2\pi\cdot2\cdot\frac{R^3}3=\frac43\pi R^3$, and the same method gives the field of a charged sphere in the electrostatics notes.

{% capture t %}
| Coordinates | Map | Volume element |
|:--|:--|:--|
| polar | $x=r\cos\theta,\ y=r\sin\theta$ | $r\,dr\,d\theta$ |
| cylindrical | $x=r\cos\varphi,\ y=r\sin\varphi,\ z=z$ | $r\,dr\,d\varphi\,dz$ |
| spherical | $x=r\sin\theta\cos\varphi,\ y=r\sin\theta\sin\varphi,\ z=r\cos\theta$ | $r^2\sin\theta\,dr\,d\theta\,d\varphi$ |
{% endcapture %}
{% include tab.html id="tab-volume-elements" caption="The three standard coordinate systems and their volume elements." body=t %}
{: .booktabs}

> Choose coordinates that make the boundary of the region constant ($r\le R$, $\theta_1\le\theta\le\theta_2$) and look at the integrand for the combination it depends on ($x^2+y^2$ suggests polar). Then multiply by the Jacobian and do the innermost integral first.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What is a multiple integral, and how is it evaluated?</summary>

It is the limit of sums of $f$ times cell volume. For continuous integrands it is computed as iterated one-dimensional integrals, with limits taken from the shape of the region.
</details>

<details class="qa" markdown="1">
<summary>Why does the polar area element contain a factor $r$?</summary>

A cell $dr\times d\theta$ has width $dr$ and arc length $r\,d\theta$. The factor is the Jacobian determinant of the map from polar to Cartesian coordinates.
</details>

<details class="qa" markdown="1">
<summary>How is $\int e^{-x^2}dx$ computed?</summary>

Square it, write the square as a double integral over the plane, and change to polar coordinates, where the Jacobian $r$ lets the radial integral be done in closed form. The result is $\sqrt\pi$.
</details>
