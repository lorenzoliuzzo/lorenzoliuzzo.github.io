---
collection: notes
title: "Angular Momentum and Spin"
date: 2026-10-27
excerpt: "The angular momentum algebra, its eigenvalues and spin one half."
hook: "Rotations do not commute, and the commutation relations of the angular momentum operators alone fix the allowed values, integer and half-integer."
goals:
  - derive the allowed values of J^2 and J_z
  - build the spin matrices for spin one half and spin one
requires:
  - commutator
  - pauli-operators
  - ladder-operators
defines:
  - {id: angular-momentum-algebra, name: "angular momentum algebra", anchor: def-angular-momentum-algebra}
  - {id: spin, name: "spin", anchor: def-spin}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

Rotations in three dimensions do not commute, and in quantum theory that single fact fixes the possible values of angular momentum. The same algebra also describes spin, which has no classical counterpart.

# The algebra

> The **angular momentum algebra** is the set of three Hermitian operators $J_x,J_y,J_z$ with the commutation relations $[J_x,J_y]=i\hbar J_z$ and its cyclic permutations. The operator $J^2=J_x^2+J_y^2+J_z^2$ commutes with each component.
{: .definition #def-angular-momentum-algebra title="Angular momentum algebra"}

For orbital angular momentum $\mathbf L=\mathbf r\times\mathbf p$ these relations follow from $[x,p_x]=i\hbar$. They are the quantum statement that rotations about different axes do not commute. Any set of operators with these relations describes an angular momentum, whether or not it comes from a position: this is how spin is introduced.

Since $J^2$ commutes with $J_z$, the two share eigenstates $|j,m\rangle$, with $J^2|j,m\rangle=\hbar^2j(j+1)|j,m\rangle$ and $J_z|j,m\rangle=\hbar m|j,m\rangle$. Ladder operators $J_\pm=J_x\pm iJ_y$ satisfy $[J_z,J_\pm]=\pm\hbar J_\pm$, so they change $m$ by one unit, and they cannot go past $|m|=j$. The conclusion:

> **Allowed values.** The quantum number $j$ takes the values $0,\frac12,1,\frac32,\dots$, and for each $j$ the number $m$ takes the $2j+1$ values $-j,-j+1,\dots,j$. Only integer $j$ occurs for orbital angular momentum.
{: .theorem #thm-angular-momentum-values title="Allowed angular momentum values"}

> Since $J_x^2+J_y^2=J^2-J_z^2\ge0$, the values $m^2\le j(j+1)$ are bounded, so $m$ has a largest value, which we call $j$, with $J_+|j,j\rangle=0$. Using $J_-J_+=J^2-J_z^2-\hbar J_z$ on this state gives $J^2=\hbar^2j(j+1)$. Likewise there is a smallest value $-j'$ with $J_-|j,-j'\rangle=0$, and $J_+J_-=J^2-J_z^2+\hbar J_z$ gives $j'(j'+1)=j(j+1)$, so $j'=j$. The ladder $J_-$ connects $m=j$ to $m=-j$ in steps of one, so $2j$ is a whole number.
{: .proof}

The two components $J_x$ and $J_y$ cannot be sharp when $J_z$ is: by the uncertainty relation $\Delta J_x\Delta J_y\ge\frac\hbar2|\langle J_z\rangle|$. For $j=1$ the length of the vector is $\sqrt{j(j+1)}\hbar=1.41\hbar$ while its largest $z$ component is $\hbar$, so the transverse components must carry the difference.

{% include fig.html src="quantum-theory/angular-momentum-cones" id="fig-angular-momentum-cones" alt="A circle with three arrows from its centre to the circle at heights of plus one, zero and minus one, each with a dashed horizontal line through its tip." caption="The vector model for $j=1$. The length is $\sqrt2\,\hbar$ and $J_z$ takes the values $-\hbar,0,\hbar$; each arrow stands for a whole cone around the $z$ axis, since the transverse components are not sharp." %}

# Spin

> **Spin** is an intrinsic angular momentum with no position-space description. A particle of spin $s$ has a $(2s+1)$-dimensional spin space on which $S_x,S_y,S_z$ satisfy the angular momentum algebra. The electron has $s=\frac12$.
{: .definition #def-spin title="Spin"}

For $s=\frac12$ the space is two-dimensional and the operators are $S_i=\frac\hbar2\sigma_i$ in terms of the Pauli matrices, so every result of the qubit notes is a statement about spin one half: $[S_x,S_y]=i\hbar S_z$ is the algebra $[X,Y]=2iZ$ rescaled. $S^2=\frac34\hbar^2$, and a spin-$\frac12$ state is a point on the Bloch sphere, with $\langle\mathbf S\rangle=\frac\hbar2\mathbf r$. For spin one the matrices are $3\times3$, with $S_z=\hbar\,\mathrm{diag}(1,0,-1)$ and $S^2=2\hbar^2I$.

A rotation by the angle $\theta$ about the axis $\hat n$ is the unitary $e^{-i\theta\,\hat n\cdot\mathbf J/\hbar}$. This is the single-qubit rotation gate $R_n(\theta)$ for spin $\frac12$, and the half-angle in it is the reason a $2\pi$ rotation of a spin-$\frac12$ state gives $-1$ rather than $1$.

> For a particle in a magnetic field $\mathbf B$ the Hamiltonian of the spin is $H=-\gamma\,\mathbf S\cdot\mathbf B$ with the gyromagnetic ratio $\gamma$. By the Heisenberg equation $\langle\mathbf S\rangle$ precesses about $\mathbf B$ at the Larmor frequency $\omega_L=\gamma B$, which is the principle of magnetic resonance and of driving a qubit with a microwave field.
{: .application title="Larmor precession"}

> Spin is not the rotation of a small ball. A point-like electron has no size to rotate with, and half-integer values appear in no classical or orbital angular momentum. The only content of the word is the algebra above.
{: .trap}

> To find the angular momentum content of a system, identify the operators that satisfy the algebra, find the largest $m$ to get $j$, and use ladder operators to generate the rest of the multiplet.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What values can $j$ and $m$ take?</summary>

$j=0,\frac12,1,\dots$ and $m=-j,\dots,j$, which is $2j+1$ values. Integer $j$ only for orbital motion.
</details>

<details class="qa" markdown="1">
<summary>Why can't all three components of angular momentum be sharp?</summary>

They do not commute. In an eigenstate of $J_z$ with $|m|\le j$, the transverse components carry the rest of $\hbar^2j(j+1)$, and their spreads obey $\Delta J_x\Delta J_y\ge\frac\hbar2|\langle J_z\rangle|$.
</details>

<details class="qa" markdown="1">
<summary>How is spin one half related to the qubit?</summary>

It is the same two-dimensional space, with spin operators $\frac\hbar2$ times the Paulis, and rotations of the spin are the rotation gates of the Bloch sphere.
</details>
