---
collection: notes
title: "Training a Multi-Layer Perceptron"
date: 2026-10-26
excerpt: "Gradient descent on the error of a layered network, the variants that cure its slow stretches, and the choices that decide how complex the fitted network may become."
hook: "Back-propagation only supplies gradients; how fast and how well a network trains depends on the step rule, on where it starts, and on how its complexity is held back."
goals:
  - write the gradient step for a logistic unit and say why it stalls in a saturated region
  - state the update of momentum, Rprop and weight decay
  - choose the number of hidden units and the stopping time with a validation set
  - use sensitivity analysis to rank inputs
requires:
  - back-propagation
  - cross-validation
  - overfitting
  - ridge-regression
  - sum-of-squared-errors
  - logistic-function
defines:
  - {id: gradient-descent, name: gradient descent, anchor: gradient-descent}
  - {id: momentum, name: momentum, anchor: variants-of-gradient-descent}
  - {id: resilient-propagation, name: resilient propagation, anchor: variants-of-gradient-descent}
  - {id: weight-decay, name: weight decay, anchor: controlling-complexity}
  - {id: early-stopping, name: early stopping, anchor: controlling-complexity}
  - {id: sensitivity-analysis, name: sensitivity analysis, anchor: sensitivity-analysis}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

A network with smooth units has a differentiable error, so its weights can be found by walking downhill. [Back-propagation]({{ '/notes/ai/supervised-learning/neural-networks-and-backpropagation/' | relative_url }}#back-propagation) computes the slope; this note is about the walk. Formulas and the update rules in full are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# Gradient descent

Training minimizes the [sum of squared errors]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}#what-learning-means) $e(w)$ over the weights and thresholds. **Gradient descent** repeatedly moves them against the gradient with a learning rate $\eta$:

$$ w\leftarrow w-\eta\,\nabla_w e. $$

For one logistic unit with output $y=\sigma(w\cdot x-\theta)$ and a pattern with target $o$, absorbing a factor 2 into $\eta$, the corrections are $\Delta w_i=\eta\,(o-y)\,y(1-y)\,x_i$ and $\Delta\theta=-\eta\,(o-y)\,y(1-y)$. Compare them with the delta rule of the threshold unit: the same $(o-y)x_i$, now multiplied by the slope $y(1-y)$ of the activation.

That factor is where training stalls. A unit whose output is already near 0 or 1 has a slope near 0, so a unit that is confidently wrong changes slowly, and the error of a logistic output can never reach 0 for targets 0 and 1, so the weights keep growing.

> Gradient descent finds a local minimum, not the global one. The usual remedy is to start from several random weight vectors and keep the best result.
{: .rule}

# Variants of gradient descent

Most variants change the step length and leave the direction alone. **Manhattan training** uses only the sign of the gradient. **Flat-spot elimination** adds a small constant to the activation's slope so it never vanishes. The **momentum** term adds a fraction $\beta$ of the previous step, $\Delta w(t)=-\eta\,\nabla e(t)+\beta\,\Delta w(t-1)$, so steps in a steady direction add up and zigzags cancel; $\beta=0.9$ is a common choice.

**Resilient propagation** (Rprop) gives every weight its own step size $\Delta_i$ and uses only the sign of the gradient: the step grows by a factor 1.2 while the sign stays the same and shrinks by 0.5 when it flips. **Quickprop** fits a parabola through the last two gradients and jumps to its minimum.

{% include fig.html src="neural-networks/gradient-flat-spot" id="fig-flat-spot" alt="Log error against iteration for three optimizers on one logistic unit started in the flat region. Plain gradient descent stays near zero for thirty iterations and reaches about minus two by sixty. Momentum and Rprop drop below minus six within the first thirty iterations, Rprop first." caption="One weight, $e=\sigma(w)^2$, started at $w=4$ in the flat tail. Plain descent barely moves for thirty steps, while momentum and Rprop, which do not depend on the size of the gradient, leave the flat spot at once." %}

Because Rprop ignores the size of the gradient, it does not suffer from the flat tails of sigmoids and needs almost no tuning, which made it a common default before adaptive methods. Momentum is the ancestor of the methods now used with deep networks.

# Controlling complexity

With too few hidden units a network cannot capture the relation between inputs and outputs, and with too many it fits the noise of the training set. A popular starting point for one hidden layer is half the sum of the numbers of inputs and outputs. The number is then chosen by training networks of several sizes and keeping the one with the lowest error on a [validation set]({{ '/notes/ai/supervised-learning/validation-and-cross-validation/' | relative_url }}#choosing-with-a-validation-set), averaged over several random splits or folds.

> **Early stopping** evaluates the validation error after each epoch. The training error keeps decreasing, the validation error starts to rise when the network begins to overfit, and training stops there. It stops a network that is too large early, instead of finding the right size.
{: .idea}

**Weight decay** adds $\tfrac\xi2\sum w^2$ to the error. Each step then also shrinks every weight, $w\leftarrow w(1-\eta\xi)-\eta\,\partial e/\partial w$, so large weights, which push units into saturation and give wildly bending functions, are penalized. It is the same penalty as [ridge regression]({{ '/notes/statistics/regularization/' | relative_url }}#ridge-shrinks-everything), applied to a network.

# Sensitivity analysis

A trained network is a matrix of numbers that nobody can read. **Sensitivity analysis** asks to which inputs the output reacts most. For input $i$, average over the training patterns the absolute change of the outputs per unit change of that input,

$$ s_i=\frac1{\lvert L\rvert}\sum_{l\in L}\sum_{v\in U_{\text{out}}}\Bigl\lvert\frac{\partial\,\mathrm{out}_v^{(l)}}{\partial\,\mathrm{ext}_{i}^{(l)}}\Bigr\rvert, $$

computed by the same backward pass that gives the weight gradients. Inputs with a small $s_i$ are candidates for removal.

> The derivatives are local and depend on the scale of the inputs, which is why the inputs are standardized first. Two correlated inputs can share their effect and both look unimportant.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does a logistic unit that is badly wrong sometimes learn slowly?</summary>

Its weight change is proportional to the slope $y(1-y)$ of the activation, which is near zero when the output is close to 0 or 1, even if the target is the opposite.
</details>

<details class="qa" markdown="1">
<summary>How do momentum and Rprop help in a flat region?</summary>

Momentum accumulates the small gradients into a growing step. Rprop ignores the size of the gradient and grows its step while the sign is constant.
</details>

<details class="qa" markdown="1">
<summary>Why does early stopping control complexity without changing the network?</summary>

Weights start small and the fit grows as training goes on, so stopping at the minimum of the validation error keeps the fit from adapting to the noise.
</details>
