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

How much would an estimate change on another sample? A **sampling distribution**, the distribution of a statistic over repeated samples, answers it. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| $\operatorname{Var}(\sum X_i)$ needs covariances; LLN and CLT | [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}#variance-covariance-and-correlation) |
| Binomial, normal, gamma | [Common random variables]({{ '/notes/statistics/common-random-variables/' | relative_url }}) |

# What a sampling distribution is

For a statistic $T$ (any function of the sample, hence random), repeat the sampling: the values of $T$ form a distribution. Its centre gives the bias, its spread (the **standard error**) the precision, its shape the valid probability statements. Get it by

1. **derivation**, when the model is simple (below);
2. **simulation**: draw many samples from an assumed model and compute $T$ on each; works for any statistic;
3. the **bootstrap** when no model is assumed: resample the data with replacement and use the spread of $T$ over resamples as the standard error.

# Distributions of sample statistics

## The sample mean

For i.i.d. data with mean $\mu$ and variance $\sigma^2$,

$$ \mathbb{E}\bar X=\mu,\qquad \operatorname{Var}\bar X=\frac{\sigma^2}{n},\qquad \operatorname{se}(\bar X)=\frac{\sigma}{\sqrt n}. $$

Exactly $\mathcal{N}(\mu,\sigma^2/n)$ for normal data, approximately so for large $n$ otherwise (CLT). Four times the data halves the standard error. For two independent groups, $\bar X_1-\bar X_2$ has variance $\sigma_1^2/n_1+\sigma_2^2/n_2$.

## The sample proportion

For $X\sim$ Binomial($n,p$), $\hat p=X/n$ has $\mathbb{E}\hat p=p$, $\operatorname{Var}\hat p=p(1-p)/n$, and is approximately normal when $np(1-p)$ is large. A classifier with true accuracy $0.8$ on $n=100$ test examples has standard error $0.04$, so its measured accuracy is typically within $0.72$–$0.88$: a gap of a few points between two models at that size is noise.

## Sample variance and the chi-square

$\chi^2_k$, a sum of $k$ squared independent standard normals, has mean $k$ and variance $2k$. For normal data

$$ \frac{(n-1)S^2}{\sigma^2}\sim\chi^2_{n-1},\qquad S^2\perp\bar X. $$

It is right-skewed, which is why intervals for a variance are asymmetric.

## Student's t

With $\sigma$ replaced by $S$,

$$ T=\frac{\bar X-\mu}{S/\sqrt n}\sim t_{n-1}, $$

a standard normal over the root of an independent $\chi^2_k/k$. Symmetric, heavier tails than the normal, tends to $\mathcal{N}(0,1)$ as the degrees of freedom grow:

| Degrees of freedom | 5 | 9 | 29 | $\infty$ |
|---|---|---|---|---|
| 97.5% quantile | 2.571 | 2.262 | 2.045 | 1.960 |

## The F distribution

A ratio of independent scaled chi-squares, $(V_1/a)/(V_2/b)\sim F_{a,b}$. It compares variances and is the null law of the overall test in ANOVA and regression. $t_k^2\sim F_{1,k}$, so a two-sided $t$-test and a one-degree-of-freedom $F$-test agree.

## Not everything is normal: the sample maximum

For i.i.d. Uniform($0,\theta$) data and $M=\max_i X_i$: $P(M\le m)=(m/\theta)^n$ and $\mathbb{E}M=\frac{n}{n+1}\theta$. It is piled against the boundary $\theta$ and biased low, and normal-theory intervals fail. Derive or simulate the sampling distribution of the statistic you actually use; do not assume it is normal.

# Recap

**Why $t$ and not $z$ when $\sigma$ is unknown?** $S$ is random too, so $(\bar X-\mu)/(S/\sqrt n)\sim t_{n-1}$: heavier tails, wider intervals for small $n$.

**Where do $\chi^2$, $t$, $F$ come from?** $\chi^2$: squared standard normals summed; $t$: normal over $\sqrt{\chi^2_k/k}$; $F$: ratio of independent $\chi^2/\text{df}$.

**Why is the sample maximum not normal?** It is tied to the boundary of the support, so it is skewed and biased; the CLT covers averages, not every statistic.
