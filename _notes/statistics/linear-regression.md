---
collection: notes
title: "Linear Regression"
date: 2026-10-04
excerpt: "Least squares as a projection, what its coefficients are and how far off they can be, and the F-test that asks whether any predictor matters at all."
hook: "Least squares drops $y$ perpendicularly onto the span of the predictors; the coefficients, their standard errors and the $F$-test all read off that one picture."
goals:
  - compute the least squares coefficients and read them as a projection
  - give the sampling distribution of a coefficient and build its interval and test
  - split the variation into explained and residual parts and run the $F$-test
  - say what Gauss–Markov guarantees and what it does not
requires:
  - conditional-expectation
  - variance-of-a-sum
  - standard-error
  - normal
  - chi-square
  - student-t
  - f-distribution
  - maximum-likelihood-estimator
defines:
  - {id: linear-model, name: linear model, anchor: least-squares}
  - {id: least-squares, name: least squares, anchor: least-squares}
  - {id: hat-matrix, name: hat matrix, anchor: least-squares}
  - {id: gauss-markov, name: Gauss–Markov theorem, anchor: what-the-estimates-are}
  - {id: coefficient-inference, name: inference on coefficients, anchor: what-the-estimates-are}
  - {id: r-squared, name: "R squared", anchor: is-the-model-worth-anything}
  - {id: anova-f-test, name: "ANOVA and the F-test", anchor: is-the-model-worth-anything}
read_time: true
tags:
  - Statistics
  - Regression
---

A regression predicts a number from other numbers, and the linear model is the baseline that every other method in this part is measured against. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Least squares

We observe a response $y_i$ and $p$ predictors for $n$ cases and assume the **linear model** $y=X\beta+\varepsilon$, where $X$ is the fixed $n\times p$ matrix of predictors (with a column of ones for the intercept), $\mathbb{E}\varepsilon=0$ and $\operatorname{Var}\varepsilon=\sigma^2I$. In words, the conditional expectation of $Y$ given the predictors is a linear function of them, and the noise around it has constant size. **Least squares** chooses the $\beta$ that makes the residual sum of squares $\lVert y-X\beta\rVert^2$ as small as possible, and setting the gradient to zero gives the normal equations.

> **Estimate** $\hat\beta=(X^\top X)^{-1}X^\top y$  
> **Fitted** $\hat y=Hy$, with $H=X(X^\top X)^{-1}X^\top$  
> **Residual** $e=y-\hat y=(I-H)y$  
> **Noise** $s^2=\lVert e\rVert^2/(n-p)$
{: .margin .spec}

The picture behind the algebra is the one in the figure. The columns of $X$ span a $p$-dimensional plane inside $\mathbb{R}^n$, and the fitted vector $\hat y$ is the point of that plane closest to $y$, which is its perpendicular projection. The matrix $H$ that does the projecting is called the **hat matrix**, since it puts the hat on $y$.

{% include fig.html src="statistics/ols-geometry" id="fig-ols" alt="A plane representing the span of the columns of X, a vector y rising above it, its projection onto the plane and a dashed perpendicular residual joining the two, with a right-angle mark at the foot." caption="Least squares as a projection. The residual $e$ is perpendicular to the plane, so $X^\\top e=0$; the coefficients are the coordinates of $\\hat y$ in the columns of $X$." %}

Everything that follows comes from this perpendicularity. It makes the residuals uncorrelated with every predictor and, with an intercept, sum to zero. Since $H$ projects onto a $p$-dimensional space, $\operatorname{tr}H=p$: the fit uses $p$ of the $n$ available degrees of freedom and leaves $n-p$ for the residuals, which is why the noise variance is estimated by dividing by $n-p$ and not by $n$.

# What the estimates are

Because $\hat\beta$ is a linear function of $y$, its moments follow from the rule for the variance of a linear map, and none of them needs a distribution for $\varepsilon$.

| Quantity | Mean | Variance |
|---|---|---|
| $\hat\beta$ | $\beta$ | $\sigma^2(X^\top X)^{-1}$ |
| $\hat y$ | $X\beta$ | $\sigma^2H$ |
| $e$ | $0$ | $\sigma^2(I-H)$ |
| $s^2$ | $\sigma^2$ | |
{: .keyed}

So the estimate is unbiased, and its variance is small when the predictors are widely spread and not nearly collinear. The **Gauss–Markov theorem** says that no other linear unbiased estimator has a smaller variance, for any linear combination of the coefficients.

