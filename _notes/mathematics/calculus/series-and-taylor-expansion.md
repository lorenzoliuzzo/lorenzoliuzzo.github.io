---
collection: notes
title: "Series and Taylor Expansion"
date: 2026-10-27
excerpt: "Convergence of series, power series, and Taylor polynomials with their error."
hook: "Near a point a smooth function is a polynomial plus a remainder, which is why small-quantity approximations work throughout physics."
goals:
  - test a series for convergence
  - expand a function and bound the error
requires:
  - limit
  - derivative
  - riemann-integral
defines:
  - {id: series, name: "series", anchor: def-series}
  - {id: taylor-expansion, name: "Taylor expansion", anchor: def-taylor-expansion}
read_time: true
tags:
  - Mathematics
  - Calculus
---

Adding infinitely many terms only makes sense through a limit, and once it does, a smooth function near a point can be written as a polynomial plus a controlled error. That is the machinery behind every "for small $x$" in physics.

# Series

> A **series** $\sum_{k=0}^\infty a_k$ is the limit of its partial sums $s_n=\sum_{k=0}^na_k$. It **converges** if the limit exists and is finite, and **diverges** otherwise.
{: .definition #def-series title="Series"}

The geometric series is the model case. For $|r|<1$ the partial sums are $s_n=(1-r^{n+1})/(1-r)$, which tend to $1/(1-r)$; for $|r|\ge1$ they do not converge. Most tests compare a series with this one or with $\sum 1/k^p$, which converges exactly when $p>1$, so the harmonic series $\sum1/k$ just fails.

> If $\sum a_k$ converges then $a_k\to0$. The converse is false: $\sum1/k$ diverges although $1/k\to0$.
{: .property title="Terms of a convergent series tend to zero"}

{% capture t %}
| Test | Condition | Conclusion |
|:--|:--|:--|
| Divergence | $a_k\not\to0$ | diverges |
| Comparison | $0\le a_k\le b_k$ and $\sum b_k$ converges | $\sum a_k$ converges |
| Ratio | $\lvert a_{k+1}/a_k\rvert\to L$ | converges if $L<1$, diverges if $L>1$, no verdict at $L=1$ |
| Alternating | $a_k\ge0$ decreasing to $0$ | $\sum(-1)^ka_k$ converges |
{% endcapture %}
{% include tab.html id="tab-convergence-tests" caption="The tests worth having at hand." body=t %}
{: .booktabs}

A series **converges absolutely** if $\sum|a_k|$ converges. Then it converges, and its terms can be reordered freely. A conditionally convergent series such as $1-\frac12+\frac13-\cdots$ cannot be reordered safely: its sum depends on the order.

# Power series

A series whose terms are powers, $\sum c_k(x-a)^k$, is a function of $x$ where it converges. The ratio test gives the shape of that set: there is a **radius of convergence** $R$ such that the series converges absolutely for $|x-a|<R$ and diverges for $|x-a|>R$, with the endpoints to be checked separately. When the limit exists, $R=\lim|c_k/c_{k+1}|$.

> Inside its radius of convergence a power series can be differentiated and integrated term by term, and the result has the same radius.
{: .theorem #thm-power-series-termwise title="Termwise calculus for power series"}

> Write the series as $\sum c_kx^k$ with radius $R$. For $|x|\le r<R$ it converges uniformly, by the Weierstrass M-test with $M_k=|c_k|r^k$. The differentiated series $\sum kc_kx^{k-1}$ has the same radius because $k^{1/k}\to1$, so it also converges uniformly on $|x|\le r$. Uniform convergence of the derivatives lets one differentiate under the sum, and uniform convergence of the series lets one integrate under it.
{: .proof}

This is how $\sum x^k=1/(1-x)$ turns into $\sum kx^{k-1}=1/(1-x)^2$ and, integrating, into $-\ln(1-x)=\sum x^{k}/k$. Radius $R=1$ in every case. The series for $e^x$ has $c_k=1/k!$, so $c_k/c_{k+1}=k+1\to\infty$ and $R=\infty$.

# Taylor expansion

If $f$ has derivatives of all orders at $a$, the power series that matches all of them is the guess for $f$ near $a$.

> The **Taylor expansion** of $f$ at $a$ is $\displaystyle\sum_{k=0}^\infty\frac{f^{(k)}(a)}{k!}(x-a)^k$, and its partial sum $T_n(x)$ is the **Taylor polynomial** of degree $n$. At $a=0$ it is also called the Maclaurin series.
{: .definition #def-taylor-expansion title="Taylor expansion"}

The polynomial $T_n$ is the unique one of degree $n$ whose value and first $n$ derivatives at $a$ equal those of $f$. How far it can be trusted is answered by the remainder.

> If $f$ has $n+1$ continuous derivatives on an interval containing $a$ and $x$, then $f(x)=T_n(x)+R_n(x)$ with $R_n(x)=\dfrac{f^{(n+1)}(\xi)}{(n+1)!}(x-a)^{n+1}$ for some $\xi$ between $a$ and $x$.
{: .theorem #thm-taylor-remainder title="Taylor's theorem with Lagrange remainder"}

> Fix $x$ and let $K$ be the number with $f(x)=T_n(x)+K(x-a)^{n+1}$. The function $g(t)=f(t)-T_n(t)-K(t-a)^{n+1}$ has $g(a)=g'(a)=\dots=g^{(n)}(a)=0$ and $g(x)=0$. Rolle's theorem, applied $n+1$ times, gives a point $\xi$ between $a$ and $x$ with $g^{(n+1)}(\xi)=0$. Since $T_n^{(n+1)}=0$, this says $f^{(n+1)}(\xi)=(n+1)!\,K$.
{: .proof}

{% include fig.html src="calculus/taylor-polynomials" id="fig-taylor-polynomials" alt="Sine curve with three polynomial approximations of degree one, three and seven. Each agrees with the sine near zero and leaves it further out, the higher degree later." caption="Taylor polynomials of $\sin x$ at $0$. Degree $7$ is indistinguishable from the sine out to about $|x|=2$ and still follows it past $\pi$, while degree $1$ is only a tangent line." %}

The bound is what makes an approximation usable. For $\sin$ every derivative is at most $1$ in size, so $|R_n(x)|\le|x|^{n+1}/(n+1)!$. At $x=1$ with $T_3=x-x^3/6$ this gives an error of at most $1/120\approx0.0083$; the actual value is $\sin1-\tfrac56=0.0081$.

{% capture t2 %}
| Function | Expansion at $0$ | Radius |
|:--|:--|:--|
| $e^x$ | $1+x+\frac{x^2}{2!}+\frac{x^3}{3!}+\cdots$ | $\infty$ |
| $\sin x$ | $x-\frac{x^3}{3!}+\frac{x^5}{5!}-\cdots$ | $\infty$ |
| $\cos x$ | $1-\frac{x^2}{2!}+\frac{x^4}{4!}-\cdots$ | $\infty$ |
| $\frac1{1-x}$ | $1+x+x^2+\cdots$ | $1$ |
| $\ln(1+x)$ | $x-\frac{x^2}{2}+\frac{x^3}{3}-\cdots$ | $1$ |
| $(1+x)^\alpha$ | $1+\alpha x+\frac{\alpha(\alpha-1)}{2}x^2+\cdots$ | $1$ |
{% endcapture %}
{% include tab.html id="tab-standard-expansions" caption="Expansions to know by heart." body=t2 %}
{: .booktabs}

> The pendulum equation $\ddot\theta=-(g/\ell)\sin\theta$ becomes the harmonic oscillator when $\sin\theta$ is replaced by $\theta$. The relativistic kinetic energy $(\gamma-1)mc^2$ with $\gamma=(1-v^2/c^2)^{-1/2}$ expands to $\tfrac12mv^2+\tfrac38mv^4/c^2+\cdots$, so Newtonian mechanics is its first term; at $v=0.1c$ the exact value $0.00504\,mc^2$ differs from $\tfrac12mv^2=0.00500\,mc^2$ by under one percent.
{: .application title="Small-quantity approximations"}

> A function can be infinitely differentiable and still not equal its Taylor series: $e^{-1/x^2}$ (with value $0$ at $0$) has every derivative zero at $0$, so its series is $0$ and is correct nowhere else. Check that $R_n\to0$, or work with functions known to be analytic.
{: .trap}

> The radius of convergence is set by the nearest singularity in the complex plane, not only on the real line: $1/(1+x^2)$ is smooth everywhere on $\mathbb R$ but its series has $R=1$, because the function blows up at $x=\pm i$.
{: .trap}

When an approximation is used, keep the first term that does not vanish and quote the next one as the size of what was dropped. That is all the Lagrange form is for in practice.

# Recap

<details class="qa" markdown="1">
<summary>Why does $a_k\to0$ not guarantee that $\sum a_k$ converges?</summary>

The partial sums can still grow without bound: $\sum1/k$ diverges, because the terms shrink too slowly (logarithmically growing partial sums). Only the reverse implication holds.
</details>

<details class="qa" markdown="1">
<summary>What does the radius of convergence tell you, and how is it found?</summary>

The power series converges absolutely for $|x-a|<R$ and diverges beyond it. The ratio test gives $R=\lim|c_k/c_{k+1}|$ when the limit exists.
</details>

<details class="qa" markdown="1">
<summary>How do you decide how many Taylor terms an approximation needs?</summary>

Bound the Lagrange remainder $|f^{(n+1)}|\,|x-a|^{n+1}/(n+1)!$ on the interval of interest and take the smallest $n$ for which it is below the tolerance.
</details>
