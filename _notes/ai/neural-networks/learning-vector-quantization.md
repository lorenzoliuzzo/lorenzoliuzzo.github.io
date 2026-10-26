---
collection: notes
title: "Learning Vector Quantization"
date: 2026-10-26
excerpt: "Codebook vectors that compete for each input, the attraction and repulsion rules, and soft LVQ as the online form of expectation maximization."
hook: "Learning vector quantization moves a few prototype vectors towards the data they should represent, and away from the data they should not, so the network is the nearest-prototype rule and training is a walk of the prototypes."
goals:
  - describe an LVQ network and its winner-takes-all output
  - apply the attraction and repulsion rules and say what the two-winner and window rules add
  - relate unlabelled LVQ to c-means and soft LVQ to a Gaussian mixture
requires:
  - radial-basis-function-network
  - free-learning-task
  - k-means
  - expectation-maximization
defines:
  - {id: learning-vector-quantization, name: learning vector quantization, anchor: codebook-vectors}
  - {id: winner-takes-all, name: winner takes all, anchor: competitive-learning}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

Most of the networks so far learn a fixed task: input and desired output pairs. Learning vector quantization starts from inputs alone, a [free learning task]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}#what-learning-means), where the principle is that similar inputs should give similar outputs, and then adds labels when they exist. The update rules and the link to expectation maximization are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# Codebook vectors

A **quantization** maps the input space to a few values, many to few, often a tessellation of Euclidean space. Learning vector quantization (LVQ) represents it by a set of **reference** or **codebook vectors** $r_1,\dots,r_c$. Each vector owns the region of the space closer to it than to any other, its Voronoi cell, and every input is quantized to the vector of its cell. Training adapts the coordinates of the vectors so that the cells fit the data.

The network is a two-layer feed-forward network, a [radial basis function network]({{ '/notes/ai/neural-networks/radial-basis-function-network/' | relative_url }}#the-radial-unit) whose hidden layer is used as the output layer. Each output unit $u$ has a weight vector $r_u$ and a distance as network input, then a radial activation.

# Competitive learning

The output function is not a function of one unit alone. It looks at every output unit,

$$ \mathrm{out}_u=\begin{cases}1 & \text{if } \mathrm{act}_u=\max_v\mathrm{act}_v,\\ 0 & \text{otherwise,}\end{cases} $$

with ties broken at random. This is the **winner-takes-all** principle: the units compete and only the one nearest the input answers. It is the second of the three functions of a unit that an architecture changes: the output function is now global.

> LVQ is the nearest-prototype classifier made trainable. Prediction costs one distance per prototype, and the model is as readable as its prototypes.
{: .idea}

# Learning rules

For each training pattern, find the nearest reference vector and adapt only that one, the winner. Without labels, move it towards the pattern. With labelled data, each reference vector has a class, and the winner is attracted by a pattern of its own class and repelled by one of another:

$$ r\leftarrow r+\eta\,(x-r)\quad\text{(attraction)},\qquad r\leftarrow r-\eta\,(x-r)\quad\text{(repulsion)}. $$

A fixed learning rate makes the vectors oscillate around their best positions, so the rate decreases with time, for instance $\eta(t)=\eta_0\alpha^t$ with $0<\alpha<1$. Updates can be applied after each pattern (online) or accumulated over an epoch (batch).

{% include fig.html src="neural-networks/lvq-update" id="fig-lvq" alt="Two squares each with two prototype vectors and one data point. Left: the point of class A lies on the class B side of the dashed boundary between the vectors. Right: the class A vector has moved towards the point, the class B vector has moved away, and the dashed boundary now passes on the other side of the point." caption="One step of labelled LVQ with $\eta=0.3$. The point of class A is closer to the class B vector, so that vector is repelled and the nearest class A vector is attracted, and the boundary moves across the point." %}

Two refinements address a flaw of the plain rule, which can push vectors further and further apart. The **two-winner** rule updates the two nearest vectors when they have different classes, attracting the one with the right class and repelling the other. The **window rule** updates only if the pattern is close to the classification boundary, within a window of width $\xi$ chosen by the user; once the boundary has moved far enough from the pattern the updates stop.

# Soft LVQ and EM

Hard LVQ is an online version of c-means. With no labels and $\eta=1/n_u$, where $n_u$ counts the patterns assigned to the winner $u$ so far, the attraction update is the running mean of those patterns, which is what c-means computes in batch.

**Soft LVQ** replaces the winner-takes-all by soft assignments. It assumes that the data were drawn from a mixture of normal distributions, and every reference vector is updated in proportion to the probability that the pattern came from its distribution. It is to estimating a mixture of Gaussians what hard LVQ is to c-means: the online version. The batch algorithm that estimates the mixture is **expectation maximization**: the expectation step computes, for each pattern and each distribution, the probability that the distribution generated it, and the maximization step re-estimates the parameters by maximum likelihood with these probabilities as weights. Each iteration increases the likelihood, and the algorithm converges to a local maximum.

> Hard assignment turns the EM algorithm into c-means. The two answer the same question, and the soft version is the one with a likelihood to maximize and to compare across models.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What makes the output function of an LVQ network different from other networks?</summary>

It depends on all output units: only the unit with the largest activation outputs 1, the others 0, so the network is a nearest-prototype rule.
</details>

<details class="qa" markdown="1">
<summary>Why does the repulsion rule help a labelled LVQ network?</summary>

A winner of the wrong class is moving the boundary into the wrong region. Pushing it away from the pattern, and the right-class neighbour towards it, moves the boundary across the pattern.
</details>

<details class="qa" markdown="1">
<summary>In what sense is soft LVQ an online version of EM?</summary>

Both give each pattern a probability of belonging to each normal distribution. Soft LVQ adjusts the vectors a little at a time per pattern, where EM re-estimates the parameters from all patterns at once.
</details>
