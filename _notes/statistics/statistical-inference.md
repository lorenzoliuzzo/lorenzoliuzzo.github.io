---
collection: notes
title: "Statistical Inference"
date: 2026-10-03
excerpt: "From samples to estimators, maximum likelihood, confidence intervals and tests: the toolkit that regression, classification, shrinkage and mixtures are built on."
read_time: true
tags:
  - Statistics
---



Almost every method in applied statistics and machine learning answers the same question: *we saw a finite sample, what can we say about the mechanism that produced it?* This note builds the vocabulary for that question. It is the foundation for the notes on linear regression, regularization, PCA and mixture models, which all reuse its three tools: the **likelihood**, the **sampling distribution** of an estimator, and the **test / interval** machinery.

A more formal version, with statements and proofs of the results quoted here, is in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistical-inference/statistical-inference.pdf' | relative_url }}). This page explains; the PDF is the thing to check a formula against. The probability it relies on (axioms, Bayes, expectation, variance, limit theorems) is in [Probability foundations]({{ '/notes/statistics/probability-foundations/' | relative_url }}), and the distributions of the sample mean, variance and the $t$, $\chi^2$ and $F$ laws it uses are in [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}).

# The setting: population, sample, model

A **population** is the thing we care about; a **sample** is the data $x_1,\dots,x_n$ we actually have. Inference needs a bridge between the two, and that bridge is a **statistical model**: we assume the data are realizations of random variables $X_1,\dots,X_n$ whose joint law belongs to a family indexed by an unknown parameter $\theta$,

$$ X_1,\dots,X_n \ \text{i.i.d.} \sim f(x;\theta), \qquad \theta \in \Theta . $$

"i.i.d." (independent, identically distributed) is the simplest assumption that makes a sample informative: each new observation tells us something about the same $\theta$, and nothing is lost by treating observations separately. Most of the machinery below breaks, or needs repair, when this fails (time series, clustered data).

The central object is a **statistic**: any function $T(X_1,\dots,X_n)$ of the sample. Because the sample is random, $T$ is itself a random variable, and its distribution, the **sampling distribution**, is what tells us how much to trust it.

# Estimators and how to judge them

An **estimator** $\hat\theta=T(X_1,\dots,X_n)$ is a rule for guessing $\theta$ from data; an **estimate** is its value on one sample. Good estimators are judged by the distribution of their error:

- **Bias**: $\operatorname{bias}(\hat\theta)=\mathbb{E}[\hat\theta]-\theta$. Unbiased means right on average.
- **Variance**: how much $\hat\theta$ fluctuates from sample to sample.
- **Mean squared error**, which combines the two,

$$ \operatorname{MSE}(\hat\theta)=\mathbb{E}[(\hat\theta-\theta)^2]=\operatorname{Var}(\hat\theta)+\operatorname{bias}(\hat\theta)^2 . $$

- **Consistency**: $\hat\theta_n\to\theta$ in probability as $n\to\infty$.

The decomposition of the MSE is the first appearance of the **bias–variance trade-off**. An unbiased estimator is not automatically the best one: a slightly biased estimator with much lower variance can have smaller MSE. Ridge and Lasso regression, in a later note, are built on exactly this observation.

How good can an unbiased estimator be? The **Cramér–Rao bound** says there is a floor,

$$ \operatorname{Var}(\hat\theta)\ \ge\ \frac{1}{n\,I(\theta)}, \qquad I(\theta)=\mathbb{E}\!\left[\Big(\frac{\partial}{\partial\theta}\log f(X;\theta)\Big)^{2}\right], $$

where $I(\theta)$ is the **Fisher information** of one observation: how sharply the log-density bends as $\theta$ moves, i.e. how much a single observation reveals about $\theta$. An unbiased estimator that reaches the bound is called efficient.

# Maximum likelihood

The most important recipe for building estimators. Given the data, regard the joint density as a function of $\theta$: the **likelihood** $L(\theta)=\prod_i f(x_i;\theta)$. The **maximum likelihood estimator** is the parameter value under which the observed data were most probable,

$$ \hat\theta_{\mathrm{MLE}}=\arg\max_\theta L(\theta)=\arg\max_\theta \ell(\theta), \qquad \ell(\theta)=\sum_i\log f(x_i;\theta). $$

We maximize the log-likelihood $\ell$ because sums are easier than products and the maximizer is the same. In regular cases we solve the **score equation** $\ell'(\theta)=0$.

