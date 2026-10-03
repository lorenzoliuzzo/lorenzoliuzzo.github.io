---
collection: notes
title: "Common Random Variables"
date: 2026-10-03
excerpt: "The standard discrete and continuous distributions: what each models, its mean and variance, the facts that matter, and how to choose."
read_time: true
tags:
  - Statistics
  - Probability
---

The catalogue of standard distributions, with the facts worth remembering about each. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| pmf, density, cdf; expectation; variance; independence | [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}) |
| Central limit theorem | [Random variables › Limit theorems]({{ '/notes/statistics/random-variables/' | relative_url }}#limit-theorems) |

# Discrete

## Bernoulli

One yes/no trial, success probability $p$: $\mathbb{E}X=p$, $\operatorname{Var}X=p(1-p)$, largest at $p=\tfrac12$. An indicator $\mathbf 1_A$ is Bernoulli($P(A)$).

## Binomial

Successes in $n$ independent Bernoulli($p$) trials:

$$ P(X=k)=\binom nk p^k(1-p)^{n-k},\qquad \mathbb{E}X=np,\quad \operatorname{Var}X=np(1-p). $$

Mean and variance come from linearity and independence on the $n$ terms. Approximately normal once $np(1-p)\gtrsim10$. The number of correct predictions of a classifier on $n$ independent test examples is binomial.

## Geometric

Trials until the first success: $P(X=k)=(1-p)^{k-1}p$, mean $1/p$, variance $(1-p)/p^2$. **Memoryless**: past failures say nothing about the remaining wait.

## Poisson

Events in a fixed interval at constant rate $\lambda$, independent:

$$ P(X=k)=\frac{e^{-\lambda}\lambda^k}{k!},\qquad \mathbb{E}X=\operatorname{Var}X=\lambda. $$

- It is the limit of Binomial($n,p$) for large $n$, small $p$, $np=\lambda$.
- Independent Poissons add: rates add.
- Mean $=$ variance is a check: count data with variance well above the mean are **overdispersed**, not Poisson.

# Continuous

## Uniform

Density $1/(b-a)$ on $[a,b]$, mean $(a+b)/2$, variance $(b-a)^2/12$. If $U\sim$ Uniform(0,1) and $F$ is a cdf, $F^{-1}(U)$ has cdf $F$: **inverse transform sampling**. Also, a $p$-value under the null is uniform on $(0,1)$.

## Exponential

Waiting time between events of a Poisson process of rate $\lambda$: $f(x)=\lambda e^{-\lambda x}$, $P(X>x)=e^{-\lambda x}$, mean $1/\lambda$, variance $1/\lambda^2$. The continuous analogue of the geometric, and also memoryless: $P(X>s+t\mid X>s)=P(X>t)$. These are the only memoryless families.

## Normal

$X\sim\mathcal{N}(\mu,\sigma^2)$, density $\frac{1}{\sqrt{2\pi\sigma^2}}e^{-(x-\mu)^2/(2\sigma^2)}$.

- **Standardization**: $Z=(X-\mu)/\sigma\sim\mathcal{N}(0,1)$. Mass within $1,2,3$ standard deviations: 68%, 95%, 99.7%; $z_{0.975}\approx1.96$.
- **Closed under linear combinations**: independent normals sum to a normal, and a linear function of a normal is normal.
- The CLT makes it the limit of averages, hence the noise model of regression and the large-sample approximation of most estimators.

## Gamma

Positive and right-skewed; a sum of $k$ independent exponentials is Gamma. The chi-square is a special case (see [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#sample-variance-and-the-chi-square)).

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

# Recap

**Binomial or Poisson?** Binomial for successes out of $n$ fixed trials, Poisson for a count of events in an interval; Poisson is the large-$n$, small-$p$ limit of the binomial.

**Which families are memoryless?** Only the geometric (discrete) and the exponential (continuous).
