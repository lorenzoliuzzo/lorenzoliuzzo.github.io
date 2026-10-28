---
collection: notes
title: Measurement and the Born Rule
date: '2026-10-27'
excerpt: Projective measurement in the computational and other bases, outcome probabilities and state collapse.
hook: A measurement turns amplitudes into probabilities and destroys the superposition, so what a circuit gives is a distribution to be sampled, not a vector to be read.
goals:
- compute outcome probabilities in an arbitrary basis
- estimate an expectation value from repeated shots
requires:
- qubit
- orthogonal-projection
defines:
- id: born-rule
  name: Born rule
  anchor: def-born-rule
- id: projective-measurement
  name: projective measurement
  anchor: def-projective-measurement
- id: shot-noise
  name: shot noise
  anchor: def-shot-noise
read_time: true
tags:
- Physics
- Quantum Computing
---

Everything a quantum computer computes is read out by measuring, and a measurement does not return a state. It returns one classical outcome, drawn from a distribution the state fixes, and it leaves the qubit in a state that depends on what came out.

# The Born rule

> A **projective measurement** in an orthonormal basis $\{|a\rangle\}$ returns an outcome $a$ and leaves the system in the state $|a\rangle$. Equivalently it measures an observable $A=\sum_a a|a\rangle\langle a|$, with projectors $\Pi_a=|a\rangle\langle a|$, and the state afterwards is $\Pi_a|\psi\rangle/\|\Pi_a|\psi\rangle\|$.
{: .definition #def-projective-measurement title="Projective measurement"}

The projectors are the orthogonal projections from linear algebra: $\Pi_a$ sends a vector to its component along $|a\rangle$.

> **Born rule.** If the system is in the normalised state $|\psi\rangle$, a projective measurement returns outcome $a$ with probability $p(a)=\|\Pi_a|\psi\rangle\|^2=|\langle a|\psi\rangle|^2$.
{: .law #def-born-rule title="Born rule"}

For a qubit $|\psi\rangle=\alpha|0\rangle+\beta|1\rangle$, measuring in the computational basis gives $0$ with probability $|\alpha|^2$ and $1$ with probability $|\beta|^2$, which sum to one because $|\psi\rangle$ is normalised. Immediately repeating the measurement gives the same outcome with certainty, since the state has collapsed to the basis vector.

The relative phase between $\alpha$ and $\beta$ does not enter this computational basis result. It enters the moment the basis changes. In a general direction the probabilities follow the Bloch vector: measuring along the unit vector $\mathbf n$ gives $+1$ with probability $\frac12(1+\mathbf n\cdot\mathbf r)$, where $\mathbf r$ is the state's Bloch vector. In the $X$ basis, for the state with Bloch angles $(\theta,\varphi)$, this is $p(+)=\frac12(1+\sin\theta\cos\varphi)$, so a state on the equator with $\varphi=0$ gives $+$ with certainty and one with $\varphi=\pi$ gives $-$.

> A measurement in a basis rotated from the computational one is done by applying the inverse rotation first and then measuring as usual. To measure in the $X$ basis, apply $H$ and read the computational bit.
{: .application title="Measuring in another basis"}

# Expectation values

> The **expectation value** of an observable $A$ in the state $|\psi\rangle$ is $\langle A\rangle=\langle\psi|A|\psi\rangle=\sum_a a\,p(a)$, the average outcome over many identically prepared systems.
{: .property #prop-expectation-value title="Expectation value"}

For $A=Z$ the outcomes are $\pm1$ and $\langle Z\rangle=p(0)-p(1)$, which is the vertical Bloch coordinate. Reading it needs many runs: the state cannot be copied, but the circuit can be run again from the start.

# Shot noise

> **Shot noise** is the statistical error of an expectation value estimated from $N$ repetitions (shots). For an observable with outcomes $\pm1$ and mean $\mu$, each shot has variance $1-\mu^2$ and the sample mean has standard error $\sqrt{(1-\mu^2)/N}$.
{: .definition #def-shot-noise title="Shot noise"}

The error shrinks as $1/\sqrt N$, the same law as in Monte Carlo integration. For $\langle Z\rangle=0.6$ the error is $0.8/\sqrt N$, that is $0.08$ after $100$ shots and $0.008$ after $10{,}000$.

{% include fig.html src="quantum-computing/shot-noise" id="fig-shot-noise" alt="Log-log plot of the error of an expectation value against the number of shots: a straight line falling with slope minus one half, with six simulated points on it." caption="Estimating $\langle Z\rangle=0.6$. The error of simulated experiments (dots, root mean square of 400 runs) follows $0.8/\sqrt N$ (line): ten times more precision costs a hundred times more shots." %}

> The hardware gives $N$ samples, not $N$ amplitudes. A quantum algorithm is only useful if the answer it encodes can be extracted with a number of shots that does not grow exponentially.
{: .implication title="Reading a circuit costs shots"}

Different Pauli observables cannot be measured in one go, because they do not commute: a run in the $Z$ basis returns nothing about $\langle X\rangle$. Estimating all three Bloch coordinates takes three bases, each with its own shots.

> The state does not hold a hidden value of the outcome waiting to be read. Mixing up "the probability of $1$" with "our ignorance of the outcome" gives wrong answers as soon as phases matter, as with $|+\rangle$ and $|-\rangle$, which give identical statistics in the computational basis and opposite certain outcomes after $H$.
{: .trap}

> To get an expectation value from a circuit, estimate it in the right basis with enough shots: choose $N\approx(1-\mu^2)/\epsilon^2$ for a target error $\epsilon$, and apply the basis-change gate before measuring.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>State the Born rule for a qubit.</summary>

For $\alpha|0\rangle+\beta|1\rangle$, outcome $0$ has probability $|\alpha|^2$ and outcome $1$ has $|\beta|^2$, after which the state is the corresponding basis vector.
</details>

<details class="qa" markdown="1">
<summary>Why does the relative phase matter if it does not change the computational basis probabilities?</summary>

It changes the probabilities in any other basis. $|+\rangle$ and $|-\rangle$ look the same measured along $z$ and give opposite certain outcomes along $x$.
</details>

<details class="qa" markdown="1">
<summary>How many shots estimate $\langle Z\rangle$ to a precision $\epsilon$?</summary>

About $(1-\langle Z\rangle^2)/\epsilon^2$, never more than $1/\epsilon^2$; the error falls as $1/\sqrt N$.
</details>
