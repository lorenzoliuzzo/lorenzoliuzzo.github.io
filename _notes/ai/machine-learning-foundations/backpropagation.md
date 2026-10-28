---
collection: notes
title: "Backpropagation and Universal Approximation"
date: 2026-10-27
excerpt: "Feed-forward networks, backpropagation as the chain rule on a graph, and the universal approximation theorem."
hook: "Backpropagation computes the gradient of the loss for all weights in one backward pass, and a single hidden layer is enough to approximate any continuous function, though not efficiently."
goals:
  - derive backpropagation for a feed-forward network
  - state the universal approximation theorem and its limits
requires:
  - gradient-descent
  - jacobian
defines:
  - {id: backpropagation, name: "backpropagation", anchor: def-backpropagation}
  - {id: universal-approximation, name: "universal approximation theorem", anchor: def-universal-approximation}
read_time: true
tags:
  - Artificial Intelligence
  - Machine Learning
---

Gradient descent needs the gradient of the loss with respect to every weight. A network with millions of weights could never be trained if each partial derivative cost a separate pass, and backpropagation is the observation that all of them cost about as much as one forward pass in total.

# A network as a composition

A feed-forward network applies layers in turn: $\mathbf a^{(l)}=W^{(l)}\mathbf h^{(l-1)}+\mathbf b^{(l)}$ and $\mathbf h^{(l)}=\sigma(\mathbf a^{(l)})$, with $\mathbf h^{(0)}=\mathbf x$ the input and a loss $L$ computed from the last layer. The loss is a composition of simple functions, so its derivative is a product of their Jacobians by the chain rule:
$$ \frac{\partial L}{\partial \mathbf h^{(l-1)}}=\Big(\frac{\partial\mathbf h^{(l)}}{\partial\mathbf h^{(l-1)}}\Big)^{\!\top}\frac{\partial L}{\partial\mathbf h^{(l)}}. $$
Evaluating this product from the right, starting at the loss, multiplies a vector by a matrix at each step. Evaluating it from the left would multiply matrices by matrices, which costs far more when the output is a single number.

> **Backpropagation** computes the gradient of a scalar loss with respect to all parameters of a layered network in one backward sweep: after a forward pass that stores every layer's activations, it propagates the error signal $\boldsymbol\delta^{(l)}=\partial L/\partial\mathbf a^{(l)}$ from the output to the input with $\boldsymbol\delta^{(l)}=\big(W^{(l+1)\top}\boldsymbol\delta^{(l+1)}\big)\odot\sigma'(\mathbf a^{(l)})$ and reads the gradients $\partial L/\partial W^{(l)}=\boldsymbol\delta^{(l)}\mathbf h^{(l-1)\top}$ and $\partial L/\partial\mathbf b^{(l)}=\boldsymbol\delta^{(l)}$.
{: .definition #def-backpropagation title="Backpropagation"}

The cost is the point: the backward sweep takes a small constant multiple of the forward pass, whatever the number of parameters, and the price is memory for the stored activations. The method is the reverse mode of automatic differentiation specialised to layers {% cite rumelhart-1986 %}.

# A worked example

Take one input $x=1$, a hidden unit $h=\tanh(w_1x)$ with $w_1=0.5$, an output $y=w_2h$ with $w_2=2$, a target $t=1$, and the loss $L=\frac12(y-t)^2$.

Forward: $a=0.5$, $h=\tanh0.5=0.4621$, $y=0.9242$, $L=0.00287$. Backward: the output error is $\delta=y-t=-0.0758$, so $\partial L/\partial w_2=\delta h=-0.0350$. The signal reaching the hidden unit is $\delta w_2=-0.1515$, and through the nonlinearity $-0.1515\,(1-h^2)=-0.1192$, which is $\partial L/\partial w_1$ since $x=1$. A central finite difference on the loss gives $-0.11917$ and $-0.03501$, the same numbers, which is the standard way to test an implementation.

> The factor $\sigma'(\mathbf a)$ appears once per layer. For a saturating nonlinearity such as $\tanh$ it is below $1$, so the signal reaching early layers of a deep network is a product of many small numbers and shrinks exponentially. This is the vanishing gradient problem.
{: .implication title="Vanishing gradients"}

> Gradient checking with finite differences costs two forward passes per parameter, so it is a test on a tiny network, never a training method. The error of the central difference falls as $\epsilon^2$ until floating-point rounding takes over, at around $\epsilon\approx10^{-5}$ in double precision.
{: .trap}

# What a single hidden layer can represent

> **Universal approximation theorem.** For a suitable continuous activation such as a sigmoid or the ReLU, a feed-forward network with one hidden layer of enough units can approximate any continuous function on a compact set to any accuracy in the supremum norm {% cite cybenko-1989 hornik-1991 %}.
{: .theorem #def-universal-approximation title="Universal approximation theorem"}

Cybenko proved it for sigmoids and Hornik extended it to a wide class of activations. The idea is visible for ReLU units, where a hidden layer produces piecewise-linear functions: $n$ units can follow any continuous piecewise-linear function with $n$ segments, and a smooth function is close to one of those.

{% include fig.html src="machine-learning-foundations/relu-approximation" id="fig-relu-approximation" alt="A sine wave over one period and two piecewise-linear approximations of it, a coarse one and a finer one that hugs the curve." caption="A sine wave and the piecewise-linear functions that networks with 3 and 8 hidden ReLU units can represent. The error falls roughly as $1/n^2$." %}

For a twice differentiable function the interpolation error with segments of width $h$ is at most $\frac{h^2}{8}\max|f''|$, which is why the error in the figure drops from $0.44$ to $0.07$ when the width grows by a factor of $8/3$.

> The theorem says an approximating network exists. It does not say how many units are needed, how to find the weights, or that gradient descent will find them. In several dimensions the number of units can grow exponentially with the dimension, and depth is what often gives a more economical representation.
{: .remark}

> Use backpropagation whenever the loss is a differentiable composition and the output is a scalar. Test with finite differences on a tiny instance, and watch the per-layer gradient norms to see vanishing or exploding signals early.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the backward pass cheap?</summary>

The loss is a scalar, so multiplying the Jacobians from the output side only ever multiplies a vector by a matrix. One sweep gives every parameter gradient, at a cost comparable to the forward pass.
</details>

<details class="qa" markdown="1">
<summary>What does the error signal $\boldsymbol\delta^{(l)}$ mean and how does it propagate?</summary>

It is the derivative of the loss with respect to the pre-activation of layer $l$. It is obtained from the layer above by multiplying with the transposed weights and then with the activation derivative.
</details>

<details class="qa" markdown="1">
<summary>What does universal approximation guarantee and what does it not?</summary>

It guarantees that wide enough one-hidden-layer networks can approximate any continuous function on a compact set. It says nothing about the width needed, about learning the weights, or about generalisation.
</details>
