---
collection: notes
title: "Regression Diagnostics and Leverage"
date: 2026-10-04
excerpt: "Residual plots, leverage, studentized residuals, Cook's distance and variance inflation: how to find the points and the predictors a fit leans on too heavily."
hook: "A point pulls on the fitted line with its leverage times how far off it is: an outlier in the middle barely matters, the same outlier at the edge can decide the fit."
goals:
  - read a residual plot for curvature, changing spread and outliers
  - compute leverage and Cook's distance and say what each measures
  - detect collinearity with the variance inflation factor and say what it does to the coefficients
  - get leave-one-out residuals without refitting
requires:
  - least-squares
  - hat-matrix
  - coefficient-inference
  - r-squared
defines:
  - {id: residuals, name: residuals, anchor: residuals}
  - {id: leverage, name: leverage, anchor: leverage-and-influence}
  - {id: studentized-residual, name: studentized residual, anchor: residuals}
  - {id: influence, name: influential observation, anchor: leverage-and-influence}
  - {id: cooks-distance, name: "Cook's distance", anchor: leverage-and-influence}
  - {id: multicollinearity, name: multicollinearity, anchor: collinearity}
read_time: true
tags:
  - Statistics
  - Regression
---

The inference in the previous note holds only if the model is right and no handful of points is deciding the answer. Both can be checked from the fit itself. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Residuals

The model assumes a linear mean, errors of constant variance and uncorrelated errors, and normal errors if the exact $t$ and $F$ results are to be used. The **residuals** $e=(I-H)y$ are the only trace of the errors we can see, so we look at them, most usefully against the fitted values.

| Pattern | What it says | Usual remedy |
|---|---|---|
| a curve | the mean is not linear in the predictors | add terms, transform, use splines |
| a funnel, spread growing with the fit | the variance is not constant | transform $y$, weight the cases |
| a few points far from the rest | outliers | look at their leverage, then at a robust fit |
| runs of one sign, in time order | correlated errors | model the dependence |
{: .keyed}

Raw residuals are not on an equal footing, even when the errors are: $\operatorname{Var}(e_i)=\sigma^2(1-h_{ii})$, where $h_{ii}$ is a number between 0 and 1 defined in the next section. Dividing by the right standard deviation gives the **studentized residual** $r_i=e_i\big/\big(s\sqrt{1-h_{ii}}\big)$. Under normality the version that estimates $\sigma$ without case $i$ has an exact $t_{n-p-1}$ distribution, and values beyond about 3 in absolute value deserve a look. A normal quantile plot of the studentized residuals checks the normality assumption, which matters mainly for small samples.

# Leverage and influence

The $i$-th fitted value is $\hat y_i=h_{ii}y_i+\sum_{j\ne i}h_{ij}y_j$, so the diagonal entry $h_{ii}$ of the hat matrix is the weight that case $i$ gives to its own response. This is the **leverage** of the case. It lies between $1/n$ and $1$, the leverages add up to $p$ so the average is $p/n$, and values above $2p/n$ are flagged. In simple regression it is a measure of distance from the centre,

$$ h_{ii}=\frac1n+\frac{(x_i-\bar x)^2}{S_{xx}}, $$

so a case with a predictor value far from the others has high leverage whatever its response is. The figure puts the same outlier, four units above the trend, in the middle and at the edge.

{% include fig.html src="statistics/leverage-influence" id="fig-leverage" alt="Two scatter plots of the same cloud with a dashed fit line without an outlier and a solid fit line with it. In the left plot the outlier sits at the middle of the x range and the line barely moves. In the right plot it sits at the edge and the line tilts towards it." caption="The same vertical outlier at the middle (leverage 0.07) and at the edge (leverage 0.45) of the predictor range. Dashed: fit without it. Solid: fit with it. The slope moves from 0.70 to 0.71 in the first case and to 0.89 in the second." %}

A case is **influential** when removing it changes the fit a lot. That needs both things at once, a misfit and the leverage to act on it, and **Cook's distance** is exactly their product,

$$ D_i=\frac{r_i^2}{p}\cdot\frac{h_{ii}}{1-h_{ii}}, $$

the first factor measuring how badly the case is fitted and the second how much it can pull. Values above $4/n$, or above 1, are the usual flags, as screening devices and not tests.

> Influence is misfit times leverage. A big residual at low leverage and a high leverage with a small residual are both harmless on their own; the combination is what moves the line.
{: .idea}

> **A high-leverage point can hide itself.** It drags the line towards it, which shrinks its own residual, so a residual plot can look clean while one case decides the slope. Check leverage as well as residuals.
{: .trap}

None of this requires refitting $n$ times. Deleting case $i$ changes the coefficients by $\hat\beta-\hat\beta_{(i)}=(X^\top X)^{-1}x_ie_i/(1-h_{ii})$, and the prediction error for case $i$ from the model fitted without it is $e_i/(1-h_{ii})$. These leave-one-out residuals are a free estimate of out-of-sample error from a single fit, and the same shortcut returns later for smoothers.

# Collinearity

When predictors are nearly linear combinations of each other the plane they span is poorly determined, even though the fit may be excellent. The fitted values hardly change but the individual coefficients can swing wildly from sample to sample, which shows in their variance. If $R_j^2$ is the $R^2$ from regressing predictor $j$ on all the others, then

$$ \operatorname{Var}(\hat\beta_j)=\frac{\sigma^2}{S_{jj}}\cdot\underbrace{\frac1{1-R_j^2}}_{\text{VIF}_j}, $$

where $S_{jj}$ is the spread of predictor $j$. The **variance inflation factor** says how many times larger the variance is than it would be with uncorrelated predictors, and **multicollinearity** is the situation where some VIFs are large.

| $R_j^2$ | VIF | Standard error inflated by |
|---:|---:|---:|
| 0.50 | 2 | 1.4 |
| 0.80 | 5 | 2.2 |
| 0.90 | 10 | 3.2 |
| 0.99 | 100 | 10 |

> A VIF above 5 to 10 is worth a look. The coefficients of the collinear predictors are unreliable one by one, but their joint effect, and predictions at new points that follow the same pattern, are fine. The remedies are to drop or combine predictors, or to shrink the coefficients, which is the next note.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why can an outlier in the middle of the predictor range matter less than the same outlier at the edge?</summary>

The leverage of a case grows with its distance from the centre of the predictors. At the edge the line is pinned by few other points and bends towards the outlier, in the middle it is held in place by the rest.
</details>

<details class="qa" markdown="1">
<summary>Why look at leverage and not only at the residuals?</summary>

A high-leverage case pulls the fit towards itself, so its residual can be small. Residuals alone miss exactly the cases that decide the fit.
</details>

<details class="qa" markdown="1">
<summary>A VIF of 10 means what for a coefficient?</summary>

Its variance is ten times what it would be with uncorrelated predictors, so its standard error is about 3.2 times larger. The fit as a whole can still be good.
</details>
