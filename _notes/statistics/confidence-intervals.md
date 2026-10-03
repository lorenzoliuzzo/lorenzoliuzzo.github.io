---
collection: notes
title: "Confidence Intervals"
date: 2026-10-03
excerpt: "What a confidence interval does and does not say, how to build one from a pivot, and what controls its width."
read_time: true
tags:
  - Statistics
  - Inference
---

A range built from the data that covers the true parameter in a stated fraction of repeated samples. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| Estimator, standard error, MLE asymptotics (Wald) | [Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}#maximum-likelihood) |
| $t$ and $\chi^2$ laws of normal samples | [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#students-t) |
| Normal quantiles, CLT | [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}#normal) |

# Confidence intervals

An interval $[L,U]$ of level $1-\alpha$ satisfies, over repeated samples,

$$ P_\theta\big(L(X)\le\theta\le U(X)\big)=1-\alpha\quad\text{for every }\theta. $$

**Reading it.** The probability is about the *procedure*. Once the data are in, $\theta$ is fixed and the interval either contains it or not. "95%" means 95% of intervals built this way cover the truth, not that $\theta$ lies in this one with probability 0.95 (that is a Bayesian credible interval).

**Recipe: pivots.** A **pivot** is a function of data and parameter whose distribution does not depend on the parameter; invert a probability statement about it to isolate $\theta$.

- *Mean, $\sigma$ unknown, normal data*: $T\sim t_{n-1}$ gives
  $$ \bar X\pm t_{n-1,1-\alpha/2}\,\frac{S}{\sqrt n}, $$
  with $z_{1-\alpha/2}$ and $\sigma$ when $\sigma$ is known.
- *Variance, normal data*: $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ gives
  $$ \left[\frac{(n-1)S^2}{\chi^2_{n-1,1-\alpha/2}},\ \frac{(n-1)S^2}{\chi^2_{n-1,\alpha/2}}\right], $$
  asymmetric, and unlike the mean's, sensitive to non-normality.
- *Any MLE, large $n$ (Wald)*: $\hat\theta\pm z_{1-\alpha/2}\widehat{\mathrm{se}}$; for a proportion $\hat p\pm z_{1-\alpha/2}\sqrt{\hat p(1-\hat p)/n}$. Only approximate: poor for small $n$ or $p$ near 0 or 1, where the Wilson interval is safer.

**Width** scales like $\sigma/\sqrt n$ times a critical value that grows with the level: more confidence widens, more data narrows.

# Recap

**What does a 95% interval mean?** The procedure covers the truth in 95% of repeated samples; it is not a probability statement about the parameter in the one interval you computed.

# Where this goes next

A $(1-\alpha)$ interval is exactly the set of values a level-$\alpha$ test does not reject: see [Hypothesis tests]({{ '/notes/statistics/hypothesis-tests/' | relative_url }}). Regression uses intervals for coefficients and predictions.
