---
collection: notes
title: Integrals
date: '2026-10-27'
excerpt: The Riemann integral, the fundamental theorem of calculus, and the main techniques of integration.
hook: Integration adds up infinitely many infinitely small pieces, and the fundamental theorem says that this is undoing differentiation.
goals:
- set up an integral as a limit of sums
- use the fundamental theorem and standard techniques
requires:
- limit
- derivative
defines:
- id: riemann-integral
  name: Riemann integral
  anchor: riemann-integral
- id: fundamental-theorem-of-calculus
  name: fundamental theorem of calculus
  anchor: fundamental-theorem-of-calculus
tags:
- Mathematics
- Calculus
read_time: true
---

Area under a curve, distance travelled from a speed, mass from a density: each is a sum of many small pieces. The integral makes the sum exact, and the fundamental theorem turns it into an antiderivative.

# Riemann integral

Take $f$ on $[a,b]$ and split the interval into $n$ strips of width $h=(b-a)/n$. The **left** and **right Riemann sums** use the height at the left and right end of each strip,
$$ L_n=h\sum_{i=0}^{n-1}f(x_i),\qquad R_n=h\sum_{i=1}^{n}f(x_i),\qquad x_i=a+ih. $$
For an increasing function the left sum underestimates and the right sum overestimates. The **Riemann integral** $\int_a^bf(x)\,dx$ is the common limit of these sums as $n\to\infty$, when it exists. It exists for every continuous $f$, and for bounded $f$ with finitely many jumps.

For $f(x)=x^2$ on $[0,1]$ with $n=8$, the sums are $L_8=0.2734$ and $R_8=0.3984$. They differ by $h(f(b)-f(a))=\tfrac18$, the area of one column of strips, and they bracket the exact value $\tfrac13$. Halving the strips halves the gap, so the error shrinks like $1/n$.

{% include fig.html src="calculus/riemann-sums" id="fig-riemann-sums" alt="The parabola x squared on zero to one with eight bars below the curve and an orange sliver above each bar that reaches the curve at the right end of the strip." caption="Left and right Riemann sums of $f(x)=x^2$ on $[0,1]$ with $n=8$. The blue bars sum to $L_8=0.2734$; adding the orange pieces gives $R_8=0.3984$; the exact area is $1/3$." %}

The integral is linear, $\int(cf+g)=c\int f+\int g$, additive over intervals, $\int_a^b+\int_b^c=\int_a^c$, and monotone: $f\le g$ implies $\int f\le\int g$. Areas below the axis count negatively, and $\int_b^a=-\int_a^b$.

# Fundamental theorem of calculus

Computing limits of sums is slow. The **fundamental theorem of calculus** replaces it with differentiation run backwards. It has two parts. If $f$ is continuous on $[a,b]$ and
$$ F(x)=\int_a^xf(t)\,dt, $$
then $F$ is differentiable and $F'(x)=f(x)$. And if $G$ is any antiderivative of $f$, meaning $G'=f$, then
$$ \int_a^bf(x)\,dx=G(b)-G(a). $$
The first part follows by applying the mean value theorem to $\big(F(x+h)-F(x)\big)/h=\tfrac1h\int_x^{x+h}f$: the average of $f$ over a short strip tends to $f(x)$ by continuity. The second part follows from the first, since $G$ and $F$ differ by a constant.

For $f(x)=x^2$ the antiderivative is $x^3/3$, giving $\int_0^1x^2\,dx=\tfrac13$, the value the sums were approaching. The same method gives $\int_0^\pi\sin x\,dx=[-\cos x]_0^\pi=2$.

# Techniques

Every differentiation rule has an integration counterpart. The derivative of a composition gives **substitution**: with $u=g(x)$,
$$ \int f(g(x))\,g'(x)\,dx=\int f(u)\,du. $$
For example, with $u=x^2$, $\int_0^1 2x\,e^{x^2}dx=\int_0^1e^u\,du=e-1$. The product rule gives **integration by parts**,
$$ \int u\,dv=uv-\int v\,du, $$
used for $\int x e^x\,dx=xe^x-e^x+C$, where $u=x$ and $dv=e^x\,dx$. Rational functions are integrated by **partial fractions**, writing, for instance, $\frac1{x(x+1)}=\frac1x-\frac1{x+1}$.

Many integrands have no elementary antiderivative, for example $e^{-x^2}$, and then numerical sums are the tool: the trapezoid rule, which averages $L_n$ and $R_n$, has error that shrinks like $1/n^2$.

> The second part needs an antiderivative to exist. The sign function is integrable, with $\int_{-1}^x\operatorname{sgn}t\,dt=|x|-1$, but nothing has it as a derivative, since $|x|$ has a corner at $0$.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>How is the Riemann integral defined?</summary>

As the limit of the sums $h\sum f(x_i)$ over $n$ strips of width $h=(b-a)/n$ as $n\to\infty$, equal for left and right endpoints when $f$ is continuous.
</details>

<details class="qa" markdown="1">
<summary>What are the two parts of the fundamental theorem?</summary>

$\frac{d}{dx}\int_a^xf=f(x)$ for continuous $f$, and $\int_a^bf=G(b)-G(a)$ for any antiderivative $G$ of $f$.
</details>

<details class="qa" markdown="1">
<summary>Which differentiation rules do substitution and integration by parts reverse?</summary>

The chain rule gives substitution, $\int f(g)g'\,dx=\int f\,du$; the product rule gives integration by parts, $\int u\,dv=uv-\int v\,du$.
</details>
