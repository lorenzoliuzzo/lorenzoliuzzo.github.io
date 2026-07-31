---
title: "Evolutionary Algorithms"
excerpt: "A comprehensive guide from biological inspiration to computational intelligence"
collection: notes

layout: single

header:
  overlay_color: "#193155ff"
  overlay_filter: "0.4"
  overlay_image: /assets/images/evolution.jpeg 

read_time: true

toc: true
toc_sticky: true
---


## 4.2 Formal Definitions
{: style="color: #4A7C59;"}

### Decoding Function
{: style="color: #C78D3F;"}

EAs separate the **phenotype space** $\Omega$ (actual solutions) from the **genotype space** $\Gamma$ (encoded representations):

$$\text{dec}: \Gamma \rightarrow \Omega$$

The fitness function $f$ is defined on $\Omega$, while mutation and recombination operate on $\Gamma$.


### Individual
{: style="color: #C78D3F;"}

An **individual** is a tuple $(\gamma, \alpha, \phi)$ where:
- $\gamma \in \Gamma$ is the **genotype** (solution candidate)
- $\alpha \in A$ is optional **additional information** or strategy parameters
- $\phi$ is the **quality/fitness** assessment


### Genetic Operators
{: style="color: #C78D3F;"}

**Mutation Operator**: A mapping that creates variation
$$\text{mut}_r: \Gamma \times \mathcal{R} \rightarrow \Gamma$$

**Recombination Operator**: Combines multiple parents
$$\text{rec}_r: \Gamma^k \times \mathcal{R} \rightarrow \Gamma^m$$


### Selection Operator
{: style="color: #C78D3F;"}

A **selection operator** $\text{Sel}$ applied to a population $\text{pop}$ with $r$ individuals chooses $s$ individuals based solely on fitness:

$$\text{Sel}: \mathbb{R}^r \rightarrow \\{ 1, \ldots, r \\}^s$$


## 4.3 The Generic Evolutionary Algorithm
{: style="color: #4A7C59;"}

```
Algorithm: General Scheme of an Evolutionary Algorithm
────────────────────────────────────────────────────────
Input: optimization problem (Ω, f, <)

1.  Create initial population pop(0) of size μ
2.  Evaluate pop(0)
3.  
4.  while not termination criterion do
5.      Select μ parents from pop(t)
6.      Create λ offspring by recombination
7.      Mutate offspring
8.      Evaluate offspring
9.      Select μ individuals for pop(t+1) from offspring + pop(t)
10.     t ← t + 1
11. end while
12. 
13. return best individual of pop(t)
────────────────────────────────────────────────────────
```


## 4.4 Genetic vs. Evolutionary Algorithms
{: style="color: #4A7C59;"}

| Aspect | Genetic Algorithm (GA) | Evolutionary Algorithm (EA) |
|--------|------------------------|----------------------------|
| **Encoding** | Bit strings (binary) | Problem-related (letters, graphs, formulas) |
| **Operators** | Standard bit-flip mutation, one-point crossover | Encoding-specific, problem-adapted |


---
# 5. Encoding and Representation
{: style="color: #1B5E6F;"}

## 5.1 Desirable Properties of Encoding
{: style="color: #4A7C59;"}

A good encoding should satisfy:

1. **Similar Phenotypes → Similar Genotypes**: Mutations should produce similar solutions
2. **Similar Fitness for Similar Candidates**: Avoid high epistasis (gene interactions)
3. **Closure under Operators**: Genetic operators should produce valid solutions


## 5.2 The Hamming Cliff Problem
{: style="color: #4A7C59;"}

When representing real numbers with binary codes, **adjacent numbers** can have **large Hamming distances**:

| Decimal | Binary | Hamming Distance to Next |
|---------|--------|--------------------------|
| 3 | 0011 | - |
| 4 | 0100 | **2** (not 1!) |

This creates **Hamming cliffs** where small phenotype changes require large genotype changes, making optimization difficult.


