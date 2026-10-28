---
collection: notes
title: "Observables and Hermitian Operators"
date: 2026-10-27
excerpt: "Observables as Hermitian operators, spectral decomposition, outcome probabilities and mean values."
hook: "Every measurable quantity is a Hermitian operator, its eigenvalues are the possible results, and the mean and spread of the outcomes follow from the state without choosing a basis."
goals:
  - compute outcome probabilities and the mean of an observable from its spectral decomposition
  - compute the variance of an observable in a state
requires:
  - hilbert-space
  - spectral-theorem
  - born-rule
  - variance
defines:
  - {id: observable, name: "observable", anchor: def-observable}
  - {id: hermitian-operator, name: "Hermitian operator", anchor: def-hermitian-operator}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

A measurement outcome is a number, and the state is a vector. The second postulate connects them with operators: each measurable quantity is an operator on the Hilbert space whose eigenvalues are the numbers that can occur.

# Hermitian operators

> An **observable** is a measurable physical quantity, represented by a Hermitian operator $A$ on the Hilbert space of the system. The possible outcomes of a measurement are the eigenvalues of $A$.
{: .definition #def-observable title="Observable"}

> An operator $A$ is **Hermitian** if $A^\dagger=A$, that is $\langle\phi|A\psi\rangle=\langle A\phi|\psi\rangle$ for all vectors. Hermitian operators have real eigenvalues, and eigenvectors with distinct eigenvalues are orthogonal.
{: .definition #def-hermitian-operator title="Hermitian operator"}

The two properties follow from one line each. If $A|a\rangle=a|a\rangle$, then $a\langle a|a\rangle=\langle a|A|a\rangle=\langle A a|a\rangle=a^*\langle a|a\rangle$, so $a$ is real. For $A|a\rangle=a|a\rangle$ and $A|b\rangle=b|b\rangle$, $(a-b)\langle b|a\rangle=0$. The spectral theorem adds that in finite dimensions the eigenvectors form an orthonormal basis, and it gives the decomposition
$$ A=\sum_aa\,\Pi_a,\qquad\Pi_a=\sum_{k}|a,k\rangle\langle a,k|, $$
where $\Pi_a$ projects onto the eigenspace of $a$ and the index $k$ labels degenerate eigenvectors.

# What a measurement gives

> **Measurement postulate.** Measuring $A$ in the state $|\psi\rangle$ gives the eigenvalue $a$ with probability $p(a)=\langle\psi|\Pi_a|\psi\rangle$, and the state afterwards is $\Pi_a|\psi\rangle/\sqrt{p(a)}$.
{: .law #def-measurement-postulate title="Measurement postulate"}

This is the Born rule written for a general observable. From the probabilities the statistics follow without reference to a basis:
$$ \langle A\rangle=\sum_aa\,p(a)=\langle\psi|A|\psi\rangle,\qquad(\Delta A)^2=\langle A^2\rangle-\langle A\rangle^2=\|(A-\langle A\rangle)\psi\|^2. $$
The second expression shows that $\Delta A=0$ only when $|\psi\rangle$ is an eigenvector of $A$: a sharp value exists only for eigenstates.

Take an observable with eigenvalues $-1,0,2$ and a state with probabilities $0.2,0.5,0.3$ of finding them. Then $\langle A\rangle=-0.2+0+0.6=0.4$, $\langle A^2\rangle=0.2+0+1.2=1.4$, and $(\Delta A)^2=1.4-0.16=1.24$, so $\Delta A=1.11$.

{% include fig.html src="quantum-theory/observable-statistics" id="fig-observable-statistics" alt="Bar chart of three outcome probabilities over the eigenvalues minus one, zero and two, with a vertical line at the mean of 0.4 and a horizontal bar showing one standard deviation either side." caption="The Born probabilities of an observable with eigenvalues $-1,0,2$ (bars), its mean (vertical line) and its spread (horizontal bar)." %}

> The mean $\langle A\rangle$ need not be an eigenvalue and usually is not: here $0.4$ is never obtained in a single measurement. It is the average over many identically prepared systems.
{: .trap}

A degenerate eigenvalue shows the role of the projector. For two qubits, the observable $Z\otimes I$ has the eigenvalue $+1$ on the plane spanned by $|00\rangle$ and $|01\rangle$. In the state $(|00\rangle+|01\rangle+|10\rangle)/\sqrt3$ it gives $+1$ with probability $\frac23$, and the state afterwards is $(|00\rangle+|01\rangle)/\sqrt2$: the measurement removes the component outside the eigenspace and leaves the relative amplitude inside it untouched.

# Functions of observables

For a function $f$, $f(A)=\sum_af(a)\Pi_a$. The result is Hermitian when $f$ is real, and it commutes with $A$. This is how the energy operator of a free particle, $p^2/2m$, or the unitary $e^{-iHt/\hbar}$ of the next notes are defined once the spectral decomposition is known, and it is the reason the qubit gate $e^{-i\theta P/2}$ equals $\cos\frac\theta2I-i\sin\frac\theta2P$ for a Pauli operator.

> To predict an experiment, find the eigenvalues and eigenprojectors of the observable, project the state to get probabilities, and use $\langle\psi|A|\psi\rangle$ and $\Delta A$ when only mean and spread are needed.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why are observables Hermitian?</summary>

Outcomes are real numbers, and a Hermitian operator has real eigenvalues and an orthonormal eigenbasis, so measurement outcomes are well defined and probabilities add to one.
</details>

<details class="qa" markdown="1">
<summary>What is the state after a measurement?</summary>

The normalised projection of the state onto the eigenspace of the outcome obtained.
</details>

<details class="qa" markdown="1">
<summary>When is the spread $\Delta A$ zero?</summary>

Exactly when the state is an eigenvector of $A$.
</details>
