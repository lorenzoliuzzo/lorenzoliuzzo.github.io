---
collection: notes
title: Stochastic and Markov Processes
date: '2026-10-27'
excerpt: The Markov property, transition matrices, the Chapman-Kolmogorov equation and stationarity.
hook: A Markov process forgets its past, which makes n-step behaviour a matrix power and long-time behaviour a question about stationary distributions.
goals:
- compute multi-step transition probabilities
- find the stationary distribution of a chain
requires:
- eigenvalue
defines:
- id: markov-process
  name: Markov process
  anchor: def-markov-process
- id: chapman-kolmogorov
  name: Chapman-Kolmogorov equation
  anchor: def-chapman-kolmogorov
- id: stationary-distribution
  name: stationary distribution
  anchor: where-the-chain-ends-up
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

Sampling the Boltzmann distribution is done with a random process that moves from configuration to configuration. This note sets down the properties of such a process that decide whether it works.

# The Markov property

> A **Markov process** is a sequence of random states in which the next state depends on the past only through the present: $P(x_{t+1}\mid x_t, x_{t-1},\dots) = P(x_{t+1}\mid x_t)$.
{: .definition #def-markov-process title="Markov process"}

For a finite state space and time-independent rules, everything about the one-step dynamics is a matrix $P_{ij} = P(x_{t+1}=j\mid x_t=i)$ whose rows sum to 1. The process is stationary in the sense used later if both its marginal law and its transition rule do not change with time.

# Many steps are a matrix power

The probability of going from $i$ to $k$ in two steps is a sum over the intermediate state $j$ of the one-step probabilities, $\sum_j P_{ij}P_{jk}$, which is a matrix product.

> The same argument for any split gives the **Chapman-Kolmogorov equation**
{: .definition #def-chapman-kolmogorov title="Chapman-Kolmogorov equation"}

$$ P^{(n+m)} = P^{(n)}P^{(m)}, \qquad P^{(n)} = P^n. $$

The distribution after $n$ steps from an initial row vector $\mu_0$ is $\mu_n = \mu_0P^n$. This is why linear algebra decides the long-time behaviour: it is governed by the spectrum of $P$.

# Where the chain ends up

A distribution $\pi$ is **stationary** when $\pi P = \pi$, that is, a left eigenvector of $P$ with eigenvalue 1, which always exists for a finite chain. If the chain is irreducible (every state reachable from every other) and aperiodic, the stationary distribution is unique and $\mu_n\to\pi$ from any start. Writing $P$ in its eigenbasis, the error decays as $|\lambda_2|^n$, where $\lambda_2$ is the eigenvalue of second largest modulus.

{% include fig.html src="ai-models-for-physics/markov-convergence" id="fig-markov-convergence" alt="Probabilities of three states against the number of steps, converging to horizontal dashed lines, and a dotted envelope decaying geometrically." caption="A three-state chain started in state 1. The probabilities approach the stationary values (dashed); the distance to them falls inside the geometric envelope $|\lambda_2|^n$." %}

> The gap $1-|\lambda_2|$ is the speed limit of the sampler. A chain with $|\lambda_2|$ close to 1 is correct in the limit and useless in a finite run.
{: .idea}

A stationary distribution is not enough to be reached from any starting point: a chain that splits into two parts that never communicate has several, and each is reached only from its own part. A chain that alternates between two groups of states has eigenvalue $-1$ and never settles. These two failures are why proposals in a sampler must connect every configuration and must be allowed to stay put.

> Having $\pi$ as a stationary distribution says nothing about how fast the chain reaches it. The speed is set by the second eigenvalue, and for Ising-type chains that eigenvalue approaches 1 near the critical point.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is the $n$-step transition matrix the $n$-th power of the one-step matrix?</summary>

The probability of $i\to k$ in $n$ steps sums over every intermediate state, and by the Markov property each factor depends only on the state before it, so the sum is a matrix product.
</details>

<details class="qa" markdown="1">
<summary>What controls how fast a finite chain forgets its starting state?</summary>

The second largest eigenvalue modulus of $P$: the distance to the stationary distribution shrinks like $|\lambda_2|^n$ once the faster modes have decayed.
</details>
