---
collection: notes
title: "Hypothesis Tests"
date: 2026-10-03
excerpt: "Null and alternative, Type I and II errors, p-values, the standard t tests, power and sample size, likelihood ratio tests, and correcting for many tests."
read_time: true
tags:
  - Statistics
  - Inference
---

A test decides between two claims about a parameter using the sampling distribution of a statistic under the default claim. This note covers the framework (null, alternative, errors, $p$-values), the standard tests, how to choose a sample size, the likelihood ratio principle, and what changes when many tests are run together. It uses the sampling laws from [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}) and is the counterpart of [Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}).

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# Before you start

[Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) (a test and an interval are two views of one thing) and the sampling laws.

| You should know | In one line | Where |
|---|---|---|
| **$t$ and $F$ laws** | null distributions of the standard test statistics | [Sampling distributions › Student's t]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#students-t), [Sampling distributions › The F distribution]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#the-f-distribution) |
| **Pivot, critical value, level** | the same ingredients as an interval | [Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) |
| **MLE and Fisher information** | the Wald and likelihood-ratio tests are built from them | [Point estimation › Maximum likelihood]({{ '/notes/statistics/point-estimation/' | relative_url }}#maximum-likelihood) |
| **Conditional probability** | error rates are probabilities conditional on $H_0$ or $H_1$ | [Probability foundations › Conditional probability and independence]({{ '/notes/statistics/probability-foundations/' | relative_url }}#conditional-probability-and-independence) |
| **Normal quantiles and $\Phi$** | critical values and power calculations | [Common random variables › Normal]({{ '/notes/statistics/common-random-variables/' | relative_url }}#normal) |

# Hypothesis tests

A test decides between two hypotheses about $\theta$: a **null** $H_0$ (the default, "no effect") and an **alternative** $H_1$. The procedure: choose a statistic $T$ whose distribution under $H_0$ is known, and reject $H_0$ if $T$ falls in a **rejection region**.

|                | $H_0$ true | $H_0$ false |
|----------------|------------|-------------|
| Reject $H_0$   | Type I error (prob. $\alpha$) | correct (prob. = **power** $1-\beta$) |
| Keep $H_0$     | correct    | Type II error (prob. $\beta$) |

The significance level $\alpha$ is fixed in advance and caps the Type I error. **Power** is the probability of detecting a real effect, and it grows with the sample size, the size of the effect, and $\alpha$, and shrinks with noise.

**The $p$-value** is the probability, *assuming $H_0$ is true*, of seeing a statistic at least as extreme as the one observed. Reject at level $\alpha$ when $p\le\alpha$. Three things it is not: it is not the probability that $H_0$ is true, not the probability the result is a fluke, and not a measure of effect size. A tiny effect can have a tiny $p$-value with enough data; report the estimate and its interval alongside it.

**Standard tests.**

- *One-sample $t$-test*, $H_0:\mu=\mu_0$: $T=\dfrac{\bar X-\mu_0}{S/\sqrt n}\sim t_{n-1}$ under $H_0$.
- *Two-sample (Welch) $t$-test*, $H_0:\mu_1=\mu_2$: $T=\dfrac{\bar X_1-\bar X_2}{\sqrt{S_1^2/n_1+S_2^2/n_2}}$, approximately $t$ with Welch–Satterthwaite degrees of freedom. It does not assume equal variances, so it is the sensible default.
- *Tests for proportions and for any MLE* use the same idea with the asymptotic normal (Wald) statistic.

**Power and sample size.** For a one-sided $z$-test of $H_0:\mu=\mu_0$ against a true mean $\mu_1>\mu_0$, with known $\sigma$,

$$ \text{power}=1-\Phi\!\Big(z_{1-\alpha}-\frac{(\mu_1-\mu_0)\sqrt n}{\sigma}\Big), \qquad n=\Big(\frac{(z_{1-\alpha}+z_{1-\beta})\,\sigma}{\mu_1-\mu_0}\Big)^2 . $$

Reading the second formula backwards is how study sizes are chosen: to detect an effect half as large you need four times the data.

**Tests and intervals are two views of one thing.** A $(1-\alpha)$ confidence interval is exactly the set of values $\theta_0$ that a level-$\alpha$ test would *not* reject. If the interval for $\mu$ excludes $\mu_0$, the $t$-test rejects $\mu=\mu_0$. The interval is more informative: it shows the whole range of values compatible with the data.

**Likelihood ratio tests.** A general principle for composite hypotheses. Compare the best likelihood under $H_0$ with the best overall,

$$ \Lambda=\frac{\sup_{\theta\in\Theta_0}L(\theta)}{\sup_{\theta\in\Theta}L(\theta)}, \qquad -2\log\Lambda\ \xrightarrow{d}\ \chi^2_r \ \text{ under } H_0 , $$

where $r$ is the number of parameters $H_0$ fixes (Wilks' theorem). For simple versus simple hypotheses, the Neyman–Pearson lemma says the likelihood-ratio test is the *most powerful* at its level, which is the sense in which these tests are optimal. This is also where the $F$-test and the deviance comparisons of regression come from.

## Testing many things at once

If you run $m$ tests at level $\alpha$ and every null is true, you expect $m\alpha$ false rejections. Two standard corrections:

- **Bonferroni**: reject only if $p_i\le\alpha/m$. This controls the probability of *any* false rejection (family-wise error rate), at the price of low power.
- **Benjamini–Hochberg**: sort the $p$-values and reject the smallest $k$, where $k$ is the largest index with $p_{(k)}\le \frac{k}{m}\alpha$. This controls the expected *proportion* of false rejections (false discovery rate) and is the usual choice when $m$ is large.

# Vocabulary

The terms this note introduces. Earlier ones are in the notes linked under Before you start.

| Term | Meaning |
|---|---|
| **Null / alternative** | $H_0$, the default claim / $H_1$, what we look for evidence of |
| **Test statistic** | The number computed from the data whose null distribution we know |
| **Rejection region** | Values of the test statistic for which $H_0$ is rejected |
| **Significance level $\alpha$** | The Type I error rate we accept, fixed in advance |
| **$p$-value** | Probability under $H_0$ of a result at least as extreme as the one seen |
| **Type I / Type II error** | Rejecting a true $H_0$ / keeping a false one |
| **Power** | $1-\beta$: the probability of detecting a real effect |
| **One- / two-sided** | The alternative is on one side of $H_0$ / on either side |

# Recap

The note in a handful of questions.

**What does a $p$-value measure?** The probability, if $H_0$ were true, of a statistic at least as extreme as the observed one. It is not the probability that $H_0$ is true and says nothing about effect size.

**What are the two kinds of error, and what is power?** Type I is rejecting a true $H_0$ (probability $\alpha$, chosen in advance); Type II is keeping a false one (probability $\beta$). Power, $1-\beta$, is the chance of detecting a real effect and grows with sample size and effect size.

**How are tests and intervals related?** A $(1-\alpha)$ interval is exactly the set of parameter values a level-$\alpha$ test does not reject, so an interval excluding $\mu_0$ means the test rejects $\mu=\mu_0$.

**What goes wrong with many tests at once?** With $m$ tests you expect $m\alpha$ false positives. Bonferroni ($p_i\le\alpha/m$) controls the chance of any false positive; Benjamini–Hochberg controls the expected share of false discoveries and keeps more power.

# Where this goes next

- **Linear regression**: the coefficient $t$-tests and the overall $F$-test are exactly the tests above.
- **Model assessment**: estimating prediction error is an inference problem with its own sampling distribution.
