---
collection: notes
title: "Support Vector Machines"
date: 2026-10-04
excerpt: "The maximum-margin classifier: why the widest empty band generalizes, how the soft margin and the hinge loss handle overlapping classes, and what the support vectors are."
hook: "Among all separating lines the SVM takes the one farthest from the data, and only the points that touch its margin determine it."
goals:
  - derive the margin width 2/‖w‖ and the hard-margin problem
  - write the soft-margin problem and say what C controls
  - recognize the hinge loss in the SVM objective
requires:
  - linear-classifier
  - overfitting
defines:
  - {id: support-vector-machine, name: support vector machine, anchor: the-maximum-margin-idea}
  - {id: margin, name: margin, anchor: the-maximum-margin-idea}
  - {id: slack-variable, name: slack variable, anchor: overlapping-classes-the-soft-margin}
  - {id: hinge-loss, name: hinge loss, anchor: the-hinge-loss-view}
read_time: true
tags:
  - Supervised Learning
  - Classic learners
---

When two classes can be separated by a line, there are infinitely many lines that do it, and they do not generalize equally. The support vector machine picks the one with the most room on both sides.

# The maximum margin idea

**Support vector machines** (SVMs) were designed for binary classification as **large margin classifiers**: among the hyperplanes $w^\top x+b=0$ that separate the classes, take the one with the largest **margin**, the width of the empty band around it. A wide band means that small shifts of a point, as noise would cause, do not move it across the boundary.

> The Euclidean distance from an instance $x_i$ to the hyperplane is $\lvert w^\top x_i+b\rvert/\lVert w\rVert$. The pair $(w,b)$ can be rescaled freely without moving the plane, so scale it until the closest instances satisfy $\lvert w^\top x_i+b\rvert=1$. They are then at distance $1/\lVert w\rVert$ on each side, and the margin is $2/\lVert w\rVert$.
{: .derive}

Maximizing the margin is therefore minimizing $\lVert w\rVert^2/2$ while keeping every instance on its correct side of the band, with labels $y_i\in\lbrace-1,+1\rbrace$:

$$ \min_{w,b}\ \tfrac12\lVert w\rVert^2\qquad\text{s.t.}\quad y_i\big(w^\top x_i+b\big)\ge1,\ \ i=1,\dots,m . $$

{% include fig.html src="supervised-learning/svm-margin" id="fig-margin" alt="Two classes of points separated by a dashed line, with a shaded band around it bounded by two solid lines. Three points, two of one class and one of the other, lie on the edges of the band and are circled as support vectors." caption="The separating line sits in the middle of the widest empty band. The circled support vectors lie on its edges, and moving any other point, as long as it stays outside the band, would not change the solution." %}

The solution depends only on the instances that lie exactly on the edges of the margin, the **support vectors**. All others could be removed without changing it, which is part of why SVMs generalize well from few of them.

# Overlapping classes: the soft margin

Real classes overlap, and then no band is empty. The remedy is to let some instances break the rules at a price, with **slack variables** $\xi_i\ge0$ that measure how far instance $i$ falls inside the band or beyond it. The **soft-margin** SVM solves

$$ \min_{w,b,\xi}\ \tfrac12\lVert w\rVert^2+C\sum_{i=1}^{m}\xi_i\qquad\text{s.t.}\quad y_i\big(w^\top x_i+b\big)\ge1-\xi_i,\ \ \xi_i\ge0 . $$

The parameter $C$ prices the violations. A large $C$ punishes every one, so the band narrows and bends to the training data, with the risk of overfitting. A small $C$ tolerates violations in exchange for a wider band, which gives a smoother and more stable boundary. It is a hyper-parameter for the validation set to choose.

> Tune $C$ on a logarithmic grid ($10^{-2},10^{-1},\dots,10^{3}$) with cross-validation. Its useful range spans orders of magnitude, so linear steps waste the search.
{: .rule}

# The hinge loss view

At the optimum each slack variable takes the smallest value that satisfies its constraint, $\xi_i=\max\big(0,\,1-y_i(w^\top x_i+b)\big)$. This function of the margin $y_i(w^\top x_i+b)$ is the **hinge loss**: zero for instances on the correct side beyond the edge of the band, and growing linearly as an instance moves into the band, across the line and further into the wrong side. The soft-margin SVM is thus the minimization of the total hinge loss plus a penalty $\lVert w\rVert^2$ on the weights, the same pattern of "loss plus regularizer" that appears throughout machine learning. The penalty is what produces the wide margin, and the hinge is what makes the solution sparse in support vectors.

# Recap

<details class="qa" markdown="1">
<summary>Why is the margin $2/\lVert w\rVert$?</summary>

After rescaling so that the closest instances have $\lvert w^\top x+b\rvert=1$, each is at distance $1/\lVert w\rVert$ from the hyperplane, one on each side. Wide margin means small $\lVert w\rVert$.
</details>

<details class="qa" markdown="1">
<summary>What changes when $C$ is made very large or very small?</summary>

Very large $C$ forces almost no violations, giving a narrow margin that follows the training data closely. Very small $C$ allows many violations, giving a wide, smooth margin that may underfit.
</details>

<details class="qa" markdown="1">
<summary>What is a support vector, and what happens if you delete a point that is not one?</summary>

A support vector is an instance on the edge of the margin or inside it. Deleting any other instance leaves the solution unchanged.
</details>
