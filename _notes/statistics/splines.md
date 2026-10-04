---
collection: notes
title: "Regression and Smoothing Splines"
date: 2026-10-04
excerpt: "Basis expansions, regression splines with knots, natural splines and smoothing splines: a curve that bends where the data bend, with the amount of bending set by one number."
hook: "A spline is a cubic that may change its mind only at a few knots; a smoothing spline puts a knot at every point and lets a single penalty decide how much to bend."
goals:
  - turn a nonlinear fit into a linear regression with a basis expansion
  - build a cubic regression spline and count its parameters
  - state what the smoothing spline minimizes and why its solution is a natural spline
  - use the effective degrees of freedom of a smoother to compare fits
requires:
  - least-squares
  - hat-matrix
  - ridge-regression
  - effective-degrees-of-freedom
  - bias-variance-tradeoff
defines:
  - {id: basis-expansion, name: basis expansion, anchor: basis-expansions}
  - {id: regression-spline, name: regression spline, anchor: regression-splines}
  - {id: natural-spline, name: natural spline, anchor: regression-splines}
  - {id: smoothing-spline, name: smoothing spline, anchor: smoothing-splines}
  - {id: linear-smoother, name: linear smoother, anchor: smoothing-splines}
read_time: true
tags:
  - Statistics
  - Regression
---

A straight line is rarely the shape of the data, and the way out is to keep the machinery of linear regression and change what the predictors are. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Basis expansions

A **basis expansion** models the regression function as $f(x)=\sum_{m=1}^M\beta_mh_m(x)$ for fixed functions $h_m$ such as $x$, $x^2$, $x^3$. The model is nonlinear in $x$ but linear in $\beta$, so it is fitted by least squares on the matrix with entries $h_m(x_i)$, and standard errors, $F$-tests and penalties carry over unchanged. The question is which functions to use, and global polynomials are the first answer and a poor one: one bend needed in one place forces the whole curve to change, and at the ends of the range a polynomial swings away from the data.

# Regression splines

The remedy is to be local. Cut the range at **knots** $\xi_1<\dots<\xi_K$ and fit a cubic polynomial in each piece, joined so smoothly that the eye cannot see the knot: the function and its first and second derivatives are continuous there. What is left free at a knot is only a jump in the third derivative, so a **cubic regression spline** is a global cubic plus one term $c_k(x-\xi_k)_+^3$ per knot. That gives the truncated power basis $1,\,x,\,x^2,\,x^3,\,(x-\xi_1)_+^3,\dots,(x-\xi_K)_+^3$ and the parameter counts below.

| Fit | Parameters |
|---|---:|
| Cubic polynomial | 4 |
| Cubic spline with $K$ knots | $K+4$ |
| Natural cubic spline with $K$ knots | $K$ |
{: .keyed}

{% include fig.html src="statistics/regression-spline" id="fig-regression-spline" alt="Noisy data around a sine-like curve, with a true curve, a cubic polynomial fit and a cubic spline fit with three knots. The spline follows the true curve closely; the polynomial deviates, especially near the ends." caption="One noisy sample, three fits. The cubic spline with three knots (7 parameters) follows the curve, while the global cubic (4 parameters) cannot bend where it needs to and drifts at the ends." %}

At the boundaries of the data the cubic pieces are the least constrained, and the variance there is the highest. A **natural spline** is forced to be linear beyond the outer knots, which removes four parameters and tames the ends at the cost of a little bias there.

> Knots are usually placed at quantiles of $x$, so that each piece has about the same number of points, and only a few are needed. Their number $K$ plays the role of the model size and is chosen by cross-validation or by effective degrees of freedom.
{: .rule}

# Smoothing splines

Choosing knots is awkward, and there is an alternative that avoids it. Among all twice differentiable functions, minimize

$$ \sum_{i=1}^n\big(y_i-f(x_i)\big)^2+\lambda\int f''(t)^2\,dt. $$

The first term rewards fitting the data and the second punishes curvature. With $\lambda=0$ the minimizer interpolates the data, and as $\lambda\to\infty$ it approaches the least squares line, since a straight line has no curvature to punish. The result that makes this practical is that, for every $\lambda$, the minimizer over *all* such functions is a natural cubic spline with a knot at each distinct $x_i$.

> **Why it is a natural spline.** Take any competitor $g$ and let $f$ be the natural spline through the same points. For $h=g-f$ we have $h(x_i)=0$, and integrating by parts twice gives $\int f''h''=0$. Hence $\int g''^2=\int f''^2+\int h''^2\ge\int f''^2$: a competitor can only add roughness, never fit better.
{: .derive}

The problem is therefore finite. The fitted values at the knots are $\hat f=(I+\lambda K)^{-1}y$, where the matrix $K$ encodes the roughness. This is linear in $y$, so the smoothing spline is a **linear smoother**, $\hat y=S_\lambda y$, and it is a ridge regression in disguise: the smooth components (the constants and straight lines, which cost no roughness) are kept untouched and the wiggly ones are shrunk by $1/(1+\lambda d_k)$. As for ridge, the trace $\operatorname{tr}S_\lambda$ is the effective degrees of freedom, and it runs from $n$ at $\lambda=0$ to $2$ for the line.

{% include fig.html src="statistics/smoothing-spline" id="fig-smoothing" alt="The same noisy data with the true curve and three smoothing spline fits: an almost straight line at about 2.5 degrees of freedom, a smooth fit at 7 and a wiggly fit at 22 that chases the noise." caption="Smoothing splines of the same data at three effective degrees of freedom. Too few and the fit is a line; too many and it follows the noise. One number moves the fit along this range." %}

In practice one reads the degrees of freedom and not $\lambda$, because they mean the same thing across data sets. They are chosen by cross-validation, and a linear smoother makes leave-one-out cross-validation free: the left-out residual is $(y_i-\hat f(x_i))/(1-S_{ii})$, the same shortcut as for the hat matrix.

> **Do not read the curve outside the data.** Beyond the range of $x$ a smoothing spline is linear by construction. That is a convention that keeps the ends stable, not a prediction.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is a spline with knots better than a high-degree polynomial?</summary>

It is local: a bend at one place does not force changes elsewhere, and it has few parameters, $K+4$ for $K$ knots. A global polynomial must bend everywhere and swings at the ends.
</details>

<details class="qa" markdown="1">
<summary>What does the penalty $\lambda$ do in a smoothing spline, and what are its extreme cases?</summary>

It sets how much curvature is tolerated. With $\lambda=0$ the fit interpolates, with $\lambda\to\infty$ it is the least squares line. In between, the effective degrees of freedom $\operatorname{tr}S_\lambda$ falls from $n$ to 2.
</details>

<details class="qa" markdown="1">
<summary>In what sense is a smoothing spline a ridge regression?</summary>

It minimizes residual sum of squares plus a quadratic penalty on the coefficients of a basis, and it shrinks each component of $y$ by a factor $1/(1+\lambda d_k)$, keeping the unpenalized constants and lines intact.
</details>
