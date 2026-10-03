---
collection: notes
title: "Probability Foundations"
date: 2026-10-03
excerpt: "Axioms, conditional probability and Bayes, random variables, expectation, variance and covariance, and the limit theorems: the vocabulary every other statistics note uses."
read_time: true
tags:
  - Statistics
---

Statistics is probability run backwards: probability starts from a known mechanism and asks what data it produces, statistics starts from data and asks what mechanism produced it. This note builds the probability side from the axioms up, and gives the vocabulary used everywhere else in the notes.

A more formal version, with the proofs of every result quoted here, is in the [technical reference (PDF)]({{ '/assets/notes/statistics/probability-foundations/probability-foundations.pdf' | relative_url }}). This page explains; the PDF is the thing to check a formula against. The next note, [Statistical inference]({{ '/notes/statistics/statistical-inference/' | relative_url }}), builds on it.

# Sample space and events

A random experiment has a **sample space** $\Omega$, the set of all possible outcomes. An **event** is a subset $A\subseteq\Omega$ ("the outcome lies in $A$"). Events combine like sets:

- $A\cup B$: $A$ or $B$ (or both) occurs; $A\cap B$: both occur; $A^c$: $A$ does not occur.
- $A$ and $B$ are **mutually exclusive** (disjoint) if $A\cap B=\varnothing$.
- Events $B_1,B_2,\dots$ form a **partition** of $\Omega$ if they are disjoint and $\cup_i B_i=\Omega$: exactly one of them happens.

Rolling a die: $\Omega=\{1,\dots,6\}$, "even" is $A=\{2,4,6\}$, and $\{1,2,3\},\{4,5,6\}$ is a partition.

# The axioms

A **probability** $P$ assigns a number to every event so that (Kolmogorov, 1933):

1. $P(A)\ge 0$ for every event $A$;
2. $P(\Omega)=1$;
3. for pairwise disjoint events $A_1,A_2,\dots$: $\;P\big(\bigcup_i A_i\big)=\sum_i P(A_i)$ (countable additivity).

That is the whole theory. Everything else is derived.

## Consequences

Each of these follows from the three axioms in a line or two (the proofs are in the technical reference).

| Rule | Why |
|---|---|
| $P(\varnothing)=0$ | Axiom 3 applied to infinitely many empty sets |
| $P(A^c)=1-P(A)$ | $A$ and $A^c$ are disjoint and their union is $\Omega$ |
| If $A\subseteq B$ then $P(A)\le P(B)$ | $B=A\cup(B\setminus A)$, a disjoint union |
| $0\le P(A)\le 1$ | monotonicity with $B=\Omega$ |
| $P(A\cup B)=P(A)+P(B)-P(A\cap B)$ | adding $P(A)+P(B)$ counts $A\cap B$ twice |
| $P(\cup_i A_i)\le\sum_i P(A_i)$ | the **union bound**: overlaps are counted several times |

The union rule generalizes to **inclusion–exclusion**: add the single probabilities, subtract the pairwise intersections, add the triple intersections, and so on. When the outcomes are equally likely, probability reduces to counting, $P(A)=|A|/|\Omega|$, which is where permutations and the binomial coefficient $\binom nk$ enter.

A word on meaning. The axioms do not say what probability *is*. In the **frequentist** reading, $P(A)$ is the long-run relative frequency of $A$ in repeated trials. In the **Bayesian** reading it is a degree of belief, updated as data arrive. The mathematics is the same; the two schools differ in what they allow $\theta$ (an unknown parameter) to be: a fixed number, or a random quantity with its own distribution.

# Conditional probability and independence

The probability of $A$ once we know $B$ happened (with $P(B)>0$) is

$$ P(A\mid B)=\frac{P(A\cap B)}{P(B)} . $$

