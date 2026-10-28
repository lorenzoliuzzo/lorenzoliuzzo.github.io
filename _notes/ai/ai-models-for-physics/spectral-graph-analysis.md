---
collection: notes
title: Spectral Analysis of Graphs
date: '2026-10-27'
excerpt: Eigenvectors of the adjacency matrix and the Laplacian, eigenvector centrality and the spectral view of smoothness.
hook: The eigenvectors of the Laplacian are the Fourier modes of the graph, and eigenvector centrality is the dominant eigenvector of the adjacency matrix.
goals:
- write the graph Laplacian and its quadratic form
- compute eigenvector centrality as a principal eigenvector
- explain why the eigenvectors of the Laplacian play the part of Fourier modes on a graph
requires:
- adjacency-matrix
- spectral-theorem
- eigenvalue
defines:
- id: eigenvector-centrality
  name: eigenvector centrality
  anchor: def-eigenvector-centrality
- id: graph-laplacian
  name: graph Laplacian
  anchor: def-graph-laplacian
- id: graph-signal
  name: graph signal
  anchor: def-graph-signal
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

A graph is a matrix, and the structure of a symmetric matrix is in its eigenvectors. Two of the matrices built from the graph, the adjacency matrix and the Laplacian, lead to a notion of importance of a node and a notion of smooth variation across the graph.

# Importance as an eigenvector

Counting neighbours measures a node by its degree.

> **Eigenvector centrality** gives a node a high score when it is joined to nodes that themselves score high: the score $c_v$ is proportional to the sum over neighbours, $\lambda c_v = \sum_uA_{vu}c_u$.
{: .definition #def-eigenvector-centrality title="Eigenvector centrality"}

In matrix form $Ac=\lambda c$, and the scores are the components of an eigenvector of $A$. The Perron-Frobenius theorem guarantees that for a connected graph the eigenvector of the largest eigenvalue has all components positive, so the centrality is the principal eigenvector, up to scale.

> Power iteration computes it: start from any positive vector and apply $A$ repeatedly, normalizing each time. Each application sums scores over 1-hop neighbourhoods, and the iteration converges to the principal eigenvector.
{: .rule}

# The Laplacian and smoothness

> The **graph Laplacian** is $L = D - A$.
{: .definition #def-graph-laplacian title="Graph Laplacian"}

> A **graph signal** is a function $x:V\to\mathbb{R}$, one number per node.
{: .definition #def-graph-signal title="Graph signal"}

Its quadratic form measures how much the signal varies across edges:

$$ x^{\top}Lx = \sum_{(u,v)\in E}(x_u - x_v)^2. $$

The form is nonnegative, so $L$ is positive semidefinite, and the constant vector has $x^{\top}Lx=0$, which makes 0 the smallest eigenvalue. The eigenvalues $0=\lambda_1\le\lambda_2\le\dots$ order the eigenvectors by how fast they vary: a small eigenvalue belongs to a signal that changes little along edges. The number of zero eigenvalues is the number of connected components, and $\lambda_2$ is large for a well-connected graph.

# Fourier modes on a graph

On a path graph of $n$ nodes the eigenvectors of $L$ are cosines of increasing frequency. The eigenvalue grows with the number of sign changes of the vector, so the Laplacian eigenbasis plays the part of the Fourier basis on a general graph. Expanding a signal in this basis is a **graph Fourier transform**, and multiplying its coefficients by a function of the eigenvalue is a filter. This is the starting point for defining convolution on graphs.

{% include fig.html src="ai-models-for-physics/laplacian-modes" id="fig-laplacian-modes" alt="Left: three curves over the nodes of a path graph, the first three nonconstant Laplacian eigenvectors, which look like cosines with one, two and three half-waves. Right: a graph of two dense groups with nodes coloured by the sign of the second eigenvector, one colour per group." caption="Left: the three lowest nonconstant Laplacian eigenvectors of a 20-node path are cosines. Right: on a graph with two dense groups, the sign of the eigenvector of $\lambda_2$ splits the groups." %}

The second eigenvector, the Fiedler vector, has the smallest variation that is not constant. When the graph has two dense groups joined by a few edges, a vector that is positive on one group and negative on the other varies only across the few connecting edges, so it nearly minimizes the quadratic form, and the sign of the Fiedler vector recovers the groups. This is the basis of spectral clustering.

> The adjacency matrix and the Laplacian have different eigenvectors unless every node has the same degree. Centrality uses the top of the spectrum of $A$; smoothness uses the bottom of the spectrum of $L$.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is the eigenvector of the largest eigenvalue of $A$ a good importance score?</summary>

The equation $\lambda c = Ac$ says a node's score is proportional to the sum of its neighbours' scores, so a node is important when its neighbours are, and for a connected graph the solution is positive and unique.
</details>

<details class="qa" markdown="1">
<summary>What does a small eigenvalue of the Laplacian say about its eigenvector?</summary>

The quadratic form $x^{\top}Lx$ equals $\lambda\|x\|^2$ for an eigenvector, so a small eigenvalue means the signal differs little between neighbouring nodes, that is, it is smooth on the graph.
</details>
