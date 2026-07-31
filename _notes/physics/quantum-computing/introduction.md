---
collection: notes
order: 1
title: "Introduction to Quantum Computing"
tags: 
  - Physics
  - Quantum Computing
---

## The Qubit

## Quantum Logic Gates

A quantum logic gate $\hat{U}$ transforms an input qubit state $\ket{\psi}$ into an output state $\ket{\psi'}$ by acting on the computational basis coefficients.
Since the normalization condition must be respected, the action of a quantum logic gate can be represented with a linear unitary transformation associated to the unitary operator $\hat{U}$.

{%
  include equation.html
  id="quantum_logic_gate"
  tex="\ket{\psi} = \alpha \ket{0} + \beta \ket{1} \rightarrow \ket{\psi'} \equiv \hat{U} \ket{\psi} = \alpha' \ket{0} + \beta' \ket{1}"
%}

### Single-Qubit Gates
#### Pauli Operators

{% include equation.html id="pauli_x_matrix" tex="\sigma_x = \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}" %}

{% include equation.html id="pauli_y_matrix" tex="\sigma_y = \begin{pmatrix} 0 & -i \\ i & 0 \end{pmatrix}" %}

{% include equation.html id="pauli_z_matrix" tex="\sigma_z = \begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}" %}

> In general, a single-qubit gate is a linear combination of Pauli operators, so there are infinte possible gates.

#### NOT Gate
The NOT gate is the only reversible classical operation on signle bits.
We can represent it as 
$$ \mathbf{X} \rightarrow \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix} $$
{% include equation.html id="NOT_gate_action" tex="\mathbf{X} \ket{x} = \ket{x \oplus 1} \equiv \ket{\bar{x}}" %}

> Observation: $\mathbf{X}^2 = \mathbb{I} \implies \mathbf{X} = \mathbf{X}^{-1}$

#### Number Gate

It is instructive to introduce the operator number operator $\mathbf{N}$ and it's counterpart $\mathbf{\bar{N}} \equiv \mathbb{I} - \mathbf{N}$:
{% include equation.html id="" tex="\mathbf{N} \ket{x} = x \ket{x} \quad \quad \mathbf{\bar{N}} \ket{x} = \bar{x} \ket{x}" %}

{%
  include equation.html
  id=""
  tex="\mathbf{N} \rightarrow \begin{pmatrix} 0 & 0 \\ 0 & 1 \end{pmatrix} \quad \quad \mathbf{\bar{N}} \rightarrow \begin{pmatrix} 1 & 0 \\ 0 & 0 \end{pmatrix}"
%}

> Observations:
- $\bar{\mathbf{N}}^2 = \mathbf{N}$
- $\mathbf{N} \mathbf{\bar{N}} = \mathbf{\bar{N}} \mathbf{N} = 0$

#### Z Gate

{%
  include equation.html
  id=""
  tex="\mathbf{Z} = \mathbf{\bar{N}} - \mathbf{N} \rightarrow \begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}"
%}

{%
  include equation.html
  id=""
  tex="\mathbf{Z} \ket{x} = (-1)^x \ket{x}"
%}

#### Hadamard Gate

{% include equation.html id="hadamard_gate" tex="\mathbf{H} = \frac{1}{\sqrt{2}} (\mathbf{X} + \mathbf{Z}) \rightarrow \frac{1}{\sqrt{2}} \begin{pmatrix} 1 & 1 \\ 1 & -1 \end{pmatrix}"%}
{% include equation.html id="hadamard_action" tex="\mathbf{H} \ket{x} = \frac{1}{\sqrt{2}} (\ket{0} + (-1)^x \ket{1})"%}

> The Hadamard transformation allows to:
- transform $\mathbf{X}$ into $\mathbf{Z}$ and vice versa 
$$\mathbf{H} \mathbf{X} \mathbf{H} = \mathbf{Z} \quad \quad \mathbf{H} \mathbf{Z} \mathbf{H} = \mathbf{X}$$
- exchange the roles of the target and control bits of a CNOT
$$\mathbf{C}\_{hk} = \mathbf{H}\_h \mathbf{H}\_k \mathbf{C}\_{kh} \mathbf{H}\_h \mathbf{H}\_k$$

#### Phase Shift Gate

> Observation: the Z gate adds a $\pi$ phase shift to the computational basis $\ket{0}$ and $\ket{1}$, since we can write $-1 = e^{i\pi}$.

The general phase shift gate acts as:
{%
  include equation.html
  id=""
  tex="\mathbf{P}(\phi) \equiv \exp(- i \phi \hat{\sigma}_z) = \cos \phi \ \mathbb{I} - i \sin \phi \ \hat{\sigma}_z \rightarrow e^{-i \phi} \begin{pmatrix} 1 & 0 \\ 0 & e^{i 2 \phi} \end{pmatrix}"
%}
where we can drop the global phase factor $e^{-i \phi}$.

