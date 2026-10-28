---
collection: notes
title: "Gradient Descent and Its Variants"
date: 2026-10-27
excerpt: "Batch and stochastic gradient descent, momentum, adaptive step sizes and convergence."
hook: "Training is walking downhill on a loss surface, and the variants differ in how they choose the step and how much of the data they use."
goals:
  - implement SGD with momentum
  - explain why the step size and the batch size matter
requires:
  - gradient
  - taylor-expansion
  - eigenvalue
defines:
  - {id: gradient-descent, name: "gradient descent", anchor: def-gradient-descent}
  - {id: stochastic-gradient, name: "stochastic gradient descent", anchor: def-stochastic-gradient}
  - {id: momentum, name: "momentum", anchor: def-momentum}
read_time: true
tags:
  - Artificial Intelligence
  - Machine Learning
---

Training a model means minimizing a loss over thousands to billions of parameters, and the only information that scales to that size is the gradient. All of the common optimizers are small changes to one rule: take a step downhill.

# Gradient descent

> **Gradient descent** minimizes a differentiable loss $L(\mathbf x)$ by repeating $\mathbf x_{k+1}=\mathbf x_k-\eta\,\nabla L(\mathbf x_k)$, where the step size $\eta>0$ is the **learning rate**.
{: .definition #def-gradient-descent title="Gradient descent"}

The reason it works is the first-order Taylor expansion: $L(\mathbf x-\eta\mathbf g)\approx L(\mathbf x)-\eta|\mathbf g|^2$ with $\mathbf g=\nabla L$, so a small enough step lowers the loss. How small is decided by the curvature. Near a minimum $L\approx\tfrac12\mathbf x^{\mathsf T}H\mathbf x$, and in the eigenbasis of the Hessian each coordinate evolves independently, multiplied at every step by $1-\eta\lambda_i$.

> On a quadratic loss with Hessian eigenvalues $0<\lambda_{\min}\le\lambda_i\le\lambda_{\max}$, gradient descent converges if and only if $\eta<2/\lambda_{\max}$. The fastest choice, $\eta=2/(\lambda_{\max}+\lambda_{\min})$, shrinks the error by the factor $\dfrac{\kappa-1}{\kappa+1}$ per step, where $\kappa=\lambda_{\max}/\lambda_{\min}$ is the condition number.
{: .theorem #thm-gd-rate title="Convergence on a quadratic"}

> In the eigenbasis of the Hessian each component of the error is multiplied at every step by $1-\eta\lambda_i$. All components shrink exactly when $|1-\eta\lambda_i|<1$ for every $i$, which is $\eta<2/\lambda_{\max}$. The slowest component has factor $\max_i|1-\eta\lambda_i|=\max\{|1-\eta\lambda_{\min}|,|1-\eta\lambda_{\max}|\}$, which is smallest when the two are equal and opposite, $1-\eta\lambda_{\min}=-(1-\eta\lambda_{\max})$. That gives $\eta=2/(\lambda_{\max}+\lambda_{\min})$ and the factor $(\kappa-1)/(\kappa+1)$.
{: .proof}

The steepest direction caps the step and the flattest direction sets the speed, so an elongated valley is slow whatever the step. For $\kappa=100$ the factor is $0.98$: reducing the loss by a factor $10^6$ takes $346$ steps in a simulation, and $\kappa=10^4$ would take thousands. The same effect appears at each step as a zigzag across the valley.

> Real losses are not quadratic and the curvature is unknown, so the learning rate is found by trial: raise it until the loss starts to oscillate or blow up, then use a fraction of that value. A loss that rises from the first steps almost always means $\eta$ is too large.
{: .rule}

# Stochastic gradients

The loss in machine learning is an average over $n$ training examples, $L=\frac1n\sum_iL_i$, and its exact gradient costs a pass over all of them. A random subset does nearly as well.

> **Stochastic gradient descent** (SGD) replaces $\nabla L$ with the gradient $\hat{\mathbf g}$ of a randomly chosen example or **minibatch** of size $B$: $\mathbf x_{k+1}=\mathbf x_k-\eta\,\hat{\mathbf g}_k$. The estimate is unbiased, $\mathbb E\hat{\mathbf g}=\nabla L$, and its variance falls as $1/B$.
{: .definition #def-stochastic-gradient title="Stochastic gradient descent"}

The noise has a price. With a constant step the iterates do not settle at the minimum but wander in a ball around it whose size grows with $\eta$ and with the variance of $\hat{\mathbf g}$; with a step that decreases so that $\sum\eta_k=\infty$ and $\sum\eta_k^2<\infty$, they converge {% cite robbins-monro-1951 %}. In practice one keeps $\eta$ constant for a while and then lowers it, so that early steps travel and late steps average out the noise.

The batch size trades cost against noise. A step costs time proportional to $B$ and reduces the noise by $1/\sqrt B$, so small batches make more, noisier steps for the same computation; very large batches waste work, since the gradient is then already accurate and a bigger step is needed to use it. In the middle, one can raise $\eta$ roughly in proportion to $B$, up to a limit set by the curvature.

> Minibatch noise is not only a cost: on non-convex losses it helps the iterates leave sharp saddle regions. But the noise is also why one never reads a single minibatch loss as a measure of progress; track a running average or evaluate on a fixed validation set.
{: .remark title="Noise as a feature"}

# Momentum

Along a narrow valley the gradient components across it keep changing sign while the component along it is small and steady. Keeping a memory of past steps cancels the first and accumulates the second.

> **Momentum** (the heavy-ball method) keeps a velocity $\mathbf v_{k+1}=\beta\mathbf v_k-\eta\nabla L(\mathbf x_k)$ and updates $\mathbf x_{k+1}=\mathbf x_k+\mathbf v_{k+1}$, with $0\le\beta<1$ {% cite polyak-1964 %}. In a steady gradient the effective step is $\eta/(1-\beta)$.
{: .definition #def-momentum title="Momentum"}

On a quadratic the best choices make the iteration count grow with $\sqrt\kappa$ instead of $\kappa$: with $\eta=4/(\sqrt{\lambda_{\max}}+\sqrt{\lambda_{\min}})^2$ and $\beta=\big(\frac{\sqrt\kappa-1}{\sqrt\kappa+1}\big)^2$ the same $\kappa=100$ problem needs $58$ steps instead of $346$. The picture shows the mechanism at $\kappa=10$.

{% include fig.html src="machine-learning-foundations/gd-momentum" id="fig-gd-momentum" alt="Two paths on an elongated bowl, both starting at the right. The plain gradient descent path zigzags across the valley while advancing slowly toward the minimum. The momentum path has smaller sideways swings and arrives closer to the minimum after the same number of steps." caption="Fourteen steps on $f=\tfrac12(x^2+10y^2)$. Plain descent ($\eta=0.18$) bounces from side to side of the valley; momentum ($\eta=0.1$, $\beta=0.5$) damps the bounce and ends at a loss about $35$ times lower." %}

# Adaptive step sizes

A single learning rate is a poor fit when parameters have very different gradient scales, as in embeddings or across layers. Adaptive methods rescale each coordinate by a running estimate of its gradient size. Adam keeps exponential averages of the gradient $m$ and of its square $v$, corrects their start-up bias, and steps by $\eta\,\hat m/(\sqrt{\hat v}+\epsilon)$ {% cite kingma-ba-2015 %}. Its defaults are $\beta_1=0.9$, $\beta_2=0.999$ and $\epsilon=10^{-8}$, and because each coordinate moves by about $\eta$ regardless of the gradient's scale, a learning rate near $10^{-3}$ is a common starting point.

> Optimizer state costs memory, which is what limits training on a single small GPU. In 32-bit floats, $N$ parameters take $4N$ bytes, their gradients another $4N$, SGD with momentum adds $4N$ and Adam adds $8N$ for $m$ and $v$: $16N$ bytes in all for Adam, before any activations. On an $8$ GB card that already caps a model at about $5\times10^8$ parameters, and in practice much less.
{: .application title="Optimizer memory on an 8 GB GPU"}

> Adaptive methods change the scale of the steps, not the condition number of the problem, and they can generalize worse than well-tuned SGD with momentum on some tasks. Treat the choice of optimizer as a hyperparameter, and compare at equal tuning effort.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is the step size limited by the largest curvature, but the speed by the smallest?</summary>

Each eigen-direction shrinks by $1-\eta\lambda_i$ per step. Stability needs $|1-\eta\lambda_{\max}|<1$, while the flattest direction shrinks by $1-\eta\lambda_{\min}$, which is close to $1$ when $\eta$ must be small.
</details>

<details class="qa" markdown="1">
<summary>What does the batch size change in SGD?</summary>

The variance of the gradient estimate falls as $1/B$ while the cost per step grows as $B$; small batches give many noisy steps, large ones a few accurate ones.
</details>

<details class="qa" markdown="1">
<summary>How does momentum speed up descent in a narrow valley?</summary>

Components of the gradient that alternate in sign cancel in the velocity, while the consistent component along the valley accumulates, so the effective step along it is larger.
</details>
