---
collection: notes
title: "Swarm and Population-Based Optimization"
excerpt: "PBIL, PSO, ACO."
order: 5
tags:
  - Artificial Intelligence
  - Evolutionary Computing
---

## Population-Based Incremental Learning (PBIL)

PBIL is a GA without an explicit population. The entire population is summarised by a **probability vector** $P = (p_1, \ldots, p_l)$ where $p_i \in [0,1]$ is the probability that position $i$ is $1$ in a sampled individual.

**Algorithm:**

1. Initialise $P = (0.5, \ldots, 0.5)$.
2. Sample $\lambda$ individuals from $P$.
3. Evaluate and identify the best individuals $B$.
4. Update: $p_i \leftarrow (1 - \alpha) \cdot p_i + \alpha \cdot \bar{b}_i$, where $\bar{b}_i$ is the mean value of bit $i$ across $B$.
5. Apply mutation: with probability $p_m$, nudge each $p_i$ by $\beta$ toward $0$ or $1$ at random.
6. Repeat from step 2.

A low learning rate $\alpha$ emphasises exploration; a high $\alpha$ accelerates fine-tuning. PBIL has less memory overhead than a standard GA, but it treats each bit position independently and therefore cannot capture joint distributions. This means it may fail when two bits are highly epistatic: the same marginal statistics $(0.5, 0.5)$ can describe radically different populations (e.g. one consisting of all $00$ and $11$, another of all $01$ and $10$).

| Parameter | Typical range |
| --------- | ------------- |
| Population size $\lambda$ | $20$–$100$ |
| Learning rate $\alpha$ | $0.05$–$0.2$ |
| Mutation rate $p_m$ | $0.001$–$0.02$ |
| Mutation constant $\beta$ | $0.05$ |

## Particle Swarm Optimization (PSO)

PSO models a swarm of agents (_particles_) exploring a continuous search space. Each particle $i$ carries a **position** $x_i$ (the candidate solution), a **velocity** $v_i$, a **personal best** $x_i^{(\text{local})}$ (best position it has ever visited), and a reference to the **global best** $x^{(\text{global})}$ across the entire swarm.

At each timestep, the velocity is updated by blending inertia, attraction toward the personal best, and attraction toward the global best:

$$v_i(t+1) = \alpha \cdot v_i(t) + \beta_1 \bigl(x_i^{(\text{local})}(t) - x_i(t)\bigr) + \beta_2 \bigl(x^{(\text{global})}(t) - x_i(t)\bigr)$$

$$x_i(t+1) = x_i(t) + v_i(t)$$

The $\alpha$ term is an **inertia weight** that smooths the trajectory; $\beta_1$ is the **cognitive coefficient** pulling toward the particle's own memory; $\beta_2$ is the **social coefficient** pulling toward the collective memory. In practice, $\beta_1$ and $\beta_2$ are scaled by uniform random numbers drawn independently at each step, introducing stochastic exploration.

**Extensions:**

- Replace the global best with a **local neighbourhood best** (ring topology, etc.) to slow down premature convergence and maintain diversity.
- Allow automatic adjustment of $\alpha$, swarm size, or neighbourhood radius over time.
- Introduce a diversity re-injection mechanism (e.g. a random velocity kick) when the swarm converges too early.

## Ant Colony Optimization (ACO)

ACO is inspired by the ability of blind ants to converge on the shortest food path using only **pheromone trails**. The core principle is **stigmergy**: communication through modification of the shared environment rather than direct signalling between individuals.

### The Double-Bridge Experiment

When an ant nest and a food source are connected by two bridges of different lengths:

1. Initially, ants choose paths at random — roughly half take each bridge.
2. Ants using the shorter bridge return faster, so the shorter bridge accumulates pheromone earlier.
3. Higher pheromone concentration makes subsequent ants more likely to take the shorter bridge, further widening the pheromone gap.
4. Positive feedback (autocatalysis) rapidly concentrates nearly all traffic on the shorter bridge.

This mechanism is self-limiting only because pheromone **evaporates**: without evaporation, the first bridge to receive a random majority would lock in indefinitely even if it is suboptimal. The experiment was run with Argentine ants (_Iridomyrmex humilis_), which are nearly blind and rely entirely on pheromone.

> A critical caveat: once a route is established, ACO struggles to switch to a shorter one introduced later. Evaporation provides some forgetting, but the system may still remain trapped on a suboptimal path that has accumulated many pheromone deposits.

### ACO for the TSP

The TSP is represented by an $n \times n$ distance matrix $D$ and a pheromone matrix $\Phi$, where $\phi_{ij}$ encodes the desirability of moving from city $i$ to city $j$. All $\phi_{ij}$ are initialised to the same small value.

**Tour construction.** Each ant starts at a random city and iteratively selects an unvisited city $j$ with probability:

$$p_{ij} = \frac{\phi_{ij}^\alpha \cdot \eta_{ij}^\beta}{\displaystyle\sum_{k \in C} \phi_{ik}^\alpha \cdot \eta_{ik}^\beta}$$

where $C$ is the set of not-yet-visited cities, $\eta_{ij} = 1/d_{ij}$ is the heuristic desirability (prefer short edges), and $\alpha$, $\beta$ control the relative weight of pheromone versus heuristic. The basic formulation uses only $\phi_{ij}$ (i.e. $\alpha = 1$, $\beta = 0$); the extended form incorporates the edge weight $\eta_{ij}$.

To prevent self-reinforcing cycles, pheromone is deposited only after a complete tour is built, and any cycles in the path can be removed before deposit.

**Pheromone update.** After each iteration:

1. **Evaporation:** $\phi_{ij} \leftarrow (1 - \rho) \cdot \phi_{ij}$ for all edges, where $\rho \in (0,1)$ is the evaporation rate.
2. **Intensification:** each ant deposits pheromone proportional to the quality of its tour: better tours receive more pheromone.

**Extensions:**

| Extension | Mechanism |
| --------- | --------- |
| **Elitism** | Only the globally best ant (or the current iteration's best) deposits pheromone |
| **Rank-based update** | Deposit amount depends on the rank of the solution in the current iteration |
| **Min/max pheromone bounds** | Clamp $\phi_{ij} \in [\phi_{\min}, \phi_{\max}]$ to prevent stagnation and preserve exploration |
| **Limited evaporation** | Evaporate only edges used in the current iteration |
| **Local optimization** | Apply 2-opt or 3-opt to each ant's tour before pheromone deposit |

Local optimization in ACO is particularly effective: applying 2-opt to the best tour before depositing pheromone (rather than to all tours) balances quality improvement with computational cost.
