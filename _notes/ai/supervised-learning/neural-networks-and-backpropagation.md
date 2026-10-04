---
collection: notes
title: "Neural Networks and Back-propagation"
date: 2026-10-04
excerpt: "A network of simple units as one differentiable function, and back-propagation as the chain rule that gives the gradient of the error for every weight."
hook: "A feed-forward network is a differentiable function of its weights, so the gradient of the error reaches every weight by applying the chain rule backwards, layer by layer."
goals:
  - write the output of a neuron and of a layer
  - explain the forward and backward passes of back-propagation
  - say what limits a network in practice
requires:
  - overfitting
  - linear-classifier
defines:
  - {id: artificial-neuron, name: artificial neuron, anchor: the-unit}
  - {id: activation-function, name: activation function, anchor: the-unit}
  - {id: multilayer-perceptron, name: multilayer perceptron, anchor: layers}
  - {id: back-propagation, name: back-propagation, anchor: back-propagation}
read_time: true
tags:
  - Supervised Learning
  - Classic learners
---

Neural networks are the fifth classic learner, and the one the rest of the course builds on. This note gives the plain feed-forward network and the algorithm that trains it. The architectures for images, sequences and attention come later.

# The unit

An **artificial neuron** is the computational unit of a network. Its inputs are multiplied by **connection weights** and summed, a bias is added, and the result goes through an **activation function** $\varphi$ that squashes or bends it,

$$ y=\varphi\Big(\sum_iw_ix_i+b\Big)=\varphi\big(w^\top x+b\big) . $$

In the McCulloch–Pitts model the bias is minus a threshold and $\varphi$ is a step: the neuron fires when the weighted input exceeds the threshold. Replacing the step with a smooth function such as the sigmoid is what makes the unit differentiable. With a step activation the unit is exactly a [linear classifier]({{ '/notes/ai/supervised-learning/linear-discriminant-analysis/' | relative_url }}).

# Layers

Units are organized in layers, each connected to the next without cycles. This is the **multilayer perceptron**, or feed-forward network: an input layer that holds the features, one or more hidden layers, and an output layer, with one output unit per class for classification. In matrix form layer $l$ computes

$$ h_l=\varphi\big(W_lh_{l-1}+b_l\big),\qquad h_0=x, $$

so the whole network is a composition of such maps, and its output is a function of all the weights and biases. A network with a single hidden layer and enough units can approximate any continuous function on a bounded region, so what limits a network in practice is not what it can represent but whether it can be trained and whether it generalizes.

# Back-propagation

Training means finding the weights that make the error $E$ against the ground truth small. As long as every activation is differentiable, $E$ is a differentiable function of all the parameters, and it can be reduced by **gradient descent**: move each weight a little against its derivative, $w\leftarrow w-\eta\,\partial E/\partial w$ with step size $\eta$.

**Back-propagation** is the algorithm that computes all these derivatives in one sweep. It has two passes:

1. **Forward:** feed the inputs through the layers to get the output, and compute the error against the label.
2. **Backward:** send the error back from the output. At each layer the derivative of $E$ with respect to that layer's input is obtained from the one of the next layer by the chain rule, and from it the derivative with respect to its weights.

> With $z\_l=W\_lh\_{l-1}+b\_l$ and $\delta\_l=\partial E/\partial z\_l$: at the output $\delta\_L$ comes from the error, then $\delta\_l=\big(W\_{l+1}^\top\delta\_{l+1}\big)\odot\varphi^{\prime}(z\_l)$ going backwards, and $\partial E/\partial W\_l=\delta\_l\,h\_{l-1}^\top$. Each layer reuses the work of the one above it, so the cost of the whole gradient is about that of one forward pass.
{: .derive}

The two passes are repeated over the training examples, in many rounds, until the training error is small or training is stopped early.

> A network has so many parameters that it can drive the training error to zero on almost any data. Held-out error must decide when to stop training and how large the network should be, exactly as in [the learning problem]({{ '/notes/ai/supervised-learning/learning-problem/' | relative_url }}): watching the validation error and stopping when it starts to rise is called early stopping.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why must the activation function be differentiable for back-propagation?</summary>

The algorithm applies the chain rule through every layer, and the derivative of each activation appears in it. A step function has zero derivative almost everywhere and gives no signal for the weights.
</details>

<details class="qa" markdown="1">
<summary>What does the backward pass reuse that makes back-propagation cheap?</summary>

The derivative at each layer is computed from the derivative at the layer above it, so the gradient with respect to all weights costs about one extra pass instead of one pass per weight.
</details>

<details class="qa" markdown="1">
<summary>If one hidden layer can approximate any function, is that enough in practice?</summary>

The theorem says a good approximation exists, not that it needs few units or that gradient descent will find it from limited data. Trainability and generalization, not representability, are what limit a network in practice.
</details>