**Two worked examples.**

- *Bernoulli.* $\ell(p)=\sum x_i\log p+(n-\sum x_i)\log(1-p)$. Setting the derivative to zero gives $\hat p=\bar x$, the sample proportion.
- *Normal.* Maximizing over $(\mu,\sigma^2)$ gives $\hat\mu=\bar x$ and $\hat\sigma^2=\frac1n\sum(x_i-\bar x)^2$. Note the divisor $n$: the MLE of the variance is **biased** ($\mathbb{E}\hat\sigma^2=\frac{n-1}{n}\sigma^2$), and $S^2$ corrects it. MLE gives good estimators, not always unbiased ones.

**Why MLE is the default.** Under regularity conditions the MLE is consistent, **asymptotically normal and asymptotically efficient**:

$$ \sqrt{n}\,(\hat\theta_{\mathrm{MLE}}-\theta_0)\ \xrightarrow{d}\ \mathcal{N}\!\big(0,\ I(\theta_0)^{-1}\big), $$

so for large $n$ it reaches the Cramér–Rao bound. It is also **invariant**: the MLE of $g(\theta)$ is $g(\hat\theta)$. The asymptotic variance yields a ready-made standard error, $\widehat{\mathrm{se}}=1/\sqrt{n\,I(\hat\theta)}$, which is the basis of the intervals and tests below. Later notes use the same principle: least squares is the MLE under Gaussian noise, and logistic regression is fitted by maximum likelihood.

The **method of moments** is the simpler alternative: equate sample moments to population moments and solve. It is easy and consistent but generally less efficient.

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

The terms used in this note and in the ones that follow. Probability vocabulary is in [Probability foundations]({{ '/notes/statistics/probability-foundations/' | relative_url }}).

| Term | Meaning |
|---|---|
| **Population / sample** | The whole collection of interest / the part of it actually observed |
| **Parameter** | A fixed, unknown number describing the population ($\mu$, $\sigma^2$, $p$) |
| **Statistic** | Any function of the sample; it is random |
| **Estimator / estimate** | A statistic used to guess a parameter / its value on one data set |
| **Sampling distribution** | The distribution of a statistic over repeated samples |
| **Standard error** | The standard deviation of an estimator, e.g. $\sigma/\sqrt n$ for $\bar X$ |
| **Bias** | $\mathbb{E}[\hat\theta]-\theta$: the average miss |
| **MSE** | $\mathbb{E}[(\hat\theta-\theta)^2]=\operatorname{Var}+\operatorname{bias}^2$ |
| **Consistent** | Converges to the true parameter as $n\to\infty$ |
| **Efficient** | Unbiased with the smallest possible variance (reaches Cramér–Rao) |
| **Sufficient statistic** | Keeps all the information the sample holds about $\theta$ |
| **Likelihood** | The joint density of the data read as a function of $\theta$ |
| **Score / Fisher information** | Derivative of the log-likelihood / its variance, the information carried per observation |
| **Degrees of freedom** | Number of independent pieces of information left after estimating parameters |
| **Pivot** | A function of data and parameter whose distribution does not depend on the parameter |
| **Confidence level / coverage** | Fraction of repeated intervals that contain the true parameter, $1-\alpha$ |
| **Critical value** | A quantile of the null distribution that bounds the rejection region, e.g. $z_{1-\alpha/2}$ |
| **Null / alternative** | $H_0$, the default claim / $H_1$, what we look for evidence of |
| **Test statistic** | The number computed from the data whose null distribution we know |
| **Rejection region** | Values of the test statistic for which $H_0$ is rejected |
| **Significance level $\alpha$** | The Type I error rate we accept, fixed in advance |
| **$p$-value** | Probability under $H_0$ of a result at least as extreme as the one seen |
| **Type I / Type II error** | Rejecting a true $H_0$ / keeping a false one |
| **Power** | $1-\beta$: the probability of detecting a real effect |
| **One- / two-sided** | The alternative is on one side of $H_0$ / on either side |

# Recap

The note in a handful of questions. If you can answer each of these without looking, you have the core.

**What do the probability axioms say?** Probabilities are non-negative, the whole sample space has probability 1, and probabilities of disjoint events add. Everything else follows, for example $P(A^c)=1-P(A)$, monotonicity, and $P(A\cup B)=P(A)+P(B)-P(A\cap B)$.

