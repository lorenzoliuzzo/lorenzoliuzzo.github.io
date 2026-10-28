---
collection: notes
title: "The Spectral Theorem"
date: 2026-10-27
excerpt: "Symmetric and Hermitian matrices, orthogonal diagonalization and quadratic forms."
hook: "A symmetric matrix has orthogonal eigenvectors and real eigenvalues, so it is a set of independent stretches along perpendicular axes."
goals:
  - diagonalize a symmetric matrix orthogonally
  - classify a quadratic form
requires:
  - eigenvalue
  - diagonalization
  - orthogonal-projection
defines:
  - {id: spectral-theorem, name: "spectral theorem", anchor: def-spectral-theorem}
  - {id: quadratic-form, name: "quadratic form", anchor: def-quadratic-form}
read_time: true
tags:
  - Mathematics
  - Linear Algebra
---

Not every matrix can be diagonalized, and one that can may need slanted axes. For symmetric matrices neither problem arises: the axes can always be taken perpendicular, which is what makes covariance matrices, Hessians and vibrating systems tractable.

# Symmetric matrices

A real matrix is **symmetric** if $A^{\mathsf T}=A$, and a complex one is **Hermitian** if $A^\dagger=A$. The eigenvectors of such a matrix are forced to be orthogonal, as two lines of algebra show.

