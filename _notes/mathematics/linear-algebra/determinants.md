---
collection: notes
title: Determinants
date: '2026-10-27'
excerpt: The determinant as signed volume, its properties and its use in inverses and systems.
hook: The determinant is the factor by which a map scales volume, and it vanishes exactly when the map loses a dimension.
goals:
- compute a determinant by expansion and by row reduction
- decide invertibility from the determinant
requires:
- linear-map
defines:
- id: determinant
  name: determinant
  anchor: def-determinant
tags:
- Mathematics
- Linear Algebra
read_time: true
---

A linear map stretches space by different amounts in different directions, and one number summarises how much volume it gains or loses overall. That number is the determinant, and whether it is zero decides most questions about invertibility.

# Determinant

> For a square matrix $A$ acting on $\mathbb R^n$, the **determinant** $\det A$ is the signed factor by which $A$ scales $n$-dimensional volume.
{: .definition #def-determinant title="Determinant"}

The unit square (or cube) is sent to the parallelogram (or parallelepiped) spanned by the columns of $A$, and $|\det A|$ is its area (volume). The sign records orientation: it is negative when the map reverses it, as a reflection does.

For $2\times2$ and $3\times3$ the formula is short:
$$ \det\begin{pmatrix}a&b\\c&d\end{pmatrix}=ad-bc,\qquad \det A=\sum_{j}(-1)^{1+j}a_{1j}\det A_{1j} $$
where $A_{1j}$ is $A$ with row $1$ and column $j$ removed. The second formula is the **cofactor expansion** along the first row; any row or column works, with signs alternating as a checkerboard.

The definition is fixed by three properties: $\det I=1$, the determinant is linear in each column separately, and it changes sign when two columns are swapped. Everything below follows from them. In particular, if two columns are equal the determinant is zero, and so it is when one column is a combination of the others, because then the columns span less than a full volume.

{% include fig.html src="linear-algebra/determinant-area" id="fig-determinant-area" alt="On the left the unit square is sent to a parallelogram of area three, and on the right a different matrix sends it to a single line segment." caption="The unit square (dashed) and its image. Left: $\det A=3$, so areas triple and orientation is kept. Right: $\det B=0$, the columns are parallel and the square collapses onto a segment." %}

# Computing and using it

Cofactor expansion costs about $n!$ operations, which is hopeless beyond small $n$. **Row reduction** is cheaper: adding a multiple of one row to another leaves $\det$ unchanged, swapping two rows flips its sign, and scaling a row by $c$ scales $\det$ by $c$. Reduce $A$ to triangular form, then the determinant is the product of the diagonal entries, times $(-1)^{\text{number of swaps}}$. For example
$$ \det\begin{pmatrix}2&1&0\\1&3&1\\0&1&4\end{pmatrix}=2\cdot(12-1)-1\cdot(4-0)+0=18. $$

The important rules are
$$ \det(AB)=\det A\,\det B,\qquad \det A^{\mathsf T}=\det A,\qquad \det A^{-1}=\frac1{\det A}. $$
The first says volume factors multiply when maps are composed. It also shows that the determinant does not depend on the basis: for a change of basis, $\det(P^{-1}AP)=\det A$, so $\det$ is a property of the map and not of its matrix.

{% capture t %}
| Property of the square matrix $A$ | Equivalent statement |
|:--|:--|
| $A$ is invertible | $\det A\neq0$ |
| $Ax=0$ has only $x=0$ | $\det A\neq0$ |
| columns are independent | $\det A\neq0$ |
| rank is less than $n$ | $\det A=0$ |
{% endcapture %}
{% include tab.html id="tab-det-invertible" caption="What the determinant decides." body=t %}
{: .booktabs}

**Invertibility.** $A$ is invertible exactly when $\det A\ne0$: a map that scales volume by zero has collapsed a direction and cannot be undone, by rank-nullity. The inverse of a $2\times2$ matrix with $\det A\ne0$ is
$$ A^{-1}=\frac1{ad-bc}\begin{pmatrix}d&-b\\-c&a\end{pmatrix}. $$
**Cramer's rule** writes the solution of $Ax=b$ as $x_i=\det A_i/\det A$, where $A_i$ has column $i$ replaced by $b$. It is useful for symbolic $2\times2$ and $3\times3$ systems and not for computation.

> A matrix can have a tiny determinant without being nearly singular, and a large one without being well conditioned: $\det(10^{-3}I_{10})=10^{-30}$. The determinant detects exact singularity, not closeness to it.
{: .trap}

# Where it appears next

The determinant of $A-\lambda I$ vanishes exactly at the eigenvalues of $A$, which is how they are found in the next note, and $\det A$ is the product of the eigenvalues. In integration, the absolute value of a Jacobian determinant is the local volume factor in a change of variables.

# Recap

<details class="qa" markdown="1">
<summary>What does the determinant measure?</summary>

The signed factor by which the map scales volume: $|\det A|$ is the volume of the image of the unit cube, and the sign records whether orientation is reversed.
</details>

<details class="qa" markdown="1">
<summary>How is it computed efficiently, and which rules does it obey?</summary>

By row reduction to triangular form, multiplying the diagonal and tracking sign changes from swaps. It satisfies $\det(AB)=\det A\det B$ and $\det A^{\mathsf T}=\det A$.
</details>

<details class="qa" markdown="1">
<summary>How does the determinant decide invertibility?</summary>

$A$ is invertible if and only if $\det A\neq0$; a zero determinant means a direction is collapsed and $Ax=0$ has non-zero solutions.
</details>
