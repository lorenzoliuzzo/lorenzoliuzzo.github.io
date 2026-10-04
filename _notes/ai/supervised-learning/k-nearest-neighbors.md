---
collection: notes
title: "k-Nearest Neighbors"
date: 2026-10-04
excerpt: "A classifier with no training step that predicts from the k closest training points, with k as the one knob between a jagged boundary and a flat one."
hook: "k-NN has no training step because the training set is the model, and k is the only dial between a jagged boundary and a flat one."
goals:
  - classify and regress with k-NN
  - choose k on validation data and say what small and large k do
  - explain why k-NN weakens as the number of features grows
requires:
  - overfitting
  - validation-set
defines:
  - {id: k-nearest-neighbors, name: k-nearest neighbors, anchor: the-method}
  - {id: lazy-learning, name: lazy learning, anchor: the-method}
  - {id: curse-of-dimensionality, name: curse of dimensionality, anchor: when-nearest-stops-meaning-anything}
read_time: true
tags:
  - Supervised Learning
  - Classic learners
---

The learners so far fit parameters to the data and then forget it. k-nearest neighbors does the opposite: it keeps the data and does all its work when asked for a prediction.

# The method

The **k-nearest neighbors** (k-NN) algorithm rests on the idea that objects close in the input space are likely to have similar outputs. To predict for a new instance, find the $k$ training instances closest to it, usually in Euclidean distance. For classification the prediction is the majority label among them, and for regression it is their average. With $k=1$ this is the *nearest neighbor classifier*.

There is no training step, only storing the data, which is why k-NN is called **lazy learning**. All the cost is paid at prediction time, where the distance to every stored instance must be computed.

Two practical points come with the distance. Features on large scales dominate it, so they are standardized first. And the distance treats every feature as equally relevant, so irrelevant features add noise to it.

# Choosing k

The number $k$ is a hyper-parameter and sets the flexibility of the model. With $k=1$ the boundary follows every training point, including noisy ones, and the training error is zero because each point is its own nearest neighbor. As $k$ grows the vote averages over more points and the boundary smooths. At $k$ equal to the size of the training set the prediction is always the majority class.

{% include fig.html src="supervised-learning/knn-error" id="fig-knn" alt="Training and test error of k-nearest neighbors against k from 1 to 99 on a two-class problem. The training error is zero at k equal to 1 and rises. The test error is 0.09 at k equal to 1, between 0.06 and 0.07 for k from 5 to 27, and climbs to 0.23 for k equal to 99." caption="At $k=1$ the training error is zero but the test error is not. The test error is lowest for moderate $k$ and rises when the neighborhood grows too large to follow the boundary." %}

The curve is the familiar one: too small a $k$ overfits, too large a $k$ underfits, and a [validation set]({{ '/notes/ai/supervised-learning/validation-and-cross-validation/' | relative_url }}) picks the value in between.

# When nearest stops meaning anything

k-NN needs its neighbors to be near. In high dimension they are not. If the data are uniform in the unit cube, a cubic neighborhood that holds a fraction $r$ of the points has edge length $r^{1/d}$ in $d$ dimensions.

| Dimension $d$ | 2 | 10 | 100 |
|---|---:|---:|---:|
| Edge length for 1% of the data | 0.10 | 0.63 | 0.96 |
{: .keyed}

In ten dimensions the "local" neighborhood that contains 1% of the data spans 63% of the range of every feature, and in a hundred it is nearly the whole cube. At the same time the distances to the nearest and farthest points become almost equal, so the ranking by distance carries little information. This is the **curse of dimensionality**.

> k-NN with many features is only as good as the distance. Selecting or learning relevant features first, or reducing the dimension, often helps more than tuning $k$.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the training error of 1-NN always zero, and why is that no comfort?</summary>

Each training point is its own nearest neighbor, so it is always classified correctly. The number says nothing about new points, where the jagged boundary that follows the noise does worse.
</details>

<details class="qa" markdown="1">
<summary>What happens as $k$ grows to the size of the training set?</summary>

The vote is always the majority class of the whole training set, the boundary disappears, and the model underfits completely.
</details>

<details class="qa" markdown="1">
<summary>Why does k-NN struggle in high dimension?</summary>

A neighborhood holding a fixed fraction of the data must cover most of the range of every feature, so it is no longer local, and all points become almost equally far away.
</details>
