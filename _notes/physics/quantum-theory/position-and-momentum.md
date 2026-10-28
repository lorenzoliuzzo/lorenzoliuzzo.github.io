---
collection: notes
title: "Position, Momentum and the Wavefunction"
date: 2026-10-27
excerpt: "Wavefunctions, the position and momentum operators and their Fourier relation."
hook: "In the position representation a state is a function, momentum is a derivative, and the uncertainty principle is the statement that a function and its Fourier transform cannot both be narrow."
goals:
  - move between position and momentum representations
  - compute mean position and momentum of a wavepacket
requires:
  - commutator
  - schrodinger-equation
  - fourier-series
defines:
  - {id: wavefunction, name: "wavefunction", anchor: def-wavefunction}
  - {id: momentum-operator, name: "momentum operator", anchor: def-momentum-operator}
read_time: true
tags:
  - Physics
  - Quantum Mechanics
  - Quantum Computing
---

For a particle on a line the state is a function. The position and momentum operators then become multiplication and differentiation, and the uncertainty principle turns out to be a theorem about Fourier transforms.

# The wavefunction

> The **wavefunction** of a particle on a line is the amplitude $\psi(x)=\langle x|\psi\rangle$ of finding it at $x$, with $|\psi(x)|^2dx$ the probability of a position in $[x,x+dx]$. Normalisation requires $\int|\psi|^2dx=1$.
{: .definition #def-wavefunction title="Wavefunction"}

The position states $|x\rangle$ are not normalisable vectors but a continuous basis, with $\langle x|x'\rangle=\delta(x-x')$ and $\int|x\rangle\langle x|\,dx=I$. In this basis the position operator multiplies by $x$, and the momentum operator is a derivative:
$$ \hat x\,\psi(x)=x\,\psi(x),\qquad\hat p\,\psi(x)=-i\hbar\,\frac{d\psi}{dx}. $$
These satisfy $[\hat x,\hat p]=i\hbar$, the canonical commutation relation, which can be checked in one line: $\hat x\hat p\psi-\hat p\hat x\psi=-i\hbar x\psi'+i\hbar(x\psi)'=i\hbar\psi$.

> The **momentum operator** $\hat p=-i\hbar\,d/dx$ is Hermitian on normalisable functions. Its eigenfunctions are plane waves $e^{ipx/\hbar}$ with eigenvalue $p$, which is the de Broglie relation $p=\hbar k$.
{: .definition #def-momentum-operator title="Momentum operator"}

# Momentum space

Expanding a state in the momentum eigenfunctions is a Fourier transform:
$$ \varphi(p)=\frac1{\sqrt{2\pi\hbar}}\int\psi(x)\,e^{-ipx/\hbar}\,dx,\qquad\psi(x)=\frac1{\sqrt{2\pi\hbar}}\int\varphi(p)\,e^{ipx/\hbar}\,dp. $$
By Parseval's theorem $\int|\varphi|^2dp=\int|\psi|^2dx=1$, so $|\varphi(p)|^2dp$ is the probability of a momentum in $[p,p+dp]$. In the momentum representation $\hat p$ multiplies and $\hat x$ becomes $i\hbar\,d/dp$. The two descriptions are the same state seen in two bases, as in the case of a qubit measured along $z$ or along $x$.

For a Gaussian $\psi(x)\propto e^{-x^2/4\sigma^2}$ the transform is again a Gaussian, with $|\varphi|^2$ of standard deviation $\hbar/2\sigma$. The spreads are then $\Delta x=\sigma$ and $\Delta p=\hbar/2\sigma$, the product is exactly $\hbar/2$, and narrowing one distribution widens the other.

{% include fig.html src="quantum-theory/fourier-pair" id="fig-fourier-pair" alt="Two panels showing the same two Gaussian wavepackets in position and in momentum: the narrow position peak corresponds to the wide momentum curve, and vice versa." caption="Two Gaussian wavepackets in position space (left) and momentum space (right). Squeezing the packet in $x$ spreads it in $p$ by the same factor." %}

> A function and its Fourier transform cannot both be sharply localised. This is the reason a short pulse has a broad spectrum, and it is the content of the position-momentum uncertainty relation: nothing about measurement enters.
{: .implication title="Uncertainty is a Fourier fact"}

# Averages

Mean values are integrals of the wavefunction: $\langle x\rangle=\int\psi^*x\psi\,dx$ and $\langle p\rangle=\int\psi^*(-i\hbar\psi')\,dx$. For a packet $\psi(x)=\psi_0(x)e^{ip_0x/\hbar}$ with a real envelope $\psi_0$, the phase factor shifts the mean momentum to $p_0$ and leaves the position distribution unchanged. The packet then moves with the group velocity $p_0/m$, which is what a classical particle with that momentum does.

> The operator $-i\hbar\,d/dx$ acts on a wavefunction, so a kink in $\psi$ means infinite kinetic energy. Wavefunctions of finite energy are continuous, and their derivative is continuous wherever the potential is finite, which is the source of the matching conditions for wells and barriers.
{: .remark}

> To go from position to momentum, Fourier transform the wavefunction. To estimate the spreads of a packet of width $\sigma$, use $\Delta x\sim\sigma$ and $\Delta p\sim\hbar/\sigma$ and check the product against $\hbar/2$.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What are the position and momentum operators in the position representation?</summary>

$\hat x$ multiplies the wavefunction by $x$ and $\hat p=-i\hbar\,d/dx$. Their commutator is $i\hbar$.
</details>

<details class="qa" markdown="1">
<summary>How is the momentum distribution obtained from the wavefunction?</summary>

As the squared modulus of the Fourier transform of $\psi(x)$, with the $\hbar$ in the exponent.
</details>

<details class="qa" markdown="1">
<summary>Why does localising a particle spread its momentum?</summary>

A narrow function needs many wavelengths to build it, so its Fourier transform is broad. For Gaussians $\Delta x\,\Delta p=\hbar/2$ exactly.
</details>
