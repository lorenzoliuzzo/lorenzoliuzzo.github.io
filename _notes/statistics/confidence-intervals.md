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

A point estimate gives no idea of its own precision. A confidence interval fixes that by giving a range, built from the data, that covers the true parameter in a stated fraction of repeated samples. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| Estimator, standard error, MLE asymptotics (Wald) | [Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}#maximum-likelihood) |
| The $t$ and $\chi^2$ laws of normal samples | [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#students-t) |
| Normal quantiles, CLT | [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}#normal) |

# Confidence intervals

An interval $[L,U]$ has level $1-\alpha$ if, over repeated samples,

$$ P_\theta\big(L(X)\le\theta\le U(X)\big)=1-\alpha\qquad\text{for every }\theta. $$

The probability here belongs to the procedure. Once the data are in, $\theta$ is a fixed number and the computed interval either contains it or does not. Saying "95% confidence" means that 95% of the intervals built this way would cover the truth. It does not mean that $\theta$ lies in this particular interval with probability 0.95, which is the statement a Bayesian credible interval makes, and it is a different thing.

To build an interval we look for a **pivot**, a function of the data and the parameter whose distribution does not depend on the parameter, and invert a probability statement about it to isolate $\theta$. For the mean of normal data with unknown $\sigma$, the pivot is $T\sim t_{n-1}$ and we get

$$ \bar X\pm t_{n-1,1-\alpha/2}\,\frac{S}{\sqrt n}, $$

with $z_{1-\alpha/2}$ and $\sigma$ in place of $t$ and $S$ when $\sigma$ is known. For the variance of normal data the pivot is $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$, giving

$$ \left[\frac{(n-1)S^2}{\chi^2_{n-1,1-\alpha/2}},\ \frac{(n-1)S^2}{\chi^2_{n-1,\alpha/2}}\right]. $$

This one is not symmetric around $S^2$ and, unlike the interval for the mean, it is sensitive to non-normality. For a general MLE and large $n$ we use the Wald interval, $\hat\theta\pm z_{1-\alpha/2}\widehat{\mathrm{se}}$, which for a proportion reads $\hat p\pm z_{1-\alpha/2}\sqrt{\hat p(1-\hat p)/n}$. It is only approximate and behaves badly for small $n$ or for $p$ near 0 or 1, where the Wilson interval is the safer choice.

The width of an interval scales like $\sigma/\sqrt n$ times a critical value that grows with the confidence level. More confidence makes it wider, more data makes it narrower, and there is no way around that trade.

# Recap

**What does a 95% interval mean?** The procedure covers the true parameter in 95% of repeated samples. It is not a probability statement about the parameter inside the one interval you computed.

# Where this goes next

A $(1-\alpha)$ interval is exactly the set of parameter values that a level-$\alpha$ test does not reject, which is the link to [Hypothesis tests]({{ '/notes/statistics/hypothesis-tests/' | relative_url }}). Regression uses intervals for its coefficients and for predictions.