## 5.3 Epistasis: Gene Interactions
{: style="color: #4A7C59;"}

**Epistasis** measures how much the effect of one gene depends on other genes:

- **High epistasis**: Changing one gene dramatically alters the fitness landscape
- **Low epistasis**: Genes contribute independently to fitness

**Example - TSP Encoding:**

| Encoding | Epistasis | Characteristics |
|----------|-----------|-----------------|
| **Permutation** | Low | Swapping two cities causes local changes only |
| **Position List** | High | Changing early genes alters the entire tour |


## 5.4 Closure Under Operators
{: style="color: #4A7C59;"}

When operators might produce invalid solutions, several remedies exist:

1. **Encoding-Specific Operators**: Design operators that preserve validity
2. **Repair Mechanisms**: Fix invalid chromosomes after operation
3. **Penalty Terms**: Reduce fitness of invalid solutions

**Example - n-Queens Problem:**
- **Valid encoding**: File positions per rank (always valid)
- **Invalid encoding**: Field numbers (can produce duplicates)


---
# 6. Fitness and Selection Pressure
{: style="color: #1B5E6F;"}

## 6.1 The Exploration-Exploitation Trade-off
{: style="color: #4A7C59;"}

| Aspect | Exploration | Exploitation |
|--------|-------------|--------------|
| **Goal** | Wide deviation of individuals | Convergence to promising regions |
| **Pressure** | Lower selective pressure | Higher selective pressure |
| **When** | Early generations | Later generations |


## 6.2 Selection Intensity
{: style="color: #4A7C59;"}

**Selection intensity** measures the differential between average quality before and after selection:

$$I(t) = \frac{\bar{f}_{\text{after}}(t) - \bar{f}(t)}{\sigma(t)}$$

where $\sigma(t)$ is the standard deviation of fitness values.


## 6.3 Time-Dependent Selective Pressure
{: style="color: #4A7C59;"}

An effective strategy adapts pressure over time:

```
Early Generations          Later Generations
     ↓                           ↓
┌──────────┐               ┌──────────┐
│  LOW     │    ──────>    │  HIGH    │
│ PRESSURE │               │ PRESSURE │
│(explore) │               │(exploit) │
└──────────┘               └──────────┘
```


## 6.4 Fitness Scaling Methods
{: style="color: #4A7C59;"}

### Linear Dynamical Scaling
{: style="color: #C78D3F;"}

