---
collection: notes
title: "Autoencoders"
date: 2026-10-26
excerpt: "A network trained to reproduce its input through a narrow code, what a linear one learns, the sparse and denoising variants, and stacking them with layer-wise pre-training."
hook: "An autoencoder is trained on a task with no labels, reconstructing its own input, and the code it is forced to use in between is the representation we want."
goals:
  - define an autoencoder and say why its code must be constrained
  - show that a linear autoencoder spans the principal subspace
  - tell the sparse and denoising variants apart and say what each constrains
  - describe layer-wise training of a stacked autoencoder and the fine-tuning step
requires:
  - multilayer-perceptron
  - back-propagation
  - principal-component-analysis
  - sum-of-squared-errors
  - free-learning-task
defines:
  - {id: autoencoder, name: autoencoder, anchor: the-bottleneck}
  - {id: denoising-autoencoder, name: denoising autoencoder, anchor: variants}
  - {id: stacked-autoencoder, name: stacked autoencoder, anchor: stacking}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

Labels are expensive and inputs are cheap. An autoencoder uses the input as its own target, so the training set needs no labels, and the features it learns can be handed to a classifier trained on the few examples that have them. The statement and proof of the linear case are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# The bottleneck

An **autoencoder** is a three-layer perceptron that maps its input $x$ to an approximation $\hat x$ of $x$. The hidden layer is the **encoder**: it computes a code $f=\varphi(W_1x-b_1)$. The output layer is the **decoder**: it reconstructs $\hat x=\psi(W_2f-b_2)$. The network is trained by back-propagation on the reconstruction error $\sum_l\lVert x^{(l)}-\hat x^{(l)}\rVert^2$, a [free learning task]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}#what-learning-means) whose desired outputs are the inputs. Afterwards only the encoder is kept, and the code $f$ is the feature vector.

The hidden layer is expected to find features that carry the information of the input in compressed form, so that the decoder can recover it. That works only if the code cannot simply copy the input: with as many hidden units as inputs, or more, the cheapest solution is to pass every input through unchanged and learn nothing.

> An autoencoder that can copy its input will copy it. The code must be constrained, by size, by sparsity or by noise, and every variant below is a different constraint.
{: .trap}

# What a linear autoencoder learns

Take identity activations and a code of $k<d$ units. Then the network computes $\hat x=W_2W_1x$, a matrix of rank at most $k$. Among all such matrices, the one that minimizes the squared reconstruction error of centred data is the orthogonal projection onto the $k$ directions of largest variance, the first $k$ [principal components]({{ '/notes/statistics/pca-factor-analysis/' | relative_url }}#principal-components). This is the Eckart-Young theorem applied to the data matrix.

{% include fig.html src="neural-networks/autoencoder" id="fig-autoencoder" alt="Left, a network with four input units, two code units in the middle and four output units, with the connections drawn between consecutive layers. Right, an elongated cloud of open points with a line through it along its long axis and filled points on the line, the reconstructions, joined to the open points by short dashed segments." caption="A 4-2-4 network (left) and a linear autoencoder with a one-unit code on two-dimensional data (right): each input is replaced by its projection on the first principal axis." %}

The linear case also says what the nonlinear one adds. The weights are not unique, since any invertible change of coordinates inside the code gives the same reconstruction, so the code spans a subspace and does not fix a basis. With nonlinear units the code can follow a curved surface through the data, which the straight principal axes cannot.

# Variants

A code narrower than the input, as above, is the simplest constraint and the first remedy of the lectures: the **sparse autoencoder** has considerably fewer hidden units than inputs, which forces it to learn the relevant features. A second reading of sparse limits the number of active hidden units to a few, on average, by adding a penalty on the mean activation of each unit, which allows a wide code that only a few units use at a time.

The **denoising autoencoder** keeps the code wide and changes the task instead. Noise is added to the input, by random variations or by setting a random subset of components to zero, and the network must reconstruct the clean input. Copying no longer works, because the copy would contain the noise, and the code has to capture the structure that survives it.

# Stacking

Deep networks were hard to train, as the previous note showed, and autoencoders gave the first workable remedy. In a **stacked autoencoder** the network is built layer by layer, and only the newly added layer is trained at each step.

The first autoencoder is trained on the raw inputs and its code gives primary features. A second autoencoder is trained on those features and gives secondary features. A classifier or predictor for the target is trained on the last features. Finally the encoders are stacked, with the classifier on top, and the whole network is **fine-tuned** with back-propagation.

> Layer-wise pre-training puts the weights of a deep network in a good region before the global training starts. Rectified units, better initialization and more data later made it unnecessary for most tasks, but the idea of a learned code survives in representation learning.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why must an autoencoder's code be constrained?</summary>

Otherwise the cheapest way to reconstruct the input is to copy it through, and the hidden layer learns no feature.
</details>

<details class="qa" markdown="1">
<summary>What does a linear autoencoder with a $k$-unit code learn?</summary>

The projection onto the first $k$ principal components, which has the smallest squared reconstruction error among all rank-$k$ linear maps.
</details>

<details class="qa" markdown="1">
<summary>How does a denoising autoencoder avoid copying without a narrow code?</summary>

Its input is corrupted and its target is the clean input, so a copy reproduces the noise and is penalized.
</details>
