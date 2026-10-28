---
collection: notes
title: "Radial Basis Function Network"
date: 2026-10-27
excerpt: "Hidden units that respond to distance from a centre, a two-stage fit that reduces to linear least squares, and the link to kernel ridge regression."
hook: "An RBF network answers by similarity to a set of centres: a hidden layer of bumps, then a linear layer fitted by least squares, with no backpropagation needed."
goals:
  - write the output of an RBF network and say what its centres and widths do
  - fit the output weights in closed form and choose centres and a width
  - explain when an RBF network is a kernel method and when it is an MLP in disguise
requires:
  - multilayer-perceptron
  - least-squares
  - ridge-regression
  - kernel-trick
defines:
  - {id: radial-basis-function-network, name: radial basis function network, anchor: bumps-as-features}
  - {id: rbf-centres, name: RBF centres and width, anchor: two-stage-training}
  - {id: rbf-interpolation, name: RBF interpolation, anchor: def-rbf-interpolation}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
  - Feed Forward Neural Networks
---

A multi-layer perceptron builds features from hyperplanes that stretch across the whole input space. A radial basis function network builds them from bumps that are large near a point and negligible away from it, and that one change makes training much simpler.

# Bumps as features

A **radial basis function network** has one hidden layer whose $j$-th unit depends only on the distance from the input to a centre $c_j$, and a linear output layer:

$$ \varphi_j(x)=\exp\!\Big(-\frac{\lVert x-c_j\rVert^2}{2\sigma^2}\Big),\qquad \hat y(x)=\sum_{j=1}^mw_j\,\varphi_j(x)+b. $$

Each hidden unit is a Gaussian bump of width $\sigma$, active only for inputs close to its centre, so the prediction at $x$ is a weighted vote of the centres near it. Broomhead and Lowe introduced such networks in 1988 as a way of interpolating functions {% cite broomhead-lowe-1988 %}. The contrast with the perceptron is locality: a sigmoid unit changes along a direction and is constant across a whole hyperplane, a Gaussian unit changes with distance and is constant nowhere.

# Two-stage training

The output depends on $w$ linearly once the centres and width are fixed, so training splits in two. First choose the centres $c_j$ and $\sigma$ without using the labels: a random subset of the training points, or the centres found by a clustering algorithm, with $\sigma$ set from the spread of the centres, for example $\sigma=d_{\max}/\sqrt{2m}$ where $d_{\max}$ is the largest distance between centres. Then collect $\Phi_{ij}=\varphi_j(x_i)$ and solve a linear least squares problem for the output weights,

$$ \hat w=(\Phi^\top\Phi+\lambda I)^{-1}\Phi^\top y. $$

There is no backward pass and no local minimum in $w$, which is the practical appeal. What is lost is that the centres never see the labels: a region of the input space that matters for the target but has few points gets few centres.

> Too small a width makes isolated spikes at the centres and a prediction near zero between them. Too large a width makes the bumps overlap almost completely, the columns of $\Phi$ nearly equal, and the system ill-conditioned. Choose $\sigma$ and $\lambda$ by cross-validation.
{: .trap}

# Interpolation and regularization

Put one centre at every training point, $m=n$. Then $\Phi$ is a square matrix, and for the Gaussian it is invertible whenever the points are distinct, so $\Phi w=y$ has a solution and the network passes through every training example.

> That is **RBF interpolation**, and with noisy targets it overfits in the way any exact fit does.
{: .definition #def-rbf-interpolation title="RBF interpolation"}

The ridge term $\lambda$ above is the remedy: with $m=n$ and Gaussian bumps, $\hat y(x)=\sum_iw_i\,k(x,x_i)$ with $k(x,x')=e^{-\lVert x-x'\rVert^2/2\sigma^2}$ is exactly kernel ridge regression with the Gaussian kernel, and the closed form for $w$ becomes $(K+\lambda I)^{-1}y$ with $K_{ij}=k(x_i,x_j)$.

So an RBF network with centres at the data is a kernel method, covered in [kernel methods]({{ '/notes/ai/machine-learning-foundations/kernel-methods/' | relative_url }}), and one with few centres is a low-rank version of it. The number of centres plays the role of the model's capacity.

{% capture t %}
| | MLP | RBF network |
|---|---|---|
| Hidden unit | function of a projection $w^\top x$ | function of a distance $\lVert x-c\rVert$ |
| Response | across a whole hyperplane | local around a centre |
| Training | gradient descent on all layers | clustering, then linear least squares |
| High dimension | scales better | needs many centres to cover the space |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-mlp-rbf" caption="The two feed-forward designs. Locality makes the RBF easy to train and hard to scale to many inputs." body=t %}

The last row is the curse of dimensionality in practice: covering the unit cube in $d$ dimensions with bumps of fixed width takes a number of centres that grows exponentially with $d$, while a hidden layer of hyperplane units has no such requirement.

The width of the bumps controls the fit as much as their number.

{% include fig.html src="neural-networks/rbf-width" id="fig-rbf-width" alt="Three fitted curves over nine centres: a narrow width that wiggles, a moderate width that follows the sine, and a wide width that is almost a line." caption="Radial basis fits of a noisy sine with three kernel widths. Width 0.12 follows the curve, 0.03 chases the points between centres, 0.8 cannot bend." %}

# Recap

<details class="qa" markdown="1">
<summary>Why can the output weights of an RBF network be found without backpropagation?</summary>

With the centres and width fixed, the prediction is linear in the weights, so fitting them is a linear least squares problem with a closed-form solution.
</details>

<details class="qa" markdown="1">
<summary>When is an RBF network the same as kernel ridge regression?</summary>

When there is one centre per training point, the hidden units are Gaussian and the output weights are fitted with a ridge penalty; the prediction is then a combination of Gaussian kernels centred at the data.
</details>
