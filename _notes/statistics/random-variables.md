---
collection: notes
title: "Random Variables, Expectation and Variance"
date: 2026-10-03
excerpt: "Random variables and their distributions, expectation, variance, covariance and correlation, conditional expectation, and the law of large numbers and central limit theorem."
read_time: true
tags:
  - Statistics
  - Probability
---

A random variable turns the outcome of an experiment into a number, and the rest of statistics works with numbers: their averages, their spread, how two of them move together. This note covers the distribution of a random variable, the summaries built from it (expectation, variance, covariance) and the two limit theorems that justify averaging. It assumes the events, axioms and conditioning from [Probability foundations]({{ '/notes/statistics/probability-foundations/' | relative_url }}).

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# Random variables and their distributions

A **random variable** $X$ is a numerical outcome of the experiment: a function from $\Omega$ to the real numbers. Its **distribution** says how probability is spread over its values. Three equivalent descriptions:

- the **cumulative distribution function** $F(x)=P(X\le x)$. It is non-decreasing, right-continuous, tends to 0 at $-\infty$ and to 1 at $+\infty$, and gives $P(a<X\le b)=F(b)-F(a)$;
- if $X$ is **discrete**, the **probability mass function** $p(x)=P(X=x)$, with $\sum_x p(x)=1$;
- if $X$ is **continuous**, the **density** $f(x)=F'(x)$, with $\int f=1$ and $P(a\le X\le b)=\int_a^b f(x)\,dx$. Single points have probability zero, so a density value is not a probability.

The **support** is where $X$ can land with positive probability or density. The **quantile** of order $p$ is the value $q_p$ with $F(q_p)=p$; the **median** is $q_{0.5}$. For two variables, the **joint** distribution describes $(X,Y)$ together, the **marginal** of $X$ is what remains after summing or integrating out $Y$, and the **conditional** distribution of $X$ given $Y=y$ is the joint divided by the marginal of $Y$. $X$ and $Y$ are independent exactly when the joint factorizes into the product of the marginals.

# Expectation

The **expectation** (mean) is the probability-weighted average of the values,

$$ \mathbb{E}[X]=\sum_x x\,p(x)\qquad\text{or}\qquad \mathbb{E}[X]=\int x f(x)\,dx . $$

For a function of $X$ there is no need to find its distribution first: $\mathbb{E}[g(X)]=\sum_x g(x)p(x)$ or $\int g(x)f(x)\,dx$.

**Properties** (these are used constantly, so learn them cold):

- **Linearity**: $\mathbb{E}[aX+b]=a\,\mathbb{E}[X]+b$ and $\mathbb{E}[X+Y]=\mathbb{E}[X]+\mathbb{E}[Y]$ *always*, with no independence needed.
- **Products**: $\mathbb{E}[XY]=\mathbb{E}[X]\,\mathbb{E}[Y]$ **if $X$ and $Y$ are independent**; in general it is false.
- **Monotone**: $X\le Y$ implies $\mathbb{E}[X]\le\mathbb{E}[Y]$.
- **Indicators**: $\mathbb{E}[\mathbf 1_A]=P(A)$, so probabilities are expectations.
- **Jensen**: for convex $g$, $g(\mathbb{E}X)\le\mathbb{E}[g(X)]$. In particular $\mathbb{E}[X^2]\ge(\mathbb{E}X)^2$, which is why variance is never negative.

Note that $\mathbb{E}[g(X)]\neq g(\mathbb{E}[X])$ in general: the mean of a square is not the square of the mean.

# Variance, covariance and correlation

The **variance** measures spread around the mean, $\operatorname{Var}(X)=\mathbb{E}[(X-\mu)^2]$ with $\mu=\mathbb{E}X$, and the **standard deviation** $\sigma=\sqrt{\operatorname{Var}X}$ has the units of $X$. Properties:

- **Shortcut**: $\operatorname{Var}(X)=\mathbb{E}[X^2]-(\mathbb{E}X)^2$.
- **Scaling**: $\operatorname{Var}(aX+b)=a^2\operatorname{Var}(X)$. Shifting changes nothing; scaling by $a$ scales the variance by $a^2$.
- $\operatorname{Var}(X)\ge 0$, with equality only if $X$ is constant.
- **Standardization**: $Z=(X-\mu)/\sigma$ has mean 0 and variance 1.

For two variables, the **covariance** $\operatorname{Cov}(X,Y)=\mathbb{E}[XY]-\mathbb{E}X\,\mathbb{E}Y$ measures how they move together, and the scale-free **correlation** is

$$ \rho_{XY}=\frac{\operatorname{Cov}(X,Y)}{\sigma_X\,\sigma_Y}\in[-1,1], $$

with $\lvert\rho\rvert=1$ exactly when $Y$ is a linear function of $X$. Covariance is bilinear and $\operatorname{Cov}(X,X)=\operatorname{Var}(X)$. This gives the rule for sums,

$$ \operatorname{Var}(X+Y)=\operatorname{Var}X+\operatorname{Var}Y+2\operatorname{Cov}(X,Y), $$

