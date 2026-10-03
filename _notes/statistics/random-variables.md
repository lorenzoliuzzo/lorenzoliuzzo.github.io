---
collection: notes
title: "Random Variables, Expectation and Variance"
date: 2026-10-03
excerpt: "Distributions, expectation, variance, covariance and correlation, conditional expectation, and the law of large numbers and central limit theorem."
read_time: true
tags:
  - Statistics
  - Probability
---

The summaries of a random variable that every later note uses: mean, spread, how two variables move together, and the two limit theorems behind averaging. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Before you start

| You should know | Where |
|---|---|
| Conditional probability and independence | [Probability foundations]({{ '/notes/statistics/probability-foundations/' | relative_url }}#conditional-probability-and-independence) |

# Distributions

A random variable $X$ is a function from outcomes to numbers; its distribution is described by

- the **cdf** $F(x)=P(X\le x)$, with $P(a<X\le b)=F(b)-F(a)$;
- for discrete $X$, the **pmf** $p(x)=P(X=x)$;
- for continuous $X$, the **density** $f=F'$, with $P(a\le X\le b)=\int_a^b f$. Points have probability zero, so a density value is **not** a probability.

For a pair $(X,Y)$: the **joint** law, the **marginal** (sum or integrate out the other variable) and the **conditional** (joint over marginal). $X,Y$ are independent exactly when the joint factorizes into the marginals. The $p$-quantile $q_p$ solves $F(q_p)=p$; the median is $q_{0.5}$.

# Expectation

$$ \mathbb{E}[X]=\sum_x x\,p(x)\quad\text{or}\quad\int x f(x)\,dx,\qquad \mathbb{E}[g(X)]=\sum_x g(x)p(x)\ \text{ or }\int g f. $$

- **Linearity**, always, with no independence needed: $\mathbb{E}[aX+b]=a\mathbb{E}X+b$, $\mathbb{E}[X+Y]=\mathbb{E}X+\mathbb{E}Y$.
- **Products**: $\mathbb{E}[XY]=\mathbb{E}X\,\mathbb{E}Y$ only if $X,Y$ are independent.
- **Indicators**: $\mathbb{E}[\mathbf 1_A]=P(A)$, so probabilities are expectations.
- **Jensen**: for convex $g$, $g(\mathbb{E}X)\le\mathbb{E}[g(X)]$; in particular $\mathbb{E}[X^2]\ge(\mathbb{E}X)^2$. Beware $\mathbb{E}[g(X)]\ne g(\mathbb{E}X)$ in general.

# Variance, covariance and correlation

$\operatorname{Var}(X)=\mathbb{E}[(X-\mu)^2]=\mathbb{E}[X^2]-\mu^2$, $\sigma=\sqrt{\operatorname{Var}X}$. Shifts do not matter and scaling squares: $\operatorname{Var}(aX+b)=a^2\operatorname{Var}X$. The standardized $Z=(X-\mu)/\sigma$ has mean 0 and variance 1.

$$ \operatorname{Cov}(X,Y)=\mathbb{E}[XY]-\mathbb{E}X\,\mathbb{E}Y,\qquad \rho_{XY}=\frac{\operatorname{Cov}(X,Y)}{\sigma_X\sigma_Y}\in[-1,1], $$

with $\lvert\rho\rvert=1$ exactly when $Y$ is linear in $X$. Covariance is bilinear and $\operatorname{Cov}(X,X)=\operatorname{Var}X$, hence

$$ \operatorname{Var}(X+Y)=\operatorname{Var}X+\operatorname{Var}Y+2\operatorname{Cov}(X,Y). $$

Variances add **only when covariances vanish**. For independent $X_i$ with variance $\sigma^2$ this gives the most used formula in statistics, $\operatorname{Var}(\bar X)=\sigma^2/n$.

**Zero correlation does not imply independence.** For $X\sim\mathcal{N}(0,1)$ and $Y=X^2$, $\operatorname{Cov}(X,Y)=\mathbb{E}[X^3]=0$ yet $Y$ is a function of $X$. Correlation detects only *linear* dependence.

## Conditioning a random variable

$\mathbb{E}[X\mid Y]$ is the best guess of $X$ given $Y$, itself a random variable (a function of $Y$):

$$ \mathbb{E}[X]=\mathbb{E}\big[\mathbb{E}[X\mid Y]\big],\qquad \operatorname{Var}(X)=\mathbb{E}\big[\operatorname{Var}(X\mid Y)\big]+\operatorname{Var}\big(\mathbb{E}[X\mid Y]\big). $$

The second is the **law of total variance**: total spread = average spread within groups + spread of the group means. Both return in regression and mixtures.

## Shape

Skewness and kurtosis are the standardized third and fourth central moments: asymmetry and tail weight (the normal has kurtosis 3). For skewed or heavy-tailed data the mean, median and mode differ and the mean is the one outliers move most.

# Limit theorems

**LLN.** $\bar X_n=\tfrac1n\sum X_i\to\mu$ as $n\to\infty$.

**CLT.** For i.i.d. $X_i$ with mean $\mu$ and finite variance $\sigma^2$,

$$ \sqrt{n}\,\frac{\bar X_n-\mu}{\sigma}\ \xrightarrow{d}\ \mathcal{N}(0,1). $$

This is why the normal appears everywhere in inference even for non-normal data. How large $n$ must be depends on skewness and tail weight, so "$n\ge30$" is a rule of thumb, not a theorem.

# Recap

**Does zero correlation mean independence?** No: uncorrelated only rules out *linear* dependence ($X$ and $X^2$ for symmetric $X$).

**When is the variance of a sum the sum of the variances?** When the covariances vanish, in particular under independence; otherwise add $2\operatorname{Cov}$. This is what gives $\operatorname{Var}(\bar X)=\sigma^2/n$.
