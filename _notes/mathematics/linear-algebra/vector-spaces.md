---
collection: notes
title: Vector Spaces
date: '2026-10-27'
excerpt: Vector spaces, subspaces, span, independence, basis and dimension.
hook: A vector space is anything you can add and scale; a basis says how few vectors you need to describe all of it.
goals:
- decide whether a set is a subspace, independent or a basis
- find the dimension of a space
defines:
- id: vector-space
  name: vector space
  anchor: vector-space
- id: basis
  name: basis and dimension
  anchor: basis-and-dimension
plan:
  sources: []
  figures:
  - span of one and two vectors in the plane
  - the same vector in two bases
  verify:
  - dimension of the solution set of Ax = 0 is n minus rank
  - any two bases of a finite-dimensional space have the same size
tags:
- Mathematics
- Linear Algebra
read_time: true
---

Vectors in the plane, polynomials, continuous functions and $m\times n$ matrices have little in common as objects, but they obey the same rules for adding and scaling. Linear algebra studies those rules once and applies them to all of them.

# Vector space

A **vector space** over $\mathbb R$ is a set $V$ with an addition $V\times V\to V$ and a multiplication by numbers $\mathbb R\times V\to V$ satisfying the following. Addition is associative and commutative, has a zero vector $0$, and every $v$ has an opposite $-v$. Scaling satisfies $a(bv)=(ab)v$, $1v=v$, and distributes over both kinds of addition, $a(u+v)=au+av$ and $(a+b)v=av+bv$. Nothing else is assumed, in particular no lengths and no angles.

Examples that recur throughout the course: $\mathbb R^n$; the polynomials of degree at most $n$; the continuous functions on $[0,1]$; the $m\times n$ matrices. The set of solutions of a homogeneous linear system $Ax=0$ is a vector space too, which is why linear algebra applies to linear differential equations later.

A **subspace** is a subset $W\subseteq V$ that is itself a vector space under the same operations. It is enough to check three things: $0\in W$, $u+v\in W$ and $av\in W$ for all $u,v\in W$ and all $a$. A line through the origin in $\mathbb R^2$ is a subspace; the same line shifted off the origin is not, because it misses $0$.

> The test that most often fails is the zero vector. The set $\{(x,y):x+y=1\}$ passes every geometric intuition for a line and fails here at once.
{: .trap}

# Span and independence

A **linear combination** of $v_1,\dots,v_k$ is a sum $a_1v_1+\dots+a_kv_k$. The **span** is the set of all of them, and it is the smallest subspace containing the $v_i$. One nonzero vector spans a line, two vectors that do not lie on a common line span a plane, and a third vector in that plane adds nothing.

That last situation is what independence measures. The vectors $v_1,\dots,v_k$ are **linearly independent** if
$$ a_1v_1+\dots+a_kv_k=0 \quad\Longrightarrow\quad a_1=\dots=a_k=0. $$
Equivalently, no vector of the list is a combination of the others. For vectors in $\mathbb R^n$ collect them as the columns of a matrix $A$: they are independent exactly when $Ax=0$ has only the solution $x=0$, which is checked by row reduction.

# Basis and dimension

A **basis** of $V$ is a list that is independent and spans $V$. Spanning says nothing is missing and independence says nothing is redundant. Every $v\in V$ is then a combination of the basis in exactly one way: if $v=\sum a_ib_i=\sum a_i'b_i$, subtracting gives a vanishing combination, so $a_i=a_i'$ by independence. The numbers $a_i$ are the **coordinates** of $v$.

The key theorem is that any two bases of a finite-dimensional space have the same number of elements. The proof exchanges vectors one at a time: in a spanning list of size $m$, any independent list has size at most $m$. That common size is the **dimension** $\dim V$. So $\dim\mathbb R^n=n$, the polynomials of degree at most $n$ have dimension $n+1$ with basis $1,x,\dots,x^n$, and the matrices of size $m\times n$ have dimension $mn$.

A basis is a choice of coordinates, and the vector does not depend on that choice. Take $w=(3,2)$. In the standard basis its coordinates are $(3,2)$. In the basis $b_1=(2,1)$, $b_2=(-1,1)$ solve $2\alpha-\beta=3$ and $\alpha+\beta=2$, which gives $\alpha=5/3$ and $\beta=1/3$.

{% include fig.html src="linear-algebra/two-bases" id="fig-two-bases" alt="Two copies of the plane. In the first, an arrow w is the sum of three steps along the horizontal unit arrow and two along the vertical one. In the second, the same arrow w is five thirds of a first skew arrow plus one third of a second." caption="The same vector $w$ in two bases. Its coordinates change, from $(3,2)$ to $(5/3,1/3)$, but the arrow is the same; the dashed path shows the steps." %}

The dimension also counts solutions. For an $m\times n$ matrix $A$ with rank $r$, the solutions of $Ax=0$ form a subspace of dimension $n-r$: the $r$ pivot columns are fixed by the others, and each of the $n-r$ free variables can be chosen independently. This is the first form of the rank-nullity theorem, which the next note proves for linear maps.

{% capture t %}
| Space | Basis | Dimension |
|:--|:--|:--|
| $\mathbb R^3$ | $e_1,e_2,e_3$ | 3 |
| polynomials of degree $\le n$ | $1,x,\dots,x^n$ | $n+1$ |
| $m\times n$ matrices | matrix units $E_{ij}$ | $mn$ |
| solutions of $y''+y=0$ | $\cos x,\ \sin x$ | 2 |
{% endcapture %}
{% include tab.html id="tab-bases" caption="Bases and dimensions of the standard examples." body=t %}
{: .booktabs}

# Recap

<details class="qa" markdown="1">
<summary>What must be checked for a subset to be a subspace?</summary>

That it contains $0$ and is closed under addition and under multiplication by numbers. Failing the zero test is the usual way a candidate fails.
</details>

<details class="qa" markdown="1">
<summary>What do independence and spanning say, and what is a basis?</summary>

Independence says no vector of the list is a combination of the others; spanning says every vector of the space is a combination. A basis does both, so each vector has exactly one set of coordinates.
</details>

<details class="qa" markdown="1">
<summary>What is the dimension of the solution set of $Ax=0$?</summary>

$n-r$ for an $m\times n$ matrix of rank $r$: one free parameter for each non-pivot column.
</details>
