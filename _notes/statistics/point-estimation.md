---
collection: notes
title: "Point Estimation and Maximum Likelihood"
date: 2026-10-03
excerpt: "Estimators, bias, variance and MSE, the Cramér–Rao bound, and maximum likelihood."
read_time: true
tags:
  - Statistics
  - Inference
---

Given a finite sample, guess the parameter of the mechanism that produced it, judge the guess, and the default recipe for making one. Regression, regularization, PCA and mixtures all reuse the likelihood and the sampling distribution of an estimator. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| Sampling distribution, standard error, law of $\bar X$ and $S^2$ | [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}) |
| Expectation, variance, LLN | [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}) |

# Setting

The data $x_1,\dots,x_n$ are realizations of

$$ X_1,\dots,X_n \ \text{i.i.d.} \sim f(x;\theta),\qquad \theta\in\Theta, $$

with $\theta$ a fixed unknown parameter. A **statistic** $T(X_1,\dots,X_n)$ is random, and its sampling distribution says how far to trust it. An **estimator** $\hat\theta=T(X)$ is a rule; an **estimate** is its value on the data in hand. The i.i.d. assumption is what makes every result below work; it fails for time series and clustered data.

# Judging an estimator

- **Bias** $\mathbb{E}\hat\theta-\theta$; **variance** $\operatorname{Var}\hat\theta$; **consistency** $\hat\theta_n\to\theta$ in probability.
- **MSE** combines the first two:

$$ \operatorname{MSE}(\hat\theta)=\mathbb{E}[(\hat\theta-\theta)^2]=\operatorname{Var}(\hat\theta)+\operatorname{bias}(\hat\theta)^2 . $$

This is the **bias–variance trade-off**: an unbiased estimator is not automatically best, since a little bias can buy a lot of variance (the basis of ridge and lasso).

**Cramér–Rao.** An unbiased estimator cannot beat

$$ \operatorname{Var}(\hat\theta)\ge\frac{1}{nI(\theta)},\qquad I(\theta)=\mathbb{E}\Big[\Big(\tfrac{\partial}{\partial\theta}\log f(X;\theta)\Big)^2\Big], $$

where the **Fisher information** $I(\theta)$ measures how sharply the log-density bends in $\theta$, i.e. how much one observation says about it. Reaching the bound means **efficient**.

**Why $n-1$ in $S^2$.** Deviations are taken from $\bar X$, fitted to the same data, so one degree of freedom is used. With $n-1$, $\mathbb{E}S^2=\sigma^2$ exactly, and $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ for normal data.

# Maximum likelihood

The **likelihood** is the joint density read as a function of $\theta$, and the MLE is the $\theta$ under which the data were most probable:

$$ \hat\theta_{\mathrm{MLE}}=\arg\max_\theta\ell(\theta),\qquad \ell(\theta)=\sum_i\log f(x_i;\theta), $$

usually from the **score equation** $\ell'(\theta)=0$.

- *Bernoulli*: $\hat p=\bar x$.
- *Normal*: $\hat\mu=\bar x$, $\hat\sigma^2=\frac1n\sum(x_i-\bar x)^2$. The divisor is $n$, so the MLE of the variance is **biased**, $\mathbb{E}\hat\sigma^2=\frac{n-1}{n}\sigma^2$. MLE gives good estimators, not always unbiased ones.

Under regularity conditions the MLE is consistent, **asymptotically normal and efficient**,

$$ \sqrt{n}(\hat\theta_{\mathrm{MLE}}-\theta_0)\xrightarrow{d}\mathcal{N}\big(0,I(\theta_0)^{-1}\big), $$

and **invariant**: the MLE of $g(\theta)$ is $g(\hat\theta)$. It gives the standard error $\widehat{\mathrm{se}}=1/\sqrt{nI(\hat\theta)}$ behind the intervals and tests that follow. Least squares is the Gaussian MLE, and logistic regression is fitted by maximum likelihood. The **method of moments** (match sample and population moments) is easier and consistent but generally less efficient.

# Recap

**What makes an estimator good?** Small MSE $=\operatorname{Var}+\operatorname{bias}^2$ and consistency; unbiasedness alone is not enough.

**Why is the MLE the default?** For large $n$ it is consistent, asymptotically normal, reaches the Cramér–Rao bound, and is invariant under reparametrization; but it can be biased (normal variance).

# Where this goes next

Regularization (bias for variance), linear regression (Gaussian MLE) and mixture models (no closed-form likelihood, hence EM) build directly on this.