$$f'(c) = f(c) - \min_{c' \in \text{pop}} f(c')$$


### σ-Scaling
{: style="color: #C78D3F;"}

$$ f'(c) = \max \\{ f(c) - (\bar{f}(t) - c \cdot \sigma(t)), 0 \\} $$

**Appropriate choice**: $c = 2$ typically works well.


### Boltzmann Selection
{: style="color: #C78D3F;"}

$$P(c) = \frac{e^{f(c)/T}}{Z}$$

where temperature $T$ decreases over generations, controlling selective pressure.


## 6.5 Common Problems
{: style="color: #4A7C59;"}

| Problem | Cause | Solution |
|---------|-------|----------|
| **Premature Convergence** | One individual dominates | Fitness scaling, rank selection |
| **Vanishing Pressure** | Fitness values become similar | Dynamic scaling, time-dependent selection |


---
# 7. Selection Methods
{: style="color: #1B5E6F;"}


## 7.1 Roulette-Wheel Selection (Fitness-Proportionate)
{: style="color: #4A7C59;"}

**Concept**: Each individual gets a roulette wheel sector proportional to its relative fitness:

$$P(c) = \frac{f(c)}{\sum_{c'} f(c')}$$

**Disadvantages**:
- Computationally expensive (requires normalization)
- High variance in offspring count
- Susceptible to dominance problems
- Complex to parallelize

**Improvements**:
- **Stochastic Universal Sampling**: Single wheel spin selects all individuals
- **Expected Value Model**: Generate expected number of copies first


## 7.2 Rank-Based Selection
{: style="color: #4A7C59;"}

**Procedure**:
1. Sort individuals by fitness (descending)
2. Assign ranks
3. Define probability distribution over ranks
4. Apply roulette-wheel selection on ranks

**Advantages**:
- Avoids dominance problem
- Selective pressure controlled by rank distribution

**Disadvantages**:
- Requires sorting ($O(\mu \log \mu)$)


## 7.3 Tournament Selection
{: style="color: #4A7C59;"}

**Procedure**:
1. Randomly draw $k$ individuals from population
2. Select the best as winner
3. Return all participants to population
4. Repeat until new population is filled

**Advantages**:
- Simple and efficient
- No global fitness normalization needed
- Pressure controlled by tournament size $k$
- Easy to parallelize


## 7.4 Elitism
{: style="color: #4A7C59;"}

**Concept**: Unchanged transfer of best individual(s) to next generation.

**Variants**:
- **Global Elitism**: Best individual always survives
- **Local Elitism**: Offspring replaces parent only if better

**Trade-offs**:
- **Advantage**: Better convergence
- **Disadvantage**: Higher risk of local optima stagnation


## 7.5 Preventing Crowding
{: style="color: #4A7C59;"}

| Method | Description |
|--------|-------------|
| **Deterministic Crowding** | Offspring replace most similar individuals |
| **Sharing** | Reduce fitness of individuals in crowded regions |


## 7.6 Selection Method Characterization
{: style="color: #4A7C59;"}

| Property | Description |
|----------|-------------|
| **Static/Dynamic** | Selection probability constant or changing |
| **Extinguishing/Preservative** | Can probability be zero? |
| **Pure-bred/Under-bred** | Offspring in one or multiple generations |
| **Right/Left** | All may reproduce vs. best may not |
| **Generational/On-the-fly** | Parents fixed or immediately replaced |


---
# 8. Genetic Operators
{: style="color: #1B5E6F;"}

## 8.1 One-Parent Operators: Mutation
{: style="color: #4A7C59;"}

Mutation introduces small random changes, enabling:
- **Exploration**: Random discovery of new regions
- **Exploitation**: Local improvement of solutions


### Standard Mutation
{: style="color: #C78D3F;"}

For bit strings of length $l$, optimal mutation probability:

$$p_m \approx \frac{1}{l}$$


### Pair Swap
{: style="color: #C78D3F;"}

Exchange values of two genes (requires same allele sets).


### Operations on Subsequences
{: style="color: #C78D3F;"}

| Operation | Description |
|-----------|-------------|
| **Shift** | Move a subsequence to another position |
| **Inversion** | Reverse a subsequence |
| **Arbitrary Permutation** | Randomly reorder a subsequence |


### Gaussian Mutation (Real-Valued)
{: style="color: #C78D3F;"}

For real-valued chromosomes:

$$x'_i = x_i + \mathcal{N}(0, \sigma)$$

- **Low $\sigma$**: Good for exploitation
- **High $\sigma$**: Good for exploration


## 8.2 Two-Parent Operators: Crossover
{: style="color: #4A7C59;"}

### One-Point Crossover
{: style="color: #C78D3F;"}

1. Choose random cutting point $k \in [1, l-1]$
2. Exchange gene sequences on one side

**Probability of splitting schema**: $\frac{\delta(h)}{l-1}$

where $\delta(h)$ is the defining length of schema $h$.


### Two-Point and n-Point Crossover
{: style="color: #C78D3F;"}

Multiple cutting points with alternating exchange/keep pattern.


### Uniform Crossover
{: style="color: #C78D3F;"}

For each gene, independently decide whether to exchange (probability $p_k$).

Number of exchanges follows binomial distribution:

$$P(X = k) = \binom{l}{k} p_k^k (1-p_k)^{l-k}$$


### Shuffle Crossover
{: style="color: #C78D3F;"}

1. Randomly permute gene positions
2. Apply one-point crossover
3. Unmix genes to original positions

**Advantage**: Each count of gene exchanges has equal probability.


## 8.3 Specialized Crossover Operators
{: style="color: #4A7C59;"}

### Edge Recombination (for TSP)
{: style="color: #C78D3F;"}

Preserves neighborhood information by:
1. Constructing edge table from both parents
2. Selecting alleles based on shared neighbors (marked)
3. Preferring alleles with shortest neighbor lists


### Uniform Order-Based Crossover
{: style="color: #C78D3F;"}

1. Mark genes to keep (+) or not (-)
2. Fill gaps with missing alleles in order from other parent


## 8.4 Multi-Parent Operators
{: style="color: #4A7C59;"}

### Diagonal Crossover
{: style="color: #C78D3F;"}

For $k$ parents, use $k-1$ crossover points, shifting gene sequences diagonally across chromosomes.

**Effect**: Strong exploration, especially with many parents (10-15).


## 8.5 Crossover Operator Properties
{: style="color: #4A7C59;"}

| Property | Description | Impact |
|----------|-------------|--------|
| **Positional Bias** | Joint inheritance depends on gene position | Undesired - makes arrangement crucial |
| **Distributional Bias** | Some exchange counts more likely than others | Less critical than positional bias |


## 8.6 Interpolating vs. Extrapolating Recombination
{: style="color: #4A7C59;"}

### Interpolating (e.g., Arithmetic Crossover)
{: style="color: #C78D3F;"}

Creates offspring between parents:

$$c_i = \alpha \cdot p_{1,i} + (1-\alpha) \cdot p_{2,i}, \quad \alpha \in [0, 1]$$

- Creates new alleles
- Focuses population on main area
- Good for fine-tuning

### Extrapolating
{: style="color: #C78D3F;"}

Creates offspring outside parent region:

$$c_i = p_{1,i} + \alpha \cdot (p_{1,i} - p_{2,i}), \quad \alpha > 0$$

- Only recombination considering fitness values
- May leave current search region
- Influences diversity unpredictably


---
# 9. Local Search and Meta-Heuristics
{: style="color: #1B5E6F;"}

## 9.1 What is a Meta-Heuristic?
{: style="color: #4A7C59;"}

A **meta-heuristic** is an algorithmic method for approximately solving combinatorial optimization problems. It defines an abstract sequence of steps applicable to any problem, though individual steps must be implemented problem-specifically.

**Key Properties**:
- Used when no efficient exact algorithm exists
- Optimal solution not guaranteed
- Success depends on problem definition and implementation


## 9.2 Local Search Methods
{: style="color: #4A7C59;"}
{: style="color: #4A7C59;"}

Local search maintains a single solution and iteratively improves it through small modifications.

### Gradient Ascent/Descent
{: style="color: #C78D3F;"}

**Assumption**: $f$ is differentiable.

**Update rule**:
$$ x^{(t+1)} = x^{(t)} + \eta \cdot \nabla f(x^{(t)}) $$

where $\eta$ is the step width (learning rate).

**Problems**:
- Step width selection (too small → slow; too large → oscillation)
- Gets stuck in local optima

### Hill Climbing
{: style="color: #581250ff;"}

For non-differentiable functions:

1. Choose random starting point $x^{(0)}$
2. Generate neighbor $x'$ (small random variation)
3. Accept if $f(x') > f(x^{(t)})$
4. Repeat until termination

**Problem**: Susceptible to local optima.


## 9.3 Simulated Annealing
{: style="color: #4A7C59;"}
{: style="color: #A23B72;"}

**Idea**: Accept worse solutions with probability decreasing over time.

**Acceptance probability**:

$$P(\text{accept}) = \begin{cases} 1 & \text{if } \Delta f \geq 0 \\ e^{-\Delta f / (Q \cdot T)} & \text{otherwise} \end{cases}$$

where:
- $\Delta f = f(x') - f(x^{(t)})$ (quality reduction)
- $Q$ estimates quality range
- $T$ is temperature (decreases over time)

**Effect**: Early exploration with occasional "uphill" moves; later convergence to local optimum.


## 9.4 Other Local Search Variants
{: style="color: #4A7C59;"}

| Algorithm | Key Mechanism |
|-----------|---------------|
| **Threshold Accepting** | Accept worse solutions within threshold |
| **Great Deluge** | Accept solutions above rising water level |
| **Record-to-Record Travel** | Accept degradation relative to best found |


## 9.5 EA-Related Methods
{: style="color: #4A7C59;"}

### Tabu Search
{: style="color: #581250ff;"}

- Uses **tabu list** (FIFO queue) to avoid revisiting solutions
- Prevents cycling and encourages exploration
- **Aspiration criteria**: Can override tabu for exceptional solutions

### Memetic Algorithms
{: style="color: #581250ff;"}

**Combination**: Population-based EA + Local Search

**Procedure**:
1. Create new individual via EA operators
2. Immediately apply local search optimization
3. Add optimized individual to population

**Advantages**: Faster convergence  
**Disadvantages**: May limit exploration, search dynamic constrained

### Differential Evolution
{: style="color: #581250ff;"}

**Idea**: Use population relationships for step width adaptation.

**DE Operator** (combines mutation and recombination):

$$v_i = x_{r1} + F \cdot (x_{r2} - x_{r3})$$

**Parameters**:
- Population size: 10-100 (typically 10× dimension)
- Recombination weight: 0.7-0.9
- Scaling factor $F$: 0.5-1.0

### Scatter Search
{: style="color: #581250ff;"}

**Deterministic method** with:
1. **Diversity generation**: Create diverse initial population
2. **Reference set update**: Combine best + most diverse
3. **Systematic recombination**: Combine all pairs
4. **Local optimization**: Improve offspring

### Cultural Algorithms
{: style="color: #581250ff;"}

**Additional memory layer**: Belief space stores cultural knowledge

| Knowledge Type | Content |
|----------------|---------|
| **Situational** | Best individuals from previous generation |
| **Normative** | Upper/lower bounds per dimension |


---
# 10. Swarm and Population-Based Optimization
{: style="color: #1B5E6F;"}

## 10.1 Swarm Intelligence

**Biological inspiration**: Social insects (ants, bees) and swarm animals (fish, birds).

**Key characteristics**:
- Simple individuals with limited skills
- Self-coordination without central control
- Information exchange through cooperation

## 10.2 Population-Based Incremental Learning (PBIL)

**Concept**: GA without explicit population—only store population statistics.

**Procedure**:
1. Initialize probability vector $P = (0.5, 0.5, \ldots, 0.5)$
2. Generate samples from $P$
3. Select best individuals
4. Update: $P_i = (1-\alpha) \cdot P_i + \alpha \cdot \text{best}_i$
5. Apply mutation to $P$

**Learning rate $\alpha$**:
- Low: emphasizes exploration
- High: emphasizes fine-tuning

## 10.3 Particle Swarm Optimization (PSO)

**Biological inspiration**: Fish or bird swarms foraging for food.

**Each particle has**:
- Position $x_i$ (candidate solution)
- Velocity $v_i$
- Personal best $p_{\text{best},i}$
- Global best $g_{\text{best}}$

**Update equations**:

$$v_i^{(t+1)} = w \cdot v_i^{(t)} + c_1 \cdot r_1 \cdot (p_{\text{best},i} - x_i^{(t)}) + c_2 \cdot r_2 \cdot (g_{\text{best}} - x_i^{(t)})$$

$$x_i^{(t+1)} = x_i^{(t)} + v_i^{(t+1)}$$

where:
- $w$ is inertia weight
- $c_1, c_2$ are cognitive and social coefficients
- $r_1, r_2 \sim U(0,1)$

**Extensions**:
- Local neighborhoods instead of global best
- Automatic parameter adjustment
- Diversity control mechanisms

## 10.4 Ant Colony Optimization (ACO)

**Biological inspiration**: Ants finding shortest paths using pheromones.

**Key principle**: **Stigmergy**—indirect communication through environment modification.

### The Double-Bridge Experiment

When nest and food are connected by two bridges of different lengths:
1. Initially, ants choose randomly
2. Ants on shorter bridge return faster
3. More pheromone accumulates on shorter path
4. Positive feedback leads to convergence on shortest route

### ACO Algorithm

**For TSP**:

1. **Construction**: Each ant builds a tour
   - At city $i$, choose next city $j$ with probability:
   
   $$P(j) = \frac{\tau_{ij}^\alpha \cdot \eta_{ij}^\beta}{\sum_{k} \tau_{ik}^\alpha \cdot \eta_{ik}^\beta}$$
   
   where $\tau_{ij}$ is pheromone and $\eta_{ij} = 1/d_{ij}$ is heuristic

2. **Pheromone Update**:
   - **Evaporation**: $\tau_{ij} \leftarrow (1-\rho) \cdot \tau_{ij}$
   - **Intensification**: Add pheromone proportional to solution quality

**Extensions**:
- Elitist strategies (only best solutions deposit pheromone)
- Min/max pheromone limits
- Local search improvements (2-opt, 3-opt)


---
# 11. Theoretical Foundations
{: style="color: #1B5E6F;"}

## 11.1 The Schema Theorem

**Goal**: Understand why GAs work by analyzing how schemata (partially specified chromosomes) propagate.

### Definitions

**Schema**: A string of length $l$ over alphabet $\{0, 1, *\}$ where $*$ is a wildcard.

Example: $h = 1*01*0**1$ matches any chromosome starting with 1, having 0 at position 3, 1 at position 4, etc.

**Order of schema** $o(h)$: Number of fixed positions (0s and 1s).

**Defining length** $\delta(h)$: Distance between first and last fixed position.

### Selection Effect

The expected number of chromosomes matching schema $h$ after selection:

$$E[m(h, t+1)] = m(h, t) \cdot \frac{\bar{f}(h)}{\bar{f}(t)}$$

where $\bar{f}(h)$ is average fitness of schema-matching chromosomes and $\bar{f}(t)$ is population average fitness.

### Crossover Effect

Probability of schema disruption by one-point crossover:

$$P_{\text{disrupt}} = p_c \cdot \frac{\delta(h)}{l-1}$$

### Mutation Effect

Probability of preserving schema match under bit-mutation:

$$P_{\text{survive}} = (1 - p_m)^{o(h)}$$

### The Schema Theorem

$$E[m(h, t+1)] \geq m(h, t) \cdot \frac{\bar{f}(h)}{\bar{f}(t)} \cdot \left[1 - p_c \cdot \frac{\delta(h)}{l-1}\right] \cdot (1 - p_m)^{o(h)}$$

**Interpretation**: Schemata with:
- Above-average fitness ($\bar{f}(h) > \bar{f}(t)$)
- Short defining length (small $\delta(h)$)
- Low order (small $o(h)$)

**breed exponentially**—these are called **building blocks**.

## 11.2 Building Block Hypothesis

**Hypothesis**: A GA explores $\Omega$ particularly well for schemata with:
- Good average fitness
- Low defining length
- Low order

These building blocks combine to form increasingly fit solutions.

**Note**: This form specifically applies to:
- Bit string representations
- Fitness-proportionate selection
- Binary mutation
- One-point crossover

## 11.3 The No Free Lunch Theorem

**Theorem**: For any two algorithms $a_1$ and $a_2$, averaged over all possible problems:

$$\sum_{f} P(d_m^y | f, m, a_1) = \sum_{f} P(d_m^y | f, m, a_2)$$

**Interpretation**:
- No algorithm is superior to all others on average
- If algorithm $a_1$ outperforms $a_2$ on some problems, it must underperform on others
- Every algorithm has its "niche" of problems where it excels

### Consequences

| Scenario | Implication |
|----------|-------------|
| **No prior knowledge** | Expected EA performance = any other method |
| **Prior knowledge exists** | Problem structure should guide algorithm choice |

**Practical insight**: Knowledge about problem structure should inform algorithm design and parameter selection.


---
# 12. Applications and Examples
{: style="color: #1B5E6F;"}

## 12.1 The n-Queens Problem

**Problem**: Place $n$ queens on an $n \times n$ chessboard such that no two queens threaten each other.

### EA Solution

**Encoding**: Chromosome of length $n$ where gene $i$ contains the column position of the queen in row $i$.

**Fitness**: Negated number of collisions (pairs of queens in same column/diagonal). Optimal: 0.

**Operators**:
- **Selection**: Tournament selection
- **Crossover**: One-point crossover
- **Mutation**: Random gene replacement

**C Implementation Structure**:
```c
typedef struct {
    int fitness;      // Number of collisions (negated)
    int cnt;          // Number of genes
    int genes[1];     // Queen positions
} IND;

typedef struct {
    int size;         // Population size
    IND **inds;       // Individuals
    IND **buf;        // Buffer for selection
    IND *best;        // Best individual
} POP;
```

## 12.2 The Traveling Salesperson Problem (TSP)

**Problem**: Find shortest Hamiltonian cycle visiting each city exactly once.

**Known**: NP-complete—no polynomial-time algorithm exists.

### Local Search Approach

**Operation**: 2-opt move—remove two edges and reconnect differently.

**Hill Climbing**:
- Accept only improving moves
- Gets stuck in local optima

**Simulated Annealing**:
- Accept worse moves with decreasing probability
- Can escape local optima
- Better chance of finding global optimum

### ACO Approach

1. Ants construct tours probabilistically based on pheromone and distance
2. Pheromone evaporates on all edges
3. Good tours deposit more pheromone
4. Iterative refinement converges to near-optimal solutions

## 12.3 Comparison of Methods

| Problem | EA | Local Search | Swarm Methods |
|---------|-----|--------------|---------------|
| n-Queens | ✓ Excellent | ✗ Poor | ○ Possible |
| TSP | ○ Good | ✓ Excellent (with SA) | ✓ Excellent (ACO) |
| Continuous Optimization | ✓ Good | ✓ Good (gradient) | ✓ Excellent (PSO) |
| Combinatorial | ✓ Excellent | ○ Moderate | ✓ Excellent |


---
# 13. Conclusion

## Key Takeaways

1. **Evolutionary Algorithms** provide a powerful, biologically-inspired framework for solving complex optimization problems that resist traditional methods.

2. **The Core Cycle**: Population → Evaluation → Selection → Variation → New Population

3. **Critical Design Decisions**:
   - Encoding choice affects epistasis and operator design
   - Selection pressure balances exploration vs. exploitation
   - Genetic operators must match the problem structure

4. **Theoretical Understanding**:
   - Schema Theorem explains building block propagation
   - No Free Lunch Theorem reminds us that problem knowledge is essential

5. **Extensions and Variants**:
   - Local search hybrids (Memetic Algorithms)
   - Swarm intelligence (PSO, ACO)
   - Estimation of Distribution Algorithms (PBIL)

## When to Use Evolutionary Algorithms

EAs are particularly valuable when:
- The search space is large and complex
- The objective function is non-differentiable or discontinuous
- Multiple local optima exist
- Problem-specific knowledge can guide the design
- Approximate solutions are acceptable

## Further Reading and Resources

- Holland, J.H. (1975). *Adaptation in Natural and Artificial Systems*
- Goldberg, D.E. (1989). *Genetic Algorithms in Search, Optimization, and Machine Learning*
- Eiben, A.E. & Smith, J.E. (2015). *Introduction to Evolutionary Computing*
- Recent journals: *Evolutionary Computation*, *IEEE Transactions on Evolutionary Computation*

---