Conditioning shrinks the sample space to $B$ and renormalizes. Rearranged, it is the **multiplication rule** $P(A\cap B)=P(A\mid B)\,P(B)$, and chaining it gives $P(A_1\cap\dots\cap A_n)=P(A_1)\,P(A_2\mid A_1)\cdots P(A_n\mid A_1\cap\dots\cap A_{n-1})$.

$A$ and $B$ are **independent** if knowing one tells nothing about the other:

$$ P(A\cap B)=P(A)\,P(B)\quad\Longleftrightarrow\quad P(A\mid B)=P(A). $$

Two traps. **Independent is not the same as mutually exclusive**: if $A$ and $B$ are disjoint and both possible, knowing $A$ happened tells you $B$ did not, so they are strongly dependent. And **pairwise independence is weaker than mutual independence**: for several events we need the product rule for every sub-collection, not just every pair.

## Law of total probability and Bayes' theorem

If $B_1,\dots,B_k$ partition $\Omega$ and each has positive probability, then splitting an event over the partition gives the **law of total probability**,

$$ P(A)=\sum_{i=1}^k P(A\mid B_i)\,P(B_i). $$

Writing $P(A\cap B_j)$ in the two possible ways, $P(A\mid B_j)P(B_j)=P(B_j\mid A)P(A)$, and substituting the law above for $P(A)$ gives **Bayes' theorem**:

$$ P(B_j\mid A)=\frac{P(A\mid B_j)\,P(B_j)}{\sum_{i}P(A\mid B_i)\,P(B_i)} . $$

Read it as an update rule. $P(B_j)$ is the **prior** (belief before seeing $A$), $P(A\mid B_j)$ the **likelihood** (how well $B_j$ explains $A$), the denominator $P(A)$ the **evidence**, and $P(B_j\mid A)$ the **posterior**. Bayes' theorem turns "probability of the data given the hypothesis" into "probability of the hypothesis given the data", which is what we actually want, and it is not the same thing.

**Worked example.** A disease affects 1% of a population. A test is positive for 95% of the sick (sensitivity) and also for 10% of the healthy (false-positive rate). Given a positive result, what is the chance of being sick? With $D$ for disease and $+$ for a positive test,

$$ P(D\mid +)=\frac{0.95\cdot 0.01}{0.95\cdot 0.01+0.10\cdot 0.99}=\frac{0.0095}{0.1085}\approx 0.088 . $$

Only about 9%, despite a "95% accurate" test: healthy people are so numerous that their false positives outnumber the true ones. Forgetting the prior (the **base rate**) is the classic error in reading tests.

# Random variables and their distributions

A **random variable** $X$ is a numerical outcome of the experiment: a function from $\Omega$ to the real numbers. Its **distribution** says how probability is spread over its values. Three equivalent descriptions:

- the **cumulative distribution function** $F(x)=P(X\le x)$. It is non-decreasing, right-continuous, tends to 0 at $-\infty$ and to 1 at $+\infty$, and gives $P(a<X\le b)=F(b)-F(a)$;
- if $X$ is **discrete**, the **probability mass function** $p(x)=P(X=x)$, with $\sum_x p(x)=1$;
- if $X$ is **continuous**, the **density** $f(x)=F'(x)$, with $\int f=1$ and $P(a\le X\le b)=\int_a^b f(x)\,dx$. Single points have probability zero, so a density value is not a probability.

The **support** is where $X$ can land with positive probability or density. The **quantile** of order $p$ is the value $q_p$ with $F(q_p)=p$; the **median** is $q_{0.5}$. For two variables, the **joint** distribution describes $(X,Y)$ together, the **marginal** of $X$ is what remains after summing or integrating out $Y$, and the **conditional** distribution of $X$ given $Y=y$ is the joint divided by the marginal of $Y$. $X$ and $Y$ are independent exactly when the joint factorizes into the product of the marginals.

# Expectation

The **expectation** (mean) is the probability-weighted average of the values,

$$ \mathbb{E}[X]=\sum_x x\,p(x)\qquad\text{or}\qquad \mathbb{E}[X]=\int x f(x)\,dx . $$

