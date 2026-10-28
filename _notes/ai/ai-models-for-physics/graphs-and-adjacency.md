---
collection: notes
title: Graphs and Their Representation
date: '2026-10-27'
excerpt: Nodes, edges, adjacency and degree matrices, features on nodes, and counting walks with powers of the adjacency matrix.
hook: A graph is stored as an adjacency matrix, and the k-th power of that matrix counts the walks of length k, which is how structure first enters a model.
goals:
- build the adjacency and degree matrices of a graph from its edges
- count walks of a given length with matrix powers
- explain why a function on graphs must not depend on the order of the nodes
defines:
- id: graph
  name: graph
  anchor: def-graph
- id: adjacency-matrix
  name: adjacency matrix
  anchor: def-adjacency-matrix
- id: walk-count
  name: walk count
  anchor: def-walk-count
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

Physics and machine learning both meet graphs wherever the objects are related by pairs: atoms bonded to atoms, spins coupled to spins, users linked to users. This note fixes the notation of the first part of the course.

# Nodes, edges and features

> A **graph** $G=(V,E)$ is a set of $n$ nodes and a set of edges, each edge a pair of nodes.
{: .definition #def-graph title="Graph"}

A **feature vector** $x_v\in\mathbb{R}^f$ can be attached to every node, and the features of all nodes are the rows of an $n\times f$ matrix $X$. In a molecule the nodes are atoms, the edges are bonds and $x_v$ encodes the element; in a spin lattice the edges are the couplings. The graph holds the relations and the features hold the content, and a model for graph data has to use both.

Two quantities describe how connected a node is: its neighbourhood $\mathcal{N}(v)$, the nodes joined to it by an edge, and its degree $k_v = |\mathcal{N}(v)|$. The 1-hop neighbourhood is the set at distance one, and the $r$-hop neighbourhood the set within distance $r$.

# The adjacency matrix

> The **adjacency matrix** $A\in\{0,1\}^{n\times n}$ has $A_{uv}=1$ if $(u,v)\in E$ and 0 otherwise.
{: .definition #def-adjacency-matrix title="Adjacency matrix"}

For an undirected graph it is symmetric. The degree matrix $D$ is diagonal with $D_{vv}=k_v$, so $k_v = \sum_uA_{vu}$. Weighted graphs replace the 1 by the weight of the edge.

# Powers count walks

The entry of $A^2$ is $(A^2)_{uv} = \sum_wA_{uw}A_{wv}$, and each term is 1 exactly when there is an edge from $u$ to $w$ and an edge from $w$ to $v$, which is a walk of length two through $w$. Summing over $w$ gives the number of such walks.

> The same argument extends by induction: $(A^k)_{uv}$ is the number of walks of length $k$ from $u$ to $v$, a **walk count**.
{: .definition #def-walk-count title="Walk count"}

{% include fig.html src="ai-models-for-physics/adjacency-powers" id="fig-adjacency-powers" alt="A six-node graph on the left, its six by six adjacency matrix of zeros and ones in the middle, and the matrix of its square on the right with a highlighted entry." caption="A six-node graph, its adjacency matrix $A$ and $A^2$. The highlighted entry of $A^2$ counts the two-step walks between a pair of nodes; the diagonal of $A^2$ is the degree." %}

The diagonal of $A^2$ is the degree, since the walks from a node back to itself in two steps go out along an edge and return along the same one. The diagonal of $A^3$ counts the triangles through each node, each triangle twice, one for each direction.

> A walk may revisit nodes and edges, so $(A^k)_{uv}$ counts more than the paths of length $k$. For $k=2$ the two coincide on pairs of distinct nodes.
{: .trap}

# The order of the nodes is arbitrary

Relabelling the nodes by a permutation matrix $P$ changes the description to $A\to PAP^{\top}$ and $X\to PX$, but it is the same graph. A function that is to describe the graph must not depend on the labels. A function giving one number for the whole graph should be **invariant**, $f(PAP^{\top},PX)=f(A,X)$, and a function giving a value per node should be **equivariant**, with the output permuted by $P$. This constraint is why an image network, which reads pixels in a fixed order, does not apply directly to graphs, and it sets the requirement that the graph networks of the later notes are built to satisfy.

# Recap

<details class="qa" markdown="1">
<summary>What does the $(u,v)$ entry of $A^3$ count?</summary>

The walks of length three from $u$ to $v$, summed over both intermediate nodes. On the diagonal it counts closed walks of length three, which are the triangles through $u$ counted once in each direction.
</details>

<details class="qa" markdown="1">
<summary>Why must a function on graphs be invariant or equivariant under permutations?</summary>

The numbering of the nodes is a choice of the description and carries no information, so a result that changed when the nodes were renumbered would be a property of the labelling and not of the graph.
</details>
