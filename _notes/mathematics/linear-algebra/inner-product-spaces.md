---
collection: notes
title: Inner Product Spaces
date: '2026-10-27'
excerpt: Inner products, norms, orthogonality, Gram-Schmidt and orthogonal projection.
hook: An inner product brings lengths and angles into a vector space, and projection is the closest point in a subspace.
goals:
- orthogonalize a basis
- project a vector onto a subspace
requires:
- vector-space
- linear-map
defines:
- id: inner-product
  name: inner product
  anchor: def-inner-product
- id: orthogonal-projection
  name: orthogonal projection
  anchor: def-orthogonal-projection
tags:
- Mathematics
- Linear Algebra
read_time: true
---

A vector space has no lengths or angles until you add them. One extra operation, the inner product, supplies both, and with it the best approximation of a vector from a subspace becomes a computation.

# Inner product

> An **inner product** on a real vector space $V$ is a function $\langle u,v\rangle\in\mathbb R$ that is symmetric, $\langle u,v\rangle=\langle v,u\rangle$, linear in each argument, and positive definite: $\langle v,v\rangle>0$ for $v\ne0$.
{: .definition #def-inner-product title="Inner product"}

On $\mathbb R^n$ the standard choice is the dot product $\langle u,v\rangle=u\cdot v=\sum u_iv_i$. Other examples are $\langle f,g\rangle=\int_0^1fg\,dx$ on functions, and $\langle A,B\rangle=\operatorname{tr}(A^{\mathsf T}B)$ on matrices. (For complex spaces one conjugates one argument.)

From it come the **norm** $\|v\|=\sqrt{\langle v,v\rangle}$ and the **angle** $\theta$ between nonzero vectors by $\langle u,v\rangle=\|u\|\|v\|\cos\theta$. The formula makes sense because of the **Cauchy-Schwarz inequality**
$$ |\langle u,v\rangle|\le\|u\|\,\|v\|, $$
which is proved by noting that $\|u-tv\|^2\ge0$ for every $t$ is a quadratic in $t$ with non-positive discriminant. It gives the triangle inequality $\|u+v\|\le\|u\|+\|v\|$.

Two vectors are **orthogonal** if $\langle u,v\rangle=0$. Orthogonal nonzero vectors are independent, and in an **orthonormal basis** $e_1,\dots,e_n$, with $\langle e_i,e_j\rangle=\delta_{ij}$, coordinates are read off directly:
$$ v=\sum_i\langle v,e_i\rangle\,e_i,\qquad \|v\|^2=\sum_i\langle v,e_i\rangle^2. $$
No linear system has to be solved. The second formula is Parseval's identity, a Pythagorean theorem in $n$ dimensions.

# Orthogonal projection

Given a unit vector $e$, the part of $v$ along $e$ is $\langle v,e\rangle e$, and what is left, $v-\langle v,e\rangle e$, is orthogonal to $e$. For a general vector $u$ the formula is
$$ \operatorname{proj}_u v=\frac{\langle v,u\rangle}{\langle u,u\rangle}\,u. $$
For $v=(3,2)$ and $u=(4,1)$ the coefficient is $14/17=0.8235$ and the projection is $(3.294,0.824)$. The residual $v-\operatorname{proj}_uv$ has dot product $0$ with $u$.

{% include fig.html src="linear-algebra/projection" id="fig-projection" alt="A vector v in the plane, a line through the origin along u, the foot of the perpendicular from the tip of v onto the line, and the dashed residual segment meeting the line at a right angle." caption="Orthogonal projection of $v=(3,2)$ onto the line spanned by $u=(4,1)$. The dashed residual $v-\operatorname{proj}_uv$ is perpendicular to $u$, and $\operatorname{proj}_uv=(3.294,0.824)$ is the closest point of the line to $v$." %}

> For a subspace $W$ with orthonormal basis $e_1,\dots,e_k$, the **orthogonal projection** of $v$ onto $W$ is $P_Wv=\sum_i\langle v,e_i\rangle e_i$.
{: .definition #def-orthogonal-projection title="Orthogonal projection"}

It has two characterisations that are worth remembering together. First, $v-P_Wv$ is orthogonal to every vector of $W$. Second, $P_Wv$ is the point of $W$ closest to $v$: for any $w\in W$,
$$ \|v-w\|^2=\|v-P_Wv\|^2+\|P_Wv-w\|^2\ \ge\ \|v-P_Wv\|^2, $$
by the Pythagorean theorem, since $v-P_Wv\perp P_Wv-w$. Least-squares fitting is exactly this: the best fit to data is the projection of the data vector onto the span of the model's columns, and it is found from the normal equations $A^{\mathsf T}A\,x=A^{\mathsf T}b$.

# Gram-Schmidt

Any basis can be turned into an orthonormal one. The **Gram-Schmidt process** takes $v_1,\dots,v_k$ and subtracts, from each new vector, its projections onto the previous orthonormal vectors,
$$ w_j=v_j-\sum_{i<j}\langle v_j,e_i\rangle e_i,\qquad e_j=\frac{w_j}{\|w_j\|}. $$
Each $e_j$ lies in the span of $v_1,\dots,v_j$, so the first $j$ vectors span the same subspace at every step. For $v_1=(1,1,0)$ and $v_2=(1,0,1)$ one gets $e_1=(1,1,0)/\sqrt2$, then $w_2=(1,0,1)-\tfrac12(1,1,0)=(\tfrac12,-\tfrac12,1)$, which is orthogonal to $e_1$. Written as matrices, the process is the QR decomposition $A=QR$ with $Q$ having orthonormal columns and $R$ upper triangular.

# Recap

<details class="qa" markdown="1">
<summary>What does an inner product add to a vector space?</summary>

Length $\|v\|=\sqrt{\langle v,v\rangle}$, angle through $\langle u,v\rangle=\|u\|\|v\|\cos\theta$, and orthogonality; all are controlled by the Cauchy-Schwarz inequality.
</details>

<details class="qa" markdown="1">
<summary>What is the orthogonal projection of $v$ onto a subspace $W$?</summary>

$P_Wv=\sum\langle v,e_i\rangle e_i$ over an orthonormal basis of $W$. It is the closest point of $W$ to $v$, and the residual is orthogonal to $W$.
</details>

<details class="qa" markdown="1">
<summary>What does Gram-Schmidt do?</summary>

It builds an orthonormal basis from any basis by subtracting from each vector its projections onto the earlier ones and normalising, keeping every initial span.
</details>
