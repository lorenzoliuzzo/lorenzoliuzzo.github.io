---
collection: notes
title: Graph Neural Networks and Message Passing
date: '2026-10-27'
excerpt: Neighbourhood aggregation, learnable aggregators as in GraphSAGE, and the link to convolution.
hook: A graph neural network replaces the shallow embedding by a function of a node and its neighbours, so it generalises to nodes it has never seen.
goals:
- write one message-passing layer with a learnable aggregator
- explain why the aggregation must be permutation invariant
- relate K layers to the K-hop neighbourhood and to graph convolution
requires:
- node-embedding
- convolutional-layer
- multilayer-perceptron
defines:
- id: message-passing
  name: message passing
  anchor: a-layer-is-neighbourhood-aggregation
- id: graph-convolution
  name: graph convolution
  anchor: convolution-on-a-graph
- id: permutation-invariance
  name: permutation invariance
  anchor: def-permutation-invariance
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

A shallow embedding gives each node a free vector. A graph neural network computes the vector of a node from its features and those of its neighbours, so it uses the graph and can be applied to nodes it has never seen.

# A layer is neighbourhood aggregation

Let $h_v^{(0)} = x_v$. One layer of **message passing** updates every node from its neighbourhood:

$$ h_v^{(k+1)} = \psi\!\Big(h_v^{(k)},\ \operatorname{AGG}\big(\{h_u^{(k)} : u\in\mathcal{N}(v)\}\big)\Big). $$

The aggregation gathers the vectors of the neighbours into one, and the update combines it with the node's own. The same functions are used at every node, so the number of parameters does not depend on the size of the graph. Stacking $K$ layers lets information travel $K$ edges: the vector of a node after $K$ layers depends on its $K$-hop neighbourhood, the set within distance $K$.

# The aggregation must not depend on order

The neighbours of a node have no natural order, so $\operatorname{AGG}$ takes a set.

> It must give the same result for any ordering of its inputs, which is **permutation invariance**.
{: .definition #def-permutation-invariance title="Permutation invariance"}

Sum, mean and maximum have this property. A flexible choice builds a learnable aggregator from two networks, as in GraphSAGE {% cite hamilton-2017 %}: transform each neighbour by an MLP with parameters $\phi$, sum the results and pass the sum through a second MLP with parameters $\Theta$,

$$ \operatorname{AGG}(\mathcal{N}(v)) = \Theta\Big(\sum_{u\in\mathcal{N}(v)}\phi(h_u)\Big). $$

Both sets of parameters are trained. With this form, a layer that is applied to all nodes at once is equivariant to relabelling the nodes.

> Summing over neighbours loses nothing that the node could use, since the neighbours are an unordered set. Concatenating them in some fixed order would make the output depend on the labelling.
{: .idea}

{% include fig.html src="ai-models-for-physics/message-passing" id="fig-message-passing" alt="A graph of nine nodes with one node highlighted, its direct neighbours shaded in a second colour and the nodes two steps away in a third." caption="The set that one node reads after two layers: itself, its 1-hop neighbours (first layer) and the nodes at distance two (second layer)." %}

# Convolution on a graph

An image convolution replaces each pixel by a weighted sum over its neighbours with weights shared across positions. A layer of message passing with a linear aggregator is the same operation on a graph, where the neighbourhood is defined by the edges. The graph convolutional network {% cite kipf-2017 %} uses the normalized sum

$$ H^{(k+1)} = \sigma\!\Big(\tilde D^{-1/2}\tilde A\,\tilde D^{-1/2}H^{(k)}W\Big), \qquad \tilde A = A + I, $$

where $\tilde D$ is the degree matrix of $\tilde A$, the identity adds a self-loop so a node keeps its own signal, and $W$ is a weight matrix shared by all nodes. In the spectral view of the previous note this is a low-pass filter on the node features, because averaging over neighbours suppresses high-frequency components.

# Depth has a cost

Stacking many layers makes each node read a larger and larger part of the graph, until all vectors become almost the same. This **over-smoothing** is the repeated application of a low-pass filter, and it limits the useful depth of such networks to a few layers on many graphs. A second limit is the loss of identity of structure: sum aggregation cannot tell apart some graphs that have different structure but the same local statistics.

> A graph network is better than a shallow embedding at generalising to new nodes and worse at telling apart nodes with identical neighbourhoods. The first is the reason it is used; the second is a bound on what it can represent.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why can a graph neural network embed a node that was not in the training graph?</summary>

It computes the vector from the node's features and its neighbours' vectors with functions shared by all nodes, so a new node needs no parameter of its own.
</details>

<details class="qa" markdown="1">
<summary>What does stacking $K$ message-passing layers do to the receptive field?</summary>

A node's output depends on all nodes within $K$ edges, the $K$-hop neighbourhood, because each layer carries information over one more edge.
</details>
