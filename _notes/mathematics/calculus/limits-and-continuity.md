---
collection: notes
title: Limits and Continuity
date: '2026-10-27'
excerpt: The limit of a sequence and of a function, continuity, and the theorems that follow from it.
hook: A limit says what a function does near a point without asking what it does at the point; continuity says the two agree.
goals:
- compute limits with the standard rules and tests
- use the intermediate and extreme value theorems
defines:
- id: limit
  name: limit
  anchor: limit
- id: continuity
  name: continuity
  anchor: continuity
plan:
  sources: []
  figures:
  - epsilon-delta band around a limit
  - intermediate value theorem on a sketch
  verify:
  - sin(x)/x tends to 1 at 0
  - a continuous function on [a, b] attains its maximum
tags:
- Mathematics
- Calculus
read_time: true
---

Calculus rests on asking what a quantity approaches, not what it equals. The question has to be made precise before it can be used, and the precise version is the same for sequences, derivatives and integrals.

# Limit

Start with the function $g(x)=\sin x/x$, which is undefined at $0$ but defined everywhere near it. We want to say that $g(x)$ approaches $1$ as $x$ approaches $0$, with no reference to the value at $0$.

The definition is a game about tolerances. We write $\lim_{x\to a}f(x)=L$ if for every $\varepsilon>0$ there is a $\delta>0$ such that
$$ 0<|x-a|<\delta \quad\Longrightarrow\quad |f(x)-L|<\varepsilon. $$
Someone names a tolerance $\varepsilon$ around $L$, and we must find a window of half-width $\delta$ around $a$ inside which the graph stays in the band. The condition $0<|x-a|$ excludes $x=a$ itself, which is why the limit may exist where the function is undefined.

For $\sin x/x$ and $\varepsilon=0.1$, solving $1-\sin x/x=0.1$ numerically gives a window $|x|<0.79$. A smaller $\varepsilon$ needs a smaller $\delta$, and the limit exists because that is always possible.

{% include fig.html src="calculus/epsilon-delta" id="fig-epsilon-delta" alt="Graph of sin x over x between minus two and two, with a horizontal band of half-width 0.1 around the value 1 and a vertical window of half-width 0.79 around zero. The graph inside the window stays inside the band, and an open circle marks the point at zero." caption="The $\varepsilon$-$\delta$ definition for $\sin(x)/x$ at $0$. For the band $1\pm0.1$ the window $|x|<0.79$ keeps the graph inside it. The open circle at $x=0$ marks the one point that is not used." %}

A **sequence** limit is the same game with $n\to\infty$: $a_n\to L$ if for every $\varepsilon$ some $N$ has $|a_n-L|<\varepsilon$ for all $n>N$.

The rules follow from the definition by combining tolerances. If $f\to L$ and $g\to M$ then $f+g\to L+M$, $fg\to LM$ and, when $M\ne0$, $f/g\to L/M$. The **squeeze theorem** says that if $h\le f\le k$ near $a$ and $h,k\to L$, then $f\to L$. This is how $\sin x/x\to1$ is proved: for small $x>0$ the areas of a triangle, a sector and a larger triangle give $\cos x<\sin x/x<1$, and both bounds tend to $1$.

> A limit may exist where the function is not defined, and may fail to exist where it is. Only the values near $a$ matter.
{: .idea}

# Continuity

A function is **continuous at $a$** if $a$ is in its domain and $\lim_{x\to a}f(x)=f(a)$. In words, the limit exists and equals the value. By the limit rules, sums, products, quotients (where the denominator is nonzero) and compositions of continuous functions are continuous, so polynomials, $\sin$, $\exp$ and everything built from them are continuous where they are defined.

There are three ways to fail. A **removable** discontinuity has a limit that differs from the value or from nothing, as $\sin x/x$ at $0$, and can be repaired by defining $g(0)=1$. A **jump** has different one-sided limits, as the sign function at $0$. An **essential** discontinuity has no one-sided limit, as $\sin(1/x)$ at $0$, which oscillates between $-1$ and $1$ forever.

Continuity on a closed interval $[a,b]$ buys two theorems. The **intermediate value theorem** says a continuous $f$ takes every value between $f(a)$ and $f(b)$. In particular if $f(a)<0<f(b)$ there is a point $c$ with $f(c)=0$. This gives existence of roots, and the bisection method that finds them: halve the interval, keep the half where the sign changes, repeat. The **extreme value theorem** says a continuous $f$ on $[a,b]$ attains a maximum and a minimum.

Both fail without the hypotheses. The function $1/x$ is continuous on $(0,1]$ and has no maximum there; the interval is not closed. The step function that is $-1$ then $1$ skips every value between, because it is not continuous.

{% capture t %}
| Failure at $a$ | Example | Repairable? |
|:--|:--|:--|
| removable | $\sin x/x$ at $0$ | yes, redefine the value |
| jump | $\operatorname{sign}x$ at $0$ | no |
| essential | $\sin(1/x)$ at $0$ | no |
{% endcapture %}
{% include tab.html id="tab-discontinuities" caption="The three kinds of discontinuity." body=t %}
{: .booktabs}

# Recap

<details class="qa" markdown="1">
<summary>What does $\lim_{x\to a}f(x)=L$ mean?</summary>

For every $\varepsilon>0$ there is a $\delta>0$ such that $0<|x-a|<\delta$ implies $|f(x)-L|<\varepsilon$. The value at $a$ plays no role.
</details>

<details class="qa" markdown="1">
<summary>What is continuity at a point?</summary>

The function is defined there, the limit exists, and the limit equals the value.
</details>

<details class="qa" markdown="1">
<summary>What do the intermediate and extreme value theorems say?</summary>

On $[a,b]$ a continuous function takes every value between $f(a)$ and $f(b)$, and attains its maximum and minimum. Both need continuity and a closed interval.
</details>
