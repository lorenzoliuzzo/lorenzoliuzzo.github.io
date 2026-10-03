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

Real data are usually modelled with one of a small number of standard distributions, and recognizing which one fits a situation is a large part of applied statistics. This note goes through them, with the facts about each that are worth remembering. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| pmf, density, cdf; expectation; variance; independence | [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}) |
| Central limit theorem | [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}#limit-theorems) |

# Discrete

## Bernoulli

The simplest random variable is a single yes/no trial, coded 1 with probability $p$ and 0 otherwise. Its mean is $p$ and its variance $p(1-p)$, which is largest at $p=\tfrac12$: a fair coin is the most uncertain yes/no event there is. Every indicator $\mathbf 1_A$ is a Bernoulli with $p=P(A)$.

## Binomial

Add up $n$ independent Bernoulli($p$) trials and you get the number of successes,

$$ P(X=k)=\binom nk p^k(1-p)^{n-k},\qquad \mathbb{E}X=np,\quad \operatorname{Var}X=np(1-p). $$

The mean and variance need no computation with the formula above: linearity and independence applied to the $n$ Bernoulli terms give them directly. For large $n$ the binomial is close to a normal, a reasonable approximation once $np(1-p)$ is around 10 or more. A typical use is the number of correct predictions of a classifier on $n$ independent test examples.

## Geometric

If instead we count trials until the first success, we get $P(X=k)=(1-p)^{k-1}p$, with mean $1/p$ and variance $(1-p)/p^2$. This distribution is **memoryless**: having already failed many times does not make success any closer, because the trials do not remember.

## Poisson

The Poisson counts events in a fixed interval when they occur independently at a constant average rate $\lambda$:

$$ P(X=k)=\frac{e^{-\lambda}\lambda^k}{k!},\qquad \mathbb{E}X=\operatorname{Var}X=\lambda. $$

It arises as the limit of Binomial($n,p$) when $n$ is large, $p$ is small and $np=\lambda$ stays fixed, which is why it describes rare events so well. Independent Poisson variables add, with their rates. The equality of mean and variance is also a quick diagnostic: count data whose variance is well above the mean are **overdispersed**, and a plain Poisson model will understate the uncertainty.

# Continuous

## Uniform

The uniform has constant density $1/(b-a)$ on $[a,b]$, with mean $(a+b)/2$ and variance $(b-a)^2/12$. It matters mostly because everything else can be built from it. If $U$ is Uniform(0,1) and $F$ is a cdf, then $F^{-1}(U)$ has cdf $F$, which is **inverse transform sampling** and the basis of most random number generation. It also appears in testing: under the null hypothesis, a $p$-value is uniform on $(0,1)$.

## Exponential

The exponential is the waiting time between events of a Poisson process of rate $\lambda$: $f(x)=\lambda e^{-\lambda x}$ for $x\ge0$, so $P(X>x)=e^{-\lambda x}$, with mean $1/\lambda$ and variance $1/\lambda^2$. It is the continuous counterpart of the geometric and, like it, memoryless, $P(X>s+t\mid X>s)=P(X>t)$. These two are the only memoryless distributions, so if the failure rate of something depends on its age, the exponential is the wrong model.

## Normal

The normal $\mathcal{N}(\mu,\sigma^2)$ has density $\frac{1}{\sqrt{2\pi\sigma^2}}e^{-(x-\mu)^2/(2\sigma^2)}$ and three properties that explain how dominant it is. Standardizing, $Z=(X-\mu)/\sigma$, reduces every normal probability to the standard normal, and about 68%, 95% and 99.7% of the mass lies within one, two and three standard deviations, with $z_{0.975}\approx1.96$. The family is closed under linear combinations: a sum of independent normals, or a linear function of one, is again normal. And the central limit theorem makes it the limit of averages, which is why it models noise in regression and approximates the distribution of most estimators for large $n$.

## Gamma

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

# Recap

**Binomial or Poisson?** Binomial when there is a fixed number of trials and we count successes, Poisson when we count events in an interval with no fixed number of trials. The Poisson is the limit of the binomial for large $n$ and small $p$.

**Which distributions are memoryless?** Only the geometric among discrete ones and the exponential among continuous ones.
