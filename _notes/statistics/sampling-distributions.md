---
collection: notes
title: "Sampling Distributions"
date: 2026-10-03
excerpt: "What a sampling distribution is, and the distributions of the sample mean, proportion and variance, with the chi-square, t and F laws."
hook: "An estimate from one sample is one draw from a distribution; the sampling distribution says how far the next draw could land."
goals:
  - give the distribution of the sample mean, proportion and variance
  - choose between the normal, t, chi-square and F for a statistic
  - explain why the sample maximum is not asymptotically normal
requires:
  - variance-of-a-sum
  - law-of-large-numbers
  - central-limit-theorem
  - binomial
  - normal
  - gamma
defines:
  - {id: sampling-distribution, name: sampling distribution, anchor: what-a-sampling-distribution-is}
  - {id: standard-error, name: standard error, anchor: the-sample-mean}
  - {id: chi-square, name: chi-square, anchor: sample-variance-and-the-chi-square}
  - {id: student-t, name: Student's t, anchor: students-t}
  - {id: f-distribution, name: F distribution, anchor: the-f-distribution}
read_time: true
tags:
  - Statistics
  - Inference
---

An estimate computed from one sample would have been different on another sample, and the question is by how much. The answer is the **sampling distribution** of the statistic: its distribution over repeated samples. This note shows how to get one and works out the cases that inference relies on. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# What a sampling distribution is

A statistic $T$ is any function of the sample, so it is random. If we could repeat the sampling many times, the values of $T$ would form a distribution. Its centre tells us about the bias, its spread, called the **standard error**, tells us about the precision, and its shape tells us which probability statements we are allowed to make.

There are three ways to find it. When the data model is simple we can derive it, which is what the rest of the note does. When it is not, we can simulate: draw many samples from an assumed model, compute $T$ on each, and look at the result. This works for any statistic and is the quickest way to build intuition for a formula. And when we do not want to assume a model at all, the **bootstrap** resamples the observed data with replacement and uses the spread of $T$ over the resamples as an estimate of the standard error.

# Distributions of sample statistics

## The sample mean

For i.i.d. data with mean $\mu$ and variance $\sigma^2$,

$$ \mathbb{E}\bar X=\mu,\qquad \operatorname{Var}\bar X=\frac{\sigma^2}{n},\qquad \operatorname{se}(\bar X)=\frac{\sigma}{\sqrt n}. $$

If the data are normal, $\bar X$ is exactly $\mathcal{N}(\mu,\sigma^2/n)$, and otherwise the central limit theorem makes it approximately so for large $n$. The standard error shrinks like $1/\sqrt n$, so four times the data halves the uncertainty. For two independent groups, the difference $\bar X_1-\bar X_2$ has variance $\sigma_1^2/n_1+\sigma_2^2/n_2$.

## The sample proportion

If $X\sim$ Binomial($n,p$) counts the successes, the proportion $\hat p=X/n$ has mean $p$ and variance $p(1-p)/n$, and is approximately normal when $np(1-p)$ is large.

> A classifier with true accuracy $0.8$ evaluated on $n=100$ test examples has a standard error of $\sqrt{0.8\cdot0.2/100}=0.04$, so its measured accuracy will typically land between $0.72$ and $0.88$. A gap of a few points between two models on a test set of that size is within noise.
{: .trap}

## Sample variance and the chi-square

A sum of $k$ squared independent standard normals follows a chi-square distribution with $k$ degrees of freedom, $\chi^2_k$, which has mean $k$ and variance $2k$. For normal data, the sample variance is tied to it:

$$ \frac{(n-1)S^2}{\sigma^2}\sim\chi^2_{n-1},\qquad S^2\ \text{independent of}\ \bar X. $$

Since the chi-square is right-skewed, $S^2$ is not symmetric around $\sigma^2$, and that is why confidence intervals for a variance are not symmetric either.

## Student's t

In practice $\sigma$ is unknown and we replace it by $S$. The standardized mean then follows a $t$ distribution,

$$ T=\frac{\bar X-\mu}{S/\sqrt n}\sim t_{n-1}, $$

which is a standard normal divided by the square root of an independent $\chi^2_k/k$. The extra randomness from estimating $\sigma$ shows up as heavier tails than the normal, so intervals for small samples have to be wider. As the degrees of freedom grow, the $t$ approaches $\mathcal{N}(0,1)$. The bodies of the curves are almost the same, so the difference lives in the tails.

{% include fig.html src="statistics/t-vs-normal" id="fig-t" alt="Left: densities of the normal, the t with 10 degrees of freedom and the t with 3 degrees of freedom, which are close to each other. Right: the same curves on the right tail, magnified, where the t with 3 degrees of freedom is clearly higher. Dashed lines mark the 97.5 percent critical values 1.96, 2.23 and 3.18." caption="Left, the whole density: the three curves look alike. Right, the right tail magnified: the $t$ puts more mass out there, so its 97.5% critical value is larger, and an interval built with it is wider." %}

| Degrees of freedom | 5 | 9 | 29 | $\infty$ |
|---|---|---|---|---|
| 97.5% quantile | 2.571 | 2.262 | 2.045 | 1.960 |
{: .keyed}

## The F distribution

The ratio of two independent scaled chi-squares, $(V_1/a)/(V_2/b)$, follows an $F_{a,b}$ distribution. It is used to compare variances and is the null distribution of the overall test in ANOVA and regression. Since $t_k^2\sim F_{1,k}$, a two-sided $t$-test and a one-degree-of-freedom $F$-test give the same answer.

## Not everything is normal: the sample maximum

Not every statistic has a bell-shaped sampling distribution. Take i.i.d. Uniform($0,\theta$) data and $M=\max_i X_i$. Then $P(M\le m)=(m/\theta)^n$ on $[0,\theta]$, so $M$ piles up against the boundary $\theta$, and $\mathbb{E}M=\frac{n}{n+1}\theta$: it always underestimates a little, and normal-theory intervals do not apply. 

> Derive or simulate the sampling distribution of the statistic you actually use, instead of assuming it is normal. The CLT is a statement about averages, not about every statistic.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why a $t$ and not a normal when $\sigma$ is unknown?</summary>

Because $S$ is itself random, the standardized mean has heavier tails than a normal, and the exact law is $t_{n-1}$. For small $n$ ignoring this makes intervals too narrow.
</details>

<details class="qa" markdown="1">
<summary>Where do the chi-square, $t$ and $F$ come from?</summary>

The chi-square is a sum of squared standard normals, the $t$ is a normal over the square root of a $\chi^2_k/k$, and the $F$ is a ratio of two independent $\chi^2$ variables divided by their degrees of freedom.
</details>

<details class="qa" markdown="1">
<summary>Why is the sample maximum not normal?</summary>

It is tied to the boundary of the support, so it is skewed and biased. The CLT is a statement about averages, not about every statistic.
</details>