For a function of $X$ there is no need to find its distribution first: $\mathbb{E}[g(X)]=\sum_x g(x)p(x)$ or $\int g(x)f(x)\,dx$.

**Properties** (these are used constantly, so learn them cold):

- **Linearity**: $\mathbb{E}[aX+b]=a\,\mathbb{E}[X]+b$ and $\mathbb{E}[X+Y]=\mathbb{E}[X]+\mathbb{E}[Y]$ *always*, with no independence needed.
- **Products**: $\mathbb{E}[XY]=\mathbb{E}[X]\,\mathbb{E}[Y]$ **if $X$ and $Y$ are independent**; in general it is false.
- **Monotone**: $X\le Y$ implies $\mathbb{E}[X]\le\mathbb{E}[Y]$.
- **Indicators**: $\mathbb{E}[\mathbf 1_A]=P(A)$, so probabilities are expectations.
- **Jensen**: for convex $g$, $g(\mathbb{E}X)\le\mathbb{E}[g(X)]$. In particular $\mathbb{E}[X^2]\ge(\mathbb{E}X)^2$, which is why variance is never negative.

Note that $\mathbb{E}[g(X)]\neq g(\mathbb{E}[X])$ in general: the mean of a square is not the square of the mean.

# Variance, covariance and correlation

The **variance** measures spread around the mean, $\operatorname{Var}(X)=\mathbb{E}[(X-\mu)^2]$ with $\mu=\mathbb{E}X$, and the **standard deviation** $\sigma=\sqrt{\operatorname{Var}X}$ has the units of $X$. Properties:

- **Shortcut**: $\operatorname{Var}(X)=\mathbb{E}[X^2]-(\mathbb{E}X)^2$.
- **Scaling**: $\operatorname{Var}(aX+b)=a^2\operatorname{Var}(X)$. Shifting changes nothing; scaling by $a$ scales the variance by $a^2$.
- $\operatorname{Var}(X)\ge 0$, with equality only if $X$ is constant.
- **Standardization**: $Z=(X-\mu)/\sigma$ has mean 0 and variance 1.

For two variables, the **covariance** $\operatorname{Cov}(X,Y)=\mathbb{E}[XY]-\mathbb{E}X\,\mathbb{E}Y$ measures how they move together, and the scale-free **correlation** is

$$ \rho_{XY}=\frac{\operatorname{Cov}(X,Y)}{\sigma_X\,\sigma_Y}\in[-1,1], $$

with $|\rho|=1$ exactly when $Y$ is a linear function of $X$. Covariance is bilinear and $\operatorname{Cov}(X,X)=\operatorname{Var}(X)$. This gives the rule for sums,

$$ \operatorname{Var}(X+Y)=\operatorname{Var}X+\operatorname{Var}Y+2\operatorname{Cov}(X,Y), $$

so the variance of a sum is the sum of the variances **only when the covariances vanish**. For independent $X_1,\dots,X_n$ with variance $\sigma^2$ this yields the most useful formula in statistics, $\operatorname{Var}(\bar X)=\sigma^2/n$.

Independence implies zero covariance, but **zero covariance does not imply independence**. If $X\sim\mathcal{N}(0,1)$ and $Y=X^2$, then $\operatorname{Cov}(X,Y)=\mathbb{E}[X^3]=0$, yet $Y$ is completely determined by $X$. Correlation only detects *linear* dependence.

## Conditioning a random variable

The **conditional expectation** $\mathbb{E}[X\mid Y]$ is the best guess of $X$ once $Y$ is known; it is itself a random variable, a function of $Y$. Two identities will return in the regression and mixture notes:

$$ \mathbb{E}[X]=\mathbb{E}\big[\mathbb{E}[X\mid Y]\big],\qquad \operatorname{Var}(X)=\mathbb{E}\big[\operatorname{Var}(X\mid Y)\big]+\operatorname{Var}\big(\mathbb{E}[X\mid Y]\big). $$

