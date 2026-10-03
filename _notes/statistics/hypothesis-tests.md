---
collection: notes
title: "Hypothesis Tests"
date: 2026-10-03
excerpt: "Null and alternative, errors and power, p-values, the standard t tests, sample size, likelihood ratio tests, and many tests at once."
read_time: true
tags:
  - Statistics
  - Inference
---

A test decides between two claims about a parameter by asking whether the data would be surprising if the default claim were true. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| The $t$ and $F$ laws | [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#students-t) |
| Pivots, critical values, level | [Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) |
| MLE, Fisher information | [Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}#maximum-likelihood) |
| Normal quantiles and $\Phi$ | [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}#normal) |

# Framework

We set a **null** hypothesis $H_0$, the default claim of no effect, against an alternative $H_1$. We pick a statistic whose distribution under $H_0$ is known and reject $H_0$ when the statistic lands in a rejection region. Two things can go wrong:

|                | $H_0$ true | $H_0$ false |
|----------------|------------|-------------|
| Reject $H_0$   | Type I error (prob. $\alpha$) | correct (prob. = **power** $1-\beta$) |
| Keep $H_0$     | correct    | Type II error (prob. $\beta$) |

The level $\alpha$ is fixed in advance and caps the Type I error. Power is the chance of detecting a real effect, and it grows with the sample size, the size of the effect and $\alpha$, and shrinks with noise.

The $p$-value is the probability, computed assuming $H_0$, of a statistic at least as extreme as the one observed, and we reject when $p\le\alpha$. It is easy to over-read. It is not the probability that $H_0$ is true, it is not the probability that the result is a fluke, and it is not a measure of effect size: with enough data a negligible effect can have a tiny $p$-value. That is why the estimate and its interval should be reported alongside it.

# Standard tests

The one-sample $t$-test of $H_0:\mu=\mu_0$ uses $T=\dfrac{\bar X-\mu_0}{S/\sqrt n}$, which is $t_{n-1}$ under $H_0$. For two groups, the Welch test of $H_0:\mu_1=\mu_2$ uses

$$ T=\frac{\bar X_1-\bar X_2}{\sqrt{S_1^2/n_1+S_2^2/n_2}}, $$

approximately $t$ with the Welch–Satterthwaite degrees of freedom. It does not assume equal variances, which makes it the sensible default. Tests for proportions, and for any MLE, work the same way with the asymptotic normal (Wald) statistic.

Tests and intervals are really one tool seen from two sides. A $(1-\alpha)$ interval is the set of values $\theta_0$ that a level-$\alpha$ test does not reject, so if the interval for $\mu$ excludes $\mu_0$, the $t$-test rejects $\mu=\mu_0$. The interval has the advantage of showing every value compatible with the data, not just one.

# Power and sample size

For a one-sided $z$-test of $\mu_0$ against a true mean $\mu_1>\mu_0$, with $\sigma$ known,

$$ \text{power}=1-\Phi\Big(z_{1-\alpha}-\frac{(\mu_1-\mu_0)\sqrt n}{\sigma}\Big),\qquad n=\Big(\frac{(z_{1-\alpha}+z_{1-\beta})\,\sigma}{\mu_1-\mu_0}\Big)^2. $$

The second formula is how a study is sized: choose the effect you want to detect and the power you want, and it gives $n$. Because the effect appears squared, detecting an effect half as large takes four times the data.

# Likelihood ratio tests

For composite hypotheses the general principle is to compare the best likelihood under $H_0$ with the best overall,

$$ \Lambda=\frac{\sup_{\theta\in\Theta_0}L(\theta)}{\sup_{\theta\in\Theta}L(\theta)},\qquad -2\log\Lambda\ \xrightarrow{d}\ \chi^2_r\ \text{under }H_0, $$

where $r$ is the number of parameters that $H_0$ fixes (Wilks' theorem). For simple against simple hypotheses, the Neyman–Pearson lemma says that the likelihood-ratio test is the most powerful at its level. The $F$-test of regression and the deviance comparisons in generalized linear models come from this construction.

# Many tests at once

If we run $m$ tests at level $\alpha$ and every null is true, we expect $m\alpha$ false rejections. Bonferroni's fix is to reject only when $p_i\le\alpha/m$, which controls the probability of any false rejection but costs a lot of power. The Benjamini–Hochberg procedure sorts the $p$-values and rejects the smallest $k$, where $k$ is the largest index with $p_{(k)}\le\frac km\alpha$. It controls the expected share of false rejections, the false discovery rate, and is the usual choice when $m$ is large.

# Recap

**What does a $p$-value measure?** The probability, if $H_0$ were true, of a result at least as extreme as the one seen. It is not the probability that $H_0$ is true, and it says nothing about the size of the effect.

**How are tests and intervals related?** The interval is the set of parameter values that the test does not reject.

**What goes wrong with many tests?** We expect $m\alpha$ false positives. Bonferroni controls the chance of any false positive; Benjamini–Hochberg controls the share of false discoveries and keeps more power.

# Where this goes next

In regression, the coefficient $t$-tests and the overall $F$-test are exactly the tests above, and estimating prediction error in model assessment is an inference problem with its own sampling distribution.
