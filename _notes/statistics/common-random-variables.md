---
collection: notes
title: "Common Random Variables"
date: 2026-10-03
excerpt: "The standard discrete and continuous distributions, what each one models, their means and variances, and how to choose between them."
read_time: true
tags:
  - Statistics
  - Probability
---

Real data are modelled with a small set of standard random variables, and knowing which one fits a situation is half of applied statistics. This note is the catalogue: the discrete and continuous families, what each one models, its mean and variance, and a table for choosing. It uses the expectation and variance from [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}). Several of these distributions return in [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}): the chi-square is a special case of the gamma, and the normal is the base for $t$ and $F$.

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# Discrete random variables

A discrete random variable takes countable values and is described by its probability mass function $p(x)=P(X=x)$.

## Bernoulli

One trial with two outcomes, coded 1 (success, probability $p$) and 0 (failure):

$$ P(X=1)=p,\quad P(X=0)=1-p,\qquad \mathbb{E}[X]=p,\quad \operatorname{Var}(X)=p(1-p). $$

**Where it is used.** Any yes/no outcome: a click, a defect, a correct or incorrect prediction. An indicator $\mathbf 1_A$ is a Bernoulli with $p=P(A)$, which is how probabilities become expectations. The variance $p(1-p)$ is largest at $p=1/2$: a fair coin is the most uncertain yes/no event.

## Binomial

The number of successes in $n$ independent Bernoulli($p$) trials, $X=X_1+\dots+X_n$:

$$ P(X=k)=\binom nk p^k(1-p)^{n-k},\quad k=0,\dots,n,\qquad \mathbb{E}[X]=np,\quad \operatorname{Var}(X)=np(1-p). $$

The mean and variance follow from linearity and independence applied to the $n$ Bernoulli terms. **Example:** with $n=10$ and $p=0.3$, $P(X=3)=\binom{10}{3}0.3^3\,0.7^7\approx 0.267$.

**Where it is used.** Counting successes out of a fixed number of trials: defective items in a batch, voters in favour in a poll, and, importantly, the number of correct predictions of a classifier on $n$ independent test examples. For large $n$ it is approximately normal, a good approximation once $np(1-p)$ is at least about 10.

## Geometric

The number of trials until the first success: $P(X=k)=(1-p)^{k-1}p$ for $k=1,2,\dots$, with mean $1/p$ and variance $(1-p)/p^2$. It is **memoryless**: having already failed $m$ times says nothing about how many more trials are needed. Use it for waiting times counted in discrete steps, such as the number of attempts until a first success.

## Poisson

The count of events in a fixed interval when events occur independently at a constant average rate $\lambda$:

$$ P(X=k)=\frac{e^{-\lambda}\lambda^k}{k!},\quad k=0,1,2,\dots,\qquad \mathbb{E}[X]=\operatorname{Var}(X)=\lambda. $$

**Example:** with $\lambda=2$ events per hour, $P(X=0)=e^{-2}\approx 0.135$, so the chance of at least one event is about $0.865$.

**Where it is used.** Rare events over time or space: arrivals at a server, typos per page, particle decays in a detector. Two facts make it practical: it is the limit of Binomial($n,p$) when $n$ is large, $p$ is small and $np=\lambda$ stays fixed, and a sum of independent Poisson variables is again Poisson, with the rates added. Mean equal to variance is a quick check: count data whose variance is much larger than the mean are overdispersed and not truly Poisson.

# Continuous random variables

A continuous random variable is described by a density $f$ with $P(a\le X\le b)=\int_a^b f$. Single values have probability zero.

## Uniform

Equal density on an interval, $f(x)=1/(b-a)$ on $[a,b]$, with mean $(a+b)/2$ and variance $(b-a)^2/12$.

**Where it is used.** As the building block of simulation, because any other distribution can be generated from it: if $U$ is Uniform(0,1) and $F$ is a distribution function, then $F^{-1}(U)$ has distribution function $F$ (**inverse transform sampling**). It also appears in testing, since a $p$-value computed under the null hypothesis is uniform on $(0,1)$.

## Exponential

The waiting time between events of a Poisson process of rate $\lambda$: $f(x)=\lambda e^{-\lambda x}$ for $x\ge 0$, with $P(X>x)=e^{-\lambda x}$, mean $1/\lambda$ and variance $1/\lambda^2$. It is the continuous counterpart of the geometric and is also **memoryless**: $P(X>s+t\mid X>s)=P(X>t)$. Use it for lifetimes and waiting times when the failure rate does not change with age. A sum of $k$ independent exponentials has a Gamma distribution.

## Normal

The bell curve, $X\sim\mathcal{N}(\mu,\sigma^2)$ with density $\frac{1}{\sqrt{2\pi\sigma^2}}e^{-(x-\mu)^2/(2\sigma^2)}$. Three properties explain its dominance:

- **Standardization**: $Z=(X-\mu)/\sigma\sim\mathcal{N}(0,1)$, so every normal probability reduces to the one standard table. About 68%, 95% and 99.7% of the mass lies within one, two and three standard deviations, and $z_{0.975}\approx 1.96$.
- **Closure under linear combinations**: a sum of independent normals, or any linear function of a normal, is normal.
- **The central limit theorem**: averages and sums of almost anything become approximately normal.

**Example:** if scores are $\mathcal{N}(100,15^2)$, then $P(X>130)=P(Z>2)\approx 0.023$.

**Where it is used.** Measurement error, the noise term in regression, and as the large-sample approximation for most estimators.

## Gamma

A flexible positive, right-skewed distribution; the sum of $k$ independent exponentials is Gamma. It matters here chiefly because the chi-square distribution, used in [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}), is a special case.

## Choosing a model

| The quantity is... | Natural model |
|---|---|
| one yes/no outcome | Bernoulli |
| number of successes in $n$ fixed trials | Binomial |
| number of trials until the first success | Geometric |
| count of events in an interval | Poisson |
| waiting time, lifetime | Exponential (or Gamma) |
| a continuous value with symmetric noise, or an average | Normal |
| a value with no preferred location in a range | Uniform |

# Vocabulary

The terms used in this note.

| Term | Meaning |
|---|---|
| **Memoryless** | The future wait does not depend on how long we have already waited (geometric, exponential) |
| **Inverse transform** | Generating a variable with cdf $F$ as $F^{-1}(U)$ for uniform $U$ |
| **Overdispersion** | Variance larger than the model allows (count data with variance above the mean) |
| **Heavy tails** | Extreme values far more likely than under the normal |

# Recap

The note in a handful of questions.

**Which distribution models a count of successes in $n$ trials, and which a count of events in an interval?** Binomial($n,p$) for the first, Poisson($\lambda$) for the second. Poisson is the limit of the binomial for large $n$ and small $p$.

**What do the Poisson mean and variance have in common?** They are equal, both $\lambda$. Count data with a much larger variance than mean are overdispersed.

**What does memoryless mean?** The remaining wait is independent of the time already waited. Among the families here only the geometric (discrete) and the exponential (continuous) have it.

**How do I compute a normal probability?** Standardize, $Z=(X-\mu)/\sigma$, then use the standard normal table or the $68$–$95$–$99.7$ rule.

# Where this goes next

[Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}) uses the normal, gamma and chi-square built here to find the distribution of statistics such as the sample mean and variance.
