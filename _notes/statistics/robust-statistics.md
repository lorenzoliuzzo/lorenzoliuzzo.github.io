---
collection: notes
title: "Robust Statistics"
date: 2026-10-04
excerpt: "Breakdown point, the influence function, M-estimators with Huber and biweight, and robust regression: estimates that a few wild observations cannot rewrite."
hook: "Least squares lets every observation vote with a weight that grows with its distance from the fit, so a single wild point can write the answer; a robust estimator caps the vote."
goals:
  - say what the breakdown point and the influence function measure, for the mean and the median
  - write an M-estimator and read its $\psi$ function
  - fit a Huber regression by reweighting and know where it still fails
  - decide between a robust fit and removing outliers
requires:
  - expectation
  - maximum-likelihood-estimator
  - least-squares
  - leverage
  - influence
defines:
  - {id: breakdown-point, name: breakdown point, anchor: outliers-and-breakdown}
  - {id: influence-function, name: influence function, anchor: outliers-and-breakdown}
  - {id: m-estimator, name: M-estimator, anchor: m-estimators}
  - {id: robust-regression, name: robust regression, anchor: robust-regression}
read_time: true
tags:
  - Statistics
  - Regression
---

The mean and least squares are optimal for clean, normal data, and they are the first to fail when the data are not. This note is about estimates that degrade gracefully. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# Outliers and breakdown

Take the mean and the median of a sample and move one observation to infinity. The mean follows it, and the median does not move at all. Two numbers capture this. The **breakdown point** is the smallest fraction of observations that can be replaced by arbitrary values before the estimate becomes arbitrary: $1/n$ for the mean, close to $1/2$ for the median, which is the highest any estimator can have. The **influence function** is the local version, the effect on the estimate of a small contamination placed at the point $x$, divided by the amount of contamination. For the mean it is $x-\mu$, which grows without limit, and for the median it is $\operatorname{sign}(x-m)/(2f(m))$, which is bounded.

This is the population counterpart of the influence of a single case in the previous note. There the influence was misfit times leverage, here it is a function of how far a value lies from the centre, and what a robust method does is bound it.

| Estimator | Breakdown point | Influence | Efficiency at the normal |
|---|---:|---|---:|
| Mean | $0$ | unbounded | 100% |
| Median | $1/2$ | bounded | 64% |
| Huber, $k=1.345$ | $1/2$ | bounded | 95% |
{: .keyed}

> Robustness is insurance. The median gives up a third of the efficiency of the mean when the data are exactly normal, and in exchange it survives contamination that would ruin the mean. The estimators below are designed to give up very little in the first case and keep most of the protection in the second.
{: .idea}

# M-estimators

An **M-estimator** generalizes maximum likelihood: it minimizes $\sum_i\rho(x_i-\theta)$, or equivalently solves $\sum_i\psi(x_i-\theta)=0$ with $\psi=\rho'$. Normal likelihood gives $\rho(u)=u^2/2$ and the mean, and a Laplace likelihood gives $\rho(u)=\lvert u\rvert$ and the median. The function $\psi$ is the pull a residual exerts on the estimate, and the influence function of the estimator is proportional to it: $\operatorname{IF}(x)=\psi(x-\theta)/\mathbb{E}\psi'$. So a robust estimator is one with a bounded $\psi$.

Two choices of $\psi$ do most of the work. **Huber's** is the identity for residuals below a threshold $k$ and constant beyond it, which means quadratic loss near the fit and linear loss in the tails; $k=1.345$ times the scale keeps 95% efficiency at the normal. **Tukey's biweight** is redescending: the pull grows, peaks and then returns to zero, so gross outliers are ignored altogether, at the price of a loss that is not convex and can have several solutions.

{% include fig.html src="statistics/psi-functions" id="fig-psi" alt="Two panels. Left: loss functions for squared error, Huber and the biweight against the residual; squared error grows without limit, Huber grows linearly and the biweight levels off. Right: the derivative psi; squared error is a straight line, Huber is capped at a constant, and the biweight rises and falls back to zero." caption="Loss $\\rho$ (left) and its derivative $\\psi$ (right), the pull of a residual on the fit. Squared error pulls in proportion to the residual, Huber caps the pull, the biweight lets it return to zero." %}

Since $\psi$ caps the residual at a multiple of the scale, the scale has to be estimated too, and not with the standard deviation, which an outlier inflates. The usual choice is the median absolute deviation divided by $0.6745$. The estimator is computed by iteratively reweighted least squares: give each case the weight $w_i=\psi(r_i/s)/(r_i/s)$, which is 1 for small residuals and falls like $k/\lvert r_i/s\rvert$ for large ones, solve the weighted problem, and repeat.

> **The scale must be robust too.** If the cap is set by a scale that the outliers have inflated, nothing is ever capped, and the robust fit quietly turns back into least squares.
{: .trap}

# Robust regression

For regression the same idea minimizes $\sum_i\rho(r_i/s)$ over the coefficients, and reweighted least squares fits it. The figure shows what that buys against four outliers in the response.

{% include fig.html src="statistics/robust-fit" id="fig-robust" alt="A scatter plot with a cloud of points along a line and four points far above it. The least squares line is tilted towards the four outliers while the Huber line stays with the main cloud and lies close to the true line." caption="Four outliers in $y$. The least squares slope is 0.94, pulled towards them; the Huber fit stays with the bulk of the data at 0.83, close to the true value 0.80." %}

The protection has a limit that the diagnostics note already pointed to. The influence in regression is proportional to $\psi(r/\sigma)\,x$: bounded in the residual but not in the predictors. A single case with extreme leverage can therefore still drag a Huber fit, with breakdown point $1/n$. Two families close that gap. Bounded-influence estimators downweight a case also by its leverage. High-breakdown estimators, the least trimmed squares, which minimizes the sum of the smallest half of the squared residuals, and the MM-estimators, which start from such a fit and finish with an efficient M-step, tolerate nearly half the data being outliers.

> **Do not delete outliers, down-weight them.** Removing points because they disagree with the model fits the model to the data you like. A robust fit keeps every case, tells you through its weights which ones it did not trust, and leaves the decision about them to you.
{: .trap}

> Fit both the least squares and a robust model. If they agree, the outliers do not matter. If they differ, look at the cases that received low weight, at their leverage and at how they were measured, before deciding anything.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why does the median have a breakdown point of one half and the mean of zero?</summary>

Moving one observation to infinity moves the mean without limit, while half of the observations have to be corrupted before the middle of the sample can be moved arbitrarily.
</details>

<details class="qa" markdown="1">
<summary>What does the $\psi$ function of an M-estimator tell you?</summary>

How hard a residual pulls on the estimate; the influence function is proportional to it. Bounded $\psi$ means bounded influence, and a redescending $\psi$ lets gross outliers be ignored entirely.
</details>

<details class="qa" markdown="1">
<summary>Can a Huber regression still be ruined by one bad point?</summary>

Yes, if the point has extreme leverage: the pull is bounded in the residual but not in the predictors. Bounded-influence or high-breakdown estimators are needed for that case.
</details>
