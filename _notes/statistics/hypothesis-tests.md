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

Decide between two claims about a parameter using the null distribution of a statistic. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| $t$ and $F$ laws | [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#students-t) |
| Pivots, critical values, level | [Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) |
| MLE, Fisher information | [Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}#maximum-likelihood) |
| Normal quantiles and $\Phi$ | [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}#normal) |

# Framework

A **null** $H_0$ (the default, "no effect") against an alternative $H_1$. Choose a statistic with known law under $H_0$ and reject when it falls in the **rejection region**.

|                | $H_0$ true | $H_0$ false |
|----------------|------------|-------------|
| Reject $H_0$   | Type I error (prob. $\alpha$) | correct (prob. = **power** $1-\beta$) |
| Keep $H_0$     | correct    | Type II error (prob. $\beta$) |

$\alpha$ is fixed in advance and caps the Type I error. Power grows with sample size, effect size and $\alpha$, and shrinks with noise.

**The $p$-value** is the probability, *assuming $H_0$*, of a statistic at least as extreme as observed; reject when $p\le\alpha$. It is not the probability that $H_0$ is true, not the probability of a fluke, and not an effect size: with enough data a negligible effect gets a tiny $p$. Report the estimate and its interval too.

# Standard tests

- *One-sample $t$*, $H_0:\mu=\mu_0$: $T=\dfrac{\bar X-\mu_0}{S/\sqrt n}\sim t_{n-1}$.
- *Two-sample Welch $t$*, $H_0:\mu_1=\mu_2$: $T=\dfrac{\bar X_1-\bar X_2}{\sqrt{S_1^2/n_1+S_2^2/n_2}}$, approximately $t$ with Welch–Satterthwaite degrees of freedom; no equal-variance assumption, so the default.
- *Proportions and any MLE*: the same with the asymptotic normal (Wald) statistic.

**Tests and intervals are one thing.** A $(1-\alpha)$ interval is the set of $\theta_0$ that a level-$\alpha$ test does not reject, so an interval excluding $\mu_0$ means the $t$-test rejects $\mu=\mu_0$. The interval also shows every compatible value.

# Power and sample size

For a one-sided $z$-test of $\mu_0$ against a true $\mu_1>\mu_0$, $\sigma$ known,

$$ \text{power}=1-\Phi\Big(z_{1-\alpha}-\frac{(\mu_1-\mu_0)\sqrt n}{\sigma}\Big),\qquad n=\Big(\frac{(z_{1-\alpha}+z_{1-\beta})\sigma}{\mu_1-\mu_0}\Big)^2 . $$

Read backwards to size a study: an effect half as large needs four times the data.

# Likelihood ratio tests

$$ \Lambda=\frac{\sup_{\Theta_0}L(\theta)}{\sup_{\Theta}L(\theta)},\qquad -2\log\Lambda\xrightarrow{d}\chi^2_r\ \text{under }H_0 $$

($r$ = parameters fixed by $H_0$; Wilks). For simple versus simple hypotheses, Neyman–Pearson says the likelihood-ratio test is the most powerful at its level. The regression $F$-test and deviance comparisons come from here.

# Many tests at once

With $m$ true nulls at level $\alpha$ you expect $m\alpha$ false rejections.

- **Bonferroni**: reject if $p_i\le\alpha/m$. Controls the chance of *any* false rejection (FWER), at low power.
- **Benjamini–Hochberg**: sort the $p$-values, reject the smallest $k$ with $k$ the largest index such that $p_{(k)}\le\frac km\alpha$. Controls the expected *share* of false rejections (FDR); the usual choice for large $m$.

# Recap

**What does a $p$-value measure?** The probability under $H_0$ of a result at least as extreme as the one seen; not $P(H_0)$ and not an effect size.

**What is the link between tests and intervals?** The interval is the set of parameter values the test does not reject.

**What goes wrong with many tests?** $m\alpha$ expected false positives; Bonferroni controls any false positive, Benjamini–Hochberg the false-discovery share and keeps more power.

# Where this goes next

Regression: the coefficient $t$-tests and the overall $F$-test are exactly these tests. Model assessment: estimating prediction error is an inference problem with its own sampling distribution.
