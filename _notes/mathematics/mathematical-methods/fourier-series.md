---
collection: notes
title: "Fourier Series"
date: 2026-10-27
excerpt: "Periodic functions as sums of sines and cosines, convergence and Parseval."
hook: "A periodic function is a sum of harmonics, and the coefficients are projections onto an orthogonal family."
goals:
  - compute the Fourier series of a function
  - state the convergence result and Parseval's identity
requires:
  - riemann-integral
  - series
defines:
  - {id: fourier-series, name: "Fourier series", anchor: def-fourier-series}
read_time: true
tags:
  - Mathematics
  - Mathematical Methods
---

A violin string, a voltage in a circuit and a planet's orbit all repeat, and repeating functions can be built out of the simplest repeating functions, sines and cosines. The coefficients are found by projection, exactly as one finds the components of a vector along perpendicular axes.

# Orthogonal harmonics

Take a function $f$ of period $2\pi$. The harmonics $1,\cos nx,\sin nx$ for $n=1,2,\dots$ are mutually orthogonal under the inner product $\langle f,g\rangle=\int_{-\pi}^{\pi}fg\,dx$:

> $\displaystyle\int_{-\pi}^{\pi}\sin mx\,\sin nx\,dx=\int_{-\pi}^{\pi}\cos mx\,\cos nx\,dx=\pi\,\delta_{mn}$ for $m,n\ge1$, while $\displaystyle\int_{-\pi}^{\pi}\sin mx\,\cos nx\,dx=0$ for all $m,n$, and $\displaystyle\int_{-\pi}^{\pi}\cos nx\,dx=0$ for $n\ge1$.
{: .property title="Orthogonality of the harmonics"}

They follow from the product-to-sum formulas for trigonometric functions. If $f$ is a combination of harmonics, taking the inner product with one of them isolates its coefficient, which is projection onto an axis of an orthogonal basis of a function space.

> The **Fourier series** of a $2\pi$-periodic function $f$ is
> $$ f(x)\sim\frac{a_0}2+\sum_{n=1}^\infty\big(a_n\cos nx+b_n\sin nx\big),\qquad a_n=\frac1\pi\int_{-\pi}^{\pi}f\cos nx\,dx,\quad b_n=\frac1\pi\int_{-\pi}^{\pi}f\sin nx\,dx. $$
{: .definition #def-fourier-series title="Fourier series"}

For period $L$ one replaces $x$ by $2\pi x/L$. The complex form is shorter: $f=\sum_nc_ne^{inx}$ with $c_n=\frac1{2\pi}\int f\,e^{-inx}\,dx$, and it is the starting point of the Fourier transform. If $f$ is even only the cosines appear, and if it is odd only the sines do, which halves the work.

> The square wave $f(x)=\operatorname{sign}x$ on $(-\pi,\pi)$ is odd, so $a_n=0$ and $b_n=\frac2{n\pi}(1-\cos n\pi)$, which is $4/(n\pi)$ for odd $n$ and $0$ for even $n$:
> $$ \operatorname{sign}x=\frac4\pi\Big(\sin x+\frac{\sin3x}3+\frac{\sin5x}5+\cdots\Big). $$
> At $x=\pi/2$ the left side is $1$ and the series becomes $\pi/4=1-\frac13+\frac15-\cdots$, Leibniz's series, recovered for free.
{: .example title="The square wave"}

# Convergence

Does the series actually add up to $f$? For the functions of physics the answer is yes, with one exception at the points where $f$ jumps.

> **Dirichlet's theorem.** If $f$ is periodic and piecewise smooth, its Fourier series converges at every point to $\tfrac12\big(f(x^+)+f(x^-)\big)$: to $f(x)$ where $f$ is continuous, and to the midpoint of the jump where it is not {% cite stein-shakarchi-2003 %}.
{: .theorem #thm-dirichlet title="Dirichlet's theorem"}

{% include fig.html src="mathematical-methods/fourier-square-wave" id="fig-fourier-square-wave" alt="Three partial sums of the square wave series. With two terms the curve is a smooth wave resembling the square wave. With eight and forty terms the curves are flatter along the plateaus and steeper at the jump, each with a spike beyond the plateau just beside the jump." caption="Partial sums of the series for $\operatorname{sign}x$. The plateaus flatten as terms are added, but a spike next to the jump persists: its height stays near $1.18$, about $9\%$ of the jump above the plateau, while it moves closer to the jump." %}

That persistent spike is the **Gibbs phenomenon**. The partial sums converge at each point but not uniformly across the jump, so adding terms narrows the overshoot without lowering it. In practice it appears as ringing next to every sharp edge in a truncated spectrum.

How quickly the coefficients fall tells how smooth $f$ is.

> The coefficients of a function with a jump decay like $1/n$, those of a continuous function with kinks like $1/n^2$, and each further continuous derivative gains another factor of $1/n$; for an analytic periodic function they decay exponentially.
{: .property title="Smoothness and decay of the coefficients"}

This is why a handful of terms describe a smooth signal and why a sharp feature needs many.

# Parseval's identity

The same orthogonality gives the length of $f$ in terms of its coefficients, the Pythagorean theorem in a function space.

> **Parseval's identity.** For a square-integrable $f$, $\displaystyle\frac1\pi\int_{-\pi}^{\pi}f^2\,dx=\frac{a_0^2}2+\sum_{n=1}^\infty\big(a_n^2+b_n^2\big)$.
{: .theorem #thm-parseval title="Parseval's identity"}

> With the inner product $\langle f,g\rangle=\frac1\pi\int_{-\pi}^{\pi}fg\,dx$, the functions $1/\sqrt2,\cos nx,\sin nx$ are orthonormal, and $a_n,b_n$ are the components of $f$ along them. In an orthonormal basis the squared length is the sum of the squared components, which is the identity. That the basis is complete, so that no length is missing, is the content of the convergence theory {% cite stein-shakarchi-2003 %}.
{: .proof}

Read as energy: the energy in a signal is the sum of the energies in its harmonics, and $a_n^2+b_n^2$ is the power spectrum. For the square wave the left side is $\frac1\pi\cdot2\pi=2$ and the right side is $\sum_{n\ \text{odd}}16/(\pi^2n^2)$, so the identity says $\sum_{n\ \mathrm{odd}}1/n^2=\pi^2/8$, which a direct sum confirms ($1.2337$).

> A function given only on an interval $(0,\ell)$ has no unique Fourier series: one chooses how to extend it to a periodic function. An odd extension gives a sine series and an even one a cosine series, and the choice should match the boundary conditions of the problem, as it will when the series solve the heat and wave equations.
{: .trap}

> The coefficient formulas hold only for the period they are written for. Before integrating, check the period and whether the function is even or odd, and carry the integration over exactly one period.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why can the Fourier coefficients be found by integrals?</summary>

The harmonics are orthogonal under $\int_{-\pi}^{\pi}fg\,dx$, so multiplying $f$ by one harmonic and integrating leaves only that harmonic's coefficient.
</details>

<details class="qa" markdown="1">
<summary>What does the Fourier series converge to at a jump, and what is the Gibbs phenomenon?</summary>

To the midpoint of the jump. Near the jump the partial sums overshoot by about $9\%$ of the jump height, and the overshoot does not shrink as terms are added; only its width does.
</details>

<details class="qa" markdown="1">
<summary>What does Parseval's identity say physically?</summary>

The total energy (mean square) of a periodic signal equals the sum of the energies of its harmonics, so no energy is lost or created by the decomposition.
</details>
