---
collection: threads
title: "Penalties Are Priors"
date: 2026-10-27
excerpt: "Ridge, the lasso, smoothing splines and weight decay look like four tricks. Read as prior beliefs about the parameters, they are one idea."
route:
  - {note: statistics/point-estimation, why: "Unbiased is not best: a little bias can buy a large drop in variance, which is the reason to penalize at all."}
  - {note: statistics/linear-regression, why: "Least squares and where it breaks when predictors are correlated or numerous."}
  - {note: statistics/regularization, why: "Ridge and the lasso, and the reading of the penalty as a prior."}
  - {note: statistics/splines, why: "A penalty on the second derivative of a curve; the same shrinkage applied to a function."}
  - {note: ai/neural-networks/multi-layer-perceptron, why: "Weight decay in a network is the same penalty on millions of weights."}
cites:
  - hoerl-kennard-1970
  - tibshirani-1996
  - wahba-1990
  - krogh-hertz-1991
tags:
  - Statistics
  - Artificial Intelligence
---

A penalty added to a loss looks like an engineering trick: the fit is too wild, so the size of the parameters is charged for. This thread argues that the trick has a meaning. Each common penalty states a belief about what the parameters look like before the data arrive, and the four methods below differ mainly in which belief they state.

# Why bias is worth paying for

An estimator's mean squared error is its variance plus its squared bias, so an estimator with a little bias and much less variance can beat an unbiased one. Least squares is unbiased, and when predictors are strongly correlated or nearly as many as the observations, its variance is large. Ridge regression was proposed for exactly this situation {% cite hoerl-kennard-1970 %}: add $\lambda\lVert\beta\rVert_2^2$ to the squared error and the coefficients shrink towards zero, trading a bit of bias for stability.

# The penalty as a prior

Suppose the noise is normal with variance $\sigma^2$ and each coefficient has an independent normal prior with mean zero and variance $\tau^2$. The posterior mode, the most probable coefficients given the data, minimizes

$$ \sum_i (y_i-x_i^\top\beta)^2 + \frac{\sigma^2}{\tau^2}\,\lVert\beta\rVert_2^2, $$

which is ridge regression with $\lambda=\sigma^2/\tau^2$. A large $\lambda$ is a confident prior that the coefficients are small; $\lambda=0$ is a prior that says nothing.

> Change the prior and the penalty changes with it. A Laplace (double exponential) prior on each coefficient gives the penalty $\lambda\lVert\beta\rVert_1$, which is the lasso {% cite tibshirani-1996 %}. The Laplace density has a sharp peak at zero, and that peak is why the lasso sets some coefficients exactly to zero while ridge only shrinks them.
{: .idea}

{% capture t %}
| Penalty | Prior on each coefficient | Effect on the fit |
|---|---|---|
| $\lambda\lVert\beta\rVert_2^2$ (ridge) | normal | shrinks all, none exactly to zero |
| $\lambda\lVert\beta\rVert_1$ (lasso) | Laplace | shrinks and sets some to zero |
| $\lambda\int f''(t)^2\,dt$ (smoothing spline) | a smooth curve is more likely than a wiggly one | shrinks the wiggly components of the curve |
| $\lambda\lVert w\rVert_2^2$ (weight decay) | normal on the network weights | keeps weights small |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-penalties" caption="Four penalties and the belief each one states. The penalty is the negative log of the prior, up to a constant." body=t %}

# From coefficients to curves

A smoothing spline chooses the function $f$ that minimizes the squared error plus $\lambda\int f''(t)^2\,dt$. The solution is a natural cubic spline, and its fitted values are $\hat f=(I+\lambda K)^{-1}y$: the straight-line part of the data is left alone and the wiggly components are shrunk, each by a factor $1/(1+\lambda d_k)$. That is ridge regression applied to a basis of curves, and the effective degrees of freedom, the trace of the smoother matrix, plays the role the number of parameters plays for least squares. The Bayesian reading carries over too: a smoothing spline is the posterior mean under a prior on functions that favours smooth ones {% cite wahba-1990 %}.

# From curves to networks

A neural network trained with weight decay adds $\lambda\lVert w\rVert_2^2$ to its loss, which is ridge on the weights, and it is read the same way: a normal prior on weights centred at zero {% cite krogh-hertz-1991 %}. What changes is that the model is no longer linear in its parameters, so the posterior mode is only a local optimum and the Bayesian picture is looser than for the linear models. The intuition survives: a penalty states what you would believe about the weights before seeing data.

> Choosing $\lambda$ is choosing how strongly you believe the prior. Do it by cross-validation, not by the training error, which always prefers $\lambda=0$.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What prior does ridge regression correspond to, and how is $\lambda$ related to it?</summary>

An independent normal prior with mean zero on each coefficient. With noise variance $\sigma^2$ and prior variance $\tau^2$, $\lambda=\sigma^2/\tau^2$.
</details>

<details class="qa" markdown="1">
<summary>Why does the lasso set coefficients to zero when ridge does not?</summary>

The Laplace prior behind the lasso has a sharp peak at zero, so the posterior mode can sit exactly there. The normal prior is smooth at zero and only pulls values towards it.
</details>
