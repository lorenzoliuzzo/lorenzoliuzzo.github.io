---
collection: notes
title: "Regularization: Ridge and Lasso"
date: 2026-10-04
excerpt: "Why accepting a little bias can cut the prediction error, and how ridge shrinks every coefficient while the lasso also sets some of them exactly to zero."
hook: "Least squares is unbiased and often too variable: ridge trades a little bias for a lot less variance, and the lasso makes that trade in a way that also deletes predictors."
goals:
  - split prediction error into noise, squared bias and variance and explain the trade-off
  - write the ridge and lasso estimates and their closed forms for orthonormal predictors
  - explain geometrically why the lasso gives exact zeros and ridge does not
  - read the effective degrees of freedom of a penalized fit
requires:
  - least-squares
  - hat-matrix
  - gauss-markov
  - bias-and-mse
  - multicollinearity
defines:
  - {id: bias-variance-tradeoff, name: bias–variance trade-off, anchor: bias-and-variance}
  - {id: ridge-regression, name: ridge regression, anchor: ridge-shrinks-everything}
  - {id: effective-degrees-of-freedom, name: effective degrees of freedom, anchor: ridge-shrinks-everything}
  - {id: lasso, name: lasso, anchor: lasso-shrinks-and-selects}
  - {id: soft-thresholding, name: soft-thresholding, anchor: lasso-shrinks-and-selects}
  - {id: elastic-net, name: elastic net, anchor: lasso-shrinks-and-selects}
read_time: true
tags:
  - Statistics
  - Regression
---

Least squares is the best unbiased linear estimator, and with many predictors, or collinear ones, that guarantee is not worth much. This note is about giving up unbiasedness on purpose. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Bias and variance

Take a new observation $y_0=f(x_0)+\varepsilon_0$ and a fit $\hat f$ made from the training data. The expected squared prediction error splits into three terms,

$$ \mathbb{E}\big[(y_0-\hat f(x_0))^2\big]=\sigma^2+\big(\mathbb{E}\hat f(x_0)-f(x_0)\big)^2+\operatorname{Var}\hat f(x_0). $$

The first is the noise that no method can remove. The other two are the squared bias and the variance of the fit, and the **bias–variance trade-off** is that a method flexible enough to have little bias usually has a lot of variance, and the other way round. Least squares sits at the zero-bias end, and Gauss–Markov says nothing against moving away from it. The earlier example of a biased variance estimator with smaller mean squared error, in [Point estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}#judging-an-estimator), was the one-dimensional version of this.

> Only the last two terms can be traded against each other. Shrinking the coefficients adds a little bias and removes a lot of variance, and it pays whenever the variance of least squares is the larger problem, which it is with many predictors, few cases or collinear columns.
{: .idea}

The tool is a penalty on the size of the coefficients, added to the residual sum of squares. Predictors should be centred and standardized first, since the penalty is not invariant to scale, and the intercept is left out of it.

# Ridge shrinks everything

**Ridge regression** minimizes $\lVert y-X\beta\rVert^2+\lambda\lVert\beta\rVert^2$, which has the closed form

$$ \hat\beta_\lambda=(X^\top X+\lambda I)^{-1}X^\top y. $$

> **Shrink factor** $d_j^2/(d_j^2+\lambda)$  
> **Fit** $\hat y=X(X^\top X+\lambda I)^{-1}X^\top y$  
> **Degrees of freedom** $\sum_j d_j^2/(d_j^2+\lambda)$  
> **Orthonormal case** $\hat\beta_j/(1+\lambda)$
{: .margin .spec}

The matrix $X^\top X+\lambda I$ is invertible even when $X^\top X$ is not, which is what makes ridge a cure for collinearity. The way it works is clearest in the singular value decomposition $X=UDV^\top$: along the $j$-th principal direction the least squares coefficient is multiplied by

$$ \frac{d_j^2}{d_j^2+\lambda}\in(0,1), $$

and the directions with a small singular value $d_j$ are exactly the poorly determined ones, so they are shrunk hardest. Variance falls and bias appears. The derivative of the mean squared error at $\lambda=0$ is negative in every direction, so for any true $\beta$ some $\lambda>0$ beats least squares.

