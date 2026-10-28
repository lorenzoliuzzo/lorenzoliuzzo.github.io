---
collection: notes
title: Complex Functions
date: '2026-10-27'
excerpt: Complex numbers, analytic functions, the Cauchy-Riemann equations and Cauchy's theorem.
hook: Being differentiable in the complex plane is a much stronger condition than on the line, and it makes integrals depend only on endpoints.
goals:
- decide whether a function is analytic
- use Cauchy's theorem and integral formula
defines:
- id: analytic-function
  name: analytic function
  anchor: analytic-function
- id: cauchy-theorem
  name: Cauchy's theorem
  anchor: cauchys-theorem
tags:
- Mathematics
- Mathematical Methods
read_time: true
---

Calculus on the real line asks that a function have a derivative. In the complex plane the same request is far more demanding, and what it buys is some of the strongest results in analysis.

# Analytic function

A complex number is $z=x+iy$ with $i^2=-1$, and a complex function is $f(z)=u(x,y)+i\,v(x,y)$. The derivative is defined by the same limit as on the real line,
$$ f'(z)=\lim_{h\to0}\frac{f(z+h)-f(z)}h, $$
but now $h$ is complex and may approach $0$ from any direction in the plane, and the limit must be the same for all of them. A function with a derivative at every point of an open region is **analytic** (or holomorphic) there.

Taking $h$ real and then $h$ imaginary gives two expressions for $f'$, and their equality is the **Cauchy-Riemann equations**,
$$ \frac{\partial u}{\partial x}=\frac{\partial v}{\partial y},\qquad \frac{\partial u}{\partial y}=-\frac{\partial v}{\partial x}. $$
They are necessary, and sufficient if the partial derivatives are continuous. Polynomials, $e^z$, $\sin z$ and $\cos z$ are analytic everywhere, and $1/z$ is analytic except at $0$. The function $f(z)=\bar z=x-iy$ is not, since $u_x=1$ and $v_y=-1$; neither is $|z|^2$.

Analytic functions are **conformal**: where $f'\ne0$, the map $z\mapsto f(z)$ preserves angles, rotating by $\arg f'$ and scaling by $|f'|$ locally. The map $w=z^2$ sends the lines $x=\text{const}$ and $y=\text{const}$, which cross at right angles, to two families of parabolas that still cross at right angles.

{% include fig.html src="mathematical-methods/conformal-map" id="fig-conformal-map" alt="Left, a square grid of horizontal and vertical lines. Right, its image under w equals z squared: two families of parabolas opening in opposite directions that cross each other at right angles." caption="The analytic map $w=z^2$ sends the grid of lines $x=\text{const}$ (blue) and $y=\text{const}$ (orange) to confocal parabolas. Angles between curves are preserved wherever $f'(z)=2z\ne0$." %}

The real and imaginary parts of an analytic function are **harmonic**, $\nabla^2u=\nabla^2v=0$, which follows by differentiating the Cauchy-Riemann equations. This is why complex analysis solves two-dimensional electrostatics and fluid flow.

# Cauchy's theorem

Integrate along a curve $C$ in the plane, $\int_Cf(z)\,dz$, with $z=z(t)$ parametrising it. For $f(z)=z^n$ on the unit circle $z=e^{i\theta}$, $dz=ie^{i\theta}d\theta$ and
$$ \oint z^n\,dz=i\int_0^{2\pi}e^{i(n+1)\theta}\,d\theta=\begin{cases}2\pi i&n=-1\\0&\text{otherwise}.\end{cases} $$
The single case $n=-1$, the function $1/z$, gives $2\pi i$, and every other power gives zero. This is the model for the whole subject.

**Cauchy's theorem.** If $f$ is analytic in a simply connected region and $C$ is a closed curve in it, then
$$ \oint_Cf(z)\,dz=0. $$
Equivalently, the integral between two points does not depend on the path, so $f$ has an antiderivative and the fundamental theorem applies. A proof uses Green's theorem: $\oint(u+iv)(dx+i\,dy)=\oint(u\,dx-v\,dy)+i\oint(v\,dx+u\,dy)$, and the two real integrals equal $\iint(-v_x-u_y)\,dA$ and $\iint(u_x-v_y)\,dA$, both zero by the Cauchy-Riemann equations. It fails when the region contains a point where $f$ is not analytic, as $1/z$ does at $0$.

The **Cauchy integral formula** says that the values of $f$ inside a curve are fixed by its values on it. For $a$ inside a closed curve $C$ (traversed counterclockwise),
$$ f(a)=\frac1{2\pi i}\oint_C\frac{f(z)}{z-a}\,dz. $$
One consequence is that an analytic function is infinitely differentiable and given locally by its Taylor series, $f^{(n)}(a)=\frac{n!}{2\pi i}\oint\frac{f(z)}{(z-a)^{n+1}}dz$. This is the reason for the word "analytic", and it contrasts sharply with real functions, which can be differentiated once and not twice. Another is **Liouville's theorem**: a bounded function analytic in the whole plane is constant. These facts lead to the residue theorem, the main tool for computing real integrals.

> Smooth in the real sense is not analytic: $\bar z$, $|z|$ and $\operatorname{Re}z$ are all infinitely differentiable as functions of $(x,y)$ and none is complex differentiable.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>What does analytic mean, and how is it tested?</summary>

Complex differentiable at every point of an open region. With continuous partial derivatives this is equivalent to the Cauchy-Riemann equations $u_x=v_y$, $u_y=-v_x$.
</details>

<details class="qa" markdown="1">
<summary>What does Cauchy's theorem say?</summary>

For $f$ analytic in a simply connected region and any closed curve $C$ in it, $\oint_Cf\,dz=0$; the integral depends only on the end points. It fails for $1/z$ around $0$, where $\oint=2\pi i$.
</details>

<details class="qa" markdown="1">
<summary>What does the Cauchy integral formula give?</summary>

$f(a)=\frac1{2\pi i}\oint f(z)/(z-a)\,dz$ for $a$ inside $C$: the boundary values determine the interior, and $f$ is infinitely differentiable.
</details>