> T Gate: $\mathbf{T} \equiv \mathbf{P}(\frac{\pi}{8}) \rightarrow \begin{pmatrix} 1 & 0 \\ 0 & e^{i \frac{\pi}{4}} \end{pmatrix}$

> S Gate: $\mathbf{S} = \mathbf{T}^2 = \mathbf{P}(\frac{\pi}{4}) \rightarrow \begin{pmatrix} 1 & 0 \\ 0 & i \end{pmatrix}$

> Observation: $\mathbf{T}^4 = \mathbf{Z}$


### Two-Qubit Gates

#### SWAP Gate

The SWAP operation exchanges the values of two bits such:
{% include equation.html id="" tex="\mathbf{S} \ket{x} \ket{y} = \ket{y} \ket{x}" %}

If we consider the $n$-bit state $\ket{x}\_n$, then we can define the operator $\mathbf{S}_{hk}$ which acts on the bits $h$ and $k$ as: 
{%
  include equation.html
  id=""
  tex="\begin{align} \mathbf{S}_{hk} \ket{x}_n &= \mathbf{S}_{hk} \ket{x_{n-1}} \cdots \ket{x_h} \cdots \ket{x_k} \cdots \ket{x_0} \\
                                                               &= \ket{x_{n-1}} \cdots \ket{x_k} \cdots \ket{x_h} \cdots \ket{x_0} \end{align}"
%}

The matrix representation of $\mathbf{S}_{hk}$ is a single permutation matrix, obtained starting from the identity matrix and exchanging the $h$-th and $k$-th columns.

#### Control NOT Gate

The controlled NOT, CNOT, acts on a target bit according to the value of the control bit. $\mathbf{C}\_{hk}$ flips the state of the $k$-th bit only if the state of the $h$-bit is $\ket{1}$. 

The matrix representations of $\mathbf{C}\_{01}$ and $\mathbf{C}\_{10}$ are: 
{%
  include equation.html
  id=""
  tex="\mathbf{C}_{01} \rightarrow \begin{pmatrix} 1 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 1 \\ 0 & 0 & 1 & 0 \end{pmatrix} \quad \quad \mathbf{C}_{10} \rightarrow \begin{pmatrix} 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 1 \\ 0 & 0 & 1 & 0 \\ 0 & 1 & 0 & 0 \end{pmatrix}"
%}

{%
  include equation.html
  id=""
  tex="\begin{align} \mathbf{C}_{hk} \ket{x}_n &= \mathbf{C}_{hk} \ket{x_{n-1}} \cdots \ket{x_h} \cdots \ket{x_k} \cdots \ket{x_0} \\
                                                               &= \ket{x_{n-1}} \cdots \ket{x_h} \cdots \ket{x_k \oplus x_h} \cdots \ket{x_0} \end{align}"
%}

> Observation: $\mathbf{C}_{hk} = \mathbf{\bar{N}}_h + \mathbf{N}_h \mathbf{X}_k$

Introducing the operator $\mathbf{Z} = \mathbf{\bar{N}} - \mathbf{N}$, rewriting $\mathbf{N} = \frac{1}{2} (\mathbb{I} - \mathbf{Z})$ and $\mathbf{\bar{N}} = \frac{1}{2} (\mathbb{I} + \mathbf{Z})$
we can write the CNOT as:

{%
  include equation.html
  id="CNOT"
  tex="
  \begin{align}
    \mathbf{C}_{hk} &= \frac{1}{2} (\mathbb{I} + \mathbf{Z}_h) + \frac{1}{2} (\mathbb{I} - \mathbf{Z}_h) \mathbf{X}_k \\
                    &= \frac{1}{2} (\mathbb{I} + \mathbf{X}_k) + \frac{1}{2} \mathbf{Z}_h (\mathbb{I} - \mathbf{X}_k) \\
                    &= \frac{1}{2} (\mathbb{I} + \mathbf{X}_k + \mathbf{Z}_h - \mathbf{Z}_h \mathbf{X}_k)
  \end{align}"
%}

> Observations:
- The same action of a SWAP can be obtained by the application of three CNOT gates $$\mathbf{S}\_{hk} = \mathbf{C}\_{hk} \mathbf{C}\_{kh} \mathbf{C}\_{hk}$$
- Using [](#CNOT), $\mathbf{Y}\_k = \mathbf{Z}\_k \mathbf{X}\_k$ and the Pauli operators, we can rewrite the SWAP gate as
$$
\begin{align}
\mathbf{S}_{hk} &= \frac{1}{2} \left ( \mathbb{I} + \mathbf{X}_h \mathbf{X}_k - \mathbf{Y}_h \mathbf{Y}_k + \mathbf{Z}_h \mathbf{Z}_k \right ) \\ 
&= \frac{1}{2} \left ( \mathbb{I} + \hat{\sigma}_x^{(h)} \hat{\sigma}_x^{(k)} + \hat{\sigma}_y^{(h)} \hat{\sigma}_y^{(k)} + \hat{\sigma}_z^{(h)} \hat{\sigma}_z^{(k)} \right )
\end{align}
$$