**What is Bayes' theorem for?** It reverses a conditional: $P(B\mid A)=P(A\mid B)P(B)/P(A)$, with $P(A)$ from the law of total probability. It turns prior belief and a likelihood into a posterior, and it is the reason a positive result from an accurate test can still mean a low chance of disease when the condition is rare.

**Does zero correlation mean independence?** No. Independence implies zero covariance, not the reverse: $X\sim\mathcal{N}(0,1)$ and $Y=X^2$ are uncorrelated yet dependent.

**When does the variance of a sum equal the sum of the variances?** When the covariances are zero, in particular for independent variables. In general $\operatorname{Var}(X+Y)=\operatorname{Var}X+\operatorname{Var}Y+2\operatorname{Cov}(X,Y)$, and this is what gives $\operatorname{Var}(\bar X)=\sigma^2/n$.

**What is the difference between a parameter, a statistic and an estimator?** A parameter $\theta$ is a fixed, unknown feature of the population. A statistic is any function of the sample, hence random. An estimator is a statistic used to guess a parameter; an estimate is its value on the data in hand.

**Why does the sample mean behave so well?** It is unbiased for $\mu$, its variance is $\sigma^2/n$, the law of large numbers makes it converge to $\mu$, and the central limit theorem makes it approximately normal for large $n$, whatever the data distribution.

**Why divide by $n-1$ in $S^2$?** Deviations are taken from $\bar X$, which was fitted to the same data, so one degree of freedom is used up. With $n-1$ the estimator is exactly unbiased, $\mathbb{E}[S^2]=\sigma^2$, and $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ for normal data.

**Why a $t$ and not a normal when $\sigma$ is unknown?** Because $S$ is random too. The standardized mean $(\bar X-\mu)/(S/\sqrt n)$ then follows $t_{n-1}$, which has heavier tails and approaches $\mathcal{N}(0,1)$ as $n$ grows.

**What makes an estimator good?** Small mean squared error, $\operatorname{MSE}=\operatorname{Var}+\operatorname{bias}^2$, and consistency. Unbiased is not automatically best: a little bias can buy a lot of variance reduction, which is the idea behind shrinkage.

**What is the best an unbiased estimator can do?** Its variance cannot go below $1/(nI(\theta))$, the Cramér–Rao bound, where $I(\theta)$ is the Fisher information.

**What does maximum likelihood do, and why is it the default?** It picks the $\theta$ under which the observed data were most probable. For large $n$ it is consistent, asymptotically normal with variance $1/(nI(\theta))$ (so it reaches the Cramér–Rao bound), and invariant under reparametrization. It is not always unbiased: the MLE of the normal variance divides by $n$.

**What does a 95% confidence interval mean?** The procedure covers the true parameter in 95% of repeated samples. It does not say the parameter lies in your specific interval with probability 0.95.

**How do you build an interval?** Find a pivot, a function of data and parameter with a known distribution, and invert the probability statement. For the mean it is $\bar X\pm t_{n-1,1-\alpha/2}S/\sqrt n$.

**What does a $p$-value measure?** The probability, if $H_0$ were true, of a statistic at least as extreme as the observed one. It is not the probability that $H_0$ is true and says nothing about effect size.

**What are the two kinds of error, and what is power?** Type I is rejecting a true $H_0$ (probability $\alpha$, chosen in advance); Type II is keeping a false one (probability $\beta$). Power, $1-\beta$, is the chance of detecting a real effect and grows with sample size and effect size.

**How are tests and intervals related?** A $(1-\alpha)$ interval is exactly the set of parameter values a level-$\alpha$ test does not reject, so an interval excluding $\mu_0$ means the test rejects $\mu=\mu_0$.

**What goes wrong with many tests at once?** With $m$ tests you expect $m\alpha$ false positives. Bonferroni ($p_i\le\alpha/m$) controls the chance of any false positive; Benjamini–Hochberg controls the expected share of false discoveries and keeps more power.

# Where this goes next

- **Linear regression**: least squares is the Gaussian MLE, the coefficient $t$-tests and the overall $F$-test are exactly the tests above.
- **Regularization**: trading a little bias for a lot of variance, via the MSE decomposition.
- **Model assessment**: estimating prediction error is an inference problem with its own sampling distribution.
- **Mixture models**: the likelihood is no longer solvable in closed form, which motivates the EM algorithm.
