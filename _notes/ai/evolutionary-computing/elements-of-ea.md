---
collection: notes
title: "Elements of Evolutionary Algorithms"
date: 2026-07-31
excerpt: "A survey of the core components of evolutionary algorithms: encoding strategies and their pitfalls, fitness scaling and selective pressure, selection methods and genetic operators."
order: 2
tags: 
  - Artificial Intelligence
  - Evolutionary Computing
---

## Encoding

Encoding of a solution candidate must be chosen based on the problem at hand, there is no general recipe to find a good encoding.

However, there are desirable properties that a good encoding should satisfy.

- **Similar Phenotypes → Similar Genotypes**:
Mutations should produce similar solutions.

> The _Hamming Cliffs_: \
Suppose we want to optimize a multivariate real function.
If we choose a binary representation for the real arguments, we encounter a problem where adjacent numbers are coded with bit-strings that have a big Hamming distance that can be hardly overcome by mutations and crossover.
A remedy is **Gray code**, where adjacent integers differ by exactly one bit. This preserves phenotypical neighborhood in the genotype and avoids the frequency-distribution breaks caused by Hamming cliffs.

- **Similar Fitness for Similar Candidates**: Avoid high epistasis (gene interactions)

> The _Travelling Sales Person Problem_:
> - **Permutation encoding** has low epistasis because swapping two cities causes local changes only.
> - **Position List encoding** has high epistasis because changing early cities alters the entire tour.

Epistasis is a property of the **encoding**, not of the problem itself. The same problem can be encoded with higher or lower epistasis. Very high epistasis makes mutations and crossover produce random fitness changes; very low epistasis often means other search methods outperform EAs.

- **Closure under Operators**: Genetic operators should produce valid solutions.
When operators might produce invalid solutions, several remedies exist:
1. **Encoding-Specific Operators**: Design operators that preserve validity (e.g. pair swaps, inversion for TSP).
2. **Repair Mechanisms**: Fix invalid chromosomes after operation (e.g. remove duplicate cities and append the missing ones at the end).
3. **Penalty Terms**: Reduce the fitness of invalid solutions proportionally to the degree of violation.

> The _n-Queens Problem_:
> - **File positions per rank** (alleles $\{1,\ldots,n\}$) is always valid: one-point crossover and standard mutation always produce valid position vectors.
> - **Field numbers encoding** (alleles $\{1,\ldots,n^2\}$) can produce duplicates, placing two queens on the same field.

> The _TSP_ with permutation encoding: one-point crossover can produce chromosomes where cities appear more than once or are missing entirely, leaving the permutation space. Encoding-specific operators (edge recombination, pair swap) or repair steps are needed.


## Fitness

Better individuals should have better chances to create offspring. **Selective pressure** measures how strongly good individuals are preferred.

There is a fundamental trade-off between two objectives:

| Mode | Goal | Selective Pressure |
|------|------|--------------------|
| **Exploration** | Wide coverage of $\Omega$; maximize chance of finding the global optimum | Low |
| **Exploitation** | Converge on (perhaps local) optimum in the vicinity of good individuals | High |

An effective strategy applies **time-dependent selective pressure**: low in early generations to explore broadly, increasing over time to refine promising regions.

### Measuring Selective Pressure

**Time to takeover** counts the number of generations until the entire population converges to a single individual. **Selection intensity** measures the quality differential between the population before and after selection:

$$I(t) = \frac{\bar{f}_{\text{after}}(t) - \bar{f}(t)}{\sigma(t)}$$

Selection intensity requires fitness values to follow a standard normal distribution, which is rarely satisfied in practice.

### Problems with Fitness-Proportionate Selection

**Premature convergence** arises when one region of $\Omega$ has a much higher absolute fitness than the rest. The population quickly clusters around the local maximum in that region, and individuals drifting toward the global maximum are penalized by comparison, preventing exploration of $\Omega''$.

**Vanishing selective pressure** occurs in later generations as the EA raises the average fitness of all individuals. Once fitness values are close together, relative differences become tiny and selection pressure collapses — the inverse of what is desired.

### Adapting the Fitness Function

Three main scaling approaches counteract these problems:

