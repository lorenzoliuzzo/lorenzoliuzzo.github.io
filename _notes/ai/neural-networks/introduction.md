---
collection: notes
title: "Introduction to Neural Networks"
date: 2026-10-27
excerpt: "The artificial neuron, the perceptron learning rule and its convergence guarantee, and the line a single neuron cannot cross."
hook: "A neuron is a weighted vote followed by a threshold; a perceptron learns its weights from mistakes, and it can only learn what one straight line can separate."
goals:
  - write the output of an artificial neuron and the perceptron update rule
  - state when the perceptron rule is guaranteed to stop and bound the number of updates
  - show that a single neuron cannot compute XOR and say what fixes it
defines:
  - {id: artificial-neuron, name: artificial neuron, anchor: the-artificial-neuron}
  - {id: perceptron, name: perceptron, anchor: def-perceptron}
  - {id: perceptron-convergence, name: perceptron convergence theorem, anchor: def-perceptron-convergence}
  - {id: linear-separability, name: linear separability, anchor: def-linear-separability}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

A neural network is a function built by wiring together many copies of one very simple unit. This note defines the unit, the oldest rule for training it, and the limit that made the field add layers.

# The artificial neuron

McCulloch and Pitts proposed in 1943 that a nerve cell could be modelled as a unit that adds up its inputs and fires if the total passes a threshold {% cite mcculloch-pitts-1943 %}. The modern version keeps that shape and drops the claim about biology. An **artificial neuron** takes an input vector $x\in\mathbb{R}^d$, weights it, adds a bias $b$ and applies an activation function $\varphi$:

$$ y=\varphi\big(w^\top x+b\big). $$

The weights $w$ say how much each input counts and with which sign, and the bias moves the threshold. With $\varphi$ a step, $y=1$ when $w^\top x+b>0$ and $0$ otherwise, so the neuron answers a yes-or-no question about which side of a hyperplane the input is on. The bias can be absorbed by appending a constant 1 to $x$, which is how the formulas below are written.

> The neuron computes one linear score and then bends it. Everything a network does comes from stacking and training this one operation.
{: .idea}

# Learning from mistakes

> Rosenblatt's **perceptron** is this neuron with a step activation, together with a rule for finding $w$ from labelled examples $(x_i,t_i)$ with $t_i\in\{-1,+1\} $ {% cite rosenblatt-1958 %}.
{: .definition #def-perceptron title="Perceptron"}

Go through the examples; whenever the current weights misclassify one, move the weights towards getting it right:

$$ w\;\leftarrow\;w+\eta\,t_i\,x_i\qquad\text{if } t_i\,w^\top x_i\le 0. $$

Correctly classified examples change nothing. The step of size $\eta$ along $t_ix_i$ raises $t_iw^\top x_i$ by $\eta\lVert x_i\rVert^2$, so the same example is a little less wrong afterwards, although the update may spoil others.

Whether this ever settles has a clean answer. Suppose some unit vector $w_\star$ separates the classes with margin $\gamma>0$, meaning $t_i\,w_\star^\top x_i\ge\gamma$ for all $i$, and suppose all $\lVert x_i\rVert\le R$.

> Then the **perceptron convergence theorem** says the rule makes at most $(R/\gamma)^2$ updates and then classifies every example correctly {% cite novikoff-1962 %}.
{: .definition #def-perceptron-convergence title="Perceptron convergence theorem"}

The bound does not depend on the number of examples or on the dimension, only on how thick the gap between the classes is relative to the spread of the data.

> After $k$ updates, $w\cdot w_\star\ge k\eta\gamma$ because each update adds at least $\eta\gamma$ in the direction of $w_\star$, while $\lVert w\rVert^2\le k\eta^2R^2$ because an update is only made on a mistake, when the cross term is not positive. Since $w\cdot w_\star\le\lVert w\rVert$, we get $k\eta\gamma\le\sqrt k\,\eta R$, hence $k\le(R/\gamma)^2$.
{: .derive}

# What one neuron cannot do

The theorem has a condition, and it is the whole story.

> **Linear separability** means a hyperplane puts one class on each side.
{: .definition #def-linear-separability title="Linear separability"}

When the data are not separable the perceptron rule never stops, because some example is always misclassified and always pulls the weights away from the others.

The standard example is XOR: the inputs $(0,0)$ and $(1,1)$ have label 0, the inputs $(0,1)$ and $(1,0)$ have label 1. No line in the plane separates the two pairs, so no choice of $w$ and $b$ gives a neuron that computes XOR. Minsky and Papert showed in 1969 that this is not an accident of one example but a limit of the whole single-layer model, with parity as the general case {% cite minsky-papert-1969 %}, and the book is often blamed for the years in which interest in neural networks faded.

{% capture t %}
| Function of $(x_1,x_2)$ | Separable by a line | Neuron |
|---|---|---|
| AND | yes | $[x_1+x_2-1.5>0]$ |
| OR | yes | $[x_1+x_2-0.5>0]$ |
| XOR | no | none exists |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-boolean" caption="Three Boolean functions of two inputs. A single neuron needs a line that separates the ones from the zeros." body=t %}

The way out is to feed the outputs of some neurons into another one. A second layer can combine two half-planes into a region no half-plane can describe, and the [multi-layer perceptron]({{ '/notes/ai/neural-networks/multi-layer-perceptron/' | relative_url }}) note builds exactly that. What the perceptron rule cannot do for such networks is say how to change the weights of the first layer, because no target is given for its outputs. That is the problem backpropagation solves.

> Run the rule by hand on AND with $w=(0,0)$, $b=0$, $\eta=1$ and labels $\pm1$, visiting $(0,0),(0,1),(1,0),(1,1)$ in turn. Then try XOR and watch the weights cycle. The recall card gives the count for AND.
{: .try}

Figure 1 shows the geometry behind the limit of a single neuron.

{% include fig.html src="neural-networks/xor-and-separability" id="fig-xor" alt="Three panels: the AND points with one separating line, the XOR points with no line that works, and XOR after a hidden layer of two neurons." caption="AND is separable by one line, XOR is not, and two hidden neurons make it separable. Left: one line splits AND. Middle: no line splits XOR. Right: in the hidden-layer coordinates the XOR points become separable." %}

# Recap

<details class="qa" markdown="1">
<summary>Why does the perceptron rule stop on separable data, and what does the bound depend on?</summary>

Each update pushes the weights towards a separating direction, while their length grows more slowly, so only a bounded number of mistakes is possible. The bound is $(R/\gamma)^2$: the data radius over the margin, independent of the number of examples.
</details>

<details class="qa" markdown="1">
<summary>Why can no single neuron compute XOR, and what does adding a layer change?</summary>

The two classes cannot be separated by one line. A second layer can combine the outputs of two neurons, each cutting the plane with its own line, into a region between them.
</details>
