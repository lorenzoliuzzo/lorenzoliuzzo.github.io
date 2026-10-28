---
collection: notes
title: "Monte Carlo Integration"
date: 2026-10-27
excerpt: "Estimating integrals by sampling, variance reduction and error scaling."
hook: "A Monte Carlo estimate improves as one over the square root of the samples in any dimension, which is why it beats grids in high dimensions."
goals:
  - estimate an integral and its error
  - apply importance sampling
requires:
  - rejection-sampling
  - numerical-error
defines:
  - {id: monte-carlo-integration, name: "Monte Carlo integration", anchor: def-monte-carlo-integration}
  - {id: importance-sampling, name: "importance sampling", anchor: def-importance-sampling}
read_time: true
tags:
  - Physics
  - Computation
---

Quadrature on a grid becomes impossible when the integral has many dimensions: ten points per axis in ten dimensions is ten billion evaluations. Averaging the integrand at random points has an error that does not care about the dimension.

# Estimating an integral

> **Monte Carlo integration** estimates $I=\int_Vf(\mathbf x)\,d\mathbf x$ over a region of volume $V$ by the sample mean $\hat I_N=\dfrac VN\sum_{i=1}^Nf(\mathbf x_i)$ at $N$ independent points drawn uniformly from $V$.
{: .definition #def-monte-carlo-integration title="Monte Carlo integration"}

The estimate is unbiased, because the mean of $f(\mathbf x)$ over uniform points is $I/V$. Its fluctuation follows from the central limit theorem: the variance of a mean of $N$ independent terms is the variance of one term divided by $N$, so with $\sigma^2=\operatorname{Var}f$ the standard error is
$$ \delta\hat I_N=\frac{V\sigma}{\sqrt N}. $$
It is estimated from the same samples, with $\sigma$ replaced by the sample standard deviation, so every Monte Carlo result comes with its own error bar for free.

> The error of Monte Carlo integration falls as $N^{-1/2}$ for any dimension $d$. Grid rules with step $h$ and error $O(h^2)$ use $N\propto h^{-d}$ points and so have error $O(N^{-2/d})$, which is worse than $N^{-1/2}$ once $d>4$.
{: .property title="Dimension independence of the rate"}

The rate is slow: each extra digit of accuracy costs a hundred times more samples, and a one-dimensional smooth integral is done far better by a grid. The gain is that the exponent does not degrade with $d$, and that nothing is assumed about smoothness, so it works for integrands with discontinuities or on awkward regions.

> The area of the quarter disc, $\int_0^1\!\!\int_0^1\mathbf 1[x^2+y^2<1]\,dx\,dy=\pi/4$, is estimated by the fraction of random points in the unit square that fall inside. Each point is a Bernoulli trial, so $\pi$ is estimated with standard deviation $\sqrt{\pi(4-\pi)}/\sqrt N=1.64/\sqrt N$: one million points give $\pi\approx3.141\pm0.002$ at best.
{: .example title="Estimating pi"}

# Reducing the variance

The only handle on the error at fixed $N$ is $\sigma$. A uniform sample wastes points where $f$ is small. Drawing the points from a density $p$ that is large where $|f|$ is large, and correcting with weights, concentrates the effort.

> **Importance sampling** estimates $I=\int f\,d\mathbf x$ by drawing $\mathbf x_i$ from a density $p$ and averaging $f(\mathbf x_i)/p(\mathbf x_i)$. The mean is still $I$, since $\mathbb E_p[f/p]=\int f\,d\mathbf x$, and the variance is that of the ratio $f/p$.
{: .definition #def-importance-sampling title="Importance sampling"}

The ideal is $p\propto|f|$, which makes the ratio constant and the variance zero (for $f>0$), but normalising such a $p$ needs the integral we want. In practice one picks a simple density with a similar shape that can be sampled directly, for instance by inverting its cumulative distribution or by the rejection method of the previous note.

For $f(x)=e^{-10x}$ on $[0,1]$ the integral is $0.09999546$ and the standard deviation of one uniform sample is $0.200$, a $2\%$ relative error at $N=10^4$. Sampling from $p(x)\propto e^{-8x}$ on $[0,1]$ makes the ratio $f/p$ much flatter, with standard deviation $0.0203$: ten times smaller, equivalent to about a hundred times more uniform samples.

{% include fig.html src="computational-physics/mc-error-scaling" id="fig-mc-error-scaling" alt="Log-log plot of the root-mean-square error against the number of samples for two methods. Both fall along lines of slope minus one half; the importance sampling line lies about a factor of ten below the uniform line." caption="RMS error of the estimate of $\int_0^1e^{-10x}dx$ over 200 repeats. Both estimators follow $N^{-1/2}$; importance sampling lowers the line by about $10\times$." %}

> A density $p$ that decays faster than $|f|$ in some region makes $f/p$ unbounded there. A few rare samples then carry huge weights, the sample variance is dominated by them and the error bar is unreliable or infinite. Choose $p$ with tails at least as heavy as $|f|$, and look at the largest weight, not only the mean.
{: .trap}

> Report $\hat I\pm s/\sqrt N$ with $s$ the sample standard deviation of the terms, and check the scaling by running at $N$ and $4N$: the error bar should halve. Seed the generator and keep the seed with the result.
{: .rule}

# Beyond independent points

Two refinements keep the same idea. **Stratified sampling** splits the region into pieces and samples each, so that the points cannot clump. **Control variates** subtract a function with a known integral that is correlated with $f$, so only the difference is estimated. Quasi-random (low-discrepancy) point sets replace the independent points by evenly spread ones and can reach a faster rate for smooth integrands, at the cost of losing the simple error bar. The next notes use the same sampling machinery for averages over a Boltzmann distribution, where $p$ is given by physics and Markov chains replace direct sampling.

# Recap

<details class="qa" markdown="1">
<summary>Why does Monte Carlo beat a grid in high dimension?</summary>

Its error $\propto N^{-1/2}$ does not depend on the dimension, while a grid of $N$ points has $N^{1/d}$ points per axis and an error that degrades as $d$ grows.
</details>

<details class="qa" markdown="1">
<summary>What does importance sampling change, the rate or the constant?</summary>

The constant. The error still falls as $N^{-1/2}$, but the variance of $f/p$ replaces that of $f$, so a well-matched $p$ gives the same accuracy with far fewer samples.
</details>

<details class="qa" markdown="1">
<summary>How do you get an error bar from a Monte Carlo run?</summary>

Compute the sample standard deviation $s$ of the evaluated terms and quote $s/\sqrt N$ (times $V$ for a volume), then check it by quadrupling $N$ and seeing it halve.
</details>
