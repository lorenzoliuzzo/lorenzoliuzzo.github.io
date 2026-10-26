---
collection: notes
title: "Multi-Layer Perceptron"
date: 2026-10-26
excerpt: "Layers of smooth units written as matrix products, why the hidden layer must be nonlinear, and the theorem that one hidden layer can approximate any continuous function."
hook: "A hidden layer of nonlinear units is enough to approximate any continuous function; the theorem guarantees that a network exists, not that it is small or that training will find it."
goals:
  - write the forward pass of a layered network as matrix products and count its parameters
  - explain why a network with linear hidden units is no better than one unit
  - construct a one-hidden-layer network that approximates a continuous function of one variable
  - say what the universal approximation theorem does and does not promise
requires:
  - feed-forward-network
  - threshold-logic-unit
  - multilayer-perceptron
  - activation-function
defines:
  - {id: universal-approximation-theorem, name: universal approximation theorem, anchor: universal-approximation}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

A threshold unit computes a hyperplane and a two-layer network of them computes any Boolean function, at the price of one hidden unit per case. Replacing the steps by smooth functions turns the same layered structure into a function approximator for real numbers. The [multilayer perceptron]({{ '/notes/ai/supervised-learning/neural-networks-and-backpropagation/' | relative_url }}#layers) was introduced in the supervised-learning course for training; here we ask what it can represent. Proofs are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# Layers of units

An **$r$-layer perceptron** is a [feed-forward network]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}#how-a-network-computes) with a strictly layered graph: layer 1 holds the input units, layer $r$ the output units, and every connection goes from one layer to the next. Hidden and output units use the weighted sum as net input. Hidden units use a **sigmoid**, a monotonically non-decreasing function with finite limits at $\pm\infty$ such as the logistic function; output units use a sigmoid or the identity.

> **Layer** $a_l=\varphi_l(W_l\,a_{l-1}-\theta_l)$  
> **Matrix** $W_l$ is $n_l\times n_{l-1}$  
> **Parameters** $\sum_l n_l(n_{l-1}+1)$  
> **Network** $y=a_r$, with $a_1=x$
{: .margin .spec}

Between two consecutive layers with $m$ and $n$ units the weights form an $n\times m$ matrix $W$, and the net inputs of the next layer are $\mathrm{net}=W\,\mathrm{out}$, minus the thresholds. The whole network is a composition of such affine maps and elementwise nonlinearities. Counting layers as the lectures do, input and output included, a three-layer perceptron has one hidden layer.

# Why the hidden layer must bend

The nonlinearity of the hidden units is not a detail. If every activation is the identity, layer $l$ computes $W_la_{l-1}-\theta_l$, and composing layers gives one affine map $x\mapsto Mx-c$ with $M=W_r\cdots W_2$. The network is then a single linear unit, however many layers it has.

> A network with only linear hidden units is a single linear map. Depth adds power only through the nonlinearity between the layers.
{: .trap}

The threshold units of the previous note had the nonlinearity in the step, and it is the same story with smooth units. The biimplication that no single unit computes is solved by two hidden units, built exactly as before, now with logistic activations in place of the steps.

# Universal approximation

Take a continuous function of one variable on $[a,b]$. The first picture is a staircase: cut the interval into $N$ pieces, put a constant on each, and take the constants from the function. A staircase is a sum of steps, one per riser, each of height equal to the jump of the function across it.

A hidden unit with a steep logistic activation is a step with a rounded riser, and the output unit adds them with the jumps as weights. With $N$ hidden units the network is within a small multiple of the staircase error of the function, and that error shrinks as $N$ grows.

{% include fig.html src="neural-networks/mlp-staircase" id="fig-staircase" alt="Two plots of the same smooth curve and a blue network output. With six hidden units the output is a rounded staircase that follows the curve loosely, with a largest error of 0.09. With twenty-four hidden units the output follows the curve closely, with ripples, and a largest error of 0.02." caption="One hidden layer of steep logistic units, the weights taken from the staircase construction. The largest error falls from 0.09 with 6 units to 0.02 with 24." %}

The same construction works for any continuous function, which is the **universal approximation theorem**: for every continuous $f$ on a compact set and every $\varepsilon>0$ there is a three-layer perceptron whose output is within $\varepsilon$ of $f$ everywhere. For several inputs the lectures build bumps from steps, which needs a second hidden layer and gives the four-layer statement for integrable functions with an area error. Cybenko (1989) and Hornik (1991) show that one hidden layer suffices in the sup norm, for any sigmoid.

> The lectures' conclusion is that the layered structure, not the shape of the activation, makes the network universal. Leshno et al. (1993) make this exact: a one-hidden-layer network with a continuous activation is universal if and only if the activation is not a polynomial.
{: .idea}

# What the theorem does not say

The theorem is an existence statement. It gives no way to find the weights, and training by gradient descent may not reach them. It also gives no bound on the number of hidden units, and for $d$ inputs a staircase needs on the order of $\varepsilon^{-d}$ pieces. Barron (1993) shows faster rates for functions with a bounded Fourier moment, and several lines of work show that some functions need exponentially many units in a shallow network and few in a deep one, which the deep-learning note takes up.

# Recap

<details class="qa" markdown="1">
<summary>Why can a network with identity hidden units not compute the biimplication?</summary>

Composing affine maps gives one affine map, so the network is a single linear unit with a step at best, and the biimplication is not linearly separable.
</details>

<details class="qa" markdown="1">
<summary>How does a hidden layer of logistic units approximate a continuous function?</summary>

Each hidden unit is a nearly sharp step at a chosen point, and the output weight is the jump of the function there. The sum is a staircase close to the function, and more units make the pieces narrower.
</details>

<details class="qa" markdown="1">
<summary>What does the universal approximation theorem leave unanswered?</summary>

How many hidden units are needed, how to find the weights, and whether training will converge to them. It says only that a good network exists.
</details>