The second is the **law of total variance**: total spread equals the average spread *within* groups plus the spread *between* the group means.

# Shape summaries

The $k$-th **moment** is $\mathbb{E}[X^k]$ and the $k$-th **central moment** is $\mathbb{E}[(X-\mu)^k]$. The standardized third and fourth central moments are the **skewness** (asymmetry) and **kurtosis** (tail weight; the normal has 3). The **mode** is the most likely value. For skewed data the mean, median and mode differ, and the mean is the one most affected by outliers.

The standard discrete and continuous distributions (Bernoulli, binomial, Poisson, uniform, exponential, normal and more), with their means, variances and uses, are in [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}).

# Limit theorems

**Law of large numbers.** The sample mean $\bar X_n=\tfrac1n\sum X_i$ converges to $\mu=\mathbb{E}X$ as $n\to\infty$. This is why averaging works.

**Central limit theorem.** If the $X_i$ are i.i.d. with mean $\mu$ and finite variance $\sigma^2$, then

$$ \sqrt{n}\,\frac{\bar X_n-\mu}{\sigma}\ \xrightarrow{d}\ \mathcal{N}(0,1). $$

The CLT is the reason the normal distribution appears everywhere in inference, even when the data are not normal: sums and averages become approximately normal. How large $n$ must be depends on how skewed or heavy-tailed the data are, so "$n\ge 30$" is a rule of thumb, not a theorem.

# Vocabulary

The probability terms used here and in the notes that follow.

| Term | Meaning |
|---|---|
| **Sample space / event** | All possible outcomes / a set of outcomes |
| **Mutually exclusive** | Events that cannot occur together, $A\cap B=\varnothing$ |
| **Partition** | Disjoint events that together cover the sample space |
| **Conditional probability** | $P(A\mid B)=P(A\cap B)/P(B)$ |
| **Independent** | $P(A\cap B)=P(A)P(B)$: knowing one tells nothing about the other |
| **Prior / likelihood / posterior / evidence** | The four pieces of Bayes' theorem: belief before, how well the hypothesis explains the data, belief after, total probability of the data |
| **Random variable** | A numerical outcome of the experiment |
| **pmf / pdf / cdf** | Mass function (discrete), density (continuous), cumulative distribution function $P(X\le x)$ |
| **Support** | Values where the mass or density is positive |
| **Marginal / joint / conditional** | Distribution of one variable alone / of several together / given the value of another |
| **Expectation** | The probability-weighted average $\mathbb{E}[X]$ |
| **Variance / standard deviation** | $\mathbb{E}[(X-\mu)^2]$ / its square root |
| **Covariance / correlation** | Linear co-movement of two variables / its scale-free version in $[-1,1]$ |
| **Moment** | $\mathbb{E}[X^k]$; central moments are taken around the mean |
| **Quantile / median** | Value below which a given fraction (one half for the median) of the probability lies |
| **Skewness / kurtosis** | Standardized third and fourth central moments: asymmetry and tail weight |
| **i.i.d.** | Independent and identically distributed |

# Recap

The note in a handful of questions.

**What do the law of large numbers and the central limit theorem say?** The sample mean converges to $\mu$, and its standardized version $\sqrt n(\bar X-\mu)/\sigma$ is approximately $\mathcal{N}(0,1)$ for large $n$, whatever the data distribution (with finite variance).

**What is the difference between a pmf, a pdf and a cdf?** A pmf gives probabilities of single values (discrete), a pdf gives a density whose integral over an interval is a probability (continuous; single points have probability zero), and the cdf $F(x)=P(X\le x)$ describes both and is always non-decreasing from 0 to 1.

# Where this goes next

The next note, [Statistical inference]({{ '/notes/statistics/statistical-inference/' | relative_url }}), uses everything here to turn data into estimates, intervals and tests. Linear regression and the other notes reuse the expectation, variance and covariance rules throughout.