**Linear dynamical scaling** shifts fitness so the minimum is zero:

$$f'(c) = f(c) - \min_{c' \in \text{pop}} f(c')$$

One can also use the minimum over the last $k$ generations for smoothing.

**$\sigma$-Scaling** normalises by population statistics:

$$f'(c) = \max \\{f(c) - \bar{f}(t) + c \cdot \sigma(t),\; 0 \\}$$

Choosing $c = 2$ works well in practice. Too large a $c$ causes premature convergence; too small causes vanishing pressure.

**Boltzmann Selection** uses an exponential weighting with a temperature $T$ that decreases (e.g. linearly) over generations:

$$P(c) = \frac{e^{f(c)/T}}{Z}$$

where $Z$ is a normalising constant. High temperature at the start gives uniform selection (exploration); low temperature later concentrates selection on the best individuals (exploitation).


## Selection

### Roulette-Wheel Selection

Each individual receives a sector of a roulette wheel proportional to its relative fitness:

$$P(c) = \frac{f(c)}{\sum_{c'} f(c')}$$

The wheel is spun once per individual to be selected.

**Disadvantages:**
- Requires normalisation over the whole population.
- High variance: even the best individual is not guaranteed a place in the next generation.
- Susceptible to dominance and crowding.
- Complex to parallelise.

**Improvements to reduce variance:**

| Variant | Idea |
|---------|------|
| **Expected Value Model** | Pre-generate $\lfloor P(c) \cdot \mu \rfloor$ copies of each individual, then fill remaining slots by roulette. |
| **Stochastic Universal Sampling** | Rotate the wheel once; place $\mu$ equally-spaced markers to read off all selected individuals in a single spin. Every above-average individual is guaranteed selection. |
| **Voting Evaluation** | Cap offspring per individual; best individual gets at most a predefined number of copies. |

### Rank-Based Selection

1. Sort individuals by fitness in descending order.
2. Assign each a rank (rank 1 = best).
3. Define a probability distribution over ranks (lower rank → lower probability).
4. Apply roulette-wheel selection on ranks rather than raw fitness.

This decouples selection probability from absolute fitness, eliminating dominance. Selective pressure is controlled by the shape of the rank distribution. Cost: $O(\mu \log \mu)$ per generation for sorting.

### Tournament Selection

1. Draw $k$ individuals uniformly at random from the population.
2. The individual with the best fitness wins and receives a descendant in the next population.
3. All $k$ participants are returned to the population.
4. Repeat until the new population is full.

**Advantages:** no global fitness normalisation, trivially parallelisable, and selective pressure is tuned simply by adjusting $k$ (larger $k$ → higher pressure).

### Elitism

**Global elitism** copies the best individual (or the $e$ best) unchanged into the next generation, preventing the best-ever solution from being lost to genetic operators. The elite are still eligible for normal selection and may be further improved.

**Local elitism** applies the principle parent-by-parent: a mutated individual replaces its parent only if its fitness is at least as good; for crossover, the four involved individuals (2 parents, 2 offspring) are sorted and the best two proceed.

| | Advantage | Disadvantage |
|-|-----------|--------------|
| **Elitism** | Better convergence toward local optima | Higher risk of stagnation; no local degradation is permitted |

### Preventing Crowding

When selection pressure drives the population toward a single region, diversity collapses. Two mechanisms counteract this:

**Deterministic Crowding:** Offspring replace the most similar individuals currently in the population (measured e.g. by Hamming distance), preventing any region from becoming overpopulated. A practical variant groups each offspring with its most similar parent and keeps the fitter of the two.

**Sharing:** Reduce the fitness of an individual proportionally to how many nearby individuals exist:

$$f'(c) = \frac{f(c)}{\sum_{c' \in \text{pop}} sh(d(c, c'))}$$

where $d$ is a distance metric on $\Gamma$ and $sh$ is a weighting function that defines the shape and size of the niche. Individuals effectively share the resources of their niche.

### Characterisation of Selection Methods

| Property | Values | Meaning |
|----------|--------|---------|
| **Static / Dynamic** | Static | Selection probability is constant across generations |
| | Dynamic | Probability changes over time |
| **Extinguishing / Preservative** | Extinguishing | Some individuals may have selection probability 0 |
| | Preservative | All individuals have probability > 0 |
| **Pure-bred / Under-bred** | Pure-bred | Individuals reproduce in one generation only |
| | Under-bred | Individuals may reproduce across multiple generations |
| **Right / Left** | Right | All individuals may reproduce |
| | Left | The best individuals may not reproduce |
| **Generational / On-the-fly** | Generational | Parents are fixed until all offspring are created |
| | On-the-fly | Offspring immediately replace their parents |


## Genetic Operators

Genetic operators are applied to a fraction of the population (the intermediary population) to generate mutations and recombinations of existing solution candidates. They are classified by the number of parents:

- **One-parent operators** (mutation)
- **Two-parent operators** (crossover)
- **Multi-parent operators**

Operators must respect the encoding: if certain allele combinations are invalid, operators should never produce them.

### Mutation

Mutation introduces small random changes. It serves two purposes:
- **Exploration**: random jumps to distant regions of $\Omega$.
- **Exploitation**: local refinement of a good candidate.

The key design principle is **phenotypical neighbourhood**: mutations that look small in the genotype should produce similar phenotypes and thus similar fitness.

**Standard Mutation** (bit strings of length $l$): flip each bit independently with probability $p_m$. The approximately optimal rate is:

$$p_m \approx \frac{1}{l}$$

**Pair Swap**: exchange the alleles of two genes. Precondition: both genes share the same allele set. Generalises to cyclic exchange of $k$ genes.

**Operations on Subsequences** (precondition: same allele sets in the affected range):

| Operation | Description |
|-----------|-------------|
| **Shift** | Move a contiguous subsequence to a different position |
| **Inversion** | Reverse the order of a subsequence |
| **Arbitrary Permutation** | Randomly reorder a subsequence |

**Gaussian Mutation** (real-valued chromosomes):

$$x'_i = x_i + \mathcal{N}(0, \sigma)$$

Low $\sigma$ gives local exploitation; high $\sigma$ gives wide exploration. Gaussian mutation respects phenotypical neighbourhood and avoids the Hamming-cliff frequency breaks of binary mutation. Binary mutation with Gray code is faster and better at detecting interesting regions of $\Omega$, while Gaussian mutation is better oriented toward phenotypical neighbourhood.

### Crossover (Two-Parent)

**One-Point Crossover**: choose a random cutting point $k \in [1, l-1]$; exchange the gene sequences on one side of $k$.

**Two-Point Crossover**: choose two cutting points; exchange the gene segment between them.

**$n$-Point Crossover**: generalisation with $n$ cutting points and alternating keep/exchange segments.

**Uniform Crossover**: for each gene independently, exchange with probability $p_k$. The number of exchanged genes follows:

$$P(X = k) = \binom{l}{k} p_k^k (1-p_k)^{l-k}$$

Uniform crossover is **not** equivalent to $l/2$-point crossover because cutting points are not fixed.

**Shuffle Crossover**:
1. Randomly permute all gene positions.
2. Apply one-point crossover.
3. Reverse the permutation to restore original gene positions.

Shuffle crossover is not equivalent to uniform crossover; its key property is that every possible count of gene exchanges has equal probability (unlike the binomial distribution of uniform crossover). It is one of the most recommended methods.

**Uniform Order-Based Crossover** (for permutation encodings):
1. For each gene, mark it as keep (+) or not (−) with probability $p_k$.
2. Copy the kept genes from parent 1 at their original positions.
3. Fill the gaps with the missing alleles in the order they appear in parent 2.

This preserves relative order information from both parents.

**Edge Recombination** (for TSP / ring encodings):
Treats each chromosome as a ring graph and preserves neighbourhood (adjacency) information:

1. **Build the edge table**: for every city, list all its neighbours in both parent tours. If a city has the same neighbour in both parents, mark that neighbour.
2. **Build the child**:
   - Take the first allele of a randomly chosen parent.
   - Iteratively choose the next allele from the current city's neighbour list, following the priority:
     1. A marked neighbour (shared in both parents).
     2. The neighbour with the shortest remaining neighbour list.
     3. Any remaining allele at random.
   - Remove each chosen allele from all neighbour lists.

Children constructed this way often introduce only one new edge (the closing wrap-around edge).

### Multi-Parent Crossover

**Diagonal Crossover** (for $k$ parents):
Use $k-1$ cutting points and shift gene segments diagonally across the $k$ chromosomes at each intersection. With many parents (10–15), this produces strong exploration of the search space.

### Properties of Crossover Operators

**Positional bias**: the probability that two genes are jointly inherited from the same parent depends on their relative positions in the chromosome. This is **undesired** because it makes the physical arrangement of genes in the chromosome critical to the algorithm's success. One-point crossover has strong positional bias (adjacent genes are almost always inherited together); shuffle crossover eliminates it.

**Distributional bias**: some counts of exchanged genes are more likely than others. Uniform crossover has binomial distributional bias; shuffle crossover has none (all exchange counts are equally probable). Distributional bias is generally less critical than positional bias.

### Interpolating vs. Extrapolating Recombination

**Interpolating recombination** creates offspring strictly between the parents in genotype space, e.g. arithmetic crossover:

$$c_i = \alpha \cdot p_{1,i} + (1-\alpha) \cdot p_{2,i}, \quad \alpha \in [0,1]$$

Creates new alleles, focuses the population on one central region, and benefits fine-tuning of already-good individuals. Requires a strong, diversity-preserving mutation to support exploration early on.

**Extrapolating recombination** creates offspring outside the parent region:

$$c_i = p_{1,i} + \alpha \cdot (p_{1,i} - p_{2,i}), \quad \alpha > 0$$

It is the only recombination operator that takes fitness values into account (moving in the direction inferred to be promising). May leave the current search region entirely; its effect on diversity is harder to predict.

### Adaptation Strategies for Mutation

The quality of a mutation operator cannot be judged independently of the current fitness level. More local operators are appropriate as the search approaches the optimum.

Three strategies exist for adapting mutation parameters (e.g. $\sigma$ in Gaussian mutation) over time:

| Strategy | Mechanism |
|----------|-----------|
| **Predefined adaptation** | Schedule $\sigma$ to decrease exponentially before the run: $\sigma_t = \sigma_0 \cdot e^{-\lambda t}$ |
| **Adaptive adaptation** | Monitor the fraction of improving mutations in the last $k$ generations; increase $\sigma$ if the fraction is too low, decrease if too high (1/5 success rule) |
| **Self-adaptive adaptation** | Store $\sigma$ as a strategy parameter inside each individual; mutate $\sigma$ itself (log-normally) before mutating the object variables. Good $\sigma$ values propagate because they produce better offspring |

Self-adaptive Gaussian mutation updates both the strategy parameter and the object variable:

$$\sigma' = \sigma \cdot e^{\tau \cdot \mathcal{N}(0,1)}, \qquad x'_i = x_i + \sigma' \cdot \mathcal{N}_i(0,1)$$

Empirically, self-adaptive adaptation outperforms both predefined schedules and adaptive rules.

### Relations and Impacts Summary

| Condition | Target | Effect |
|-----------|--------|--------|
| Genotype | Mutation | Influences the vicinity of the mutation operator |
| Mutation | Exploration | Random mutations support broad exploration |
| Mutation | Fine-tuning | Local mutations (w.r.t. fitness) support fine-tuning |
| Mutation | Diversity | Mutation increases diversity |
| Recombination | Exploration | Extrapolating operators strengthen exploration |
| Recombination | Fine-tuning | Interpolating operators strengthen fine-tuning |
| Selection | Exploration | Low selective pressure strengthens exploration |
| Selection | Fine-tuning | High selective pressure strengthens fine-tuning |
| Selection | Diversity | Selection mostly decreases diversity |
| Fine-tuning | Diversity | Fine-tuning operations decrease diversity |
| Diversity | Selection | Small diversity decreases effective selection pressure under fitness-proportionate selection |
| Local optima | Search progress | Large numbers of local optima inhibit progress |
| All factors | Search progress | Counterbalancing of exploration, fine-tuning, and selection is required |