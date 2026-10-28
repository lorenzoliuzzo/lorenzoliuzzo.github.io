---
collection: notes
title: "Multi-Layer Perceptron"
date: 2026-10-27
excerpt: "A hidden layer as learned features, the forward and backward pass in matrix form, and the regularization that stops a network from memorizing its training set."
hook: "A hidden layer lets a network build its own features; backpropagation tells every weight how to change, and weight decay and early stopping keep the result from memorizing."
goals:
  - write the forward pass of a network with hidden layers and count its parameters
  - build a two-layer network that computes XOR
  - state the backward recursion and choose weight decay or early stopping against overfitting
requires:
  - perceptron
  - linear-separability
  - activation-function
  - softmax
  - gradient-descent
  - backpropagation
defines:
  - {id: multilayer-perceptron, name: multi-layer perceptron, anchor: def-multilayer-perceptron}
  - {id: hidden-layer, name: hidden layer, anchor: def-hidden-layer}
  - {id: weight-decay, name: weight decay, anchor: def-weight-decay}
  - {id: early-stopping, name: early stopping, anchor: def-early-stopping}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
  - Feed Forward Neural Networks
---

The perceptron could only draw one line. Putting a layer of neurons between the input and the output removes that limit, and the rest of this note is about how such a network is evaluated, trained and kept honest.

# Layers of features

> A **multi-layer perceptron** is a chain of layers in which every neuron receives all outputs of the layer before.
{: .definition #def-multilayer-perceptron title="Multi-layer perceptron"}

> A **hidden layer** is a layer between input and output. For one hidden layer of $m$ units the network computes $h=\varphi(W_1x+b_1)$ and $\hat y=g(W_2h+b_2)$.
{: .definition #def-hidden-layer title="Hidden layer"}

$$ h=\varphi(W_1x+b_1),\qquad \hat y=g(W_2h+b_2), $$

with $W_1\in\mathbb{R}^{m\times d}$, $W_2\in\mathbb{R}^{K\times m}$ and an output function $g$ chosen to match the target, as in the [activation functions]({{ '/notes/ai/neural-networks/activation-functions/' | relative_url }}#output-functions) note. The hidden vector $h$ is a set of $m$ features that the network invents for itself, and the output layer is a linear model on them. The parameter count is $m(d+1)+K(m+1)$, so a network with 784 inputs, 100 hidden units and 10 classes has $78{,}500+1{,}010=79{,}510$ weights and biases.

XOR shows what the hidden layer buys. Let $h_1=[x_1+x_2-0.5>0]$ (OR), $h_2=[x_1+x_2-1.5>0]$ (AND) and $y=[h_1-h_2-0.5>0]$. The input $(0,0)$ gives $h=(0,0)$ and $y=0$; $(1,0)$ and $(0,1)$ give $h=(1,0)$ and $y=1$; $(1,1)$ gives $h=(1,1)$ and $y=0$. Each hidden neuron draws one line, and the output neuron selects the strip between them.

# Training by backpropagation

The loss $L$ is a function of all weights, so gradient descent needs $\partial L/\partial W_\ell$ for every layer. Write $z_\ell=W_\ell h_{\ell-1}+b_\ell$ and $h_\ell=\varphi(z_\ell)$. Backpropagation applies the chain rule from the output backwards, reusing one quantity per layer, the error signal $\delta_\ell=\partial L/\partial z_\ell$:

$$ \delta_L=\hat y-t,\qquad \delta_\ell=\big(W_{\ell+1}^\top\delta_{\ell+1}\big)\odot\varphi'(z_\ell),\qquad \frac{\partial L}{\partial W_\ell}=\delta_\ell\,h_{\ell-1}^\top. $$

The first equation holds for a softmax or sigmoid output with its cross-entropy, or an identity output with squared error. The second is the whole idea: the error at a layer is the error one layer up, carried back through the transposed weights and scaled by the local derivative. One forward pass and one backward pass give every gradient, at about twice the cost of evaluating the network, which is what made training deep models practical {% cite rumelhart-1986 %}. The derivation and its generalization to any computation graph are in [backpropagation]({{ '/notes/ai/machine-learning-foundations/backpropagation/' | relative_url }}).

> The derivative factor $\varphi'(z_\ell)$ appears once per layer in the recursion, so the choice of activation sets how the error signal scales with depth, as in the vanishing gradient discussion.
{: .rule}

# Keeping it from memorizing

A network with 79,510 parameters can fit a training set of a few thousand examples exactly, noise included, and then predict new data poorly. Two remedies are standard.

> **Weight decay** adds $\tfrac\lambda2\lVert w\rVert^2$ to the loss, which in gradient descent shrinks every weight by a factor $(1-\eta\lambda)$ at each step.
{: .definition #def-weight-decay title="Weight decay"}

It is ridge regression applied to the weights, and it has the same reading: a normal prior on the weights centred at zero {% cite krogh-hertz-1991 %}. The thread [Penalties are priors]({{ '/threads/penalties-are-priors/' | relative_url }}) follows that reading from least squares to networks.

> **Early stopping** instead watches the error on held-out data and stops training when it starts to rise; for a linear model trained from zero weights it acts like a ridge penalty whose strength shrinks as training goes on.
{: .definition #def-early-stopping title="Early stopping"}

> Choose $\lambda$ and the stopping point on a validation set, never on the training loss, which always prefers $\lambda=0$ and more steps.
{: .trap}

{% capture t %}
| Task | Output function $g$ | Loss |
|---|---|---|
| regression | identity | squared error |
| binary classification | sigmoid | binary cross-entropy |
| $K$ classes | softmax | cross-entropy |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-output-loss" caption="Output function and loss are chosen as a pair; the error signal at the output is then $\hat y-t$ in each case." body=t %}

A model trained by gradient descent shows the effect that early stopping exploits.

{% include fig.html src="neural-networks/early-stopping" id="fig-early-stopping" alt="Two error curves against training steps on a log axis: training error keeps falling while held-out error reaches a minimum and rises." caption="Training and held-out error of an overfitting polynomial model against gradient-descent steps. Training error falls throughout; held-out error bottoms out early and then climbs. The marked step is where to stop." %}

# Recap

<details class="qa" markdown="1">
<summary>What does a hidden layer add that the perceptron lacks?</summary>

Learned features. Each hidden neuron cuts the input space with its own hyperplane, and the output layer combines them, so classes that no single line separates can still be separated.
</details>

<details class="qa" markdown="1">
<summary>How does the backward pass compute the gradients for all layers in one sweep?</summary>

The error signal of a layer is obtained from the one above by multiplying by the transposed weights and the local derivative, and each weight gradient is that signal times the layer's input. Nothing is recomputed.
</details>

<details class="qa" markdown="1">
<summary>Why is weight decay a prior, and how does it differ from early stopping?</summary>

Minimizing loss plus $\tfrac\lambda2\lVert w\rVert^2$ is the posterior mode under a normal prior on the weights. Early stopping reaches a similar shrinkage implicitly, by limiting how far training can move from the starting point, and its strength is set by the number of steps instead of by $\lambda$.
</details>
