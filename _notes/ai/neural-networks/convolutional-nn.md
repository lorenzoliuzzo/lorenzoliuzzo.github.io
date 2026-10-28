---
collection: notes
title: "Convolutional Neural Networks"
date: 2026-10-27
excerpt: "Local connections and shared weights, the arithmetic of convolution and pooling, and how receptive fields grow with depth."
hook: "A convolutional layer is a fully connected layer forced to apply the same small filter at every position, which removes almost all its parameters and builds in that a pattern means the same wherever it appears."
goals:
  - compute the output size and parameter count of a convolutional layer
  - explain translation equivariance and the role of pooling
  - find the receptive field of a unit in a stack of layers
requires:
  - multilayer-perceptron
  - convolution
defines:
  - {id: convolutional-layer, name: convolutional layer, anchor: def-convolutional-layer}
  - {id: weight-sharing, name: weight sharing, anchor: two-constraints}
  - {id: pooling, name: pooling, anchor: def-pooling}
  - {id: receptive-field, name: receptive field, anchor: def-receptive-field}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

A fully connected layer treats an image as a list of unrelated numbers. Images are not like that: neighbouring pixels are related, and an edge is an edge wherever it sits. Convolutional networks are what you get when those two facts are written into the architecture.

# Two constraints

Connect each output unit only to a small window of the input, and give every window the same weights.

> These are the two constraints, **local connectivity** and **weight sharing**, and a layer that obeys them is a **convolutional layer**.
{: .definition #def-convolutional-layer title="Convolutional layer"}

A single filter is a small array of weights $w$ of size $k\times k$ slid over the image, with output at position $(i,j)$

$$ y_{ij}=\varphi\Big(b+\sum_{a=0}^{k-1}\sum_{b'=0}^{k-1}w_{ab'}\,x_{i+a,\,j+b'}\Big). $$

Strictly this is a cross-correlation, and the flipped version is the convolution of signal processing, but the filter is learned, so the difference does not matter. The saving is large. Mapping a $224\times224$ RGB image, which has $150{,}528$ values, to $64$ feature maps of the same spatial size with a fully connected layer takes about $4.8\times10^{11}$ weights. A convolutional layer with $3\times3$ filters needs $(3\cdot3\cdot3+1)\cdot64=1{,}792$.

> Sharing weights makes the layer **translation equivariant**: shift the input and the feature map shifts by the same amount. A detector learned in one corner works everywhere, and the training signal from every position updates the same weights.
{: .idea}

# Feature maps and their arithmetic

A layer has several filters, each producing a **feature map**, and a filter spans all input channels. A layer with $C_{\text{in}}$ input channels, $C_{\text{out}}$ filters of size $k\times k$ has $(k^2C_{\text{in}}+1)C_{\text{out}}$ parameters regardless of the image size. The spatial size of the output depends on padding $p$ and stride $s$:

$$ n_{\text{out}}=\Big\lfloor\frac{n+2p-k}{s}\Big\rfloor+1. $$

A $32\times32$ input with $5\times5$ filters, no padding and stride 1 gives $28\times28$ maps, as in the first layer of LeNet-5 {% cite lecun-1998 %}. Padding by $(k-1)/2$ keeps the size, and a stride of 2 halves it.

# Pooling and receptive fields

> **Pooling** replaces each small window of a feature map by one number, usually the maximum or the mean.
{: .definition #def-pooling title="Pooling"}

It shrinks the maps, so later layers are cheaper, and it makes the output insensitive to small shifts of the input, since a feature that moves by a pixel inside a pooling window leaves the maximum unchanged. The idea of alternating feature detection with this kind of pooling goes back to Fukushima's neocognitron {% cite fukushima-1980 %}.

> The **receptive field** of a unit is the set of input pixels that can affect it.
{: .definition #def-receptive-field title="Receptive field"}

One $3\times3$ layer gives $3\times3$; a second $3\times3$ layer on top sees $5\times5$; in general $L$ stacked $3\times3$ layers with stride 1 see $(2L+1)\times(2L+1)$, and strides and pooling make it grow faster. This is why depth matters: early layers respond to edges and textures in small windows, and units deep in the stack respond to parts and objects because they see a large region.

{% capture t %}
| Layer | Maps and size | Parameters |
|---|---|---|
| input | $3\times224\times224$ | 0 |
| conv $3\times3$, 64 filters, $p=1$ | $64\times224\times224$ | 1,792 |
| max pool $2\times2$, stride 2 | $64\times112\times112$ | 0 |
| conv $3\times3$, 128 filters, $p=1$ | $128\times112\times112$ | 73,856 |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-conv-sizes" caption="The size and parameter count of a small stack. Pooling halves each side and has no weights; the second layer has $(9\cdot64+1)\cdot128$ parameters." body=t %}

# Training

Backpropagation works unchanged through a convolutional layer. The only difference is that a shared weight appears at every position, so its gradient is the sum of the contributions from all positions. The first network trained end to end on images in this way, with gradient descent, was LeNet-5 for handwritten digits {% cite lecun-1998 %}. What changed in 2012 was scale: a deeper network with ReLU activations, trained on a large dataset on GPUs, won the ImageNet challenge by a wide margin {% cite krizhevsky-2012 %}, and convolutional networks became the default for vision.

> Translation equivariance is a property of the convolution, not of the whole network. Pooling with a stride, and padding at the borders, break exact equivariance, so classifiers are only approximately invariant to shifts.
{: .trap}

Depth, not kernel size, is what lets a unit see a large part of the input.

{% include fig.html src="neural-networks/receptive-field" id="fig-receptive-field" alt="A pyramid of nodes: each unit connects to three below, and the number of inputs it sees grows from 3 to 5 to 7 with depth." caption="Receptive field growth in a stack of width-3 convolutions. Follow one output unit down: it sees 3, then 5, then 7 inputs, while each layer still uses only width-3 kernels." %}

# Recap

<details class="qa" markdown="1">
<summary>Why does a convolutional layer have so few parameters compared with a fully connected one?</summary>

Each output depends only on a small window, and the same filter is reused at every position, so the parameter count depends on the filter size and the number of channels, not on the image size.
</details>

<details class="qa" markdown="1">
<summary>How big is the receptive field of a unit after three $3\times3$ layers with stride 1?</summary>

$7\times7$, since each added layer widens it by two pixels, giving $2L+1$ with $L=3$.
</details>
