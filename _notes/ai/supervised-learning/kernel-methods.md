---
collection: notes
title: "Kernel Methods"
date: 2026-10-04
excerpt: "How the dual SVM needs only inner products, so a kernel function can stand in for them and make the boundary nonlinear without ever building the feature space."
hook: "A kernel returns the inner product of two points in a feature space that is never built, so a linear method becomes nonlinear at no extra cost."
goals:
  - explain the kernel trick starting from the dual SVM
  - check by hand that a polynomial kernel is an inner product of explicit features
  - choose between the linear, polynomial and Gaussian kernels
requires:
  - support-vector-machine
defines:
  - {id: kernel-trick, name: kernel trick, anchor: the-kernel-trick}
  - {id: kernel-function, name: kernel function, anchor: choosing-a-kernel}
  - {id: rbf-kernel, name: Gaussian (RBF) kernel, anchor: choosing-a-kernel}
read_time: true
tags:
  - Supervised Learning
  - Classic learners
---

A linear classifier cannot separate data that is intrinsically nonlinear. Mapping the data into a richer space can fix that, and this note shows how to do so without paying for the larger space.

# Lifting the data

The general remedy for non-separable data is a map $\phi$ into a higher-dimensional feature space where the classes become linearly separable. Figure [](#fig-lift) shows the smallest example: points on a line, with one class between two groups of the other, cannot be split by any threshold, but after $x\mapsto(x,x^2)$ a horizontal line separates them.

{% include fig.html src="supervised-learning/kernel-lift" id="fig-lift" alt="Left: points on a line with six blue points in the middle and six orange points on both outer sides, not separable by a threshold. Right: the same points plotted as x against x squared on a parabola; the orange points sit high and the blue points low, and a horizontal line separates them." caption="Mapping $x$ to $(x,x^2)$ turns a one-dimensional problem no threshold can solve into one a straight line solves." %}

The cost is that the feature space can be very large, and training in it slows down. The way out comes from how the SVM is solved.

# The kernel trick

The soft-margin SVM of the [previous note]({{ '/notes/ai/supervised-learning/support-vector-machines/' | relative_url }}) has an equivalent **dual form**, in which the training instances appear only through inner products,

$$ \max_{\alpha}\ \sum_i\alpha_i-\frac12\sum_{i,j}\alpha_i\alpha_jy_iy_j\,\langle x_i,x_j\rangle\qquad\text{s.t.}\quad 0\le\alpha_i\le C,\ \ \sum_i\alpha_iy_i=0, $$

and a new instance is classified by $\operatorname{sign}\big(\sum_i\alpha_iy_i\langle x_i,x\rangle+b\big)$, where $\alpha_i>0$ only for the support vectors. To work in feature space, replace every $\langle x_i,x_j\rangle$ by $\langle\phi(x_i),\phi(x_j)\rangle$. The **kernel trick** is the observation that for many maps $\phi$ this inner product can be computed directly from the original vectors, by a **kernel function**

$$ K(x_i,x_j)=\big\langle\phi(x_i),\phi(x_j)\big\rangle , $$

without ever forming $\phi(x)$. A tiny check: for $x=(x_1,x_2)$ and $\phi(x)=(x_1^2,\sqrt2\,x_1x_2,x_2^2)$,

$$ \langle\phi(x),\phi(z)\rangle=x_1^2z_1^2+2x_1x_2z_1z_2+x_2^2z_2^2=(x^\top z)^2 . $$

The right side costs one inner product in two dimensions, while the left works in three. For a polynomial of degree $p$ in $d$ features the feature space has order $d^p$ coordinates, but the kernel is still one inner product.

> Which functions are kernels? By Mercer's theorem, every symmetric positive semi-definite function is one: its Gram matrix $K(x_i,x_j)$ is positive semi-definite for any points, and it is then an inner product in some feature space (a reproducing kernel Hilbert space).
{: .idea}

# Choosing a kernel

Three kernels cover most uses:

| Kernel | $K(x,z)$ | Boundary |
|---|---|---|
| Linear | $x^\top z$ | a hyperplane, the plain SVM |
| Polynomial | $(x^\top z+c)^p$ | a polynomial surface of degree $p$ |
| Gaussian (RBF) | $\exp\big(-\lVert x-z\rVert^2/2\sigma^2\big)$ | smooth, flexible, local |
{: .keyed}

The **Gaussian kernel** corresponds to an infinite-dimensional feature space. Its width $\sigma$ plays the role that $k$ plays for neighbors: a small $\sigma$ makes each support vector influence only its immediate surroundings and overfits, a large $\sigma$ smooths the boundary towards a linear one.

> Start with the Gaussian kernel, and tune $C$ and $\sigma$ together on a logarithmic grid by cross-validation. Prefer the linear kernel when there are many more features than examples, since the data is probably separable already.
{: .rule}

Nothing here is special to the SVM. Any algorithm that can be written with inner products between instances can be kernelized by the same substitution, and once it is, it is called a **kernel method**. The SVM with a kernel is the best known one.

# Recap

<details class="qa" markdown="1">
<summary>What is the kernel trick, and why does it work for the SVM?</summary>

The dual SVM and its predictor use the data only through inner products. A kernel computes the inner product in a feature space directly from the original vectors, so the feature space is never built.
</details>

<details class="qa" markdown="1">
<summary>What does a small versus a large Gaussian width do?</summary>

A small width lets each support vector affect only a tiny neighborhood, so the boundary is jagged and overfits. A large width spreads the influence out, smoothing the boundary until it is almost linear.
</details>

<details class="qa" markdown="1">
<summary>What must a function satisfy to be a kernel?</summary>

It must be symmetric and positive semi-definite (Mercer's condition). Then it is an inner product in some feature space, even if that space is infinite-dimensional.
</details>
