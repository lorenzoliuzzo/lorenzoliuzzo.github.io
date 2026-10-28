---
collection: notes
title: "Activation Functions"
date: 2026-10-27
excerpt: "Why a network needs a nonlinearity, how sigmoid, tanh and ReLU differ in what they do to gradients, and which output function pairs with which loss."
hook: "Without a nonlinearity a deep network collapses to one matrix; the choice of nonlinearity decides whether the gradient survives the trip back through many layers."
goals:
  - explain why a network without activation functions is a linear model
  - compute the derivatives of sigmoid, tanh and ReLU and see how they shrink the gradient
  - choose the output activation and loss for regression, binary and multiclass problems
requires:
  - artificial-neuron
defines:
  - {id: activation-function, name: activation function, anchor: def-activation-function}
  - {id: sigmoid, name: sigmoid, anchor: def-sigmoid}
  - {id: vanishing-gradient, name: vanishing gradient, anchor: def-vanishing-gradient}
  - {id: relu, name: rectified linear unit, anchor: def-relu}
  - {id: softmax, name: softmax, anchor: def-softmax}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

The activation function is the only place a neuron is not linear, so it carries all the expressive power of a network and also most of its numerical trouble.

# Why a nonlinearity

Take two layers without activations, $h=W_1x$ and $y=W_2h$. Then $y=(W_2W_1)x$, a single linear map, and any number of layers collapses the same way.

> An **activation function** $\varphi$ applied elementwise between layers breaks the collapse: with it, composing layers produces functions that no single matrix can imitate.
{: .definition #def-activation-function title="Activation function"}

The universal approximation results say that one hidden layer with almost any non-polynomial activation is enough to approximate a continuous function on a compact set, which is why the choice is mostly about training behaviour and not about what is representable.

# The classic squashing functions

> The **sigmoid** $\sigma(z)=1/(1+e^{-z})$ maps the real line to $(0,1)$ and was the default for decades because it reads as a probability and is smooth.
{: .definition #def-sigmoid title="Sigmoid"}

Its derivative is $\sigma'(z)=\sigma(z)\big(1-\sigma(z)\big)$, which peaks at $1/4$ at $z=0$ and falls towards zero on both sides. The hyperbolic tangent $\tanh z=2\sigma(2z)-1$ has range $(-1,1)$, is centred at zero, which helps the next layer, and has derivative $1-\tanh^2z\le1$. Both saturate: for large $|z|$ the output is nearly constant and the derivative nearly zero.

# Gradients through many layers

Backpropagation multiplies one factor per layer, and each factor contains $\varphi'(z)$ at that layer. For a chain of sigmoid units with weights of size about one, the gradient reaching the first layer of a ten-layer network is scaled by roughly $(1/4)^{10}\approx10^{-6}$.

> This is the **vanishing gradient** problem, analysed first by Hochreiter in 1991 {% cite hochreiter-1991 %}: the early layers receive almost no signal and learn slowly or not at all.
{: .definition #def-vanishing-gradient title="Vanishing gradient"}

The opposite failure, gradients that grow at each layer, happens when the weights are large, and is the exploding gradient.

> Saturation is a property of the activation and of the size of $z$. If the weights are initialized so that the pre-activations have unit scale, units start in the region where the derivative is not small. Glorot and Bengio derived such scalings from the variance of activations and gradients across layers {% cite glorot-bengio-2010 %}.
{: .idea}

# Rectifiers

> The **rectified linear unit** $\operatorname{ReLU}(z)=\max(0,z)$ has derivative 1 for $z>0$ and 0 for $z<0$.
{: .definition #def-relu title="Rectified linear unit"}

On the active side it passes the gradient through unchanged, so depth does not shrink it, and it is cheap to compute. It became the default hidden activation after it was shown to work well in deep networks {% cite nair-hinton-2010 %}. Its weakness is the other side: a unit whose input is negative for every example has zero gradient and never recovers, a "dead" unit. Variants keep a small slope there, as in the leaky ReLU $\max(\alpha z,z)$ with $\alpha\approx0.01$.

{% capture t %}
| Function | Range | Largest $\varphi'$ | Typical use |
|---|---|---|---|
| sigmoid | $(0,1)$ | $0.25$ | output of a binary classifier |
| tanh | $(-1,1)$ | $1$ | recurrent networks |
| ReLU | $[0,\infty)$ | $1$ | hidden layers |
| leaky ReLU | $\mathbb{R}$ | $1$ | hidden layers, to avoid dead units |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-activations" caption="Four common activations. The largest derivative decides how fast gradients shrink across layers." body=t %}

# Output functions

The last layer's activation is chosen to match the target, not to help the gradient. For a real-valued target the identity is used with squared error. For a binary label the sigmoid gives a probability $p$ and the loss is the cross-entropy $-t\log p-(1-t)\log(1-p)$.

> For $K$ classes the **softmax** maps scores $z_k$ to probabilities $p_k=e^{z_k}/\sum_je^{z_j}$.
{: .definition #def-softmax title="Softmax"}

$$ p_k=\frac{e^{z_k}}{\sum_{j}e^{z_j}} $$

turns scores into a probability vector, and with the cross-entropy $-\sum_kt_k\log p_k$ the gradient with respect to the scores is the simple difference $p_k-t_k$. The pairing is deliberate: the logarithm cancels the exponential, so the output layer does not saturate when it is wrong, which a sigmoid with squared error does.

> Softmax is unchanged when the same constant is added to every score. Subtract the largest score before exponentiating, or the exponentials overflow for scores around 90 in single precision.
{: .trap}

The shapes and their slopes are easiest to compare side by side.

{% include fig.html src="neural-networks/activations" id="fig-activations" alt="Curves of sigmoid, tanh and ReLU on top, and their derivatives below." caption="Sigmoid, tanh and ReLU with their derivatives. The sigmoid derivative never exceeds one quarter, which is why stacked sigmoids shrink gradients; ReLU keeps slope one for positive inputs." %}

# Recap

<details class="qa" markdown="1">
<summary>Why does a network of linear layers have no more power than one layer?</summary>

The product of the weight matrices is itself a matrix, so the whole network is one linear map of the input.
</details>

<details class="qa" markdown="1">
<summary>Why does ReLU help with vanishing gradients where sigmoid does not?</summary>

Its derivative is exactly 1 wherever the unit is active, so the gradient passes through unchanged, whereas the sigmoid derivative is at most $1/4$ and shrinks the gradient at every layer.
</details>

<details class="qa" markdown="1">
<summary>What does softmax with cross-entropy give for the gradient at the output, and why is that useful?</summary>

The difference $p_k-t_k$ between prediction and target. It is large when the prediction is wrong and never saturates, so learning does not stall on confident mistakes.
</details>
