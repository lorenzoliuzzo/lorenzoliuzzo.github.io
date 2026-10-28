---
collection: notes
title: The Qubit and the Bloch Sphere
date: '2026-10-27'
excerpt: A two-level system as a unit vector in C^2, the Bloch sphere and the Pauli operators.
hook: A qubit is a unit vector in a two-dimensional complex space, and its global phase is invisible, which leaves exactly the two angles of a point on a sphere.
goals:
- write a pure qubit state from its Bloch angles
- read the Pauli expectation values as Bloch coordinates
requires:
- vector-space
- inner-product
- eigenvalue
defines:
- id: qubit
  name: qubit
  anchor: def-qubit
- id: bloch-sphere
  name: Bloch sphere
  anchor: def-bloch-sphere
- id: pauli-operators
  name: Pauli operators
  anchor: def-pauli-operators
read_time: true
tags:
- Physics
- Quantum Computing
---

A classical bit is $0$ or $1$. A qubit is any unit vector in a two-dimensional complex space, and two facts about that space make it fit on a sphere: the overall phase of a vector is unobservable, and a complex vector with unit length has only three real degrees of freedom left after that.

# A qubit as a vector

> A **qubit** is a quantum system whose states are the unit vectors $|\psi\rangle=\alpha|0\rangle+\beta|1\rangle$ of $\mathbb C^2$, with $\alpha,\beta\in\mathbb C$ and $|\alpha|^2+|\beta|^2=1$. The vectors $|0\rangle=(1,0)^{\mathsf T}$ and $|1\rangle=(0,1)^{\mathsf T}$ form the computational basis.
{: .definition #def-qubit title="Qubit"}

The coefficients are amplitudes. Measuring in the computational basis gives $0$ with probability $|\alpha|^2$ and $1$ with probability $|\beta|^2$, which is why the normalization is $|\alpha|^2+|\beta|^2=1$; the measurement note works this out. The vector $|+\rangle=(|0\rangle+|1\rangle)/\sqrt2$ gives $0$ or $1$ with probability $\frac12$ each, and $|-\rangle=(|0\rangle-|1\rangle)/\sqrt2$ does as well, yet the two are different states and are distinguished by what other operations do to them.

Multiplying the vector by a phase $e^{i\gamma}$ changes no probability of any measurement, so $|\psi\rangle$ and $e^{i\gamma}|\psi\rangle$ describe the same physical state. Only the **relative** phase between $\alpha$ and $\beta$ matters. Removing the global phase, the free parameters are the magnitude ratio and the relative phase: two real numbers.

# The Bloch sphere

Choose the global phase so that $\alpha$ is real and non-negative. Then $\alpha=\cos(\theta/2)$ and $\beta=e^{i\varphi}\sin(\theta/2)$ with $\theta\in[0,\pi]$ and $\varphi\in[0,2\pi)$:
$$ |\psi\rangle=\cos\frac\theta2\,|0\rangle+e^{i\varphi}\sin\frac\theta2\,|1\rangle. $$

> The **Bloch sphere** is the unit sphere on which the pure state with angles $(\theta,\varphi)$ is the point $\mathbf n=(\sin\theta\cos\varphi,\ \sin\theta\sin\varphi,\ \cos\theta)$. Every pure qubit state is a point of the sphere and every point is a state.
{: .definition #def-bloch-sphere title="Bloch sphere"}

The half-angle is needed because $|0\rangle$ and $|1\rangle$ are orthogonal, yet they sit at opposite poles, a rotation by $\pi$ on the sphere and by $\pi/2$ in the amplitude space.

{% include fig.html src="quantum-computing/bloch-sphere" id="fig-bloch-sphere" alt="A sphere with a vertical axis whose ends are labelled zero and one, and horizontal axes x and y. An arrow from the centre to a point on the surface is labelled psi, with the polar angle theta from the vertical and the azimuth phi in the equatorial plane." caption="A pure qubit state as a point of the Bloch sphere. The polar angle $\theta$ sets the probabilities of $0$ and $1$, the azimuth $\varphi$ sets the relative phase. Orthogonal states sit at opposite ends of a diameter." %}

{% capture t %}
| State | $\theta$, $\varphi$ | Point |
|:--|:--|:--|
| $\lvert0\rangle$, $\lvert1\rangle$ | $0$, $\pi$ | $+z$, $-z$ |
| $\lvert\pm\rangle=(\lvert0\rangle\pm\lvert1\rangle)/\sqrt2$ | $\pi/2$, $0$ or $\pi$ | $\pm x$ |
| $\lvert\pm i\rangle=(\lvert0\rangle\pm i\lvert1\rangle)/\sqrt2$ | $\pi/2$, $\pm\pi/2$ | $\pm y$ |
{% endcapture %}
{% include tab.html id="tab-bloch-points" caption="The six states at the ends of the axes." body=t %}
{: .booktabs}

> Orthogonal states are antipodal on the sphere, not at a right angle. The overlap of two pure states is $|\langle\psi|\phi\rangle|^2=\tfrac12(1+\mathbf n_\psi\cdot\mathbf n_\phi)$, which vanishes exactly when $\mathbf n_\phi=-\mathbf n_\psi$.
{: .trap}

# Pauli operators

The coordinates of $\mathbf n$ are not arbitrary: they are expectation values of three matrices.

> The **Pauli operators** are $\sigma_x=\begin{pmatrix}0&1\\1&0\end{pmatrix}$, $\sigma_y=\begin{pmatrix}0&-i\\i&0\end{pmatrix}$ and $\sigma_z=\begin{pmatrix}1&0\\0&-1\end{pmatrix}$. Each is Hermitian and unitary, squares to the identity and has eigenvalues $\pm1$, and they obey $\sigma_x\sigma_y=i\sigma_z$ with cyclic permutations; two different ones anticommute.
{: .definition #def-pauli-operators title="Pauli operators"}

> For a pure state with Bloch vector $\mathbf n$, $\langle\psi|\sigma_x|\psi\rangle=n_x$, $\langle\psi|\sigma_y|\psi\rangle=n_y$ and $\langle\psi|\sigma_z|\psi\rangle=n_z$.
{: .property title="Bloch coordinates are Pauli expectation values"}

With $\alpha=\cos\frac\theta2$ and $\beta=e^{i\varphi}\sin\frac\theta2$ one computes $\langle\sigma_z\rangle=|\alpha|^2-|\beta|^2=\cos\theta$, $\langle\sigma_x\rangle=2\operatorname{Re}(\bar\alpha\beta)=\sin\theta\cos\varphi$ and $\langle\sigma_y\rangle=2\operatorname{Im}(\bar\alpha\beta)=\sin\theta\sin\varphi$. The eigenvectors of $\sigma_z$ are $|0\rangle,|1\rangle$, those of $\sigma_x$ are $|\pm\rangle$ and those of $\sigma_y$ are $|\pm i\rangle$, the pairs at the ends of the three axes. For example $(|0\rangle+i|1\rangle)/\sqrt2$ has $\langle\sigma_y\rangle=1$ and $\langle\sigma_x\rangle=\langle\sigma_z\rangle=0$, so it is the point $+y$.

Any $2\times2$ Hermitian matrix is a combination $a_0I+\mathbf a\cdot\boldsymbol\sigma$ of the identity and the three Paulis, which makes them the natural basis for observables and, next, for gates: a rotation of the Bloch sphere about the axis $\hat{\mathbf m}$ by an angle $\alpha$ is $e^{-i\alpha\,\hat{\mathbf m}\cdot\boldsymbol\sigma/2}$.

> The states of an isolated pure qubit lie on the surface, with $|\mathbf n|=1$. A qubit that is entangled with another system, or noisy, is described by a point strictly inside the ball, which is how the density-matrix note generalizes the picture.
{: .remark title="Inside the ball"}

> A qubit is not "both $0$ and $1$ at once" in any way that gives more information at readout: one measurement returns one bit. The extra structure is the continuous point $\mathbf n$ that gates act on and that interference makes visible, and a single readout learns about it only through probabilities.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does a pure qubit state have only two real parameters?</summary>

The two complex amplitudes are four real numbers; normalization removes one and the unobservable global phase another, leaving the two Bloch angles.
</details>

<details class="qa" markdown="1">
<summary>How do you read the Bloch vector of a state?</summary>

Its components are the expectation values $\langle\sigma_x\rangle$, $\langle\sigma_y\rangle$ and $\langle\sigma_z\rangle$ in the state.
</details>

<details class="qa" markdown="1">
<summary>Where do $|+\rangle$ and $|-\rangle$ sit, and what distinguishes them from $|0\rangle$ and $|1\rangle$?</summary>

On the $\pm x$ axis, on the equator; a $z$ measurement gives $0$ or $1$ with probability $\tfrac12$ for both, and they differ only in the relative phase.
</details>