so the variance of a sum is the sum of the variances **only when the covariances vanish**. For independent $X_1,\dots,X_n$ with variance $\sigma^2$ this yields the most useful formula in statistics, $\operatorname{Var}(\bar X)=\sigma^2/n$.

Independence implies zero covariance, but **zero covariance does not imply independence**. If $X\sim\mathcal{N}(0,1)$ and $Y=X^2$, then $\operatorname{Cov}(X,Y)=\mathbb{E}[X^3]=0$, yet $Y$ is completely determined by $X$. Correlation only detects *linear* dependence.

## Conditioning a random variable

The **conditional expectation** $\mathbb{E}[X\mid Y]$ is the best guess of $X$ once $Y$ is known; it is itself a random variable, a function of $Y$. Two identities will return in the regression and mixture notes:

$$ \mathbb{E}[X]=\mathbb{E}\big[\mathbb{E}[X\mid Y]\big],\qquad \operatorname{Var}(X)=\mathbb{E}\big[\operatorname{Var}(X\mid Y)\big]+\operatorname{Var}\big(\mathbb{E}[X\mid Y]\big). $$

The second is the **law of total variance**: total spread equals the average spread *within* groups plus the spread *between* the group means.

# Shape summaries

The $k$-th **moment** is $\mathbb{E}[X^k]$ and the $k$-th **central moment** is $\mathbb{E}[(X-\mu)^k]$. The standardized third and fourth central moments are the **skewness** (asymmetry) and **kurtosis** (tail weight; the normal has 3). The **mode** is the most likely value. For skewed data the mean, median and mode differ, and the mean is the one most affected by outliers.

The standard discrete and continuous distributions (Bernoulli, binomial, Poisson, uniform, exponential, normal and more), with their means, variances and uses, are in [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}).

# Limit theorems

**Law of large numbers.** The sample mean $\bar X_n=\tfrac1n\sum X_i$ converges to $\mu=\mathbb{E}X$ as $n\to\infty$. This is why averaging works.

**Central limit theorem.** If the $X_i$ are i.i.d. with mean $\mu$ and finite variance $\sigma^2$, then

$$ \sqrt{n}\,\frac{\bar X_n-\mu}{\sigma}\ \xrightarrow{d}\ \mathcal{N}(0,1). $$

The CLT is the reason the normal distribution appears everywhere in inference, even when the data are not normal: sums and averages become approximately normal. How large $n$ must be depends on how skewed or heavy-tailed the data are, so "$n\ge 30$" is a rule of thumb, not a theorem.

# Vocabulary

The terms used here and in the notes that follow.

| Term | Meaning |
|---|---|
| **Random variable** | A numerical outcome of the experiment |
| **pmf / pdf / cdf** | Mass function (discrete), density (continuous), cumulative distribution function $P(X\le x)$ |
| **Support** | Values where the mass or density is positive |
| **Marginal / joint / conditional** | Distribution of one variable alone / of several together / given the value of another |
| **Expectation** | The probability-weighted average $\mathbb{E}[X]$ |
| **Variance / standard deviation** | $\mathbb{E}[(X-\mu)^2]$ / its square root |
| **Covariance / correlation** | Linear co-movement of two variables / its scale-free version in $[-1,1]$ |
| **Moment** | $\mathbb{E}[X^k]$; central moments are taken around the mean |
| **Quantile / median** | Value below which a given fraction (one half for the median) of the probability lies |
| **Skewness / kurtosis** | Standardized third and fourth central moments: asymmetry and tail weight |
| **i.i.d.** | Independent and identically distributed |

# Recap

The note in a handful of questions.

**What is the difference between a pmf, a pdf and a cdf?** A pmf gives probabilities of single values (discrete), a pdf gives a density whose integral over an interval is a probability (continuous; single points have probability zero), and the cdf $F(x)=P(X\le x)$ describes both and is always non-decreasing from 0 to 1.

**Does zero correlation mean independence?** No. Independence implies zero covariance, not the reverse: $X\sim\mathcal{N}(0,1)$ and $Y=X^2$ are uncorrelated yet dependent.

**When does the variance of a sum equal the sum of the variances?** When the covariances are zero, in particular for independent variables. In general $\operatorname{Var}(X+Y)=\operatorname{Var}X+\operatorname{Var}Y+2\operatorname{Cov}(X,Y)$, and this is what gives $\operatorname{Var}(\bar X)=\sigma^2/n$.

**What do the law of large numbers and the central limit theorem say?** The sample mean converges to $\mu$, and its standardized version $\sqrt n(\bar X-\mu)/\sigma$ is approximately $\mathcal{N}(0,1)$ for large $n$, whatever the data distribution (with finite variance).

# Where this goes next

[Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}) is the catalogue of standard distributions (Bernoulli, binomial, Poisson, normal and others) built from these tools. [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}) then asks what the variance and central limit rules say about statistics computed from a sample. Linear regression reuses the expectation, variance and covariance rules throughout.
