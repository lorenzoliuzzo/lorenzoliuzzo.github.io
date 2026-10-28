---
collection: notes
title: Derivatives
date: '2026-10-27'
excerpt: The derivative as a limit and as a best linear approximation, the rules of differentiation, and the mean value theorem.
hook: The derivative is the slope of the best straight line at a point, and the mean value theorem ties that slope to what happens over a whole interval.
goals:
- differentiate any combination of standard functions
- state and use the mean value theorem
requires:
- limit
- continuity
defines:
- id: derivative
  name: derivative
  anchor: derivative
- id: mean-value-theorem
  name: mean value theorem
  anchor: mean-value-theorem
tags:
- Mathematics
- Calculus
read_time: true
---

A moving car has a speed at each instant, although an instant has no duration. The derivative is the limit that makes that sentence precise, and it applies equally to a slope, a growth rate or a force.

# Derivative

For a function $f$ near a point $a$, the slope of the secant line through $(a,f(a))$ and $(a+h,f(a+h))$ is $\big(f(a+h)-f(a)\big)/h$. The **derivative** is the limit of this slope as $h\to0$,
$$ f'(a)=\lim_{h\to0}\frac{f(a+h)-f(a)}{h}, $$
when it exists. For $f(x)=x^2$ at $a=1$ the secant slope is $\big((1+h)^2-1\big)/h=2+h$, which tends to $2$. The secants with $h=1$ and $h=\tfrac12$ have slopes $3$ and $2.5$.

{% include fig.html src="calculus/secant-to-tangent" id="fig-secant-tangent" alt="The parabola y equals x squared with two secant lines through the point (1, 1) of slopes 3 and 2.5, and a tangent line through the same point with slope 2, lying below both." caption="Secants of $f(x)=x^2$ through $(1,1)$ for $h=1$ and $h=\tfrac12$, and their limit, the tangent line of slope $f'(1)=2$." %}

There is a second reading that generalises better. The derivative is the slope of the **best linear approximation**: $f(a+h)=f(a)+f'(a)h+o(h)$, where $o(h)/h\to0$. Differentiability means that the graph looks like a straight line under a strong enough magnifying glass.

> A differentiable function is continuous: $f(a+h)-f(a)=h\cdot\frac{f(a+h)-f(a)}{h}\to0\cdot f'(a)=0$. The converse fails, and $|x|$ at $0$ is continuous with a corner and no derivative.
{: .trap}

The rules follow from the limit rules of the previous note. For differentiable $f$ and $g$:
$$ (f+g)'=f'+g',\quad (fg)'=f'g+fg',\quad \Big(\frac fg\Big)'=\frac{f'g-fg'}{g^2},\quad (f\circ g)'=f'(g)\,g'. $$
The last, the **chain rule**, says that the derivative of a composition multiplies the rates, like gear ratios. With the basic list below, any combination of standard functions can be differentiated.

{% capture t %}
| $f(x)$ | $f'(x)$ |
|:--|:--|
| $x^n$ | $nx^{n-1}$ |
| $e^x$ | $e^x$ |
| $\ln x$ | $1/x$ |
| $\sin x$ | $\cos x$ |
| $\cos x$ | $-\sin x$ |
{% endcapture %}
{% include tab.html id="tab-derivatives" caption="Derivatives of the basic functions." body=t %}
{: .booktabs}

As an example of the chain rule, $\frac{d}{dx}\sin(x^2)=2x\cos(x^2)$, and of the product rule, $\frac{d}{dx}(x e^x)=(1+x)e^x$.

# Mean value theorem

If you drive $100$ km in one hour, your speedometer must read $100$ km/h at some moment. The **mean value theorem** says this for every differentiable function: if $f$ is continuous on $[a,b]$ and differentiable on $(a,b)$, there is a point $c\in(a,b)$ with
$$ f'(c)=\frac{f(b)-f(a)}{b-a}. $$
Geometrically, some tangent is parallel to the chord. The special case $f(a)=f(b)$ is **Rolle's theorem**: a smooth function that returns to its starting value has a point of zero slope. Rolle follows from the extreme value theorem, because a continuous function on $[a,b]$ has a maximum and a minimum, and one of them is interior unless $f$ is constant; there the derivative is zero. The general case follows by subtracting the chord from $f$.

The theorem is what connects the derivative at points to behaviour on intervals. If $f'\ge0$ on an interval then $f$ is non-decreasing there, since $f(y)-f(x)=f'(c)(y-x)\ge0$. If $f'=0$ then $f$ is constant. These facts are used when finding extrema: at an interior maximum or minimum of a differentiable function $f'=0$, and the sign of $f'$ around such a point tells which one it is. It also controls errors: if $|f'|\le M$ then $|f(y)-f(x)|\le M|y-x|$.

# Recap

<details class="qa" markdown="1">
<summary>What is the derivative?</summary>

The limit of the secant slope $(f(a+h)-f(a))/h$ as $h\to0$, equivalently the slope of the best linear approximation at $a$.
</details>

<details class="qa" markdown="1">
<summary>What are the product and chain rules?</summary>

$(fg)'=f'g+fg'$ and $(f\circ g)'=f'(g)\,g'$.
</details>

<details class="qa" markdown="1">
<summary>What does the mean value theorem say, and what does it give?</summary>

For $f$ continuous on $[a,b]$ and differentiable inside, some $c$ has $f'(c)=(f(b)-f(a))/(b-a)$. It gives monotonicity from the sign of $f'$ and bounds on how much $f$ can change.
</details>
