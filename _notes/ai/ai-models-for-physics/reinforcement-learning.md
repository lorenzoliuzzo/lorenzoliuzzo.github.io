---
collection: notes
title: Reinforcement Learning
date: '2026-10-27'
excerpt: Policies, value functions, the Bellman equation, value iteration as a contraction, and Q-learning as the same equation estimated from interaction.
hook: An agent learns by acting, and the Bellman equation is the consistency condition that ties the value of a state to the values of what can follow it.
goals:
- write the Bellman equation for a policy and for the optimal values
- show that value iteration converges at the rate gamma
- state the Q-learning update and say what it estimates
requires:
- markov-decision-process
- discounted-return
- markov-process
defines:
- id: policy
  name: policy
  anchor: def-policy
- id: value-function
  name: value function
  anchor: def-value-function
- id: bellman-equation
  name: Bellman equation
  anchor: def-bellman-equation
- id: q-learning
  name: Q-learning
  anchor: learning-from-interaction
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

The previous note scored a trajectory with its return. An agent has to choose, and it chooses by comparing the expected return of the options, which needs a name and an equation {% cite sutton-2018 %}.

# Policies and value functions

> A **policy** $\pi(a\mid s)$ gives the probability of each action in each state.
{: .definition #def-policy title="Policy"}

> The **value function** of a policy is the expected return obtained by starting in $s$ and following $\pi$ afterwards, $V^\pi(s)=\mathbb{E}_\pi[G_t\mid s_t=s]$.
{: .definition #def-value-function title="Value function"}

Its companion, the action value $Q^\pi(s,a)$, is the expected return after taking action $a$ in $s$ and then following $\pi$. The optimal policy is the one whose values are largest in every state at once, and its values are written $V^*$ and $Q^*$.

# The Bellman equation

Insert the recursion $G_t=r_{t+1}+\gamma G_{t+1}$ into the definition and use the Markov property: what follows the next state does not depend on how the agent got there.

> The result is the **Bellman equation** for the policy,
{: .definition #def-bellman-equation title="Bellman equation"}

$$ V^\pi(s) = \sum_a\pi(a\mid s)\sum_{s'}P(s'\mid s,a)\big[r(s,a,s')+\gamma V^\pi(s')\big], $$

a linear system $V^\pi = r_\pi + \gamma P_\pi V^\pi$ with the unique solution $V^\pi=(I-\gamma P_\pi)^{-1}r_\pi$. For the optimal values the average over actions becomes a maximum,

$$ V^*(s)=\max_a\sum_{s'}P(s'\mid s,a)\big[r(s,a,s')+\gamma V^*(s')\big], $$

which is nonlinear but has the same structure: a value is a reward plus the discounted value of what follows. The optimal policy is read off by acting greedily with respect to $V^*$.

> The Bellman equation is a fixed-point equation. Its content is that the optimal value of a state can be computed from the optimal values of its successors, with no need to enumerate whole trajectories.
{: .idea}

# Value iteration

Write the right-hand side of the optimal equation as an operator $T$. It is a contraction in the maximum norm with factor $\gamma$: $\|TV-TW\|_\infty\le\gamma\|V-W\|_\infty$. By the contraction argument the iteration $V_{k+1}=TV_k$ converges to the unique fixed point $V^*$ from any start, and $\|V_k-V^*\|_\infty\le\gamma^k\|V_0-V^*\|_\infty$.

On the grid of the previous note the exit pays $+1$ and $\gamma=0.9$, so the optimal value of a cell at distance $d$ from the exit is $0.9^{d-1}$. Starting from $V_0=0$, each sweep carries the information one cell further from the exit, and after six sweeps, the longest shortest path, the values are exact.

{% include fig.html src="ai-models-for-physics/gridworld-values" id="fig-gridworld-values" alt="A four by four grid with optimal values from 0.59 in the far corner to 1.00 next to the exit, with arrows pointing towards the exit, and a plot of the error of value iteration against the number of sweeps, below a dashed geometric bound." caption="Optimal values and greedy actions on the grid (left), and the error of value iteration against the sweeps (right). The error stays under the bound $\gamma^k$ and reaches zero after six sweeps because the grid is small and deterministic." %}

The bound is a guarantee and not a prediction. For a stochastic problem the error decays geometrically at a rate between zero and $\gamma$, and for $\gamma$ near one the number of sweeps needed grows like $1/(1-\gamma)$.

# Learning from interaction

Value iteration needs the transition law $P$. An agent that has only experience, a stream of transitions $(s,a,r,s')$, can run the same equation on samples. **Q-learning** keeps a table of action values and, after each transition, moves the entry towards a one-sample version of the optimal Bellman target {% cite watkins-1992 %}:

$$ Q(s,a)\leftarrow Q(s,a)+\alpha\Big[r+\gamma\max_{a'}Q(s',a')-Q(s,a)\Big]. $$

The bracket is the temporal-difference error, the gap between the current estimate and a better one made from a single step of real experience. Under the usual conditions, every state-action pair visited infinitely often and a suitably decreasing step size $\alpha$, the table converges to $Q^*$. In practice the agent must keep exploring, and a common rule is to take a random action with probability $\varepsilon$ and the greedy one otherwise.

{% include fig.html src="ai-models-for-physics/q-learning-curve" id="fig-q-learning" alt="Steps needed to reach the exit per episode, dropping from about fifty to just above the dashed line at six within about fifteen episodes, then staying flat." caption="Q-learning on the grid, averaged over 40 seeds, with $\alpha=0.5$, $\gamma=0.9$ and $\varepsilon=0.1$. The agent learns the shortest path in a few tens of episodes; the exploration rate keeps the average slightly above six." %}

{% capture t %}
| | Value-based | Policy-based |
|---|---|---|
| Learns | $Q(s,a)$, acts greedily | $\pi_\theta(a\mid s)$ directly |
| Actions | discrete, or a maximisation per step | discrete or continuous |
| Update | Bellman target | gradient of expected return |
| Typical use | tabular and small problems, Q-learning | continuous control, large action spaces |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-rl-families" caption="The two main families of reinforcement learning." body=t %}

> A table of $Q$ values needs one entry per state and action. Once the state is a spin configuration the table has $2^N$ rows, and a network has to stand in for it, which is where the instability of deep Q-learning comes from.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>What does the Bellman equation say?</summary>

The value of a state is the expected reward of the next step plus the discounted value of the state that follows. For a fixed policy it is a linear system; for the optimal values the average over actions is replaced by a maximum.
</details>

<details class="qa" markdown="1">
<summary>Why does value iteration converge, and how fast?</summary>

The Bellman operator contracts the maximum-norm distance between two value functions by a factor $\gamma$, so the iteration has a unique fixed point and the error after $k$ sweeps is at most $\gamma^k$ times the initial error.
</details>

<details class="qa" markdown="1">
<summary>What does Q-learning estimate that value iteration computes exactly?</summary>

The optimal action values, from sampled transitions instead of the known transition law. Each update moves $Q(s,a)$ towards the one-sample target $r+\gamma\max_{a'}Q(s',a')$.
</details>
