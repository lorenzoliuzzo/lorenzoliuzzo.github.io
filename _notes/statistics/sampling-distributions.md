---
collection: notes
title: "Sampling Distributions and Common Random Variables"
date: 2026-10-03
excerpt: "The standard discrete and continuous random variables with their uses, and the distributions of the statistics built from samples: the mean, the proportion, the variance, and the t, chi-square and F laws."
read_time: true
tags:
  - Statistics
---

An estimate is only as trustworthy as we can say how much it would change on another sample. That is the job of a **sampling distribution**: the distribution of a statistic over repeated samples. To derive one we need a catalogue of standard random variables to build from, so this note has two halves. First the common discrete and continuous random variables, what each one models and when to reach for it. Then the distributions of the statistics computed from samples, which are built out of them.

The probability used here (expectation, variance, independence, the central limit theorem) is in [Probability foundations]({{ '/notes/statistics/probability-foundations/' | relative_url }}). A more formal version of this note, with derivations, is in the [technical reference (PDF)]({{ '/assets/notes/statistics/sampling-distributions/sampling-distributions.pdf' | relative_url }}). The next note, [Statistical inference]({{ '/notes/statistics/statistical-inference/' | relative_url }}), uses these distributions to build estimators, intervals and tests.

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

A flexible positive, right-skewed distribution; the sum of $k$ independent exponentials is Gamma. It matters here chiefly because the chi-square distribution below is a special case.

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

| Term | Meaning |
|---|---|
| **Sampling distribution** | The distribution of a statistic over repeated samples |
| **Standard error** | The standard deviation of a statistic, e.g. $\sigma/\sqrt n$ for $\bar X$ |
| **Memoryless** | The future wait does not depend on how long we have already waited (geometric, exponential) |
| **Degrees of freedom** | The parameter of the $\chi^2$, $t$ and $F$ families: the number of free squared terms |
| **Inverse transform** | Generating a variable with cdf $F$ as $F^{-1}(U)$ for uniform $U$ |
| **Overdispersion** | Variance larger than the model allows (count data with variance above the mean) |
| **Bootstrap** | Estimating a sampling distribution by resampling the observed data |
| **Heavy tails** | Extreme values far more likely than under the normal |

# Recap

**What is a sampling distribution, and why does it matter?** It is the distribution of a statistic over repeated samples. Its centre shows the bias, its spread (the standard error) the precision, and its shape which probability statements are valid.

**Which distribution models a count of successes in $n$ trials, and which a count of events in an interval?** Binomial($n,p$) for the first, Poisson($\lambda$) for the second. Poisson is the limit of the binomial for large $n$ and small $p$.

**What do the Poisson mean and variance have in common?** They are equal, both $\lambda$. Count data with a much larger variance than mean are overdispersed.

**What does memoryless mean?** The remaining wait is independent of the time already waited. Among the families here only the geometric (discrete) and the exponential (continuous) have it.

**How do I compute a normal probability?** Standardize, $Z=(X-\mu)/\sigma$, then use the standard normal table or the $68$–$95$–$99.7$ rule.

**What is the standard error of a sample mean and of a proportion?** $\sigma/\sqrt n$ and $\sqrt{p(1-p)/n}$. Both shrink like $1/\sqrt n$.

**Where do the chi-square, $t$ and $F$ distributions come from?** The chi-square is a sum of squared standard normals, $t$ is a standard normal over the root of an independent $\chi^2_k/k$, and $F$ is a ratio of two independent $\chi^2$ variables each divided by its degrees of freedom. For normal data $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ and $(\bar X-\mu)/(S/\sqrt n)\sim t_{n-1}$.

**Why is the sample maximum not normal?** Its distribution is tied to a boundary, here the upper end of the uniform range, so it is skewed and its mean is biased. The normal shape of averages comes from the central limit theorem, which does not cover every statistic.

# Where this goes next

[Statistical inference]({{ '/notes/statistics/statistical-inference/' | relative_url }}) uses these distributions to turn samples into estimators, confidence intervals and tests. Linear regression reuses the $t$ and $F$ laws for its coefficient tests and overall test, and the Bernoulli and binomial for logistic regression.
