---
collection: notes
title: The Density Matrix
date: '2026-10-27'
excerpt: Pure and mixed states, purity, and why mixed states sit inside the Bloch ball.
hook: When the state is only known statistically, the vector is replaced by a density matrix, and the Bloch vector shrinks inside the sphere as purity is lost.
goals:
- build the density matrix of an ensemble
- show that a mixed qubit lies strictly inside the Bloch sphere
requires:
- qubit
- bloch-sphere
- born-rule
defines:
- id: density-matrix
  name: density matrix
  anchor: def-density-matrix
- id: mixed-state
  name: mixed state
  anchor: def-mixed-state
- id: purity
  name: purity
  anchor: def-purity
read_time: true
tags:
- Physics
- Quantum Computing
---

A state vector describes a qubit prepared in one definite way. Real devices are noisy, and an experiment may even prepare $|0\rangle$ half of the time and $|+\rangle$ the other half. The density matrix is the object that describes both cases and keeps every prediction of the Born rule.

# From ensembles to a matrix

> The **density matrix** of an ensemble that is in the pure state $|\psi_k\rangle$ with probability $p_k$ is $\rho=\sum_kp_k|\psi_k\rangle\langle\psi_k|$. It is Hermitian, positive semidefinite and has trace $1$, and it gives the probability of an outcome $a$ as $\mathrm{tr}(\Pi_a\rho)$ and the expectation value of an observable $A$ as $\langle A\rangle=\mathrm{tr}(A\rho)$.
{: .definition #def-density-matrix title="Density matrix"}

The formula follows from the Born rule for each member, weighted by $p_k$: $\sum_kp_k\langle\psi_k|A|\psi_k\rangle=\mathrm{tr}(A\rho)$, using the fact that $\langle\psi|A|\psi\rangle=\mathrm{tr}(A|\psi\rangle\langle\psi|)$. A pure state $|\psi\rangle$ is the special case $\rho=|\psi\rangle\langle\psi|$.

> A state is **mixed** when it is not pure, that is when $\rho$ cannot be written as $|\psi\rangle\langle\psi|$ for any vector. A mixed state is a classical probability distribution over pure states, and different ensembles can give the same $\rho$.
{: .definition #def-mixed-state title="Mixed state"}

The last statement matters. An equal mixture of $|0\rangle,|1\rangle$ and an equal mixture of $|+\rangle,|-\rangle$ both give $\rho=I/2$, and no measurement can tell them apart. The density matrix holds exactly what is observable and no more.

# Bloch vectors and purity

For a qubit, any $\rho$ can be written $\rho=\frac12(I+\mathbf r\cdot\boldsymbol\sigma)$ with the Bloch vector $\mathbf r=(\langle X\rangle,\langle Y\rangle,\langle Z\rangle)$. Its eigenvalues are $\frac12(1\pm|\mathbf r|)$, so positivity requires $|\mathbf r|\le1$: the allowed states fill the whole Bloch ball, and pure states are its surface.

> The **purity** of a state is $\gamma=\mathrm{tr}(\rho^2)$. It lies between $1/d$ and $1$ for a $d$-dimensional system, equals $1$ exactly for pure states, and for a qubit equals $\frac12(1+|\mathbf r|^2)$.
{: .definition #def-purity title="Purity"}

Mixing pure states averages their Bloch vectors, so a mixture lies on the chord between them. An equal mixture of $|0\rangle$, with $\mathbf r=(0,0,1)$, and $|+\rangle$, with $\mathbf r=(1,0,0)$, has $\mathbf r=(\frac12,0,\frac12)$. Its length is $1/\sqrt2\approx0.71$ and its purity is $0.75$.

{% include fig.html src="quantum-computing/mixed-state-disc" id="fig-mixed-state-disc" alt="A circle with two points on its edge joined by a dashed chord. The midpoint of the chord and the centre of the circle are marked." caption="A cross-section of the Bloch ball. Pure states lie on the circle, an equal mixture of $|0\rangle$ and $|+\rangle$ lies at the midpoint of the chord, and the maximally mixed state $I/2$ is the centre." %}

> Noise moves a qubit inward. Depolarising noise with probability $q$ shrinks the Bloch vector by the factor $1-q$, so a $10\%$ depolarised $|0\rangle$ has $r=0.9$ and purity $0.905$. Unitary gates leave purity unchanged, so only a measurement or a fresh preparation restores it.
{: .application title="Noise as shrinkage"}

> Unitary evolution acts as $\rho\mapsto U\rho U^\dagger$ and keeps $\mathrm{tr}\,\rho^2$ fixed, so the Bloch ball rotates rigidly under gates. A measurement with outcome $a$ maps $\rho$ to $\Pi_a\rho\Pi_a/\mathrm{tr}(\Pi_a\rho)$.
{: .property #prop-density-evolution title="Evolution and measurement of $\rho$"}

> Do not read a mixed state as "the system is secretly in one of the pure states, we just do not know which". That reading fails for the reduced state of a subsystem of an entangled pair, which is mixed although nothing about the pair is unknown. The next notes on multi-qubit systems return to this.
{: .trap}

> To describe a qubit with noise or a partly known preparation, work with $\rho$ and its Bloch vector, and quote the purity as a measure of how much coherence is left.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>How is the density matrix of an ensemble built, and what does it predict?</summary>

It is the probability-weighted sum of the projectors on the members. The expectation value of an observable is $\mathrm{tr}(A\rho)$ and the probability of an outcome is $\mathrm{tr}(\Pi_a\rho)$.
</details>

<details class="qa" markdown="1">
<summary>Where do mixed qubit states sit in the Bloch picture?</summary>

Strictly inside the ball. The length of the Bloch vector is $\sqrt{2\,\mathrm{tr}\rho^2-1}$, the surface holds the pure states and the centre is the maximally mixed state $I/2$.
</details>

<details class="qa" markdown="1">
<summary>Can you tell two ensembles with the same $\rho$ apart?</summary>

No. All outcome statistics depend on $\rho$ alone, so the ensemble is not observable beyond its density matrix.
</details>
