---
collection: notes
title: "Theoretical Foundations"
date: 2026-07-31
excerpt: ""
order: 6
tags:
  - Artificial Intelligence
  - Evolutionary Computing
---


### The Schema Theorem

The Schema Theorem provides a formal, if approximate, account of why GAs work. It is derived for a specific setting: binary chromosomes of fixed length $L$, fitness-proportionate (roulette-wheel) selection, bit-flip mutation with probability $p_m$, and one-point crossover with probability $p_x$.

**Schema.** A schema $h$ is a string of length $L$ over $\{0, 1, *\}$, where $*$ is a wildcard. A chromosome matches $h$ if it agrees with $h$ at every non-wildcard position.

Two measures characterise a schema:

- **Order** $\text{ord}(h)$: the number of fixed (non-wildcard) positions.
- **Defining length** $\text{dl}(h)$: the distance between the first and last fixed position.

**Effect of selection.** Let $N(h, t)$ be the number of chromosomes in generation $t$ that match schema $h$, and let $f_{\text{rel}}(h)$ be their mean relative fitness (average fitness divided by population average). Under fitness-proportionate selection:

$$N(h, t + \Delta t_s) = N(h, t) \cdot f_{\text{rel}}(h) \cdot |P|$$

Schemata with above-average fitness grow, and those with below-average fitness shrink — exactly the intended selection pressure.

**Effect of one-point crossover.** Crossover can split a schema's fixed positions across the two parents, destroying the match. The probability of disruption is:

$$p_{\text{loss}} = p_x \cdot \frac{\text{dl}(h)}{L - 1} \cdot \left(1 - \frac{N(h, t)}{|P|} \cdot f_{\text{rel}}(h)\right)$$

A schema with short defining length loses few matches to crossover; a schema that already dominates the population also loses fewer (it is likely to cross with a copy of itself).

**Effect of bit-flip mutation.** To preserve a match, none of the $\text{ord}(h)$ fixed positions must be flipped:

$$N(h, t+1) = N(h, t + \Delta t_s + \Delta t_x) \cdot (1 - p_m)^{\text{ord}(h)}$$

Schemata of low order survive mutation with high probability; every additional fixed position multiplies the survival probability by $(1-p_m)$.

**The theorem.** Combining all three effects:

$$N(h, t+1) \geq \frac{\overline{f_t(h)}}{\bar{f}_t} \left(1 - p_x \frac{\text{dl}(h)}{L-1}\left(1 - \frac{N(h,t)}{|P|} \cdot \frac{\overline{f_t(h)}}{\bar{f}_t}\right)\right) (1-p_m)^{\text{ord}(h)} \cdot N(h,t)$$

The lower bound on the count grows approximately **exponentially** for schemata with:

- Above-average fitness: $\overline{f_t(h)} > \bar{f}_t$
- Short defining length: small $\text{dl}(h)$
- Low order: small $\text{ord}(h)$

These are the **building blocks**.

### The Building Block Hypothesis

The Schema Theorem motivates the **Building Block Hypothesis**: a GA implicitly identifies, combines, and amplifies short, low-order schemata of above-average fitness. These building blocks recombine to form increasingly fit chromosomes, guiding the search efficiently toward good solutions.

The hypothesis should be read carefully:

> The building block interpretation holds specifically for bit strings, fitness-proportionate selection, binary mutation, and one-point crossover. With other operators (e.g. tournament selection, uniform crossover), the relevant "building blocks" may have different characteristics — but high average fitness always favours propagation under any selection method.

### The No-Free-Lunch Theorem

The No-Free-Lunch (NFL) theorem applies to the space of all possible optimisation problems. If we assume no prior knowledge about the problem at hand — i.e. we treat all objective functions as equally likely — then the expected performance of **any two algorithms is identical**:

$$E\bigl[\text{QuAlg}_{F,n}(\text{Alg}_1) \mid F \in \mathcal{F}\bigr] = E\bigl[\text{QuAlg}_{F,n}(\text{Alg}_2) \mid F \in \mathcal{F}\bigr]$$

for any performance measure $\text{QuAlg}$ (e.g. average best fitness after $n$ evaluations). More precisely, if algorithm $\text{Alg}_1$ outperforms $\text{Alg}_2$ on a subset $\mathcal{F}' \subset \mathcal{F}$ of problems, then $\text{Alg}_2$ must outperform $\text{Alg}_1$ on the complement $\mathcal{F} \setminus \mathcal{F}'$ — there is no free lunch.

| Scenario | Consequence |
|----------|-------------|
| **No prior knowledge** | Expected EA performance equals that of random search or any other method |
| **Problem structure is known** | Knowledge should be used to tailor the algorithm; a specialised EA will outperform generic ones on that problem class |

The practical takeaway is not pessimism, but a reminder: the value of an EA is unlocked by encoding problem-specific knowledge into the representation, operators, and selection mechanism. A GA without domain knowledge is no better than a random walk — it is the deliberate choices that create the algorithm's "niche" of problems where it excels.

