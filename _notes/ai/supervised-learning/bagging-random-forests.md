---
collection: notes
title: "Bagging and Random Forests"
date: 2026-10-04
excerpt: "Bootstrap samples make the trees differ, averaging cancels their variance, the left-out examples give a free test error, and a random forest adds a random feature subset at every split."
hook: "Resample the data to get different trees and average them to cancel the variance, and the examples each tree never saw give a free estimate of the test error."
goals:
  - build a bagged ensemble and aggregate it by voting or averaging
  - compute the out-of-bag estimate of the generalization error
  - say what a random forest adds to bagging and what its parameter K controls
requires:
  - decision-tree
  - ensemble
  - base-learner
defines:
  - {id: bootstrap, name: bootstrap, anchor: the-bootstrap-sample}
  - {id: bagging, name: bagging, anchor: bagging}
  - {id: out-of-bag-error, name: out-of-bag error, anchor: out-of-bag-error}
  - {id: random-forest, name: random forest, anchor: random-forests}
read_time: true
tags:
  - Supervised Learning
  - Ensembles
---

The parallel way to build an ensemble needs base learners that differ, and the only data available is the one training set. Bagging gets different learners out of it by resampling.

# The bootstrap sample

Disjoint subsets of the data would give independent learners, but with finite data each subset is small and unrepresentative, and the learners trained on them are poor. The **bootstrap** gets many different samples from one data set: draw $m$ examples *with replacement* from the $m$ training examples. Some originals appear several times in the sample, and some not at all.

The chance that a given example is missed by all $m$ draws is $(1-1/m)^m$, which tends to $1/e\approx0.368$. Each bootstrap sample therefore contains about 63.2% of the distinct training examples, and about 36.8% are left out. (The number of times a given example is drawn is approximately Poisson with mean 1.)

# Bagging

**Bagging** (bootstrap aggregating) draws $T$ bootstrap samples $\mathcal{D}\_{bs}^{(1)},\dots,\mathcal{D}\_{bs}^{(T)}$, trains a base learner $h\_t$ on each, and aggregates the outputs: by voting for classification, $H(x)=\arg\max\_{y}\sum\_{t=1}^{T}\mathbb{I}(h\_t(x)=y)$, and by averaging for regression. It handles binary and multiclass problems alike, and the $T$ learners train independently, so in parallel.

Averaging cancels the part of the error that comes from the learner's sensitivity to the particular sample, its variance. Bagging therefore helps **unstable** learners, those where small changes in the data change the model a lot, such as decision trees and neural networks. It does little for stable ones such as k-NN, which have little variance to average away.

# Out-of-bag error

The examples left out of each bootstrap sample form a free validation set for that learner. To evaluate an example $x$, vote only among the learners that did not train on it,

{% include equation.html tex="H^{oob}(x)=\arg\max_{y}\sum_{t=1}^{T}\mathbb{I}\big(h_t(x)=y\big)\,\mathbb{I}\big(x\notin\mathcal{D}_{bs}^{(t)}\big), \qquad \operatorname{err}^{oob}=\frac1{\lvert D\rvert}\sum_{(x,y)\in D}\mathbb{I}\big(H^{oob}(x)\ne y\big)." %}

The **out-of-bag error** is an estimate of the generalization error of the bagged ensemble with no separate validation set and no extra training, since every prediction comes from learners that never saw that example.

# Random forests

A **random forest** is bagging of decision trees with randomized feature selection. While growing each tree, at every split the algorithm first draws a random subset of $K$ of the features and then runs the usual split selection (gain ratio, Gini) *within that subset only*. The parameter $K$ sets the randomness: with $K=d$, the number of features, each tree is the ordinary deterministic one and the forest is plain bagging, and with $K=1$ the feature at each split is picked at random. A common recommendation is $K$ of the order of $\log_2d$, and $\sqrt d$ is another widespread default. The randomness is in the *features* only; the split point on a selected feature is still the best one.

Compared with bagging, a forest starts worse: with few trees, the restricted feature choice weakens each of them. But its trees are more diverse, so as trees are added the forest usually converges to a lower test error. It is also faster to train, because each split evaluates $K$ features instead of all $d$.

> The forest's trees are decorrelated twice, by the bootstrap sample and by the feature subsets. Increasing $T$ does not make a forest overfit, it only reduces the variance, so the number of trees is set by compute, not by validation.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why do about 36.8% of the examples miss a given bootstrap sample?</summary>

Each of the $m$ draws misses a given example with probability $1-1/m$, so all $m$ draws miss it with probability $(1-1/m)^m\to1/e\approx0.368$.
</details>

<details class="qa" markdown="1">
<summary>Why is the out-of-bag error a fair estimate of generalization error?</summary>

Each example is predicted only by the trees that were not trained on it, so the prediction is made on data the voters have not seen, as in a validation set.
</details>

<details class="qa" markdown="1">
<summary>What does the feature subset add to bagged trees, and what does $K$ control?</summary>

It makes the trees less alike, so averaging removes more variance. $K=d$ gives bagging and $K=1$ the most random trees; small $K$ also makes each split cheaper.
</details>
