---
collection: notes
title: "Random Variables, Expectation and Variance"
date: 2026-10-03
excerpt: "Distributions, expectation, variance, covariance and correlation, conditional expectation, and the law of large numbers and central limit theorem."
hook: "A random variable is a number the experiment has not produced yet; its distribution tells you what to expect, and its variance how far off to be."
goals:
  - read a distribution off a pmf, density or cdf and compute probabilities from it
  - compute expectations and variances, including of sums of dependent variables
  - tell uncorrelated from independent
  - say what the law of large numbers and the CLT promise, and what they do not
requires:
  - probability-axioms
  - conditional-probability
  - independence
defines:
  - {id: random-variable, name: random variable, anchor: distributions}
  - {id: cdf, name: cdf, anchor: distributions}
  - {id: pmf-and-density, name: pmf and density, anchor: distributions}
  - {id: expectation, name: expectation, anchor: expectation}
  - {id: variance, name: variance, anchor: variance-covariance-and-correlation}
  - {id: covariance-and-correlation, name: covariance and correlation, anchor: variance-covariance-and-correlation}
  - {id: variance-of-a-sum, name: variance of a sum, anchor: variance-covariance-and-correlation}
  - {id: conditional-expectation, name: conditional expectation, anchor: conditioning-a-random-variable}
  - {id: law-of-large-numbers, name: law of large numbers, anchor: limit-theorems}
  - {id: central-limit-theorem, name: central limit theorem, anchor: limit-theorems}
read_time: true
tags:
  - Statistics
  - Probability
---

From here on we work with numbers rather than events, so we need the standard summaries of a random variable: where it sits, how spread out it is, how it moves together with another variable. The note ends with the two theorems that explain why averaging data works at all. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Distributions

A random variable $X$ is a number attached to the outcome of an experiment, and its distribution tells us how probability is spread over the possible values. The most general description is the cumulative distribution function $F(x)=P(X\le x)$, which gives interval probabilities through $P(a<X\le b)=F(b)-F(a)$. For a discrete $X$ it is more convenient to list the mass function $p(x)=P(X=x)$. For a continuous $X$ we use the density $f=F'$, with $P(a\le X\le b)=\int_a^b f$.
> A density value is not a probability. Every single point has probability zero and $f(x)$ can exceed one; only areas under $f$ are probabilities.
{: .margin}

With two variables we also need the joint distribution of the pair, the marginal of each (obtained by summing or integrating out the other), and the conditional distribution of one given the value of the other, which is the joint divided by the marginal. $X$ and $Y$ are independent exactly when the joint factorizes into the product of the marginals. The $p$-quantile $q_p$ solves $F(q_p)=p$, and the median is $q_{0.5}$.

# Expectation

The expectation is the probability-weighted average of the values,

$$ \mathbb{E}[X]=\sum_x x\,p(x)\quad\text{or}\quad\int x\,f(x)\,dx, $$

and for a function of $X$ we do not need its distribution first, we just weight $g(x)$ in the same way: $\mathbb{E}[g(X)]=\sum_x g(x)p(x)$ or $\int g f$.

The property that does most of the work is linearity, $\mathbb{E}[aX+b]=a\,\mathbb{E}X+b$ and $\mathbb{E}[X+Y]=\mathbb{E}X+\mathbb{E}Y$, which holds always, with no independence needed. That is what makes so many calculations short. Products are different: $\mathbb{E}[XY]=\mathbb{E}X\,\mathbb{E}Y$ needs independence, and fails in general.

A useful trick is that probabilities are expectations of indicators, $\mathbb{E}[\mathbf 1_A]=P(A)$, so anything proved for expectations also holds for probabilities. Finally, Jensen's inequality says that for convex $g$ we have $g(\mathbb{E}X)\le\mathbb{E}[g(X)]$. The case to remember is $\mathbb{E}[X^2]\ge(\mathbb{E}X)^2$, and the general warning is that $\mathbb{E}[g(X)]$ is not $g(\mathbb{E}X)$: the mean of the squares is not the square of the mean.

# Variance, covariance and correlation

The variance measures spread around the mean, $\operatorname{Var}(X)=\mathbb{E}[(X-\mu)^2]=\mathbb{E}[X^2]-\mu^2$, and the standard deviation $\sigma$ is its square root, which has the same units as $X$. Shifting a variable does not change its spread, while scaling by $a$ multiplies the variance by $a^2$:

$$ \operatorname{Var}(aX+b)=a^2\operatorname{Var}(X). $$

