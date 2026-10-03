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

A point estimate from [Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}) says nothing about its own precision. A confidence interval does: it is a range built from the data that covers the true parameter in a stated fraction of repeated samples. This note explains how to read one correctly, how to build the standard ones from a pivot using the $t$ and $\chi^2$ laws of [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}), and what makes an interval wide.

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# Confidence intervals

A point estimate says nothing about its own precision. A **confidence interval** $[L,U]$ with level $1-\alpha$ is built from the data so that, over repeated samples,

$$ P_\theta\big(L(X)\le\theta\le U(X)\big)=1-\alpha \quad\text{for every } \theta . $$

**How to read it.** The probability statement is about the *procedure*, not about the numbers in one computed interval. After the data are in, $\theta$ is a fixed number and the interval either contains it or does not. "95% confident" means: if we repeated the experiment many times, 95% of the intervals so constructed would cover the truth. It does *not* mean "$\theta$ lies in this interval with probability 0.95" (that is a Bayesian credible-interval statement, with a different meaning).

**Recipe: pivots.** A pivot is a function of data and parameter whose distribution does not depend on the parameter. Invert a probability statement about the pivot to isolate $\theta$.

- Mean, $\sigma$ unknown, normal data. The pivot is $T\sim t_{n-1}$, giving
  $$ \bar X\ \pm\ t_{n-1,\,1-\alpha/2}\ \frac{S}{\sqrt n}. $$
  With $\sigma$ known, replace $t_{n-1,1-\alpha/2}$ by $z_{1-\alpha/2}$ and $S$ by $\sigma$.
- Variance, normal data. The pivot $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ gives
  $$ \left[\frac{(n-1)S^2}{\chi^2_{n-1,\,1-\alpha/2}},\ \frac{(n-1)S^2}{\chi^2_{n-1,\,\alpha/2}}\right]. $$
  This one is not symmetric around $S^2$ and, unlike the interval for the mean, is sensitive to non-normality.
- Any MLE, large $n$ (the **Wald** interval): $\hat\theta\pm z_{1-\alpha/2}\,\widehat{\mathrm{se}}$. For a proportion this is $\hat p\pm z_{1-\alpha/2}\sqrt{\hat p(1-\hat p)/n}$. It is only approximate and can behave badly for small $n$ or $p$ near 0 or 1, where the Wilson interval is the safer choice.

**What controls the width.** Width scales like $\sigma/\sqrt n$ times a critical value that grows with the confidence level. More confidence means a wider interval; more data means a narrower one; there is no free lunch between them.

# Vocabulary

The terms used in this note.

| Term | Meaning |
|---|---|
| **Pivot** | A function of data and parameter whose distribution does not depend on the parameter |
| **Confidence level / coverage** | Fraction of repeated intervals that contain the true parameter, $1-\alpha$ |
| **Critical value** | A quantile of the null distribution that bounds the rejection region, e.g. $z_{1-\alpha/2}$ |

# Recap

The note in a handful of questions.

**What does a 95% confidence interval mean?** The procedure covers the true parameter in 95% of repeated samples. It does not say the parameter lies in your specific interval with probability 0.95.

**How do you build an interval?** Find a pivot, a function of data and parameter with a known distribution, and invert the probability statement. For the mean it is $\bar X\pm t_{n-1,1-\alpha/2}S/\sqrt n$.

# Where this goes next

[Hypothesis tests]({{ '/notes/statistics/hypothesis-tests/' | relative_url }}) are the other face of the same machinery: a $(1-\alpha)$ interval is exactly the set of parameter values a level-$\alpha$ test would not reject. Linear regression uses intervals for each coefficient and for predictions.
