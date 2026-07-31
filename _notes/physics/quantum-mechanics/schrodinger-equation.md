---
title: "Schrodinger's Equation"
collection: notes
read_time: true
tags:
  - Physics
  - Quantum Mechanics
---

The Schrödinger equation is the fundamental governing equation of non-relativistic quantum mechanics, describing how the quantum state of a physical system evolves over time.

## 1. Core Formulations

### Time-Dependent Schrödinger Equation

The TDSE describes the dynamic evolution of a wave function $\psi(\mathbf{r}, t)$ in a state space:
{%
  include equation.html
  id="time_dep_schrodinger_equation"
  tex="i\hbar \frac{\partial \psi(\mathbf{r}, t)}{\partial t} = \hat{H} \psi(\mathbf{r}, t)"
%}

Where $\hat{H}$ is the Hamiltonian operator, representing the total energy of the system.
For a single particle of mass $m$ moving in a potential $V(\mathbf{r}, t)$, the explicit coordinate-space Hamiltonian is:
{%
  include equation.html
  id="general_single_particle_hamiltonian_coord_space"
  tex="\hat{H} = -\frac{\hbar^2}{2m} \nabla^2 + V(\mathbf{r}, t)"
%}

### Time-Independent Schrödinger Equation

When the potential $V(\mathbf{r})$ is stationary (independent of time), we can look for separable solutions of the form $\Psi(\mathbf{r}, t) = \psi(\mathbf{r})\phi(t)$. 
This separation of variables reduces the problem to an eigenvalue problem of the form:

{%
  include equation.html
  id="time_indep_schrodinger_equation_eigen_general"
  tex="\hat{H} \psi(\mathbf{r}) = E \psi(\mathbf{r})"
%}
{%
  include equation.html
  id="time_indep_schrodinger_equation_eigen"
  tex="-\frac{\hbar^2}{2m}\nabla^2 \psi(\mathbf{r}) + V(\mathbf{r})\psi(\mathbf{r}) = E \psi(\mathbf{r})"
%}

Where $E$ represents the definite energy eigenvalues of the stationary states. 
The temporal component simply evolves as a phase factor: $\phi(t) = e^{-iEt/\hbar}$.

---

## 2. Properties of Solutions

* **Linearity & Superposition:** If $\psi_1$ and $\psi_2$ are solutions to the TDSE, then any linear combination $c_1\psi_1 + c_2\psi_2$ is also a solution.

* **Normalization:** The total probability of finding the particle somewhere in space must equal $1$:
$$\int_{-\infty}^{\infty} |\psi(x,t)|^2 dx = 1$$

* **Orthogonality:** Stationary states belonging to distinct energy eigenvalues are orthogonal:
$$\int_{-\infty}^{\infty} \psi_m^*(x) \psi_n(x) dx = \delta_{mn}$$

---

## 3. Particular Solutions (1D Systems)

### The Free Particle

For a particle experiencing zero potential everywhere, the hamiltonian simplifies to:

{% include equation.html id="free_particle_hamiltonian" tex="\hat{H} = \frac{\hat{p}^2}{2m}" %}

Since $[\hat{H}, \hat{p}] = 0$, we can choose the eigenstate of the hamiltonian to be those of the impulse operator, which acts as: 
{% include equation.html id="impulse_op_eigen" tex="\hat{p} \ket{k} = \hbar k \ket{k}" %}

{% include equation.html tex="\hat{H} \ket{k} = \frac{\hbar^2 k^2}{2m} \ket{k}" %}
{% include equation.html tex="E_k = \frac{\hbar^2 k^2}{2m}" %}


$$-\frac{\hbar^2}{2m} \frac{d^2\psi}{dx^2} = E \psi$$

* **General Solution:**
$$\psi(x) = A e^{ikx} + B e^{-ikx}$$

Where the wavenumber $k$ is defined by:

$$k^2 = \frac{2mE}{\hbar^2}$$

* **Physical Meaning:** Represents a superposition of forward- and backward-propagating plane waves with continuous energy spectra ($E \ge 0$). Note that these idealized states cannot be normalized across infinite space without forming wave packets.

### Infinite Potential Well

### Finite Potential Step

### Finite Potential Barrier

A particle confined to a 1D box of length $L$, where:
$$V(x) = \begin{cases} 0 & 0 < x < L \\ \infty & \text{otherwise} \end{cases}$$

Applying boundary conditions ($\psi(0) = \psi(L) = 0$) yields quantized energy levels and strictly bounded wave functions:

* **Normalized Eigenfunctions:**
$$\psi_n(x) = \sqrt{\frac{2}{L}} \sin\left(\frac{n\pi x}{L}\right), \quad n = 1, 2, 3, \dots$$

* **Energy Quantization:**
$$E_n = \frac{n^2 \pi^2 \hbar^2}{2mL^2}$$

### Case C: Quantum Harmonic Oscillator

A particle subject to a parabolic restoring potential, modeling smooth localized fluctuations:
$$V(x) = \frac{1}{2}m\omega^2 x^2$$

Solving this requires transforming the TISE into Hermite's differential equation.

* **Energy Quantization:**
$$E_n = \hbar\omega\left(n + \frac{1}{2}\right), \quad n = 0, 1, 2, \dots$$

> **Note:** The ground state ($n=0$) possesses a non-zero minimum energy $E_0 = \frac{1}{2}\hbar\omega$, known as the zero-point energy, a direct consequence of the uncertainty principle.

* **Eigenfunctions:**
$$\psi_n(x) = \left( \frac{m\omega}{\pi \hbar} \right)^{1/4} \frac{1}{\sqrt{2^n n!}} H_n(\xi) e^{-\xi^2 / 2}$$

Where $\xi = \sqrt{\frac{m\omega}{\hbar}} x$ and $H_n(\xi)$ are the physicist's Hermite polynomials.

---

## 4. Particular Solutions (3D Systems)
