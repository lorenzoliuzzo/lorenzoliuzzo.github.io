---
collection: notes
title: "Point Estimation and Maximum Likelihood"
date: 2026-10-03
excerpt: "Population, sample and model; bias, variance and mean squared error; the Cramér–Rao bound; and maximum likelihood, the default way to build an estimator."
read_time: true
tags:
  - Statistics
  - Inference
---

Almost every method in applied statistics and machine learning answers the same question: *we saw a finite sample, what can we say about the mechanism that produced it?* This note starts the answer with a single number: how to guess a parameter from data, how to judge the guess, and the standard recipe, maximum likelihood. It is the foundation for linear regression, regularization, PCA and mixture models, which all reuse the **likelihood** and the **sampling distribution** of an estimator from [Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}).

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# Before you start

[Sampling distributions]({{ '/notes/statistics/sampling-distributions/' | relative_url }}) and the probability notes before it, plus derivatives and logarithms.

| You should know | In one line | Where |
|---|---|---|
| **Sampling distribution, standard error** | the distribution of a statistic over repeated samples, and its spread | [Sampling distributions › What a sampling distribution is]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#what-a-sampling-distribution-is) |
| **Distribution of the mean and variance** | $\mathbb{E}\bar X=\mu$, $\operatorname{Var}\bar X=\sigma^2/n$; $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ | [Sampling distributions › The sample mean]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#the-sample-mean), [Sampling distributions › The sample variance]({{ '/notes/statistics/sampling-distributions/' | relative_url }}#the-sample-variance-and-the-chi-square-distribution) |
| **Expectation and variance** | bias and MSE are expectations of the error | [Random variables › Expectation]({{ '/notes/statistics/random-variables/' | relative_url }}#expectation) |
| **Law of large numbers** | the idea behind consistency | [Random variables › Limit theorems]({{ '/notes/statistics/random-variables/' | relative_url }}#limit-theorems) |
| **Bernoulli and normal families** | the running examples for the likelihood | [Common random variables › Bernoulli]({{ '/notes/statistics/common-random-variables/' | relative_url }}#bernoulli), [Common random variables › Normal]({{ '/notes/statistics/common-random-variables/' | relative_url }}#normal) |
| **Maximizing a function** | setting a derivative to zero | Assumed |

# The setting: population, sample, model

A **population** is the thing we care about; a **sample** is the data $x_1,\dots,x_n$ we actually have. Inference needs a bridge between the two, and that bridge is a **statistical model**: we assume the data are realizations of random variables $X_1,\dots,X_n$ whose joint law belongs to a family indexed by an unknown parameter $\theta$,

$$ X_1,\dots,X_n \ \text{i.i.d.} \sim f(x;\theta), \qquad \theta \in \Theta . $$

"i.i.d." (independent, identically distributed) is the simplest assumption that makes a sample informative: each new observation tells us something about the same $\theta$, and nothing is lost by treating observations separately. Most of the machinery below breaks, or needs repair, when this fails (time series, clustered data).

The central object is a **statistic**: any function $T(X_1,\dots,X_n)$ of the sample. Because the sample is random, $T$ is itself a random variable, and its distribution, the **sampling distribution**, is what tells us how much to trust it.

# Estimators and how to judge them

An **estimator** $\hat\theta=T(X_1,\dots,X_n)$ is a rule for guessing $\theta$ from data; an **estimate** is its value on one sample. Good estimators are judged by the distribution of their error:

- **Bias**: $\operatorname{bias}(\hat\theta)=\mathbb{E}[\hat\theta]-\theta$. Unbiased means right on average.
- **Variance**: how much $\hat\theta$ fluctuates from sample to sample.
- **Mean squared error**, which combines the two,

$$ \operatorname{MSE}(\hat\theta)=\mathbb{E}[(\hat\theta-\theta)^2]=\operatorname{Var}(\hat\theta)+\operatorname{bias}(\hat\theta)^2 . $$

- **Consistency**: $\hat\theta_n\to\theta$ in probability as $n\to\infty$.

The decomposition of the MSE is the first appearance of the **bias–variance trade-off**. An unbiased estimator is not automatically the best one: a slightly biased estimator with much lower variance can have smaller MSE. Ridge and Lasso regression, in a later note, are built on exactly this observation.

How good can an unbiased estimator be? The **Cramér–Rao bound** says there is a floor,

$$ \operatorname{Var}(\hat\theta)\ \ge\ \frac{1}{n\,I(\theta)}, \qquad I(\theta)=\mathbb{E}\!\left[\Big(\frac{\partial}{\partial\theta}\log f(X;\theta)\Big)^{2}\right], $$

where $I(\theta)$ is the **Fisher information** of one observation: how sharply the log-density bends as $\theta$ moves, i.e. how much a single observation reveals about $\theta$. An unbiased estimator that reaches the bound is called efficient.

# Maximum likelihood

The most important recipe for building estimators. Given the data, regard the joint density as a function of $\theta$: the **likelihood** $L(\theta)=\prod_i f(x_i;\theta)$. The **maximum likelihood estimator** is the parameter value under which the observed data were most probable,

$$ \hat\theta_{\mathrm{MLE}}=\arg\max_\theta L(\theta)=\arg\max_\theta \ell(\theta), \qquad \ell(\theta)=\sum_i\log f(x_i;\theta). $$

We maximize the log-likelihood $\ell$ because sums are easier than products and the maximizer is the same. In regular cases we solve the **score equation** $\ell'(\theta)=0$.

**Two worked examples.**

- *Bernoulli.* $\ell(p)=\sum x_i\log p+(n-\sum x_i)\log(1-p)$. Setting the derivative to zero gives $\hat p=\bar x$, the sample proportion.
- *Normal.* Maximizing over $(\mu,\sigma^2)$ gives $\hat\mu=\bar x$ and $\hat\sigma^2=\frac1n\sum(x_i-\bar x)^2$. Note the divisor $n$: the MLE of the variance is **biased** ($\mathbb{E}\hat\sigma^2=\frac{n-1}{n}\sigma^2$), and $S^2$ corrects it. MLE gives good estimators, not always unbiased ones.

**Why MLE is the default.** Under regularity conditions the MLE is consistent, **asymptotically normal and asymptotically efficient**:

$$ \sqrt{n}\,(\hat\theta_{\mathrm{MLE}}-\theta_0)\ \xrightarrow{d}\ \mathcal{N}\!\big(0,\ I(\theta_0)^{-1}\big), $$

so for large $n$ it reaches the Cramér–Rao bound. It is also **invariant**: the MLE of $g(\theta)$ is $g(\hat\theta)$. The asymptotic variance yields a ready-made standard error, $\widehat{\mathrm{se}}=1/\sqrt{n\,I(\hat\theta)}$, which is the basis of the intervals and tests below. Later notes use the same principle: least squares is the MLE under Gaussian noise, and logistic regression is fitted by maximum likelihood.

The **method of moments** is the simpler alternative: equate sample moments to population moments and solve. It is easy and consistent but generally less efficient.

# Vocabulary

The terms this note introduces. Earlier ones are in the notes linked under Before you start.

| Term | Meaning |
|---|---|
| **Population / sample** | The whole collection of interest / the part of it actually observed |
| **Parameter** | A fixed, unknown number describing the population ($\mu$, $\sigma^2$, $p$) |
| **Statistic** | Any function of the sample; it is random |
| **Estimator / estimate** | A statistic used to guess a parameter / its value on one data set |
| **Bias** | $\mathbb{E}[\hat\theta]-\theta$: the average miss |
| **MSE** | $\mathbb{E}[(\hat\theta-\theta)^2]=\operatorname{Var}+\operatorname{bias}^2$ |
| **Consistent** | Converges to the true parameter as $n\to\infty$ |
| **Efficient** | Unbiased with the smallest possible variance (reaches Cramér–Rao) |
| **Sufficient statistic** | Keeps all the information the sample holds about $\theta$ |
| **Likelihood** | The joint density of the data read as a function of $\theta$ |
| **Score / Fisher information** | Derivative of the log-likelihood / its variance, the information carried per observation |

# Recap

The note in a handful of questions.

**What is the difference between a parameter, a statistic and an estimator?** A parameter $\theta$ is a fixed, unknown feature of the population. A statistic is any function of the sample, hence random. An estimator is a statistic used to guess a parameter; an estimate is its value on the data in hand.

**Why divide by $n-1$ in $S^2$?** Deviations are taken from $\bar X$, which was fitted to the same data, so one degree of freedom is used up. With $n-1$ the estimator is exactly unbiased, $\mathbb{E}[S^2]=\sigma^2$, and $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ for normal data.

**What makes an estimator good?** Small mean squared error, $\operatorname{MSE}=\operatorname{Var}+\operatorname{bias}^2$, and consistency. Unbiased is not automatically best: a little bias can buy a lot of variance reduction, which is the idea behind shrinkage.

**What is the best an unbiased estimator can do?** Its variance cannot go below $1/(nI(\theta))$, the Cramér–Rao bound, where $I(\theta)$ is the Fisher information.

**What does maximum likelihood do, and why is it the default?** It picks the $\theta$ under which the observed data were most probable. For large $n$ it is consistent, asymptotically normal with variance $1/(nI(\theta))$ (so it reaches the Cramér–Rao bound), and invariant under reparametrization. It is not always unbiased: the MLE of the normal variance divides by $n$.

# Where this goes next

A point estimate says nothing about its own precision. [Confidence intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) attach a range to it, and [Hypothesis tests]({{ '/notes/statistics/hypothesis-tests/' | relative_url }}) ask whether a claimed value is compatible with the data.

- **Regularization**: trading a little bias for a lot of variance, via the MSE decomposition.
- **Linear regression**: least squares is the Gaussian MLE.
- **Mixture models**: the likelihood is no longer solvable in closed form, which motivates the EM algorithm.
