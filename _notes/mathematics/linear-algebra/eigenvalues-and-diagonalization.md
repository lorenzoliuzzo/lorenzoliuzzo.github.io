---
collection: notes
title: "Eigenvalues and Diagonalization"
date: 2026-10-27
excerpt: "Eigenvectors, the characteristic polynomial, diagonalization and the Jordan form."
hook: "An eigenvector is a direction the map only stretches; when there are enough of them the map is a list of stretches."
goals:
  - find eigenvalues and eigenvectors
  - decide whether a matrix is diagonalizable
requires:
  - determinant
  - change-of-basis
defines:
  - {id: eigenvalue, name: "eigenvalue and eigenvector", anchor: def-eigenvalue}
  - {id: diagonalization, name: "diagonalization", anchor: def-diagonalization}
read_time: true
tags:
  - Mathematics
  - Linear Algebra
---

Most directions are turned by a linear map; a few are only stretched. Finding them turns a matrix into a list of numbers, and the determinant from the previous note is the tool that finds them.

# Eigenvalue and eigenvector

> A number $\lambda$ is an **eigenvalue** of a square matrix $A$ if $Av=\lambda v$ for some non-zero vector $v$, and $v$ is then an **eigenvector** of $A$ for $\lambda$.
{: .definition #def-eigenvalue title="Eigenvalue and eigenvector"}

The map sends the line through $v$ onto itself and scales it by $\lambda$, with a flip if $\lambda<0$ and a collapse if $\lambda=0$. Rewriting $Av=\lambda v$ as $(A-\lambda I)v=0$ shows that a non-zero solution exists exactly when $A-\lambda I$ is singular, that is when
$$ \det(A-\lambda I)=0. $$
The left side is a polynomial of degree $n$ in $\lambda$, the **characteristic polynomial**, so an $n\times n$ matrix has at most $n$ eigenvalues. For each root $\lambda$, the eigenvectors are the non-zero solutions of $(A-\lambda I)v=0$, which together with $0$ form a subspace, the **eigenspace**.

Take $A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$. Then $\det(A-\lambda I)=(2-\lambda)^2-1=(\lambda-1)(\lambda-3)$, so the eigenvalues are $1$ and $3$. Solving $(A-3I)v=0$ gives $v=(1,1)$ and $(A-I)v=0$ gives $v=(1,-1)$. Each of these two lines stays where it is, and the circle of unit vectors becomes an ellipse whose axes lie along them.

{% include fig.html src="linear-algebra/eigen-directions" id="fig-eigen-directions" alt="The unit circle on the left and its image on the right, an ellipse tilted at forty-five degrees. Two arrows along the ellipse axes are labelled with the eigenvalues three and one." caption="The matrix $A$ turns the unit circle into an ellipse. The two eigenvectors keep their direction: the orange one is stretched by $3$, the green one is left at length $1$." %}

> For an $n\times n$ matrix with eigenvalues $\lambda_1,\dots,\lambda_n$ counted with multiplicity over $\mathbb C$, $\operatorname{tr}A=\sum_i\lambda_i$ and $\det A=\prod_i\lambda_i$.
{: .property title="Trace and determinant from the eigenvalues"}

This is read off the characteristic polynomial: the coefficient of $\lambda^{n-1}$ is $(-1)^{n-1}\operatorname{tr}A$ and the constant term is $\det A$. In the example the eigenvalues $1$ and $3$ give trace $4$ and determinant $3$, as the matrix does. A zero eigenvalue is the same thing as $\det A=0$.

# Diagonalization

Eigenvectors for different eigenvalues cannot line up.

> Eigenvectors belonging to distinct eigenvalues are linearly independent.
{: .theorem #thm-eigen-independent title="Independence of eigenvectors"}

> Suppose $v_1,v_2$ have eigenvalues $\lambda_1\ne\lambda_2$ and $a_1v_1+a_2v_2=0$. Applying $A-\lambda_2I$ gives $a_1(\lambda_1-\lambda_2)v_1=0$, so $a_1=0$, and then $a_2=0$. The general case is the same argument by induction.
{: .proof}

So a matrix with $n$ distinct eigenvalues has $n$ independent eigenvectors, which form a basis. Writing them as the columns of $P$ and the eigenvalues on the diagonal of $D$, the equation $AP=PD$ holds column by column.

> A square matrix $A$ is **diagonalizable** if $A=PDP^{-1}$ for an invertible $P$ and a diagonal $D$. This happens exactly when $\mathbb R^n$ (or $\mathbb C^n$) has a basis of eigenvectors of $A$, which are then the columns of $P$.
{: .definition #def-diagonalization title="Diagonalization"}

In the change of basis from the earlier note, $P$ is the matrix that translates eigenvector coordinates to standard ones, so $D$ is the same map written in the eigenbasis. In that basis the map is a list of independent stretches, and everything about it becomes easy. Powers, for one:
$$ A^k=PD^kP^{-1},\qquad D^k=\operatorname{diag}(\lambda_1^k,\dots,\lambda_n^k). $$

> The Fibonacci recurrence $F_{k+1}=F_k+F_{k-1}$ is the map $\begin{pmatrix}F_{k+1}\\F_k\end{pmatrix}=\begin{pmatrix}1&1\\1&0\end{pmatrix}\begin{pmatrix}F_k\\F_{k-1}\end{pmatrix}$. Its eigenvalues solve $\lambda^2=\lambda+1$, so they are $\varphi=\tfrac{1+\sqrt5}{2}\approx1.618$ and $\psi=\tfrac{1-\sqrt5}{2}\approx-0.618$, and diagonalizing gives $F_k=(\varphi^k-\psi^k)/\sqrt5$. Because $|\psi|<1$, the numbers grow like $\varphi^k$, and $F_k$ is the integer nearest $\varphi^k/\sqrt5$.
{: .example title="Fibonacci numbers from eigenvalues"}

The same idea solves linear difference and differential systems: $\dot x=Ax$ has solutions $e^{\lambda_it}v_i$, so the signs of the real parts of the eigenvalues decide whether the system settles down or blows up.

# When it fails

Eigenvalues are roots of a polynomial, so repeated roots and complex roots appear, and each is a way to fail. The **algebraic multiplicity** of $\lambda$ is its multiplicity as a root; the **geometric multiplicity** is the dimension of its eigenspace. The second never exceeds the first, and $A$ is diagonalizable exactly when they agree for every eigenvalue.

> The matrix $\begin{pmatrix}1&1\\0&1\end{pmatrix}$ has the single eigenvalue $1$ with algebraic multiplicity $2$, but $(A-I)v=0$ only gives multiples of $(1,0)$. There is one eigenvector direction, no eigenbasis, and the matrix is not diagonalizable.
{: .example title="A defective matrix"}

Such a matrix is **defective**. The best one can do is the **Jordan form**: $P^{-1}AP$ is block diagonal, each block having one eigenvalue on the diagonal and ones just above it. This is the general statement over $\mathbb C$, and a defective block is exactly where powers $A^k$ pick up polynomial factors in $k$ next to $\lambda^k$.

> A real matrix can have complex eigenvalues, and then it has no real eigenvectors: a rotation of the plane by $90^\circ$ has $\det(A-\lambda I)=\lambda^2+1$. It is diagonalizable over $\mathbb C$ but not over $\mathbb R$, so say which field the question is asked in.
{: .trap}

> Do not conclude from distinct eigenvalues to a symmetric or orthogonal eigenbasis. The eigenvectors of $\begin{pmatrix}1&1\\0&2\end{pmatrix}$ are $(1,0)$ and $(1,1)$, which are independent but not perpendicular. Orthogonality needs the symmetry assumption of the spectral theorem.
{: .trap}

# Where this goes next

For a real symmetric matrix the eigenbasis can be chosen orthonormal and all eigenvalues are real; that is the spectral theorem, and it is what makes principal components and the singular value decomposition work.

# Recap

<details class="qa" markdown="1">
<summary>Why are eigenvalues the roots of $\det(A-\lambda I)$?</summary>

$Av=\lambda v$ with $v\ne0$ means $A-\lambda I$ sends a non-zero vector to zero, so it is singular, and a matrix is singular exactly when its determinant vanishes.
</details>

<details class="qa" markdown="1">
<summary>What does diagonalizing a matrix buy you?</summary>

In an eigenbasis the map is a list of stretches, so powers and exponentials of $A$ reduce to powers and exponentials of numbers: $A^k=PD^kP^{-1}$.
</details>

<details class="qa" markdown="1">
<summary>Name two reasons a matrix may fail to be diagonalizable.</summary>

A repeated eigenvalue whose eigenspace is smaller than its multiplicity (a defective matrix, Jordan blocks), and complex eigenvalues when only real eigenvectors are allowed.
</details>
