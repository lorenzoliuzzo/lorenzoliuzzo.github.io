---
collection: notes
title: "Point Estimation and Maximum Likelihood"
date: 2026-10-03
excerpt: "Estimators, bias, variance and MSE, the Cramér–Rao bound, and maximum likelihood."
hook: "A good estimator is not one that is right on average but one with small total error; maximum likelihood is the default recipe, and for large samples it is about as good as any estimator can be."
goals:
  - judge an estimator by its bias, variance and MSE, and say why unbiased is not enough
  - state the Cramér–Rao bound and what Fisher information measures
  - derive a maximum likelihood estimator and read a standard error off it
requires:
  - sampling-distribution
  - standard-error
  - expectation
  - variance
  - law-of-large-numbers
defines:
  - {id: estimator, name: estimator, anchor: setting}
  - {id: bias-and-mse, name: bias and MSE, anchor: judging-an-estimator}
  - {id: cramer-rao-bound, name: Cramér–Rao bound, anchor: judging-an-estimator}
  - {id: fisher-information, name: Fisher information, anchor: judging-an-estimator}
  - {id: likelihood, name: likelihood, anchor: maximum-likelihood}
  - {id: maximum-likelihood-estimator, name: maximum likelihood estimator, anchor: maximum-likelihood}
read_time: true
tags:
  - Statistics
  - Inference
---

We have a finite sample and want to say something about the mechanism that generated it. The simplest version is to guess one number, a parameter, and then to ask how good the guess is. This note covers how to judge an estimator and the standard recipe for building one, maximum likelihood, which regression, regularization, PCA and mixture models all reuse. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Setting

We model the data as realizations of

$$ X_1,\dots,X_n\ \text{i.i.d.}\sim f(x;\theta),\qquad \theta\in\Theta, $$

where the parameter $\theta$ is a fixed, unknown number. A **statistic** is any function $T(X_1,\dots,X_n)$ of the sample. It is random, and its sampling distribution tells us how far to trust it. An **estimator** $\hat\theta=T(X)$ is a rule for guessing $\theta$, and an **estimate** is the value that rule takes on the data we actually have. The i.i.d. assumption is what makes everything below work, and it is exactly what breaks for time series and clustered data.

# Judging an estimator

An estimator is judged by the distribution of its error. The **bias** $\mathbb{E}\hat\theta-\theta$ says whether it is right on average, the **variance** says how much it moves from sample to sample, and **consistency** says that $\hat\theta_n\to\theta$ in probability as $n$ grows. The mean squared error combines the first two:

$$ \operatorname{MSE}(\hat\theta)=\mathbb{E}[(\hat\theta-\theta)^2]=\operatorname{Var}(\hat\theta)+\operatorname{bias}(\hat\theta)^2. $$

This decomposition is the first appearance of the bias–variance trade-off.

> Unbiased does not mean best. An estimator with a little bias and much smaller variance can have lower MSE, which is the whole idea behind ridge and lasso.
{: .idea}

Is there a limit to how good an unbiased estimator can be? Yes, the Cramér–Rao bound:

$$ \operatorname{Var}(\hat\theta)\ \ge\ \frac{1}{nI(\theta)},\qquad I(\theta)=\mathbb{E}\Big[\Big(\tfrac{\partial}{\partial\theta}\log f(X;\theta)\Big)^2\Big]. $$

The **Fisher information** $I(\theta)$ measures how sharply the log-density changes as $\theta$ moves, in other words how much a single observation tells us about $\theta$. An unbiased estimator that reaches the bound is called efficient.

A familiar example of bias is the sample variance. We divide by $n-1$ and not $n$ because the deviations are taken from $\bar X$, which was fitted to the same data and so uses up one degree of freedom. With $n-1$ we get $\mathbb{E}S^2=\sigma^2$ exactly, and $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$ for normal data.

# Maximum likelihood

The likelihood is the joint density of the data read as a function of $\theta$, and the maximum likelihood estimator is the value of $\theta$ under which the observed data were most probable. In practice we maximize the log-likelihood, since sums are easier than products and the maximizer is the same:

$$ \hat\theta_{\mathrm{MLE}}=\arg\max_\theta\ell(\theta),\qquad \ell(\theta)=\sum_i\log f(x_i;\theta), $$

usually by solving the score equation $\ell'(\theta)=0$.

{% include fig.html src="statistics/likelihood" id="fig-likelihood" alt="Relative likelihood of a success probability p for 7 successes in 10 trials and for 70 in 100. Both curves peak at 0.7, and the curve for 100 trials is much narrower." caption="Likelihood of $p$ for the same observed proportion, $0.7$, at two sample sizes, each scaled to peak at 1. The maximizer is the same; the curvature at the peak, which is the Fisher information, grows with $n$, and so the estimate gets more precise." %}

For Bernoulli data this gives $\hat p=\bar x$, the sample proportion. For normal data it gives $\hat\mu=\bar x$ and $\hat\sigma^2=\frac1n\sum(x_i-\bar x)^2$, with the divisor $n$, so the MLE of the variance is biased, $\mathbb{E}\hat\sigma^2=\frac{n-1}{n}\sigma^2$.

> Maximum likelihood produces good estimators, but not always unbiased ones.
{: .trap}

Its appeal is what happens for large $n$. Under regularity conditions the MLE is consistent, asymptotically normal and asymptotically efficient,

$$ \sqrt{n}\,(\hat\theta_{\mathrm{MLE}}-\theta_0)\ \xrightarrow{d}\ \mathcal{N}\big(0,I(\theta_0)^{-1}\big), $$

so it reaches the Cramér–Rao bound. It is also invariant: the MLE of $g(\theta)$ is $g(\hat\theta)$. The asymptotic variance gives a ready-made standard error, $\widehat{\mathrm{se}}=1/\sqrt{nI(\hat\theta)}$, which is the basis of the intervals and tests in the next notes. The same principle returns later: least squares is the MLE under Gaussian noise, and logistic regression is fitted by maximum likelihood. The alternative, the method of moments, matches sample moments to population moments. It is easier and consistent, but generally less efficient.

# Recap

<details class="qa" markdown="1">
<summary>What makes an estimator good?</summary>

Small mean squared error and consistency. MSE is variance plus squared bias, so an unbiased estimator is not automatically the best one.
</details>

<details class="qa" markdown="1">
<summary>Why is the MLE the default choice?</summary>

For large $n$ it is consistent, asymptotically normal, reaches the Cramér–Rao bound and is invariant under reparametrization. It can still be biased in finite samples, as the normal variance shows.
</details>

<details class="qa" markdown="1">
<summary>Why divide by $n-1$ in the sample variance?</summary>

The deviations are measured from $\bar X$, which was fitted to the same data and so uses up one degree of freedom. Dividing by $n$ would underestimate $\sigma^2$ by the factor $(n-1)/n$.
</details>

# Where this goes next

Regularization trades bias for variance, linear regression is a Gaussian MLE, and mixture models have a likelihood with no closed-form maximizer, which is what motivates the EM algorithm.
