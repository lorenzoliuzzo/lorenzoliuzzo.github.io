---
collection: notes
title: "Auto-Encoder Networks"
date: 2026-10-27
excerpt: "Learning a compressed code by reconstructing the input, the exact link to PCA in the linear case, and the regularizers that keep nonlinear codes useful."
hook: "An autoencoder is trained to reproduce its input through a narrow code, so the code must keep what matters; with linear units it finds the PCA subspace, and nonlinearity buys curved coordinates."
goals:
  - write the encoder, decoder and reconstruction loss of an autoencoder
  - state what a linear autoencoder learns and how it relates to PCA
  - explain why denoising and sparsity are needed when the code is not smaller than the input
requires:
  - multilayer-perceptron
  - svd
defines:
  - {id: autoencoder, name: autoencoder, anchor: def-autoencoder}
  - {id: latent-representation, name: latent representation, anchor: def-latent-representation}
  - {id: denoising-autoencoder, name: denoising autoencoder, anchor: def-denoising-autoencoder}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

Most of the networks so far are trained to predict a label. An autoencoder needs no labels: its target is its own input, and what it learns is a compact description of the data.

# Reconstruction through a bottleneck

> An **autoencoder** has an encoder $f$ that maps an input $x\in\mathbb{R}^d$ to a code $z=f(x)\in\mathbb{R}^k$ and a decoder $g$ that maps the code back, trained to minimize the reconstruction error
{: .definition #def-autoencoder title="Autoencoder"}

$$ L=\sum_i\lVert x_i-g(f(x_i))\rVert^2. $$

> The code $z=f(x)$ is the **latent representation** of the input: a $k$-dimensional description from which the decoder rebuilds $x$.
{: .definition #def-latent-representation title="Latent representation"}

If $k<d$ the network cannot copy its input and must keep what lets it rebuild the data, so the code is a compression. Anything that has no structure, such as noise independent from sample to sample, cannot be reconstructed from a short code and is discarded.

# The linear case is PCA

Take $f$ and $g$ linear, $z=Wx$ and $\hat x=Vz$. Minimizing the squared error over $W$ and $V$ gives a reconstruction equal to the projection of the data onto the span of its $k$ leading principal components. The weights themselves are not unique, since any invertible $k\times k$ matrix can be absorbed between $W$ and $V$, but the subspace is. So a linear autoencoder rediscovers PCA, which is the singular value decomposition of the centred data matrix truncated to rank $k$.

> The nonlinear autoencoder is a generalization of PCA: the code lives on a learned curved surface instead of a flat subspace. Hinton and Salakhutdinov trained deep nonlinear autoencoders on images and text and found codes that reconstructed better than the corresponding PCA codes of the same size {% cite hinton-salakhutdinov-2006 %}.
{: .idea}

# Regularized and denoising codes

A bottleneck is not the only way to force a useful code, and it is not always possible. If $k\ge d$ and the network is flexible, it can learn the identity and the code tells nothing. Two changes restore the pressure. A **sparsity** penalty on $z$ allows a wide code but keeps most units off for any given input.

> A **denoising autoencoder** corrupts the input to $\tilde x$, for example by zeroing a random subset of entries or adding noise, and is trained to reconstruct the clean $x$ {% cite vincent-2008 %}.
{: .definition #def-denoising-autoencoder title="Denoising autoencoder"}

The identity no longer helps, because the network has to use the relations between the entries to undo the corruption, which is what the structure of the data consists of.

{% capture t %}
| Variant | What prevents the identity | Typical use |
|---|---|---|
| undercomplete | code smaller than the input | compression, visualization |
| sparse | penalty on the code activity | features for classification |
| denoising | input is corrupted, target is clean | robust features, image repair |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-autoencoders" caption="Three ways of making reconstruction a nontrivial task." body=t %}

# Uses and limits

A trained encoder gives features for a later supervised task, a low-dimensional map for visualization, and a detector for unusual inputs: an input unlike the training data reconstructs badly, so a large error flags an anomaly. The decoder alone is a poor generator of new data. Nothing makes the codes of real data fill a region of the code space, so a random code often decodes to nonsense. Variational autoencoders address this by training the code to follow a fixed distribution, which turns the decoder into a model that can be sampled.

> Reconstruction error measures how well the network copies, not how good the code is. A model with a large error on rare inputs can be the right one for anomaly detection and the wrong one if those inputs matter for the task.
{: .trap}

A one-number code makes the gap between linear and nonlinear autoencoders visible.

{% include fig.html src="neural-networks/autoencoder-pca" id="fig-autoencoder-pca" alt="Two panels of points on an arc: a straight PCA line leaves large residuals at the ends, a curved decoder leaves almost none." caption="A linear one-number code against a curved one on data along an arc. Dashed segments are reconstruction errors. The line is the best any linear autoencoder can do; the curve stands in for a trained nonlinear decoder." %}

# Recap

<details class="qa" markdown="1">
<summary>What does a linear autoencoder with squared error learn?</summary>

The subspace spanned by the top $k$ principal components, the same as PCA, though the individual weights are only determined up to an invertible transformation of the code.
</details>

<details class="qa" markdown="1">
<summary>Why does a denoising autoencoder not learn the identity even with a wide code?</summary>

Its input is corrupted and its target is the clean version, so copying the input reproduces the corruption. To reduce the error it has to use the dependencies between the entries.
</details>
