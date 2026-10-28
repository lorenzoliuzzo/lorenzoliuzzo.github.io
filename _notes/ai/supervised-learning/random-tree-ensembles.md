---
collection: notes
title: "Random Trees for Density and Anomalies"
date: 2026-10-04
excerpt: "Completely random trees measure how hard a point is to isolate, which gives a density estimate from the average depth and an anomaly score from the isolation forest."
hook: "Points in dense regions need many random cuts to be isolated and outliers need few, so the depth at which a random tree isolates a point measures how ordinary it is."
goals:
  - estimate a density from the average depth of completely random trees
  - compute the isolation forest anomaly score of a point
  - explain why isolation finds anomalies that a density estimate misses
requires:
  - decision-tree
  - ensemble
defines:
  - {id: random-tree-density, name: density from random trees, anchor: density-from-depth}
  - {id: isolation-forest, name: isolation forest, anchor: the-isolation-forest}
  - {id: anomaly-score, name: anomaly score, anchor: the-isolation-forest}
read_time: true
tags:
  - Supervised Learning
  - Ensembles
---

Ensembles of trees are not restricted to labelled data. A tree whose splits are chosen completely at random never looks at a label, and an ensemble of such trees answers two unsupervised questions: how dense is the data here, and is this point an anomaly.

# Density from depth

A **completely random tree** picks a feature at random and a split point at random, and keeps splitting until every leaf holds a single instance (or instances that cannot be told apart). Building one needs only random numbers, so it is very cheap, and the trees can be grown incrementally on streaming data.

Take five points on a line, with larger gaps around points 1 and 5 than between points 2, 3 and 4. A random split point falls in a larger gap with higher probability, so points 1 and 5 tend to be cut off early and end in shallow leaves, while the points in the crowd take more cuts to separate and end deeper. Average the depth of each point over several random trees and normalize, and the result is a density estimate. With three trees giving average depths $1.67,\ 3.33,\ 3.67,\ 3,\ 1.67$ (sum 13.34), the densities are $0.125,\ 0.25,\ 0.275,\ 0.225,\ 0.125$: points 1 and 5 lie in a sparse region and points 2, 3 and 4 in a dense one. The same principle extends to higher dimensions.

# The isolation forest

An **anomaly** (or outlier) is a point that does not conform to the behaviour of the majority. Estimating the density and flagging low values has a flaw: a small clustered group of anomalies can have high density, while normal points on the border of the data can have low density. What is true of anomalies is that they are *few and different*, so they are easy to **isolate**.

{% include fig.html src="supervised-learning/isolation-depth" id="fig-isolation" alt="Average isolation depth of fifteen points on a line. Fourteen points in a cluster between 0 and 3 have average depths between about 4 and 7, while a single point at position 9 has an average depth of about 1.4." caption="Average depth at which random cuts isolate each point, over 600 trees. The cluster needs about five cuts per point, the outlier needs fewer than two." %}

The **isolation forest** (Liu, Ting and Zhou, 2008) measures the path length $h(x)$ from the root to the leaf that isolates $x$, averaged over the trees. To make this scale to large data, every tree is built on a small random sub-sample of size $\psi$ with a depth limit of about $\log_2\psi$, and an instance that reaches the limit in a leaf of $n$ instances has its path length increased by the average depth of an unbuilt tree on $n$ points,

$$ c(n)=2H(n-1)-\frac{2(n-1)}{n}\ \ (n>1),\qquad c(1)=0,\qquad H(a)\approx\ln a+0.5772 . $$

The **anomaly score** of $x$ is then

$$ s(x)=2^{-\mathbb{E}[h(x)]/c(\psi)} . $$

> $s\approx1$: definitely an anomaly. $s\ll0.5$: safely normal. $s\approx0.5$ for every point: there is no distinct anomaly in the data.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why does a point in a dense region end up deeper in a random tree?</summary>

Random cuts separate it from its neighbors only when one falls in the small gaps between them, which takes many cuts. A point with wide empty space around it is cut off by the first few.
</details>

<details class="qa" markdown="1">
<summary>Why is isolation a better test for anomalies than low density?</summary>

A small cluster of anomalies can be dense, and normal border points sparse, so density misleads. Anomalies are few and different, and that is exactly what makes them quick to isolate.
</details>

<details class="qa" markdown="1">
<summary>Why are the trees of an isolation forest built on small sub-samples?</summary>

Short paths already separate anomalies, so deep trees on all the data add cost without information. The sub-sample size $\psi$ fixes the depth limit and the normalization $c(\psi)$.
</details>
