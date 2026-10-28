---
title: Convolutional Networks for Lattices
collection: notes
date: '2026-10-27'
tags:
- Artificial Intelligence
- AI Models For Physics
goals:
- write a periodic convolution on a lattice and show that it commutes with a shift
- distinguish equivariance from invariance and place pooling
- describe how a network classifies the phase of a spin configuration
defines:
- id: translation-equivariance
  name: translation equivariance
  anchor: equivariance-and-invariance
requires:
- convolutional-layer
- convolution
- ising-model
- order-parameter
- graph-convolution
excerpt: Why translation symmetry of a lattice model calls for convolutions, equivariance and invariance, and a network that reads spin configurations to find the phase.
hook: 'A lattice model is the same everywhere, so a network that reads it should be too: a convolution shares one kernel across the lattice and commutes with translations.'
read_time: true
---

A spin on a square lattice has the same neighbours as every other spin, and the energy of the Ising model is the same sum at every site. A network that reads a configuration should not have to learn that again for every position {% cite lecun-1998 %}.

# The same kernel at every site

On a lattice of $L$ sites with periodic boundaries, one convolutional layer computes $y_i=\sum_{j}k_j\,x_{i+j}$ with the offsets $j$ running over a small neighbourhood and the indices taken modulo $L$. The kernel $k$ has a handful of weights, whatever $L$ is, so the layer has few parameters and applies to a lattice of any size. For spin systems the periodic wrap is not a detail: a network trained on one size with wrapped padding sees the same local statistics as the physical model, with no artificial boundary.

# Equivariance and invariance

Let $T_s$ shift a configuration by $s$ sites. A map $f$ is **translation equivariant** if $f(T_sx)=T_sf(x)$: shifting the input shifts the output. A convolution has this property, because the same kernel is applied at every site and so the output at site $i$ depends only on the neighbourhood of $i$. A map is invariant if $f(T_sx)=f(x)$, which is what a classifier of phases needs, since the phase of a configuration does not depend on where the lattice was cut.

The two are joined by pooling. A stack of equivariant convolutions followed by a global sum or average gives an invariant output, because the sum over sites forgets where each contribution came from.

{% include fig.html src="ai-models-for-physics/equivariance-shift" id="fig-equivariance" alt="Four rows of twelve cells. The top row has two filled cells, the second row shows the convolution with a bump four cells wide. Rows three and four show the same input shifted by four cells and the convolution shifted with it. The sums of the two convolutions are both eight." caption="A periodic convolution with kernel $(1,2,1)$ commutes with a shift: the output of the shifted input is the shifted output. The sum over sites is the same, 8 and 8, so a global sum is invariant." %}

> Equivariance is a statement about structure, not about the amount of data. A fully connected layer can learn it only by seeing every pattern at every position, while a convolution has it by construction and needs no such data.
{: .rule}

Translations are one symmetry among those a physical model can have. Rotations and reflections of the lattice enlarge the group, and group equivariant convolutions extend the construction to them {% cite cohen-2016 %}. The Ising energy is also invariant under flipping all spins, which a network can respect by an even activation or by feeding it both $x$ and $-x$.

# Reading the phase of a spin configuration

The Ising model has an ordered phase below the critical temperature and a disordered one above it, and the magnetisation is the order parameter. A neural network can learn to tell them apart from sampled configurations. Train on configurations from temperatures well below and well above $T_c$, labelled ordered and disordered, then evaluate on intermediate temperatures. The output probability crosses one half near the transition, and the crossing, extrapolated over lattice sizes, locates $T_c$ {% cite carrasquilla-2017 %}.

The network is not given the magnetisation. For the Ising phases a single hidden layer can find it, since the output is largest when most spins agree. The interesting cases are those with no known order parameter, where the network is trained on one phase diagram and the learned decision rule is then looked at.

> A classifier trained only on the two ends of the temperature range has seen no configuration near $T_c$. Its crossing point measures where the learned boundary falls, which is a property of the training set as well as of the physics.
{: .trap}

# A lattice is a graph

A convolution on a periodic chain is a polynomial in the shift matrix, and the shift matrix is the adjacency matrix of a cycle graph up to orientation. Replacing the lattice with an arbitrary graph, and the shift with the adjacency or Laplacian matrix, gives the graph convolution of the first part of the course. What is lost is the uniform neighbourhood: on a general graph there is no way to put the kernel at a node in a canonical orientation, which is why graph networks aggregate over neighbours with a permutation-invariant operation.

{% capture t %}
| | Lattice convolution | Graph convolution |
|---|---|---|
| Neighbourhood | the same shape at every site | different at every node |
| Symmetry | translations | permutations of the nodes |
| Kernel | one weight per offset | one shared weight per aggregation |
| Parameters | independent of $L$ | independent of the node count |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-lattice-graph-conv" caption="Convolution on a lattice and on a graph." body=t %}

# Recap

<details class="qa" markdown="1">
<summary>Why does a convolution commute with translations?</summary>

The same kernel is applied at every site, so the output at a site depends only on the neighbourhood of that site. Shifting the input moves each neighbourhood, and with it each output, by the same amount.
</details>

<details class="qa" markdown="1">
<summary>How does a network become invariant to translations?</summary>

By ending an equivariant stack with a global pooling such as a sum or an average, which discards the position of each contribution.
</details>

<details class="qa" markdown="1">
<summary>How does a network locate a phase transition without being told the order parameter?</summary>

It is trained to label configurations from the two phases far from the transition and is then evaluated at intermediate temperatures. The temperature at which its output crosses one half marks the learned boundary.
</details>