> **"Best" is a narrow claim.** Gauss–Markov compares only estimators that are linear in $y$ and unbiased. It says nothing about biased estimators, and these can have a much smaller mean squared error: that is the whole point of the next notes on regularization.
{: .trap}

To get exact intervals and tests we add normal errors, $\varepsilon\sim\mathcal{N}(0,\sigma^2I)$. Then $\hat\beta\sim\mathcal{N}(\beta,\sigma^2(X^\top X)^{-1})$, $(n-p)s^2/\sigma^2\sim\chi^2_{n-p}$, and the two are independent, because $\hat\beta$ lives in the plane and $e$ is perpendicular to it. Under normality the least squares estimate is also the maximum likelihood estimate. Dividing a coefficient by its estimated standard error therefore gives a Student statistic,

$$ \frac{\hat\beta_j-\beta_j}{\hat{\operatorname{se}}(\hat\beta_j)}\sim t_{n-p},\qquad \hat{\operatorname{se}}(\hat\beta_j)=s\sqrt{[(X^\top X)^{-1}]_{jj}}, $$

which gives the interval $\hat\beta_j\pm t_{n-p,\,1-\alpha/2}\,\hat{\operatorname{se}}$ and the $t$-test of $\beta_j=0$.

The same variance formulas answer the question of how far off a prediction can be. At a new point $x_0$ the estimated mean response $x_0^\top\hat\beta$ has variance $\sigma^2x_0^\top(X^\top X)^{-1}x_0$, but a new observation also carries its own noise, so its prediction error has variance $\sigma^2\big(1+x_0^\top(X^\top X)^{-1}x_0\big)$.

> More data shrinks the uncertainty about the line but not the noise around it: a prediction interval never gets narrower than about $\pm1.96\,\sigma$, however large $n$ is.
{: .idea}

# Is the model worth anything

The perpendicularity gives one more identity. Centring at $\bar y$, the vector $y-\bar y\mathbf 1$ splits into the part the model explains, $\hat y-\bar y\mathbf 1$, and the residual $e$, and these two are perpendicular, so by Pythagoras the squared lengths add:

$$ \underbrace{\sum(y_i-\bar y)^2}_{\text{SST}}=\underbrace{\sum(\hat y_i-\bar y)^2}_{\text{SSR}}+\underbrace{\sum e_i^2}_{\text{SSE}}. $$

The share $R^2=\text{SSR}/\text{SST}$ is the proportion of variation explained, and it equals the squared correlation between $y$ and $\hat y$. To ask whether the explained part is more than chance, compare the two parts after dividing each by its degrees of freedom.

| Source | Sum of squares | df | Mean square |
|---|---|---:|---|
| Regression | SSR | $p-1$ | SSR$/(p-1)$ |
| Residual | SSE | $n-p$ | $s^2$ |
| Total | SST | $n-1$ | |
{: .keyed}

Under the hypothesis that no predictor matters, the ratio of the two mean squares has an $F_{p-1,\,n-p}$ distribution. The same construction tests any nested pair of models: if dropping $q$ predictors raises the residual sum of squares from SSE to $\text{SSE}_0$, then

$$ F=\frac{(\text{SSE}_0-\text{SSE})/q}{\text{SSE}/(n-p)}\sim F_{q,\,n-p}\quad\text{under the smaller model.} $$

For $q=1$ this is the square of the coefficient's $t$ statistic. The joint test is needed because testing each coefficient separately at 5% makes a false alarm somewhere much more likely than 5%.

> **$R^2$ cannot go down when a predictor is added**, even one made of pure noise, so it is a poor guide to the number of predictors. The adjusted $R^2$, which charges for the degrees of freedom used, or the $F$-test of the added terms, is what to look at.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why are the residuals orthogonal to every column of $X$, and what does that give you?</summary>

Because $\hat y$ is the orthogonal projection of $y$ onto the span of the columns. It gives the normal equations, residuals that sum to zero with an intercept, and the split of SST into SSR and SSE.
</details>

<details class="qa" markdown="1">
<summary>What does Gauss–Markov say, and what does it leave out?</summary>

Among linear unbiased estimators, least squares has the smallest variance, assuming only uncorrelated errors of equal variance. It leaves out biased estimators, which can have smaller mean squared error, and the exact $t$ and $F$ results, which need normal errors.
</details>

<details class="qa" markdown="1">
<summary>Why is a prediction interval wider than an interval for the mean response?</summary>

The prediction error also contains the noise of the new observation, variance $\sigma^2$, which does not shrink with $n$.
</details>
