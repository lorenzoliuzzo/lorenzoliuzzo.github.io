---
collection: notes
title: "Introduction to Evolutionary Computing"
date: 2026-07-31
order: 1
tags: 
  - Artificial Intelligence
  - Evolutionary Computing
---

**Evolutionary Algorithms (EAs)** are a family of computational intelligence techniques inspired by the principles of biological evolution. These algorithms solve complex optimization and search problems by mimicking natural selection, where solutions evolve over generations toward better fitness.

## The Optimization Problem

An **optimization problem** is formally defined by:

- A **search space** $\Omega$ containing all candidate solutions
- An **evaluation function** $f: \Omega \rightarrow \mathbb{R}$ that assigns quality assessments
- A **comparison relation** (typically $<$ or $>$)

The **set of global optima** is:

$$\Omega^* = \\{ \omega \in \Omega \mid f(\omega) \text{ is optimal in } \Omega \\}$$

**Given**: An optimization problem $(\Omega, f, <)$  
**Wanted**: An element $\omega^* \in \Omega^*$ that optimizes $f$ across the entire search space

Traditional optimization approaches face significant limitations:

| Approach | Strengths | Limitations |
| -------- | --------- | ----------- |
| **Analytical Solutions** | Exact, efficient | Rarely applicable to real-world problems |
| **Exhaustive Search** | Guarantees optimal solution | Only feasible for very small search spaces |
| **Random Search** | Always applicable | Mostly inefficient, no guidance |
| **Guided Search** | Efficient when applicable | Requires smooth fitness landscapes |

## The Evolutionary Advantage

EAs embody a powerful problem-solving philosophy, borrowed from Darwinian evolution:

> *"Beneficial traits resulting from random variation are favored by natural selection. Better-adapted individuals have enhanced chances of procreation and multiplication."*

The fundamental premise is elegantly simple yet powerful: maintain a population of candidate solutions, evaluate their quality using a fitness function, and apply operators inspired by genetics (selection, mutation, crossover) to produce progressively better solutions.

This principle, enables EAs to explore vast solution spaces efficiently while exploiting promising regions.
Furthermore, EAs can handle:

- Non-differentiable objective functions
- Discontinuous search spaces
- Multiple local optima
- High-dimensional problems
- Problems with complex constraints

## Core Evolutionary Principles
{: style="color: #4A7C59;"}
Understanding EAs requires appreciating their biological inspiration. Natural evolution operates through several fundamental principles:

### **Diversity**
{: style="color: #C78D3F;"}

All life forms differ from each other, even within the same species. This genetic diversity provides the raw material for evolution. The currently existing life forms represent only a tiny fraction of all theoretically possible configurations.

### **Variation**
{: style="color: #C78D3F;"}

New variants are continuously created through:
- **Mutation**: Random changes in genetic material
- **Genetic Recombination**: Mixing of genetic material during sexual reproduction

### **Inheritance**
{: style="color: #C78D3F;"}

Variations are heritable when they enter the germ line and are passed to offspring. Importantly, **acquired traits are generally not inherited** (contrary to Lamarckism).

### **Natural Selection / Differential Reproduction**
{: style="color: #C78D3F;"}

On average, hereditary variations of survivors increase adaptation to the local environment. Rather than "survival of the fittest," evolution favors **"different fitness → different reproduction."**

### **Randomness (Blind Variation)**
{: style="color: #C78D3F;"}

Variations are triggered by random processes—there is no concentration on certain traits or beneficial adaptations. Evolution is **non-teleological** (goal-less).

### **Gradualism**
{: style="color: #C78D3F;"}

Variations occur in comparatively small steps. Phylogenetic changes are gradual and relatively slow.


### Additional Biological Concepts
{: style="color: #C78D3F;"}

| Concept | Description |
|---------|-------------|
| **Discrete Genetic Units** | Genetic information is stored, transferred, and changed in discrete units (genes), preventing the "Jenkins nightmare" where differences would blend away |
| **Opportunism** | Evolution works exclusively on what is present; optimal solutions may not be found if intermediate stages have fitness handicaps |
| **Ecological Niches** | Competitive species can coexist by occupying different niches, enabling biological diversity |
| **Irreversibility** | The course of evolution is irreversible and unrepeatable |
| **Unpredictability** | Evolution is neither determined, programmed, nor predictable |
| **Increasing Complexity** | Biological evolution tends toward increasing complexity over time |

## Core Components of Evolutionary Algorithms
{: style="color: #1B5E6F;"}

EAs implement a sophisticated form of guided search where:

- **Similar genotypes** should produce **similar phenotypes**
- **Similar candidate solutions** should have **similar fitness values**
- The search space should be **closed under genetic operators**

Every evolutionary algorithm requires:

| Component | Purpose |
|-----------|---------|
| **Encoding** | Representation of solution candidates (highly problem-specific) |
| **Initial Population** | Method to create starting solutions (commonly random) |
| **Fitness Function** | Evaluates quality of individuals (represents the environment) |
| **Selection Method** | Chooses parents for offspring creation |
| **Genetic Operators** | Mutation and crossover for creating variation |
| **Parameters** | Population size, mutation probability, etc. |
| **Termination Criterion** | Stopping condition (e.g., max generations) |

### The Generic Evolutionary Algorithm
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
