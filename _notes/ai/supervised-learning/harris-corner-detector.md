---
collection: notes
title: "The Harris Corner Detector"
date: 2026-10-04
excerpt: "Why corners make good keypoints, and how the eigenvalues of a 2x2 matrix built from image derivatives separate corners from edges and flat regions."
hook: "A good keypoint is a patch that changes however you shift it, and the two eigenvalues of one 2x2 matrix say whether it does."
goals:
  - derive the matrix M from the error of shifting a window
  - classify a patch as flat, edge or corner from the eigenvalues of M
  - compute the Harris response without computing eigenvalues
requires:
  - keypoint
defines:
  - {id: harris-detector, name: Harris detector, anchor: the-shift-error}
  - {id: corner-response, name: corner response, anchor: flat-edge-or-corner}
read_time: true
tags:
  - Supervised Learning
  - Keypoints
---

Which points of an image are worth describing? Not flat regions, where nothing identifies the position, and not edges, along which a point can slide without changing what it sees. Corners are the points that pin their own position down, and Harris and Stephens turned this into a formula.

# The shift error

Consider a window around a pixel, weighted by a mask $w(x,y)$ that keeps only the desired area. If the window is shifted by $(u,v)$, the change in what it contains is

$$ E(u,v)=\sum_{x,y}w(x,y)\,\big[I(x+u,\,y+v)-I(x,y)\big]^2 . $$

A good keypoint is a window for which $E$ is large for every direction of shift. To study it, replace the shifted intensity by its first-order Taylor expansion, $I(x+u,y+v)\approx I(x,y)+uI_x+vI_y$, with $I_x,I_y$ the image derivatives. The error becomes a quadratic form,

{% include equation.html tex="E(u,v)\approx\begin{pmatrix}u&v\end{pmatrix}M\begin{pmatrix}u\\v\end{pmatrix},\qquad M=\sum_{x,y}w(x,y)\begin{pmatrix}I_x^2&I_xI_y\\I_xI_y&I_y^2\end{pmatrix}." %}

The matrix $M$ summarizes the gradients in the window, and the eigenvalues $\lambda_1,\lambda_2$ of $M$ are the rates at which the error grows along its two principal directions.

# Flat, edge or corner

If both eigenvalues are small, shifting changes nothing in any direction: a **flat** region. If one is large and one small, the window changes when shifted across the edge and not along it: an **edge**. If both are large, every shift changes the window: a **corner**.

{% include fig.html src="supervised-learning/harris-regions" id="fig-harris" alt="The plane of the two eigenvalues, each from 0 to 10. A large shaded region in the upper right, bounded by a hyperbola-like curve, is labelled corner. Two thin wedges along the axes are labelled edge. The area near the origin is labelled flat." caption="Where the Harris response puts a window, as a function of its two eigenvalues. Corners need both to be large; the edge wedges lie along the axes, where one eigenvalue is much smaller than the other." %}

Computing eigenvalues for every pixel is costly, and Harris avoided it with the **response**

$$ R=\det M-k\,(\operatorname{trace}M)^2=\lambda_1\lambda_2-k(\lambda_1+\lambda_2)^2, $$

with $k$ a small constant, typically between 0.04 and 0.06. The determinant and the trace of $M$ are available without eigenvalues. A window whose $R$ is above a threshold is a corner, $R$ is negative on edges, and $\lvert R\rvert$ is small on flat regions.

> The Harris detector is not scale invariant. A corner viewed from far away looks like a smooth curve at a larger scale, so the same object at two sizes gives different corners. It also only *finds* points: it says nothing that would help to recognize them again.
{: .trap}

Both limits are what SIFT addresses in the next two notes: the scale by searching across blur levels, and the description by a vector computed around each point.

# Recap

<details class="qa" markdown="1">
<summary>Why are corners better keypoints than edges?</summary>

A window on an edge looks the same when shifted along the edge, so its position is ambiguous. A corner changes under a shift in every direction, so it can be located exactly.
</details>

<details class="qa" markdown="1">
<summary>What do the eigenvalues of $M$ tell you?</summary>

How fast the shift error grows along the two principal directions of the window's gradients. Both large means a corner, one large an edge, both small a flat patch.
</details>

<details class="qa" markdown="1">
<summary>Why use $R=\det M-k(\operatorname{trace}M)^2$ instead of the eigenvalues?</summary>

The determinant is $\lambda_1\lambda_2$ and the trace is $\lambda_1+\lambda_2$, and both come straight from the entries of $M$, so $R$ classifies the window without an eigenvalue decomposition at every pixel.
</details>
