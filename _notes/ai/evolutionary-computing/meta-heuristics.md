---
collection: notes
title: "Meta-Heuristics"
excerpt: >
  Local search, simulated annealing, tabu search, memetic algorithms, differential evolution, PBIL, PSO, ACO.
order: 3
tags:
  - Artificial Intelligence
  - Evolutionary Computing
---

A **meta-heuristic** is an algorithmic framework for approximately solving combinatorial optimization problems. It prescribes an abstract sequence of steps that applies to any problem, while requiring problem-specific implementations of each step. Meta-heuristics are used when no efficient exact algorithm is known, and they provide no optimality guarantee.

## Gradient-Based Search

For differentiable objectives, gradient ascent/descent iterates:

$$x^{(t+1)} = x^{(t)} + \eta \cdot \nabla f(x^{(t)})$$

where $\eta$ is the step width.

> Too small a step causes slow convergence, while too large a step causes oscillation around local optima. Both forms converge only to local optima, not global ones.

## Hill Climbing

For non-differentiable objectives, **hill climbing** replaces the gradient with a random perturbation:

1. Choose a random starting point $x^{(0)}$.
2. Generate a neighbour $x'$ via a small random variation.
3. Accept $x'$ if $f(x') > f(x^{(t)})$.
4. Repeat until a termination criterion is met.

Hill climbing always terminates in a local optimum. Restarting from multiple random initial points is the simplest way to improve its chance of finding the global optimum.

## Simulated Annealing

Simulated annealing (SA) escapes local optima by occasionally accepting worse solutions. The acceptance probability is:

$$P(\text{accept}) = \begin{cases} 1 & \text{if } \Delta f \geq 0 \\ e^{-\Delta f / (Q \cdot T)} & \text{otherwise} \end{cases}$$

where $\Delta f = f(x') - f(x^{(t)})$ is the quality change, $Q$ is an estimate of the fitness range, and $T$ is a **temperature** parameter that decreases over time. High temperature at the start allows broad exploration; as $T \to 0$ the algorithm hardens into ordinary hill climbing. The probability of accepting a degradation decreases both as the degradation grows larger and as the temperature falls.

## Other Threshold-Based Variants

| Algorithm | Acceptance criterion |
|-----------|----------------------|
| **Threshold Accepting** | Accept worse solutions within a fixed threshold $\delta$: $\Delta f \geq -\delta$ |
| **Great Deluge** | Accept any solution above a rising "water level" $W(t)$: $f(x') \geq W(t)$ |
| **Record-to-Record Travel** | Accept solutions whose quality is at most a fixed deviation below the current best |

All three avoid the stochastic acceptance of SA in favour of deterministic criteria, which makes them faster but typically less robust to complex fitness landscapes.


## Tabu Search

Tabu search maintains a **tabu list** — a short FIFO queue of recently visited solutions or solution attributes. Moves that would produce a state on the tabu list are forbidden, which prevents cycling and forces exploration of new regions. An **aspiration criterion** can override the tabu status: if a tabu move would produce the best solution found so far, it is permitted regardless.

## Memetic Algorithms

Memetic algorithms combine a population-based EA with a local search step applied to every new individual:

1. Generate an offspring via standard EA operators (selection, crossover, mutation).
2. Immediately apply a local search procedure to that individual, improving it within its neighbourhood.
3. Insert the locally optimised individual into the population.

The result converges faster than a plain EA, because offspring are already local optima before entering the population. The drawback is that the local search constrains dynamics to the basins of attraction of local optima, which can limit the diversity of the population if many individuals converge to the same basin.

## Differential Evolution

Differential evolution (DE) adapts the mutation step size using the current population's spread. For each target individual $x_i$, a **trial vector** is constructed from three randomly chosen, distinct individuals $x_{r1}, x_{r2}, x_{r3}$:

$$v_i = x_{r1} + F \cdot (x_{r2} - x_{r3})$$

$v_i$ is then recombined with $x_i$ via uniform crossover, and the result replaces $x_i$ if it is fitter. The difference vector $F \cdot (x_{r2} - x_{r3})$ automatically shrinks as the population converges, providing self-adaptive step scaling without explicit parameter tuning.

| Parameter | Typical range |
|-----------|---------------|
| Population size | $10$–$100$ (often $10 \times$ the dimension) |
| Recombination probability | $0.7$–$0.9$ |
| Scaling factor $F$ | $0.5$–$1.0$ |

## Scatter Search

Scatter search is a deterministic meta-heuristic with explicit diversity management:

1. **Diversity generation** — create a population of maximally diverse solutions.
2. **Reference set update** — maintain a small reference set combining the best solutions and the most diverse ones.
3. **Systematic recombination** — enumerate and evaluate all pairs from the reference set.
4. **Local optimization** — apply a local search to each produced offspring.

The absence of randomness makes scatter search reproducible, but it requires a well-defined diversity metric and a fast local optimiser.

## Cultural Algorithms

Cultural algorithms augment a standard EA with a **belief space**: an additional memory layer that accumulates knowledge across generations and biases the search.

| Knowledge type | Content |
|----------------|---------|
| **Situational** | Best individuals found in previous generations |
| **Normative** | Upper and lower bounds on each gene dimension, extracted from high-fitness individuals |

The belief space is updated after each generation and feeds back into the variation operators, guiding offspring toward regions that have historically been productive.
