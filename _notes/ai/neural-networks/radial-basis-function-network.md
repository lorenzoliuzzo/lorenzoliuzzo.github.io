---
collection: notes
title: "Radial Basis Function Networks"
date: 2026-10-26
excerpt: "Units that answer to the distance from a centre, how a sum of such bumps approximates a function, and how centres, radii and output weights are chosen and trained."
hook: "A radial unit responds to inputs near its centre and ignores the rest, so a radial network builds a function from local bumps, and its output weights are a linear least-squares problem."
goals:
  - write the output of a radial basis function network and name its three kinds of parameter
  - compute the output weights by interpolation or by the pseudo-inverse
  - run c-means to place the centres and say what the three training phases are
  - contrast a radial unit with a sigmoid unit
requires:
  - network-input-function
  - feed-forward-network
  - k-means
  - least-squares
  - gradient-descent
  - sum-of-squared-errors
defines:
  - {id: radial-basis-function-network, name: radial basis function network, anchor: the-radial-unit}
  - {id: radial-activation-function, name: radial activation function, anchor: the-radial-unit}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

A sigmoid unit answers along a direction: its output depends on which side of a hyperplane the input lies. A radial unit answers by proximity. This changes one of the three functions of a unit, the network input, and gives a network that is local, easy to initialize and, for the output weights, linear. Derivations are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# The radial unit

A **radial basis function network** is a feed-forward network with three layers. Each hidden unit $k$ has a centre $c_k$, its weight vector, and its network input is the distance $d(c_k,x)$ from the input. The distance is a metric: zero only at the centre, symmetric, and satisfying the triangle inequality. The usual family is the Minkowski distance $d_p(x,y)=(\sum_i\lvert x_i-y_i\rvert^p)^{1/p}$, the city-block distance for $p=1$, the Euclidean for $p=2$ and the maximum distance as $p\to\infty$.

The **radial activation function** is a monotonically decreasing $f:[0,\infty)\to[0,1]$ with $f(0)=1$ and $f(r)\to0$ as $r\to\infty$, evaluated at the distance scaled by a reference radius $\sigma_k$ that sets the size of the catchment region. The Gaussian $f(r)=e^{-r^2/2}$ is the standard. Output units use the weighted sum and a linear activation:

$$ y(x)=\theta+\sum_{k=1}^m w_k\,f\!\left(\frac{d(c_k,x)}{\sigma_k}\right). $$

> Three kinds of parameter: **centres** $c_k$ place the bumps, **radii** $\sigma_k$ set their width, **weights** $w_k$ set height and sign.
{: .margin .spec}

With a Gaussian, the centres fix the locations of the bumps and the output weights fix their heights, upward or downward. A logical function is the simplest example: a unit centred at $(1,1)$ with a small radius is the conjunction, and the biimplication is the sum of units at $(0,0)$ and $(1,1)$.

# Approximating a function

The lectures approximate a function by pulses, rectangular or triangular, one per unit, and then by Gaussians, which are smooth. With centres on a grid and a radius a little under the spacing, each unit adds one bump of the right height, and fewer or wider bumps leave gaps.

{% include fig.html src="neural-networks/rbf-fit" id="fig-rbf" alt="Two plots of a smooth curve with a blue network output and dashed single-unit contributions. With four Gaussian units the output is close to the curve with a largest error of 0.08. With nine units the output is nearly on the curve, with a largest error of 0.02." caption="Gaussian units on a regular grid with radius $0.6$ times the spacing, output weights by least squares. The largest error is $0.08$ with 4 units and $0.02$ with 9." %}

Gaussian networks, like sigmoid ones, can approximate any continuous function on a compact set (Park and Sandberg, 1991). The difference is where the units act: a sigmoid unit changes the function everywhere along its direction, a radial unit only near its centre, so adding a unit leaves the fit elsewhere unchanged. The price is that in many dimensions a grid of centres is impossible, and the centres must follow the data.

# Weights by linear algebra

Fix the centres and radii and the network is linear in the weights. For a fixed learning task with $m$ patterns, place one unit on each pattern and choose the radius from the largest distance $d_{\max}$ between two patterns, $\sigma=d_{\max}/\sqrt{2m}$. The condition that the network reproduce every desired output is a linear system $A\,w=o$, where $A_{lk}=f(d(c_k,\iota^{(l)})/\sigma)$ and $\theta=0$. For Gaussians with distinct centres $A$ is invertible (Micchelli, 1986), so $w=A^{-1}o$ interpolates the data exactly, and for the biimplication this initialization already solves the task.

Exact interpolation of $m$ patterns with $m$ units is costly and fits the noise. With a subset of $k<m$ centres the system is over-determined, and the solution of least error is the **pseudo-inverse**, $w=(A^{\top}A)^{-1}A^{\top}o$, with a column of ones in $A$ for $\theta$. This is ordinary [least squares]({{ '/notes/statistics/linear-regression/' | relative_url }}#least-squares) on the radial features.

# Centres and training

The centres can be all data points, which is exact but infeasible for large sets, a random subset, which is fast but depends on luck, or the result of clustering. **c-means** is the standard: choose $c$, place the centres at random, assign every point to the nearest centre, move each centre to the mean of its points, and repeat until the centres stop moving. The [k-means]({{ '/notes/ai/unsupervised-learning/cluster-analysis/algorithms/' | relative_url }}) algorithm of the unsupervised course is the same, and learning vector quantization, the next note, is another way to choose centres.

Training then has up to three phases: one finds the output weights with the pseudo-inverse, two first places the centres by clustering, three follows with gradient descent on all parameters. The gradients are those of a multi-layer perceptron with the radial unit's derivative. For a Gaussian unit with squared distance $d_k^2$ and output $a_k$, the error derivatives with respect to a centre and a radius carry the factors $(x-c_k)/\sigma_k^2$ and $d_k^2/\sigma_k^3$.

> A radial network is not the *RBF kernel* machine of the supervised-learning course. A kernel machine puts a Gaussian on every training point and takes its weights from the learning problem, sparse for a support vector machine, while a radial network chooses a few centres and trains their positions.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is a radial network easier to initialize than a multi-layer perceptron?</summary>

With centres and radii fixed the output is linear in the weights, so they solve a least-squares problem in one step, where a sigmoid network needs gradient descent from a random start.
</details>

<details class="qa" markdown="1">
<summary>What does a radial unit do that a sigmoid unit does not?</summary>

It responds only near its centre, so it changes the function locally, while a sigmoid unit changes it everywhere along one direction.
</details>

<details class="qa" markdown="1">
<summary>Why is the pseudo-inverse used when there are fewer centres than patterns?</summary>

The linear system has more equations than unknowns and no exact solution, and the pseudo-inverse gives the weights of least squared error.
</details>
