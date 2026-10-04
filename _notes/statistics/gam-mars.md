---
collection: notes
title: "GAMs and MARS"
date: 2026-10-04
excerpt: "Additive models with one smooth curve per predictor, fitted by backfitting, and MARS, which builds a piecewise linear model from hinge functions and admits interactions only where they pay."
hook: "One smooth curve per predictor keeps a model readable and avoids the curse of dimension, at the price of assuming no interactions; MARS lets interactions in only where they pay."
goals:
  - write an additive model and say what its assumption rules out
  - describe backfitting and why it converges for smoothers
  - build a MARS model from hinge functions, forward then backward
  - choose between a GAM and MARS for a given problem
requires:
  - least-squares
  - regression-spline
  - smoothing-spline
  - linear-smoother
  - effective-degrees-of-freedom
defines:
  - {id: additive-model, name: additive model, anchor: additive-models}
  - {id: backfitting, name: backfitting, anchor: additive-models}
  - {id: hinge-function, name: hinge function, anchor: mars}
  - {id: mars, name: MARS, anchor: mars}
read_time: true
tags:
  - Statistics
  - Regression
---

One smooth curve fits one predictor. With several predictors the question is how much of the structure to assume in advance. Proofs and the exact criteria are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Additive models

A fully flexible function of $p$ predictors is out of reach: in high dimensions every neighbourhood of a point is almost empty, so there is nothing local to average. The way out is to assume structure, and the **additive model** assumes the simplest one,

$$ \mathbb{E}[Y\mid x]=\alpha+f_1(x_1)+\dots+f_p(x_p), $$

with each $f_j$ a smooth function of one variable, usually a smoothing spline. Each curve can be drawn and read like a coefficient that is allowed to bend, which is the appeal. Wrapping the right-hand side in a link function, as in $g(\mu)=\alpha+\sum_jf_j(x_j)$, gives the generalized additive model (GAM) for binary and count responses.

The cost is in the word additive: the effect of $x_1$ is the same curve at every value of $x_2$. If the true effect of one predictor depends on another, the model cannot say so.

> **An additive model has no interactions.** It cannot represent "this predictor matters only when that one is large". If the data have such structure, the fit is biased however flexible each curve is.
{: .trap}

The curves are fitted by **backfitting**, which turns many smoothing problems into repeated one-dimensional ones. Start from $\hat\alpha=\bar y$ and $f_j\equiv0$, then repeat until the curves stop changing:

1. for each $j$, form the partial residuals $y-\hat\alpha-\sum_{k\ne j}f_k(x_k)$;
2. smooth them against $x_j$ to get a new $f_j$;
3. subtract the mean of $f_j$, so that the split of effects between $\alpha$ and the curves is unique.

> The curves are not identified when one predictor is a smooth function of the others, a situation called concurvity. It is collinearity for curves, and it makes the individual $f_j$ unreliable while the sum stays well determined.
{: .margin}

Each step is the fit of a linear smoother, and for symmetric smoothers such as smoothing splines the cycle converges to the minimizer of the residual sum of squares plus one roughness penalty per curve. Each curve then has its own effective degrees of freedom, and the model uses about $1+\sum_j(\mathrm{df}_j-1)$ in total.

# MARS

Multivariate adaptive regression splines take the opposite route. Instead of smooth curves they use the simplest possible bend, a **hinge function**: for a knot $t$ the pair $(x-t)_+$ and $(t-x)_+$, each zero on one side of the knot and linear on the other.

{% include fig.html src="statistics/hinge-basis" id="fig-hinge" alt="Left: noisy data with a piecewise linear fit in solid blue after pruning and a dashed orange fit with more terms before pruning, with the two retained knots marked below the axis. Right: a hinge pair at knot 4, one rising to the right of the knot and one rising to the left." caption="MARS in one variable. Right: the pair of hinge functions at knot $t=4$. Left: the forward pass overgrows a sum of hinges (dashed, nine terms) and the backward pass prunes it to three terms, keeping knots near the two bends of the data." %}

A MARS model is a constant plus a weighted sum of hinges, so it is piecewise linear and still a linear regression once the terms are chosen. Choosing them takes two passes. The **forward pass** is greedy: at each step it adds the pair of hinges, over all variables and all observed values as knots, that lowers the residual sum of squares the most, until the model is clearly too large. The **backward pass** then deletes one term at a time, each time the term whose removal hurts least, and keeps the size with the smallest generalized cross-validation score, which charges for every term and every knot.

Interactions come from multiplying hinges of different variables, so that a term like $(x_1-t)_+\,(x_2-s)_+$ is active only where both are large. Each product is built from a term already in the model, which means an interaction can enter only where its parts already matter. With degree 1, products are not allowed and the model is an additive model with piecewise linear curves.

| | GAM | MARS |
|---|---|---|
| Building block | smooth curve per predictor | hinge functions, or products of them |
| Interactions | none | optional, by degree |
| Variable selection | no, unless penalized | yes, by the forward pass |
| Tuning | smoothness of each curve | number of terms and degree |
| Reading the fit | plot each curve | list the terms, plot slices |
{: .keyed}

> Use a GAM when you want to look at each effect and expect them to add up. Use MARS when predictors may matter only in combination, or when you want the variable selection done for you. Neither extrapolates well: outside the data both continue their last segment.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What does the additive assumption buy, and what does it cost?</summary>

It reduces a $p$-dimensional problem to $p$ one-dimensional ones, which can be fitted and plotted separately. It costs the interactions: the effect of one predictor cannot depend on the value of another.
</details>

<details class="qa" markdown="1">
<summary>What does backfitting do in one cycle?</summary>

For each predictor in turn, it smooths the partial residuals, the response minus the intercept and the other curves, against that predictor, and recentres the new curve. Cycles repeat until nothing changes.
</details>

<details class="qa" markdown="1">
<summary>Why does MARS grow the model too large and then prune it?</summary>

The greedy forward pass cannot know which early terms later ones make redundant. Pruning with a criterion that penalizes terms and knots removes the ones that do not pay for themselves.
</details>
