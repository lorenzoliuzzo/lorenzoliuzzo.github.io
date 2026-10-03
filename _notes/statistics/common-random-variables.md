---
collection: notes
title: "Common Random Variables"
date: 2026-10-03
excerpt: "The standard discrete and continuous distributions: what each models, its mean and variance, the facts that matter, and how to choose."
hook: "A handful of distributions cover most data: pick by what you are counting or measuring, not by what the histogram happens to look like."
goals:
  - pick the standard distribution that matches a counting or waiting situation
  - quote the mean and variance of each without rederiving them
  - recognize the memoryless property and the Poisson limit
requires:
  - pmf-and-density
  - expectation
  - variance
  - central-limit-theorem
defines:
  - {id: binomial, name: binomial, anchor: binomial}
  - {id: poisson, name: Poisson, anchor: poisson}
  - {id: exponential, name: exponential, anchor: exponential}
  - {id: normal, name: normal, anchor: normal}
  - {id: gamma, name: gamma, anchor: gamma}
read_time: true
tags:
  - Statistics
  - Probability
---

Real data are usually modelled with one of a small number of standard distributions, and recognizing which one fits a situation is a large part of applied statistics. This note goes through them, with the facts about each that are worth remembering. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Discrete

## Bernoulli

> **Mean** $p$  
> **Variance** $p(1-p)$
{: .margin .spec}

The simplest random variable is a single yes/no trial, coded 1 with probability $p$ and 0 otherwise. The variance is largest at $p=\tfrac12$: a fair coin is the most uncertain yes/no event there is. Every indicator $\mathbf 1_A$ is a Bernoulli with $p=P(A)$.

## Binomial

> **pmf** $\binom nk p^k(1-p)^{n-k}$  
> **Mean** $np$  
> **Variance** $np(1-p)$
{: .margin .spec}

Add up $n$ independent Bernoulli($p$) trials and you get the number of successes. The mean and variance need no computation with the pmf: linearity and independence applied to the $n$ Bernoulli terms give them directly. A typical use is the number of correct predictions of a classifier on $n$ independent test examples.

> For large $n$ the binomial is close to a normal, a reasonable approximation once $np(1-p)$ is around 10 or more.
{: .rule}

## Geometric

> **pmf** $(1-p)^{k-1}p$, $k\ge1$  
> **Mean** $1/p$  
> **Variance** $(1-p)/p^2$
{: .margin .spec}

If instead we count trials until the first success, we get the geometric distribution. It is **memoryless**: having already failed many times does not make success any closer, because the trials do not remember.

## Poisson

> **pmf** $e^{-\lambda}\lambda^k/k!$  
> **Mean** $\lambda$  
> **Variance** $\lambda$
{: .margin .spec}

The Poisson counts events in a fixed interval when they occur independently at a constant average rate $\lambda$. It arises as the limit of Binomial($n,p$) when $n$ is large, $p$ is small and $np=\lambda$ stays fixed, which is why it describes rare events so well. Independent Poisson variables add, with their rates.

{% include fig.html src="statistics/poisson-limit" id="fig-poisson-limit" alt="Two panels of bars for the binomial pmf with mean 2, for n equal to 10 and to 100, with the Poisson pmf with mean 2 drawn on top. The Poisson curve matches the bars better for n equal to 100." caption="Binomial bars and the Poisson with the same mean. With $n=10$ the two still differ visibly, with $n=100$ and $p=0.02$ they nearly coincide." %}

> The equality of mean and variance is a quick diagnostic. Count data whose variance is well above the mean are **overdispersed**, and a plain Poisson model will understate the uncertainty.
{: .trap}

# Continuous

## Uniform

> **Density** $1/(b-a)$ on $[a,b]$  
> **Mean** $(a+b)/2$  
> **Variance** $(b-a)^2/12$
{: .margin .spec}

The uniform matters mostly because everything else can be built from it. If $U$ is Uniform(0,1) and $F$ is a cdf, then $F^{-1}(U)$ has cdf $F$, which is **inverse transform sampling** and the basis of most random number generation. It also appears in testing: under the null hypothesis, a $p$-value is uniform on $(0,1)$.

## Exponential

> **Density** $\lambda e^{-\lambda x}$, $x\ge0$  
> **Mean** $1/\lambda$  
> **Variance** $1/\lambda^2$
{: .margin .spec}

The exponential is the waiting time between events of a Poisson process of rate $\lambda$, so $P(X>x)=e^{-\lambda x}$. It is the continuous counterpart of the geometric and, like it, memoryless, $P(X>s+t\mid X>s)=P(X>t)$.

> The geometric and the exponential are the only memoryless distributions. If the failure rate of something depends on its age, the exponential is the wrong model.
{: .trap}

## Normal

> **Density** $\frac{1}{\sqrt{2\pi\sigma^2}}e^{-(x-\mu)^2/(2\sigma^2)}$  
> **Mean** $\mu$  
> **Variance** $\sigma^2$
{: .margin .spec}

{% include fig.html src="statistics/normal-rule" place="margin" id="fig-normal-rule" alt="The standard normal density with brackets showing that 68 percent of the mass lies within one standard deviation, 95 percent within two and 99.7 percent within three." caption="The 68, 95 and 99.7 percent rule." %}

The normal $\mathcal{N}(\mu,\sigma^2)$ has three properties that explain how dominant it is. Standardizing, $Z=(X-\mu)/\sigma$, reduces every normal probability to the standard normal, and about 68%, 95% and 99.7% of the mass lies within one, two and three standard deviations, with $z_{0.975}\approx1.96$. The family is closed under linear combinations: a sum of independent normals, or a linear function of one, is again normal. And the central limit theorem makes it the limit of averages, which is why it models noise in regression and approximates the distribution of most estimators for large $n$.

## Gamma

> **Density** $\lambda^k x^{k-1}e^{-\lambda x}/\Gamma(k)$  
> **Mean** $k/\lambda$  
> **Variance** $k/\lambda^2$
{: .margin .spec}

The gamma is a flexible positive, right-skewed distribution, and a sum of $k$ independent exponentials has this form. For us its main role is that the chi-square distribution is a special case; see [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#sample-variance-and-the-chi-square).

# Choosing a model

| The quantity is | Model |
|---|---|
| one yes/no outcome | Bernoulli |
| successes in $n$ fixed trials | Binomial |
| trials until the first success | Geometric |
| events in an interval | Poisson |
| waiting time, lifetime | Exponential (or Gamma) |
| symmetric noise, or an average | Normal |
| no preferred value in a range | Uniform |
{: .keyed}

# Recap

<details class="qa" markdown="1">
<summary>Binomial or Poisson?</summary>

Binomial when there is a fixed number of trials and we count successes, Poisson when we count events in an interval with no fixed number of trials. The Poisson is the limit of the binomial for large $n$ and small $p$.
</details>

<details class="qa" markdown="1">
<summary>Which distributions are memoryless?</summary>

Only the geometric among the discrete ones and the exponential among the continuous ones.
</details>

<details class="qa" markdown="1">
<summary>Count data have variance three times their mean. What does that say about a Poisson model?</summary>

It is overdispersed relative to the Poisson, whose variance equals its mean, so a Poisson model would understate the uncertainty. Use a model with an extra dispersion parameter.
</details>