The fit is still linear in $y$, with matrix $H_\lambda=X(X^\top X+\lambda I)^{-1}X^\top$, which is no longer a projection. Its trace $\sum_jd_j^2/(d_j^2+\lambda)$ takes the place of $p$ and is called the **effective degrees of freedom**: it runs from $p$ at $\lambda=0$ down to $0$, and it is the number to quote when comparing penalized fits. Ridge also has a Bayesian reading: it is the posterior mean when the coefficients get independent normal priors, with $\lambda=\sigma^2/\tau^2$ the ratio of noise variance to prior variance.

# Lasso shrinks and selects

The **lasso** replaces the squared penalty by the absolute one, minimizing $\tfrac12\lVert y-X\beta\rVert^2+\lambda\lVert\beta\rVert_1$. It has no closed form in general, but it is convex and is solved efficiently one coordinate at a time. Its optimality conditions say that a predictor with a nonzero coefficient has inner product exactly $\pm\lambda$ with the residual, and a predictor with a zero coefficient at most $\lambda$ in absolute value; so $\hat\beta=0$ exactly when $\lambda\ge\lVert X^\top y\rVert_\infty$. For orthonormal predictors, with $b_j$ the least squares coefficients, the solution is **soft-thresholding**, and the three penalties can be compared directly.

| Rule | Penalty | Estimate |
|---|---|---|
| Least squares | none | $b_j$ |
| Ridge | $\lambda\lVert\beta\rVert^2$ | $b_j/(1+\lambda)$ |
| Lasso | $\lambda\lVert\beta\rVert_1$ | $\operatorname{sign}(b_j)\,(\lvert b_j\rvert-\lambda)_+$ |
| Best subset | $\lambda\lVert\beta\rVert_0$ | $b_j\,\mathbf 1\{\lvert b_j\rvert>\sqrt{2\lambda}\}$ |
{: .keyed}

{% include fig.html src="statistics/shrinkage-functions" id="fig-shrinkage" alt="Four lines showing the penalized estimate against the least squares coefficient: the identity as a dashed line, ridge as a line with slope one half, the lasso as a line flat at zero on an interval and then parallel to the identity, and best subset as zero on an interval and then the identity." caption="Orthonormal predictors, penalty $\\lambda=1$. Ridge multiplies every coefficient by $1/2$; the lasso subtracts 1 from each and sets the small ones to zero; best subset keeps or drops with no shrinkage." %}

The flat piece of the lasso curve is the selection: any coefficient with least squares value below $\lambda$ is set exactly to zero. For general predictors the reason is geometric. Both methods minimize the residual sum of squares, whose contours are ellipses around the least squares estimate, inside a constraint region, and the solution is where the first contour touches it.

{% include fig.html src="statistics/penalty-geometry" id="fig-geometry" alt="Two panels each showing elliptical contours around the least squares point and a shaded constraint region. On the left the region is a disc and the contour touches it at a point with both coordinates nonzero. On the right the region is a diamond and the contour touches it at a corner on the horizontal axis." caption="The disc of ridge has no corners, so the contact point has both coefficients nonzero. The diamond of the lasso has corners on the axes, and an ellipse reaches a corner easily: there one coefficient is exactly zero." %}

> **Selected does not mean significant.** The set of predictors the lasso keeps was chosen with the same data, so the usual standard errors, intervals and $p$-values computed afterwards on those predictors are too optimistic.
{: .trap}

With correlated predictors the lasso tends to keep one of them and drop the others, and with $p>n$ it keeps at most $n$. The **elastic net** adds the ridge penalty to the lasso penalty, keeping the sparsity while sharing weight among correlated predictors.

> The penalty weight $\lambda$ is chosen by cross-validation, that is, by held-out error. Taking the $\lambda$ with the smallest error is the default; the largest $\lambda$ within one standard error of it gives a simpler model of almost the same accuracy.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why can a biased estimator predict better than the unbiased one?</summary>

The prediction error is noise plus squared bias plus variance. If shrinking removes more variance than the bias it adds, the total falls.
</details>

<details class="qa" markdown="1">
<summary>Why does ridge help when predictors are collinear?</summary>

Collinear predictors give small singular values, whose directions least squares estimates with huge variance. Ridge shrinks exactly those directions the most, and it keeps $X^\top X+\lambda I$ invertible.
</details>

<details class="qa" markdown="1">
<summary>Why does the lasso produce exact zeros and ridge not?</summary>

The lasso constraint region has corners on the axes, where the error contours often touch it first; the ridge disc is smooth. Equivalently, soft-thresholding sets small coefficients to zero while ridge only rescales them.
</details>
