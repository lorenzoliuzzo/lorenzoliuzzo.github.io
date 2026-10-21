---
collection: notes
title: "Introduction to Neural Networks"
date: 2026-10-21
excerpt: "The vocabulary of the whole series: a network as a graph of units with three functions each, how feed-forward and recurrent networks compute, and the two kinds of learning task."
hook: "A neural network is a graph of simple units, each defined by three functions, and a learning task is a request about what the graph should compute from its inputs."
goals:
  - define a neural network as a graph and say what the net input, activation and output of a unit are
  - tell a feed-forward network from a recurrent one and describe how each is evaluated
  - state a fixed and a free learning task and write the error of a fixed one
  - explain why inputs are standardized and symbols are coded one unit per symbol
requires:
  - supervised-learning
  - artificial-neuron
  - activation-function
  - maximum-likelihood-estimator
defines:
  - {id: neural-network, name: neural network, anchor: a-network-is-a-graph}
  - {id: network-input-function, name: network input function, anchor: a-network-is-a-graph}
  - {id: feed-forward-network, name: feed-forward network, anchor: how-a-network-computes}
  - {id: fixed-learning-task, name: fixed learning task, anchor: what-learning-means}
  - {id: free-learning-task, name: free learning task, anchor: what-learning-means}
  - {id: sum-of-squared-errors, name: sum of squared errors, anchor: what-learning-means}
  - {id: standardization, name: standardization, anchor: preparing-the-data}
  - {id: one-hot-encoding, name: one-hot encoding, anchor: preparing-the-data}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

Neural networks started as a model of nerve cells and became a family of functions fitted to data. This note fixes the words the series uses for them: the graph, the three numbers each unit carries, the two ways a network can be run, and the two kinds of learning task. Proofs are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# Biology, taken lightly

A nerve cell collects signals on its dendrites, where neurotransmitter from other cells shifts the polarization of its membrane. When the net excitation is large enough, an action potential runs down the axon and releases neurotransmitter onto the next cells. Weighted inputs, a threshold and an all-or-none output are all that the artificial model keeps. McCulloch and Pitts (1943) turned this into a logical unit, and Rosenblatt (1958) into a unit whose weights can be learned.

The appeal is in the numbers. A human brain has about 86 billion neurons (Azevedo et al., 2009), each firing fewer than a thousand times per second, against a processor that performs billions of steps per second. The brain wins by working in parallel, and the properties engineers wanted to copy follow: speed, tolerance to damage, gradual degradation as units fail, and learning from examples.

> The tolerance is a property of distributed, redundant representations, not of every network. Morcos et al. (2018) found that trained networks that generalize well depend less on any single unit than networks that merely memorize their training set.
{: .trap}

The analogy stops there: a real neuron spikes in time and computes inside its dendrites. Read an artificial network as Haykin does, as a parallel processor of simple units that acquires knowledge by learning and stores it in the connection strengths.

# A network is a graph

A **neural network** is a directed graph $G=(U,C)$. Its vertices $u\in U$ are **units** and its edges $(v,u)\in C$ are **connections**, each with a weight $w_{uv}$. The units split into input units $U_{\text{in}}$, output units $U_{\text{out}}$ and the remaining hidden units $U_{\text{hid}}$; the first two may overlap, as in the Hopfield networks later in the course, where every unit is both.

> **Net input** $\mathrm{net}_u=f_{\text{net}}(w_u,\mathrm{in}_u)$  
> **Activation** $\mathrm{act}_u=f_{\text{act}}(\mathrm{net}_u,\theta_u)$  
> **Output** $\mathrm{out}_u=f_{\text{out}}(\mathrm{act}_u)$  
> **Input unit** $\mathrm{net}_u=\mathrm{ext}_u$
{: .margin .spec}

Every unit carries three numbers, computed in this order: its **network input function** $f_{\text{net}}$ combines the outputs $\mathrm{in}_u$ of its predecessors with the weights, the activation function $f_{\text{act}}$ turns the result into an activation, and the output function $f_{\text{out}}$ turns the activation into what successors see. Here $\theta_u$ collects the unit's own parameters, such as a threshold. An input unit has no predecessors and takes its net input from outside, as $\mathrm{ext}_u$.

{% include fig.html src="neural-networks/unit-state" id="fig-unit" alt="Outputs of three predecessor units enter a box f_net, which gives net_u; a box f_act gives act_u; a box f_out gives out_u, which goes to the successors. Under the boxes: weighted sum, step or sigmoid, identity." caption="The three functions of a unit. The threshold unit of the next note fills the boxes with a weighted sum, a step at the threshold and the identity." %}