> **Spectral theorem.** A real symmetric matrix $A$ has real eigenvalues and an orthonormal basis of eigenvectors. Equivalently, $A=Q\Lambda Q^{\mathsf T}$ with $Q$ orthogonal ($Q^{\mathsf T}Q=I$) and $\Lambda$ diagonal. The same holds for Hermitian matrices, with $Q$ unitary.
{: .theorem #def-spectral-theorem title="Spectral theorem"}

> If $Au=\lambda u$ and $Av=\mu v$ with $\lambda\ne\mu$, then $\lambda\,u\cdot v=Au\cdot v=u\cdot Av=\mu\,u\cdot v$, using symmetry in the middle step. So $(\lambda-\mu)\,u\cdot v=0$ and $u\perp v$. For the eigenvalues, $\bar v^{\mathsf T}Av$ is real for symmetric $A$ and equals $\lambda|v|^2$, so $\lambda$ is real. Inside an eigenspace of dimension greater than one an orthonormal basis can be chosen by Gram-Schmidt.
{: .proof}

The factorization is the diagonalization of the earlier note with a bonus: $P^{-1}$ is simply $Q^{\mathsf T}$, so there is nothing to invert and the change of basis is a rotation or reflection that preserves lengths. Writing $u_i$ for the columns of $Q$,
$$ A=\sum_i\lambda_i\,u_iu_i^{\mathsf T}, $$
a sum of orthogonal projections onto the eigen-directions, each weighted by its eigenvalue.

For $A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$ the eigenvalues are $3$ and $1$ with unit eigenvectors $\tfrac1{\sqrt2}(1,1)$ and $\tfrac1{\sqrt2}(1,-1)$, and indeed
$$ A=3\cdot\tfrac12\begin{pmatrix}1&1\\1&1\end{pmatrix}+1\cdot\tfrac12\begin{pmatrix}1&-1\\-1&1\end{pmatrix}. $$

> A function of a symmetric matrix is defined through its eigenvalues: $f(A)=Q\,f(\Lambda)\,Q^{\mathsf T}$, with $f$ applied to each diagonal entry. This gives $A^k$, $A^{-1}$ (when no eigenvalue is zero), $\sqrt A$ (when all are non-negative) and $e^{A}$ in one stroke.
{: .implication title="Functions of a matrix"}

# Quadratic forms

> A **quadratic form** on $\mathbb R^n$ is $q(x)=x^{\mathsf T}Ax$ for a symmetric matrix $A$, a polynomial in which every term has degree two, such as $2x^2+2xy+2y^2$.
{: .definition #def-quadratic-form title="Quadratic form"}

The cross terms $xy$ are the sign that the axes are badly chosen. Rotate to the eigenbasis with $y=Q^{\mathsf T}x$, and they disappear:
$$ x^{\mathsf T}Ax=y^{\mathsf T}\Lambda y=\sum_i\lambda_iy_i^2. $$
Everything about the form can then be read off the eigenvalues.

> A quadratic form is positive definite ($q(x)>0$ for $x\ne0$) exactly when all eigenvalues of $A$ are positive, negative definite when all are negative, and indefinite when the signs are mixed. The level set $x^{\mathsf T}Ax=1$ of a positive definite form is an ellipsoid with semi-axes $1/\sqrt{\lambda_i}$ along the eigenvectors.
{: .property title="Classification by the eigenvalues"}

{% include fig.html src="linear-algebra/quadratic-ellipse" id="fig-quadratic-ellipse" alt="A tilted ellipse with its two principal axes drawn as dashed lines. The short axis lies along the direction one, one and the long axis along one, minus one." caption="The set $2x^2+2xy+2y^2=1$. Its axes are the eigenvectors of $A$; the larger eigenvalue $3$ gives the shorter semi-axis $1/\sqrt3$, the smaller eigenvalue $1$ the longer semi-axis $1$." %}

The extreme values come for free. The **Rayleigh quotient** $x^{\mathsf T}Ax/x^{\mathsf T}x$ is a weighted average of the eigenvalues, with weights $y_i^2/|y|^2$, so it lies between $\lambda_{\min}$ and $\lambda_{\max}$ and attains them at the corresponding eigenvectors.

> At a critical point the sign of the Hessian's eigenvalues classifies it, because $f(x_0+h)\approx f(x_0)+\tfrac12h^{\mathsf T}Hh$: a minimum when all are positive, a saddle when mixed. The covariance matrix $\Sigma$ of a data set is symmetric and positive semi-definite, and its eigenvectors are the principal axes of the cloud, with eigenvalues the variances along them; in the example above, a covariance $\begin{pmatrix}2&1\\1&2\end{pmatrix}$ has variance $3$ along $(1,1)$ and $1$ along $(1,-1)$. The normal modes of coupled oscillators are eigenvectors of the symmetric matrix $K/m$.
{: .application title="Where symmetric matrices come from"}

> The theorem needs symmetry. The matrix $\begin{pmatrix}1&1\\0&2\end{pmatrix}$ has real eigenvalues $1$ and $2$ but eigenvectors $(1,0)$ and $(1,1)$, which are not perpendicular, so no rotation diagonalizes it. Check $A^{\mathsf T}=A$ before reaching for orthogonal eigenvectors.
{: .trap}

# Where this goes next

Rectangular matrices have no eigenvalues, but $A^{\mathsf T}A$ is always symmetric and positive semi-definite, so it has an orthonormal eigenbasis. Its eigenvectors and the square roots of its eigenvalues are the ingredients of the singular value decomposition, the next note.

# Recap

<details class="qa" markdown="1">
<summary>Why are eigenvectors of a symmetric matrix for different eigenvalues orthogonal?</summary>

Moving $A$ from one factor to the other in $Au\cdot v$ is allowed by symmetry, which gives $\lambda\,u\cdot v=\mu\,u\cdot v$, so $u\cdot v=0$ unless $\lambda=\mu$.
</details>

<details class="qa" markdown="1">
<summary>How does the spectral theorem remove the cross terms of a quadratic form?</summary>

Changing coordinates to the orthonormal eigenbasis, $y=Q^{\mathsf T}x$, turns $x^{\mathsf T}Ax$ into $\sum_i\lambda_iy_i^2$, a sum of squares with no cross terms.
</details>

<details class="qa" markdown="1">
<summary>What do the eigenvalues say about the level sets of a quadratic form?</summary>

Their signs decide whether the form is definite, and for a positive definite form the level set is an ellipsoid whose semi-axes are $1/\sqrt{\lambda_i}$ along the eigenvectors.
</details>
