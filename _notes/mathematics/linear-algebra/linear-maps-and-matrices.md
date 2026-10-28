---
collection: notes
title: Linear Maps and Matrices
date: '2026-10-27'
excerpt: Linear maps, matrices, rank and nullity, change of basis and linear systems.
hook: A matrix is a linear map written in a basis, and changing the basis changes the matrix but not the map.
goals:
- write a linear map as a matrix in a given basis
- solve a linear system and read off rank and nullity
requires:
- vector-space
- basis
defines:
- id: linear-map
  name: linear map
  anchor: linear-map
- id: rank-nullity
  name: rank and nullity
  anchor: rank-and-nullity
- id: change-of-basis
  name: change of basis
  anchor: change-of-basis
tags:
- Mathematics
- Linear Algebra
read_time: true
---

A matrix looks like a table of numbers, but the numbers are the description of something geometric: a map that stretches, rotates or shears space and keeps straight lines straight. Writing the map as a matrix is a choice of basis, and the rest of linear algebra is about which choices make it simple.

# Linear map

A map $T:V\to W$ between vector spaces is **linear** if
$$ T(u+v)=T(u)+T(v),\qquad T(av)=aT(v) $$
for all vectors $u,v$ and numbers $a$. It follows that $T(0)=0$ and that $T$ respects linear combinations. Examples are rotation of the plane, projection of space onto a plane, differentiation of polynomials, and multiplication by a matrix. The map $x\mapsto x+1$ is not linear, since it moves the origin.

A linear map is determined by what it does to a basis. If $b_1,\dots,b_n$ is a basis of $V$ and $c_1,\dots,c_m$ a basis of $W$, write $T(b_j)=\sum_iA_{ij}c_i$. The $m\times n$ table $A$ is the **matrix of $T$** in these bases. Its $j$-th column holds the coordinates of $T(b_j)$, so applying $T$ to coordinates is multiplication $x\mapsto Ax$, and composing maps is multiplying matrices, $(ST)\leftrightarrow BA$.

{% include fig.html src="linear-algebra/unit-square-map" id="fig-unit-square-map" alt="A unit square on the left and, on the right, the parallelogram into which it is mapped. The two edges leaving the origin are the images of the two unit vectors, with coordinates (2, 1) and (1, 1)." caption="The matrix $A=\begin{pmatrix}2&1\\1&1\end{pmatrix}$ sends the unit square to the parallelogram spanned by its columns, $Ae_1=(2,1)$ and $Ae_2=(1,1)$. Straight lines stay straight and the origin stays fixed." %}

> To read a matrix, look at its columns: each is the image of one basis vector.
{: .idea}

# Rank and nullity

Two subspaces describe $T$. The **kernel** $\ker T=\{v:Tv=0\}$ is what $T$ collapses, and the **image** $\operatorname{im}T=\{Tv\}$ is what it reaches. Both are subspaces. Their dimensions are the **nullity** and the **rank**, and they satisfy the **rank-nullity theorem**
$$ \dim V=\operatorname{rank}T+\operatorname{nullity}T. $$
For a matrix, the rank is the number of pivots after row reduction, which equals the dimension of the span of the columns. The proof takes a basis of the kernel and extends it to a basis of $V$; the images of the added vectors are a basis of the image. Every direction in the domain is either collapsed or reaches a distinct direction in the image.

The theorem governs linear systems. The system $Ax=b$ is solvable exactly when $b$ lies in the image, and the solutions then form a translate of $\ker A$: one particular solution plus anything the map kills. So there is a unique solution if the nullity is zero, none if $b\notin\operatorname{im}A$, and a family of dimension equal to the nullity otherwise. For $A=\begin{pmatrix}1&2\\2&4\end{pmatrix}$ the second row is twice the first, the rank is $1$, the nullity is $2-1=1$, and the kernel is the line spanned by $(2,-1)$.

{% capture t %}
| Quantity | Meaning | For an $m\times n$ matrix |
|:--|:--|:--|
| kernel | vectors sent to $0$ | subspace of $\mathbb R^n$ |
| image | all outputs | subspace of $\mathbb R^m$ |
| rank | $\dim\operatorname{im}$ | pivots, at most $\min(m,n)$ |
| nullity | $\dim\ker$ | $n-\text{rank}$ |
{% endcapture %}
{% include tab.html id="tab-rank" caption="The subspaces attached to a linear map and their dimensions." body=t %}
{: .booktabs}

A map is injective exactly when its kernel is $\{0\}$ and surjective when its image is all of $W$. For $\dim V=\dim W$ these two conditions are equivalent, by rank-nullity.

# Change of basis

The matrix depends on the bases. If $P$ is the matrix whose columns are the new basis vectors $b'_j$ written in the old coordinates, then the old and new coordinates of one vector are related by $x=Px'$. A map with matrix $A$ in the old basis has, in the new basis,
$$ A'=P^{-1}AP. $$
The map is the same; only its description has changed. Matrices related like this are called **similar**, and they share every property of the map itself: the rank, and later the determinant, the trace and the eigenvalues.

The point of changing basis is to choose one in which $A'$ is simple. A shear $A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$ cannot be made diagonal, but many matrices can, as the note on eigenvalues shows. For a map between two different spaces, the bases of $V$ and $W$ can be changed independently, $A'=Q^{-1}AP$, and a suitable choice puts $A$ in the form of an identity block of size $r$ padded with zeros, which is a restatement of rank-nullity.

# Recap

<details class="qa" markdown="1">
<summary>How do you write a linear map as a matrix?</summary>

Choose bases, and let column $j$ hold the coordinates of the image of the $j$-th basis vector of the domain. Composition then becomes matrix multiplication.
</details>

<details class="qa" markdown="1">
<summary>What does the rank-nullity theorem say, and what does it give for $Ax=b$?</summary>

$\dim V=\operatorname{rank}+\operatorname{nullity}$. The solutions of $Ax=b$, if any, are a particular solution plus the kernel, so they form a family of dimension equal to the nullity.
</details>

<details class="qa" markdown="1">
<summary>How does the matrix of a map change under a change of basis?</summary>

$A'=P^{-1}AP$, where the columns of $P$ are the new basis vectors in old coordinates. The map is unchanged, and so are the rank and the eigenvalues.
</details>
