---
collection: notes
title: Markov Decision Processes
date: '2026-10-27'
excerpt: A Markov chain in which an agent picks the transition probabilities, the discounted return that scores a trajectory, and what the discount factor does to the horizon.
hook: A Markov decision process is a Markov chain in which an agent chooses the transition probabilities, and the goal is the choice that maximises the expected discounted reward.
goals:
- write the five ingredients of an MDP for a small control problem
- compute the discounted return of a trajectory
- explain what the discount factor does to the planning horizon
requires:
- markov-process
defines:
- id: markov-decision-process
  name: Markov decision process
  anchor: def-markov-decision-process
- id: discounted-return
  name: discounted return
  anchor: def-discounted-return
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

The Markov chains of the sampling part of the course run by themselves: the transition matrix is given and the only question is where the distribution ends up. A control problem adds a hand on the dial. At each step something outside the chain, an agent, picks among actions that change the transition probabilities, and the question becomes which choices are best {% cite sutton-2018 %}.

# Adding a choice to a Markov chain

> A **Markov decision process** (MDP) is specified by five objects.
{: .definition #def-markov-decision-process title="Markov decision process"}

A set of states $\mathcal{S}$ and a set of actions $\mathcal{A}$. A transition law $P(s'\mid s,a)$, the probability of reaching $s'$ when action $a$ is taken in state $s$. A reward $r(s,a,s')$, a real number paid for that transition. A discount factor $\gamma\in[0,1)$, used below. The Markov property is kept: the law of the next state depends on the present state and action and on nothing earlier.

Fix a rule for choosing actions, written $\pi(a\mid s)$ and called a policy in the next note. The pair of MDP and policy is an ordinary Markov chain with transition matrix $P_\pi(s,s') = \sum_a\pi(a\mid s)P(s'\mid s,a)$. Everything learned about chains, stationary distributions and mixing included, applies to it once the policy is fixed.

> An MDP is a family of Markov chains indexed by the policy. Optimising over policies means choosing the chain.
{: .idea}

A physical example is a spin system under feedback. The state is a spin configuration, the action is a choice of field applied for one step, the transition law is a Metropolis step at that field, and the reward is the negative energy of the final state. The same ingredients describe a robot in a corridor, which is the example used below because its numbers can be followed by hand.

{% capture t %}
| Ingredient | Symbol | Corridor with an exit |
|---|---|---|
| States | $\mathcal{S}$ | cells of a $4\times4$ grid |
| Actions | $\mathcal{A}$ | up, down, left, right |
| Transitions | $P(s'\mid s,a)$ | move one cell, or stay at a wall |
| Reward | $r$ | $+1$ on entering the exit, $0$ otherwise |
| Discount | $\gamma$ | $0.9$ |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-mdp-ingredients" caption="The five ingredients of an MDP, filled in for the grid of the next note." body=t %}

# The discounted return

A trajectory $s_0,a_0,r_1,s_1,a_1,r_2,\dots$ produces a stream of rewards, and the agent needs one number to compare streams.

> The **discounted return** from time $t$ is
{: .definition #def-discounted-return title="Discounted return"}

$$ G_t = r_{t+1} + \gamma\,r_{t+2} + \gamma^2 r_{t+3} + \dots = \sum_{k=0}^{\infty}\gamma^{k}\,r_{t+k+1}. $$

It satisfies the recursion $G_t = r_{t+1} + \gamma G_{t+1}$, which is the seed of the Bellman equation. If every reward is bounded by $R_{\max}$ the sum converges and $|G_t|\le R_{\max}/(1-\gamma)$, so the return of an infinite trajectory is a finite number whenever $\gamma<1$. For the grid, an agent that reaches the exit after $d$ steps gets $G_0=\gamma^{d-1}$: with $\gamma=0.9$ and $d=6$ that is $0.9^5\approx0.59$.

# What the discount does

The factor $\gamma$ is a soft horizon. A reward $k$ steps ahead counts $\gamma^k$ times its face value, and the weights sum to $1/(1-\gamma)$, so $1/(1-\gamma)$ plays the part of the number of steps the agent effectively looks ahead. At $\gamma=0.5$ that is two steps, at $0.9$ it is ten, and at $0.99$ it is a hundred.

{% include fig.html src="ai-models-for-physics/discount-weights" id="fig-discount-weights" alt="Three decaying curves of the weight gamma to the k against the number of steps ahead, for gamma 0.5, 0.9 and 0.97, with a dashed vertical line at ten steps." caption="The weight $\gamma^k$ of a reward $k$ steps ahead. A small $\gamma$ makes the agent short-sighted; $\gamma$ near one makes it plan far ahead and makes the value harder to learn." %}

Two things push in opposite directions. A value of $\gamma$ near one respects long-term consequences, which a task such as holding a pendulum upright needs. It also enlarges the bound $R_{\max}/(1-\gamma)$ and slows down the algorithms of the next note, whose error shrinks by a factor $\gamma$ per sweep.

> The discount is part of the problem, not a tuning knob that leaves the answer alone. Two values of $\gamma$ can have different optimal policies: a small one takes a small reward now over a large one later.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Which objects define an MDP?</summary>

States, actions, a transition law $P(s'\mid s,a)$, a reward and a discount factor. The Markov property says the transition law depends only on the current state and action.
</details>

<details class="qa" markdown="1">
<summary>Why does fixing a policy turn an MDP into a Markov chain?</summary>

Averaging the action choice $\pi(a\mid s)$ over the transition law gives a matrix $P_\pi$ on states alone. The decision problem is then a statement about which of these matrices to pick.
</details>

<details class="qa" markdown="1">
<summary>What is the effective planning horizon of a discount factor $\gamma$?</summary>

About $1/(1-\gamma)$ steps, the sum of the weights $\gamma^k$. The return is bounded by $R_{\max}/(1-\gamma)$ for bounded rewards.
</details>
