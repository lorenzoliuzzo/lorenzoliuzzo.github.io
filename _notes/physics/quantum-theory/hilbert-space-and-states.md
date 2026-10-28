---
collection: notes
title: "States, Kets and the Hilbert Space"
date: 2026-10-27
excerpt: "The state space of a quantum system, Dirac notation and the superposition principle."
hook: "A quantum state is a vector in a complex inner-product space, and the amplitudes of a superposition add before they are squared, which is where interference comes from."
goals:
  - write a state as a ket and read its components as amplitudes
  - explain interference as the addition of amplitudes
requires:
  - vector-space
  - inner-product
  - qubit
defines:
  - {id: hilbert-space, name: "Hilbert space", anchor: def-hilbert-space}
  - {id: dirac-notation, name: "Dirac notation", anchor: def-dirac-notation}
  - {id: quantum-superposition, name: "superposition principle", anchor: def-quantum-superposition}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

Quantum theory starts from one idea about what a state is. The rest of the course, from qubits to oscillators and entangled pairs, is what follows from taking it seriously: states are vectors, and vectors can be added.

# The state space

> A **Hilbert space** $\mathcal H$ is a complex vector space with an inner product $\langle\phi|\psi\rangle$ that is complete: every Cauchy sequence of vectors converges. For finite-dimensional systems, such as a qubit with $\mathcal H=\mathbb C^2$, completeness is automatic and a Hilbert space is a complex inner-product space.
{: .definition #def-hilbert-space title="Hilbert space"}

The first postulate says that the state of an isolated system is a unit vector in $\mathcal H$, and that $|\psi\rangle$ and $e^{i\alpha}|\psi\rangle$ describe the same state. The inner product turns amplitudes into numbers, so that for an orthonormal basis $\{|n\rangle\}$ any state is $|\psi\rangle=\sum_nc_n|n\rangle$ with $c_n=\langle n|\psi\rangle$ and normalisation $\sum_n|c_n|^2=1$.

> **Dirac notation** writes a vector as a ket $|\psi\rangle$, the linear functional it defines through the inner product as a bra $\langle\psi|$, the inner product as the bracket $\langle\phi|\psi\rangle$ and an operator that maps $|\psi\rangle$ to $|\phi\rangle$ as the outer product $|\phi\rangle\langle\psi|$.
{: .definition #def-dirac-notation title="Dirac notation"}

The outer product gives the resolution of the identity, $\sum_n|n\rangle\langle n|=I$ for any orthonormal basis, which is the tool for changing bases in a line: insert $I$ and read off the coefficients. The operator $|n\rangle\langle n|$ projects onto $|n\rangle$.

# Superposition and interference

> **Superposition principle.** If $|\psi_1\rangle$ and $|\psi_2\rangle$ are possible states of a system, so is every normalised combination $a|\psi_1\rangle+b|\psi_2\rangle$ with $a,b\in\mathbb C$. The probability of a result is the squared modulus of the total amplitude, so amplitudes for different paths add before they are squared.
{: .law #def-quantum-superposition title="Superposition principle"}

The consequence is interference. Suppose a particle can reach a detector by two routes, each with amplitude $\frac12$ and with a relative phase $\varphi$ between them. Taken alone, each route gives probability $\frac14$, so adding probabilities as for classical particles gives $\frac12$. The quantum rule adds the amplitudes first:
$$ P=\Big|\tfrac12\big(1+e^{i\varphi}\big)\Big|^2=\cos^2\tfrac\varphi2, $$
which ranges from $0$ to $1$ as the phase changes. This is the output of a balanced interferometer, and with $\varphi=\pi$ the two routes cancel completely.

{% include fig.html src="quantum-theory/interference-amplitudes" id="fig-interference-amplitudes" alt="A cosine-squared curve of probability against relative phase, crossing a dashed horizontal line at one half." caption="Two routes of amplitude $\tfrac12$ each. Adding probabilities gives a constant $\tfrac12$; adding amplitudes gives $\cos^2(\varphi/2)$, between $0$ and $1$ depending on the phase." %}

The superposition is not a statistical mixture of the two states. A mixture, described by a density matrix, has no $\varphi$-dependence, which is the difference between a qubit in $|+\rangle$ and one that is $|0\rangle$ or $|1\rangle$ with equal probability.

> Global phase is irrelevant, relative phase is not. $|\psi\rangle$ and $-|\psi\rangle$ are the same state, while $|0\rangle+|1\rangle$ and $|0\rangle-|1\rangle$ are orthogonal.
{: .trap}

# Infinite dimensions

Many systems, a particle on a line for instance, need infinitely many basis states. The space is then $L^2$, the square-integrable functions, and the discrete sums above become integrals. The state of a particle on a line is a function $\psi(x)$ with $\int|\psi|^2dx=1$, and it is the vector $|\psi\rangle$ written in the basis of positions. The new difficulty is that operators such as position are unbounded and have continuous spectra, which the notes on position and momentum take up.

> Before computing, check the answer would not change under a change of basis. If a result depends on writing $|0\rangle$ rather than $|1\rangle$ first, as when a matrix is read off in the wrong ordering, a basis was treated as the state itself.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What is the state of a quantum system?</summary>

A unit vector in a Hilbert space, defined up to a global phase.
</details>

<details class="qa" markdown="1">
<summary>Why does superposition differ from a probabilistic mixture?</summary>

Amplitudes carry phases and are added before squaring, so the relative phase affects the probabilities. A mixture adds probabilities and has no such dependence.
</details>

<details class="qa" markdown="1">
<summary>What does the resolution of the identity let you do?</summary>

Insert $\sum_n|n\rangle\langle n|$ between any bra and ket to expand in a basis, which turns abstract expressions into sums over amplitudes.
</details>
