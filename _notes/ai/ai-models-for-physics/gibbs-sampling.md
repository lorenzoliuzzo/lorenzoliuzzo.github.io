---
collection: notes
title: Gibbs Sampling
date: '2026-10-27'
excerpt: Updating one variable at a time from its conditional distribution, and why it converges.
hook: 'Gibbs sampling is Metropolis with an acceptance of one: each variable is redrawn from its conditional given the rest.'
goals:
- write the Gibbs update for a single variable and for a block
- show that the target distribution is invariant under the update
- explain why strong correlations slow the sampler
requires:
- markov-process
- detailed-balance
- energy-based-model
defines:
- id: gibbs-sampling
  name: Gibbs sampling
  anchor: def-gibbs-sampling
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

Metropolis proposes a move and decides whether to accept it. When the conditional distribution of one variable given all the others is easy to sample, a simpler rule suffices: draw the new value from that conditional.

# Resampling one variable from its conditional

> **Gibbs sampling** updates one variable $x_k$ at a time.
{: .definition #def-gibbs-sampling title="Gibbs sampling"}

Given the current state, it replaces $x_k$ by a draw from $\pi(x_k\mid x_{-k})$ and leaves the other variables unchanged. The transition kernel for the $k$-th update is

$$ T_k(x\to x') = \pi(x'_k\mid x_{-k})\,\delta(x'_{-k}-x_{-k}), $$

where the Dirac delta states that every other component stays fixed. A **sweep** applies $T_1,\dots,T_n$ in turn, or picks $k$ at random each time.

For the Ising model the conditional is the heat-bath rule: with local field $h_i = h+J\sum_{j\sim i}\sigma_j$, the new spin is $+1$ with probability $1/(1+e^{-2\beta h_i})$ regardless of its old value. This is Metropolis with the acceptance replaced by an exact draw.

# Why the target is invariant

Take the state $x$ distributed as $\pi$, and apply $T_k$. The pair $(x, x')$ has density $\pi(x)\,\pi(x'_k\mid x_{-k})$ on states with $x'_{-k}=x_{-k}$. Writing $\pi(x) = \pi(x_{-k})\pi(x_k\mid x_{-k})$, the density is symmetric under exchanging $x_k$ and $x'_k$, so each single-variable update satisfies detailed balance with respect to $\pi$. A composition of kernels that each leave $\pi$ invariant leaves it invariant. Convergence to $\pi$ needs in addition that the chain reaches every state, which holds when $\pi$ is positive everywhere.

> The target is stationary for each single-variable kernel separately, which is why the order of updates in a sweep does not affect correctness.
{: .rule}

# Blocks and the RBM

If a group of variables is conditionally independent given the rest, the whole group can be redrawn at once, which is a **block** update and is exactly equivalent to updating its members one after another. The RBM has two such blocks. Alternating $h\sim P(h\mid v)$ and $v\sim P(v\mid h)$ is a Gibbs sampler for $P(v,h)$ in which each step is one parallel draw, a reason why bipartite structure is useful.

# Where it is slow

Gibbs moves along coordinate axes. When two variables are strongly correlated, the conditional of one given the other is narrow, and the sampler takes small steps along a long diagonal ridge.

{% include fig.html src="ai-models-for-physics/gibbs-correlated" id="fig-gibbs-correlated" alt="Scatter of samples from a correlated two-dimensional Gaussian along a diagonal, with a staircase path of short horizontal and vertical steps over the first iterations." caption="Gibbs sampling of a Gaussian with correlation 0.95. Each move is parallel to an axis and its size is the conditional standard deviation, so the path crawls along the diagonal." %}

For a Gaussian with correlation $\rho$ the conditional standard deviation is $\sqrt{1-\rho^2}$ times the marginal one, which is $0.31$ for $\rho = 0.95$ and falls to $0.14$ for $\rho=0.99$. The same effect in a spin system is critical slowing down seen from the conditional side.

> Gibbs sampling needs no tuning, since there is no step size or acceptance rate to set, and for that reason it is easy to believe it always mixes well. Strong dependence between variables is what it cannot handle.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does Gibbs sampling accept every move?</summary>

The new value is drawn from the exact conditional distribution, so the update already satisfies detailed balance with respect to the target and no correction is required.
</details>

<details class="qa" markdown="1">
<summary>Why can a whole layer of an RBM be updated at once?</summary>

Given the other layer, the units of a layer are conditionally independent, so redrawing them all simultaneously gives the same distribution as redrawing them one at a time.
</details>
