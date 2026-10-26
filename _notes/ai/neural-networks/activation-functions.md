---
collection: notes
title: "Activation Functions"
date: 2026-10-26
excerpt: "The step, the logistic function and the hyperbolic tangent, then the rectified family, with their derivatives and the places where each one flattens."
hook: "The activation function sets how far a unit can be trained: the derivative of a saturating function vanishes for large inputs, and the rectified family keeps a slope of one on half the line."
goals:
  - list the classic sigmoids and say what makes a function a sigmoid
  - compute the derivative of the logistic function and of tanh from their values
  - say where each activation saturates and what that does to training
  - choose between ReLU and its variants for a hidden layer
requires:
  - activation-function
  - multilayer-perceptron
  - universal-approximation-theorem
defines:
  - {id: logistic-function, name: logistic function, anchor: the-logistic-function}
  - {id: rectified-linear-unit, name: rectified linear unit, anchor: the-rectified-family}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

The previous note showed that the shape of the hidden activation hardly matters for what a network can represent. It matters for whether the network can be trained, because gradient descent uses the derivative. This note lists the functions in use and what each does to the gradient. The formulas are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# From steps to sigmoids

A threshold unit uses a step: the output jumps from 0 to 1 at the threshold and is flat elsewhere. A flat function has zero derivative almost everywhere and no derivative at the jump, so gradient descent cannot use it. The lectures remove the jump in stages. The **semi-linear** function rises linearly between two points and is constant outside, the **sine until saturation** does the same with a sine arc, and the **logistic function** does it with a curve that is smooth everywhere.

All of these are **sigmoids**: monotonically non-decreasing with finite limits at both ends. In a multi-layer perceptron the hidden units use a sigmoid and the output units use a sigmoid or the identity, the identity being the usual choice for regression because it leaves the range of the output free.

# The logistic function

The **logistic function** and its derivative are

$$ \sigma(z)=\frac{1}{1+e^{-z}},\qquad \sigma'(z)=\sigma(z)\bigl(1-\sigma(z)\bigr). $$

> **Range** $(0,1)$, $\sigma(0)=\tfrac12$  
> **Slope** at most $\tfrac14$, at $z=0$  
> **Symmetry** $\sigma(-z)=1-\sigma(z)$  
> **tanh** $2\sigma(2z)-1$, range $(-1,1)$
{: .margin .spec}

The derivative is computed from the output already known, so back-propagation needs no extra evaluation of the exponential. It is largest at $z=0$ and falls to zero in both directions: a weight changes fastest when the net input is near the threshold, and almost not at all when the unit is already saturated near 0 or 1.

Some networks use the bipolar sigmoid with range $-1$ to $1$, the **hyperbolic tangent**, which is the logistic function rescaled to $2\sigma(2z)-1$. Its derivative $1-\tanh^2 z$ peaks at 1, four times that of the logistic function, and its output is centred on zero, so the inputs of the next layer are not all positive. Both functions flatten for $\lvert z\rvert$ beyond a few units, as the derivative panel of the figure shows.

{% include fig.html src="neural-networks/activation-functions" id="fig-activations" alt="Left: the logistic curve rising from 0 to 1, tanh rising from -1 to 1 and the ReLU equal to zero for negative inputs and to the input for positive ones. Right: the derivatives. The logistic derivative is a bump of height 0.25, the tanh derivative a narrower bump of height 1, and the ReLU derivative is 0 for negative inputs and 1 for positive ones." caption="Three activations (left) and their derivatives (right). The two sigmoids lose their slope away from zero. The rectified unit has slope 1 on the whole positive half-line." %}

> A saturated unit passes almost no gradient back. A network whose units sit in the flat parts cannot learn, however large the error.
{: .trap}

# The rectified family

The **rectified linear unit** (ReLU) is $\max(0,z)$. It is not a sigmoid, since it is unbounded, and by the approximation theorem of the previous note it is universal anyway, because it is not a polynomial. Its derivative is 1 for $z>0$ and 0 for $z<0$, so gradients pass unchanged through active units and the cost per unit is a comparison. Rectified units are the standard hidden unit of deep networks for this reason, which the deep-learning note explains.

Their weakness is a unit whose net input is negative for every input: its gradient is 0 and its weights never change, a *dead* unit. The variants repair that. The **leaky** ReLU uses a small slope $\alpha z$ for $z<0$, with $\alpha$ fixed or learned, and the **noisy** ReLU adds Gaussian noise to the net input. The **softplus** $\log(1+e^z)$ is a smooth version of the ReLU, and its derivative is the logistic function. Newer smooth variants, such as GELU and Swish, go beyond what the lectures cover.

> **Rule of thumb.** ReLU in the hidden layers, the identity at the output for regression, a logistic or softmax output for classification. Move to a leaky variant if many units die.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the derivative of the logistic function easy to use in back-propagation?</summary>

It equals $\sigma(1-\sigma)$, a function of the output the forward pass has already produced, so no further exponential is needed.
</details>

<details class="qa" markdown="1">
<summary>Why does a saturated sigmoid unit stop learning?</summary>

Its derivative is close to zero far from the origin, so the error signal multiplied by it is close to zero and the weights barely change.
</details>

<details class="qa" markdown="1">
<summary>What does a ReLU gain over the logistic function, and what does it risk?</summary>

A slope of 1 on the positive side, so gradients are not shrunk. It risks dead units that output 0 for every input and receive no gradient.
</details>