Standardizing, $Z=(X-\mu)/\sigma$, therefore gives mean 0 and variance 1.

For two variables the covariance $\operatorname{Cov}(X,Y)=\mathbb{E}[XY]-\mathbb{E}X\,\mathbb{E}Y$ measures how they move together, and dividing by the two standard deviations gives the correlation, which is free of units and lies in $[-1,1]$:

$$ \rho_{XY}=\frac{\operatorname{Cov}(X,Y)}{\sigma_X\sigma_Y}. $$

It reaches $\pm1$ exactly when $Y$ is a linear function of $X$. Because covariance is bilinear, expanding $\operatorname{Var}(X+Y)$ produces a cross term:

$$ \operatorname{Var}(X+Y)=\operatorname{Var}X+\operatorname{Var}Y+2\operatorname{Cov}(X,Y). $$

So variances add only when the covariances vanish, for instance under independence.

> For independent $X_1,\dots,X_n$ with common variance $\sigma^2$ the sample mean has $\operatorname{Var}(\bar X)=\sigma^2/n$, so its standard deviation shrinks like $\sigma/\sqrt n$. Four times the data halves the uncertainty. This is probably the single most used formula in statistics.
{: .idea}

> **Uncorrelated is not independent.** Independence implies zero covariance, but the converse is false. Take $X\sim\mathcal{N}(0,1)$ and $Y=X^2$: then $\operatorname{Cov}(X,Y)=\mathbb{E}[X^3]=0$, even though $Y$ is completely determined by $X$. Correlation only detects linear dependence.
{: .trap}

## Conditioning a random variable

The conditional expectation $\mathbb{E}[X\mid Y]$ is the best guess of $X$ once $Y$ is known. It is itself a random variable, since it depends on $Y$, and it satisfies two identities that will come back in regression and mixture models:

$$ \mathbb{E}[X]=\mathbb{E}\big[\mathbb{E}[X\mid Y]\big],\qquad \operatorname{Var}(X)=\mathbb{E}\big[\operatorname{Var}(X\mid Y)\big]+\operatorname{Var}\big(\mathbb{E}[X\mid Y]\big). $$

The first says that averaging the group means gives the overall mean. The second is the law of total variance: the total spread is the average spread inside the groups plus the spread between the group means.

## Shape

Two further summaries describe the shape of a distribution. Skewness, the standardized third central moment, measures asymmetry, and kurtosis, the standardized fourth, measures tail weight, with the normal sitting at 3. For skewed or heavy-tailed data the mean, median and mode separate, and the mean is the one that outliers drag around most.

# Limit theorems

The law of large numbers says that the sample mean $\bar X_n=\tfrac1n\sum X_i$ converges to $\mu$ as $n$ grows. This is the reason averaging works. The central limit theorem adds the shape of the fluctuations: for i.i.d. $X_i$ with mean $\mu$ and finite variance $\sigma^2$,

$$ \sqrt{n}\,\frac{\bar X_n-\mu}{\sigma}\ \xrightarrow{d}\ \mathcal{N}(0,1). $$

This is why the normal distribution turns up everywhere in inference, even when the data themselves are far from normal. The figure shows it happening for a clearly skewed variable.

{% include fig.html src="statistics/clt" id="fig-clt" alt="Densities of the standardized mean of n exponential variables for n equal to 2, 5 and 30, drawn against the standard normal density. The curves approach the normal as n grows." caption="Standardized mean of $n$ exponential variables. At $n=2$ the skew is still obvious, at $n=5$ the curve is already close to the normal one, and by $n=30$ the two are hard to tell apart." %}

> How large $n$ has to be depends on how skewed or heavy-tailed the data are, so "$n\ge30$" is a rule of thumb and not a theorem. For a heavy-tailed variable it can take far more.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Does zero correlation mean independence?</summary>

No. Uncorrelated only rules out linear dependence; $X$ and $X^2$ for a symmetric $X$ are uncorrelated yet completely dependent.
</details>

<details class="qa" markdown="1">
<summary>When is the variance of a sum equal to the sum of the variances?</summary>

When the covariances vanish, in particular for independent variables. Otherwise there is the extra $2\operatorname{Cov}$ term, and with independence this is exactly what gives $\operatorname{Var}(\bar X)=\sigma^2/n$.
</details>

<details class="qa" markdown="1">
<summary>What do the law of large numbers and the central limit theorem each add?</summary>

The law of large numbers says the sample mean settles at $\mu$. The CLT says how it fluctuates around $\mu$: about $\sigma/\sqrt n$ in size, with a normal shape.
</details>