The usual choices are a weighted sum, a step or a sigmoid, and the identity: the [artificial neuron]({{ '/notes/ai/supervised-learning/neural-networks-and-backpropagation/' | relative_url }}#the-unit) of the supervised-learning course. The architectures that follow change one of the three. Radial basis function networks replace the sum by a distance, learning vector quantization replaces the output by a winner-takes-all rule, and in a Hopfield network every unit is both input and output.

> A network model is a graph plus three functions per unit. When a new architecture appears, ask which of the three it changes.
{: .idea}

# How a network computes

If the graph has no cycle the network is a **feed-forward network**. Some unit has no predecessor, so the units can be ordered such that each depends only on earlier ones; freeze the external input and compute the units once, in that order, and the output units hold the answer. The network is then an ordinary function from the input vector to the output vector.

{% include fig.html src="neural-networks/network-graphs" id="fig-graphs" alt="Left: two input units connected to three hidden units connected to one output unit, all arrows pointing right. Right: one input unit feeds a hidden unit that is part of a cycle of three hidden units, one of which feeds the output unit." caption="An acyclic graph (left) and a graph with a cycle (right). Only the first can be evaluated by a single pass." %}

If the graph has a cycle the network is **recurrent**, and there is no last unit to compute. The network works in two phases: the input phase sets the initial activations from the external input, then the external input is switched off and any unit whose inputs changed is recomputed, until the outputs no longer change or a limit on the number of recomputations is reached. The order of the updates matters. The same weights can settle to a stable state under one order and oscillate forever under another, and whether they settle is what the Hopfield note settles with an energy function.

# What learning means

Learning changes the weights and the parameters $\theta_u$ so that a criterion improves. There are two kinds of task. A **fixed learning task** is a set of pairs $L=\{(\iota^{(l)},o^{(l)})\}$, each an input vector and the output vector we want for it; it is solved when the network produces $o^{(l)}$ from $\iota^{(l)}$ for every $l$. This is [supervised learning]({{ '/notes/ai/supervised-learning/learning-problem/' | relative_url }}#the-setting). How far a network is from solving it is measured by the **sum of squared errors**

$$ e=\sum_{l\in L}\sum_{v\in U_{\text{out}}}\big(o_v^{(l)}-\mathrm{out}_v^{(l)}\big)^2 . $$

Differences are squared so that errors of opposite sign cannot cancel and the error is smooth, which gives simple adaptation rules. There is a statistical reason too. If a target is the network's output plus Gaussian noise of constant variance $\sigma^2$, the negative log-likelihood of the data is $e/(2\sigma^2)$ plus a constant, so minimizing $e$ is maximum likelihood, the same argument that justifies [least squares]({{ '/notes/statistics/linear-regression/' | relative_url }}#least-squares) in regression.

A **free learning task** has only input vectors, $L=\{\iota^{(l)}\}$, and the method chooses the outputs. The principle that replaces the desired output is that similar inputs should give similar outputs, so that learning groups the inputs into clusters, each with its own output. Learning vector quantization and self-organizing maps solve free tasks.

# Preparing the data

Weights multiply inputs, so an input measured in thousands dominates the net input and the gradient. **Standardization** replaces each input $x_j$ by $(x_j-\bar x_j)/s_j$, with the mean and the corrected standard deviation of that input, so every input has mean 0 and standard deviation 1. LeCun et al. (1998) recommend this, and decorrelated inputs, for gradient descent.

> The mean and standard deviation come from the training set only, and the same two numbers are applied to validation and test data. Computing them on all the data lets test information leak into training.
{: .trap}

Symbolic inputs need a different treatment. Coding red, green and blue as 1, 2 and 3 tells the network that blue is further from red than green is, and that green lies between them. **One-hot encoding** (the slides say 1-in-$N$) gives each of the $N$ symbols its own input unit, set to 1 for that symbol and 0 for the others, so all symbols are at the same distance $\sqrt2$ from one another.

# Recap

<details class="qa" markdown="1">
<summary>What distinguishes one network architecture from another, given that all are graphs of units?</summary>

The choice of the three functions of the units and of the graph. A weighted sum with a step gives the threshold unit, a distance with a radial activation gives a radial basis function unit, and a winner-takes-all output gives a quantization network.
</details>

<details class="qa" markdown="1">
<summary>Why is a feed-forward network evaluated in one pass while a recurrent one may never settle?</summary>

An acyclic graph has an order in which every unit depends only on earlier units, so each is computed once. With a cycle a unit's input depends on its own earlier output, so recomputation can go on indefinitely, and the result can depend on the update order.
</details>

<details class="qa" markdown="1">
<summary>When is the sum of squared errors exactly the right error, and not just a convenient one?</summary>

When the targets are the network output plus independent Gaussian noise of constant variance: the negative log-likelihood is then proportional to the sum of squares, so minimizing it is maximum likelihood.
</details>

<details class="qa" markdown="1">
<summary>Why code three colours with three input units instead of the numbers 1, 2, 3?</summary>

Numbers impose an order and unequal distances on categories that have none. One unit per symbol makes all pairs of symbols equally far apart.
</details>
