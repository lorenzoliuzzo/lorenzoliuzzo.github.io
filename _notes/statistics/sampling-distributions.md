---
collection: notes
title: "Sampling Distributions"
date: 2026-10-03
excerpt: "What a sampling distribution is, and the distributions of the sample mean, proportion and variance, with the chi-square, t and F laws."
read_time: true
tags:
  - Statistics
  - Inference
---

An estimate is only as trustworthy as we can say how much it would change on another sample. That is the job of a **sampling distribution**: the distribution of a statistic over repeated samples. This note shows how to find one, by derivation or by simulation, and works out the cases that inference leans on: the mean, the proportion, the variance, and the $\chi^2$, $t$ and $F$ laws. It builds on the distributions in [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}) and the limit theorems in [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}).

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# What a sampling distribution is

Draw a sample, compute a statistic $T$, and repeat on fresh samples: the values of $T$ form a distribution. Its centre tells us about bias, its spread (the **standard error**) about precision, and its shape tells us which probability statements are valid. Two ways to obtain it:

1. **Derive it** with probability, when the data model is simple enough (the cases below).
2. **Simulate it**: draw many samples from an assumed model, compute $T$ on each, and look at the resulting distribution. This works for any statistic and is the cheapest way to build intuition for a formula.

When there is no assumed model and no formula, the **bootstrap** resamples the observed data with replacement and recomputes $T$ on each resample, using the resulting spread as an estimate of the standard error.

# Distributions of sample statistics

## The sample mean

For i.i.d. data with mean $\mu$ and variance $\sigma^2$,

$$ \mathbb{E}[\bar X]=\mu,\qquad \operatorname{Var}(\bar X)=\frac{\sigma^2}{n},\qquad \operatorname{se}(\bar X)=\frac{\sigma}{\sqrt n}. $$

The shape depends on the data. For normal data $\bar X\sim\mathcal{N}(\mu,\sigma^2/n)$ exactly; otherwise the central limit theorem gives approximate normality for large $n$. The standard error shrinks like $1/\sqrt n$: four times the data halves the uncertainty. For two independent groups, $\bar X_1-\bar X_2$ has mean $\mu_1-\mu_2$ and variance $\sigma_1^2/n_1+\sigma_2^2/n_2$.

## The sample proportion

If $X\sim$ Binomial($n,p$) counts successes, the proportion $\hat p=X/n$ has

$$ \mathbb{E}[\hat p]=p,\qquad \operatorname{Var}(\hat p)=\frac{p(1-p)}{n}, $$

and is approximately normal when $np(1-p)$ is large. **Example:** a classifier with true accuracy $0.8$ evaluated on $n=100$ test examples has standard error $\sqrt{0.8\cdot 0.2/100}=0.04$, so its measured accuracy typically falls between about $0.72$ and $0.88$ (two standard errors). A difference of a few points between two models on a test set that size is within noise.

## The sample variance and the chi-square distribution

The sum of $k$ squared independent standard normals follows a **chi-square distribution with $k$ degrees of freedom**, $\chi^2_k$, with mean $k$ and variance $2k$. For normal data,

$$ \frac{(n-1)S^2}{\sigma^2}\sim\chi^2_{n-1}, $$

and $S^2$ is independent of $\bar X$. The chi-square is right-skewed, so the sample variance is not symmetric around $\sigma^2$, which is why intervals for a variance are not symmetric either.

## Student's t

When $\sigma$ is replaced by its estimate $S$, the standardized mean is

$$ T=\frac{\bar X-\mu}{S/\sqrt n}\sim t_{n-1}. $$

The $t$ distribution is a standard normal divided by the square root of an independent $\chi^2_k/k$. It is symmetric with heavier tails than the normal, and approaches $\mathcal{N}(0,1)$ as the degrees of freedom grow. Heavier tails mean wider intervals for small samples:

| Degrees of freedom | 5 | 9 | 29 | $\infty$ (normal) |
|---|---|---|---|---|
| 97.5% quantile | 2.571 | 2.262 | 2.045 | 1.960 |

## The F distribution

The ratio of two independent scaled chi-squares, $(V_1/a)/(V_2/b)\sim F_{a,b}$. It compares variances, and it is the distribution of the overall test in analysis of variance and regression. A $t_k$ squared is an $F_{1,k}$, so a two-sided $t$-test and a one-degree-of-freedom $F$-test agree.

## A statistic that is not normal: the sample maximum

Not every statistic has a bell-shaped sampling distribution. If $X_1,\dots,X_n$ are i.i.d. Uniform($0,\theta$) and $M=\max_i X_i$, then $P(M\le m)=(m/\theta)^n$ for $0\le m\le\theta$, so $M$ is piled up just below $\theta$, and $\mathbb{E}[M]=\frac{n}{n+1}\theta$. It always underestimates $\theta$ slightly, and the usual normal-based intervals do not apply. This is the reminder to derive or simulate the sampling distribution of the statistic you actually use, rather than assume it is normal.

# Vocabulary

The terms used in this note.

| Term | Meaning |
|---|---|
| **Sampling distribution** | The distribution of a statistic over repeated samples |
| **Standard error** | The standard deviation of a statistic, e.g. $\sigma/\sqrt n$ for $\bar X$ |
| **Degrees of freedom** | The parameter of the $\chi^2$, $t$ and $F$ families: the number of free squared terms |
| **Bootstrap** | Estimating a sampling distribution by resampling the observed data |
| **Statistic** | Any function of the sample; it is random |

# Recap

The note in a handful of questions.

**What is a sampling distribution, and why does it matter?** It is the distribution of a statistic over repeated samples. Its centre shows the bias, its spread (the standard error) the precision, and its shape which probability statements are valid.

**What is the standard error of a sample mean and of a proportion?** $\sigma/\sqrt n$ and $\sqrt{p(1-p)/n}$. Both shrink like $1/\sqrt n$.

**Where do the chi-square, $t$ and $F$ distributions come from?** The chi-square is a sum of squared standard normals, $t$ is a standard normal over the root of an independent $\chi^2_k/k$, and $F$ is a ratio of two independent $\chi^2$ variables each divided by its degrees of freedom. For normal data $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ and $(\bar X-\mu)/(S/\sqrt n)\sim t_{n-1}$.

**Why is the sample maximum not normal?** Its distribution is tied to a boundary, here the upper end of the uniform range, so it is skewed and its mean is biased. The normal shape of averages comes from the central limit theorem, which does not cover every statistic.

**Why does the sample mean behave so well?** It is unbiased for $\mu$, its variance is $\sigma^2/n$, the law of large numbers makes it converge to $\mu$, and the central limit theorem makes it approximately normal for large $n$, whatever the data distribution.

**Why a $t$ and not a normal when $\sigma$ is unknown?** Because $S$ is random too. The standardized mean $(\bar X-\mu)/(S/\sqrt n)$ then follows $t_{n-1}$, which has heavier tails and approaches $\mathcal{N}(0,1)$ as $n$ grows.

# Where this goes next

[Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}) uses these distributions to ask how good an estimator is, and [Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) and [Hypothesis tests]({{ '/notes/statistics/hypothesis-tests/' | relative_url }}) invert them. Linear regression reuses the $t$ and $F$ laws for its coefficient tests.
