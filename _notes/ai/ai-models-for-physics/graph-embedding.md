---
collection: notes
title: Graph Embedding and Similarity
date: '2026-10-27'
excerpt: Shallow node embeddings, random-walk methods and the similarity they preserve.
hook: A shallow embedding gives every node its own trainable vector with no use of its neighbours, which works for the nodes seen in training and for no others.
goals:
- write a shallow embedding as a lookup table trained against a similarity matrix
- choose the similarity from adjacency, walk counts or random-walk co-occurrence
- explain why a shallow embedding cannot produce a vector for a node that was not in training
requires:
- adjacency-matrix
- gradient-descent
defines:
- id: node-embedding
  name: node embedding
  anchor: def-node-embedding
- id: shallow-embedding
  name: shallow embedding
  anchor: def-shallow-embedding
- id: random-walk-embedding
  name: random-walk embedding
  anchor: similarity-from-random-walks
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---
A machine-learning model wants a vector for every node.

> A **node embedding** is a map from nodes to $\mathbb{R}^d$, with $d\ll n$, trained so that nodes that are similar in the graph have vectors that are close.
{: .definition #def-node-embedding title="Node embedding"}

What similar means is the modelling choice.

# Vectors that preserve similarity

Fix a similarity $s(u,v)$ between nodes and ask that the dot product of the embeddings reproduce it, $z_u^{\top}z_v\approx s(u,v)$. Stacking the embeddings as rows of $Z\in\mathbb{R}^{n\times d}$, the training problem is

$$ \min_Z\ \big\|ZZ^{\top} - S\big\|_F^2, $$

with $S$ the matrix of similarities. The simplest choice is $S=A$: nodes joined by an edge have a large product. Using $A^k$ instead counts walks of length $k$ and makes nodes that are $k$ steps apart similar, at the price of a dense matrix.

# The shallow embedding

> In a **shallow embedding** each node has its own trainable vector, a row of $Z$ read from a lookup table.
{: .definition #def-shallow-embedding title="Shallow embedding"}

Nothing about the structure of the graph enters the model beyond the loss: the vector of a node does not depend on the vectors or features of its neighbours, so each node is treated as an independent entity whose coordinates are fitted to the target.

{% include fig.html src="ai-models-for-physics/embedding-communities" id="fig-embedding-communities" alt="Graph of two groups of nodes drawn in the plane at the positions of their learned embeddings, with the two groups separated into two clusters." caption="A shallow embedding in two dimensions of a graph with two dense groups ($S=A$, trained by gradient descent). Nodes that share many neighbours end up close; edges are drawn only to show the graph." %}

The method has three limits that follow from its definition. The number of parameters is $nd$, so it grows with the graph. It uses no node features, so two nodes with identical neighbourhoods and different attributes get the same treatment. And it is **transductive**: a node that was not in the training graph has no row in $Z$, and nothing in the model says how to create one.

# Similarity from random walks

For large graphs the similarity can be defined from a random walk. In **random-walk embeddings** two nodes are similar when they appear close together on a walk started at one of them. DeepWalk {% cite perozzi-2014 %} samples uniform walks and trains vectors to predict the neighbours on the walk, as word vectors are trained from text. node2vec {% cite grover-2016 %} biases the walk with two parameters, one for returning to the previous node and one for moving outward, which interpolates between exploring a local neighbourhood and exploring far away.

> Different similarities produce different embeddings from the same graph. An embedding that preserves community membership may discard roles, such as being a hub, and the reverse.
{: .trap}

All of these methods share the lookup-table form. Replacing the table by a function that computes a node's vector from its features and its neighbours' vectors gives a graph neural network, which removes the three limits above.

# Recap

<details class="qa" markdown="1">
<summary>Why can a shallow embedding not embed a new node?</summary>

The embedding of a node is a free parameter learned during training. A new node has no such parameter and the model has no rule that computes one from its neighbours or attributes.
</details>

<details class="qa" markdown="1">
<summary>What changes when the similarity $S$ is $A^2$ instead of $A$?</summary>

Two nodes become similar if they share neighbours, not only if they are adjacent, because $(A^2)_{uv}$ counts two-step walks between them.
</details>
