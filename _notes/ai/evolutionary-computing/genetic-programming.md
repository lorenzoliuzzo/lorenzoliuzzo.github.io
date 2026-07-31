---
collection: notes
title: "Genetic Programming"
date: 2026-07-31
excerpt: ""
order: 4
tags:
  - Artificial Intelligence
  - Evolutionary Computing
---


Genetic Programming (GP) extends the EA framework to evolve computer programs rather than fixed-length vectors. A candidate solution is a complete program: a function that maps inputs to outputs. GP searches for the program that best fits a target specification.

## Representation

Programs are represented as **parse trees**. Two disjoint sets define the language:

- **Function set $\mathcal{F}$**: operators and control structures (e.g. $\{+, -, \times, /, \sin, \cos, \log, \text{if-then-else}\}$).
- **Terminal set $\mathcal{T}$**: variables and constants (e.g. $\{x_1, \ldots, x_m\} \cup \mathbb{R}$).

A **symbolic expression** is defined recursively: every element of $\mathcal{T}$ is a symbolic expression, and if $t_1, \ldots, t_n$ are symbolic expressions and $f \in \mathcal{F}$ is $n$-ary, then $f(t_1, \ldots, t_n)$ is a symbolic expression. The Lisp-style notation $(+ \;(*\;3\;x)\;(/\;8\;2))$ encodes $3x + \frac{8}{2}$.

The sets $\mathcal{F}$ and $\mathcal{T}$ must be **complete**: every combination of operators and terminals must produce a well-defined value (e.g. protected division that returns $1$ when dividing by zero). Finding the smallest complete sufficient set is in general NP-hard.

## Initialisation

Three standard strategies generate the initial population, parameterised by a maximum tree depth $d_{\max}$:

**Full**: at every depth $d < d_{\max}$, draw nodes from $\mathcal{F}$; at depth $d = d_{\max}$, draw from $\mathcal{T}$. All leaf nodes are exactly at depth $d_{\max}$; every tree is maximally bushy.

**Grow**: at every internal node, draw from $\mathcal{F} \cup \mathcal{T}$; force a terminal if $d = d_{\max}$. Trees have variable depth and shape, some much shallower than $d_{\max}$.

**Ramped-half-and-half**: the recommended default. For each depth $i$ from $1$ to $d_{\max}$, generate $\mu / (2 \cdot d_{\max})$ full trees and $\mu / (2 \cdot d_{\max})$ grow trees. This ensures diverse tree sizes and shapes at the start of the run.

## Genetic Operators

**Crossover** in GP exchanges subtrees between two parents: a random node is selected in each parent, and the subtrees rooted at those nodes are swapped. The result is two offspring of (generally) different sizes and shapes. This is the primary operator in GP — it can transfer large subprograms between individuals and is analogous to modular code reuse.

**Mutation** replaces a randomly selected subtree with a newly generated random tree (using the grow or full method). It introduces genuinely new structure that crossover alone cannot create.

**Clonal reproduction** copies an individual unchanged into the next generation, playing the role of global elitism.

## Bloat and Introns

A well-known problem in GP is **bloat**: trees grow steadily larger across generations without corresponding fitness gains. This mirrors the biological concept of **introns** — stretches of DNA that carry no functional information. An expression like $x + 0 - 0$ contains introns that crossover may preserve and extend.

Three strategies counter bloat:

- **Breeding with selection**: generate many offspring from each crossover and keep only the best, directly penalising unnecessary size.
- **Selective crossover points**: choose crossover points that are more likely to exchange functionally meaningful subtrees.
- **Editing (algebraic simplification)**: apply constant folding and algebraic identities (e.g. $x + 0 \to x$, $x \times 1 \to x$) to simplify trees after crossover. Editing reduces tree size but may discard subtrees that could become active under a future change to the fitness function.

## Fitness Evaluation

The fitness function must measure how well a program solves the target problem. Two representative cases:

**Boolean function learning.** The fitness of a program is the number of correct outputs over all $2^m$ input combinations, or equivalently $2^m$ minus the total error $\sum_i e_i$.

**Symbolic regression.** Given $n$ data points $\\{(x_k, y_k)\\}$, the fitness is typically the negative sum of squared errors: $f(s) = -\sum_k (s(x_k) - y_k)^2$.

> An 11-input multiplexer (3 address lines, 8 data lines, $2^{11} = 2048$ input combinations) was solved by GP in 9 generations. The resulting parse tree with fitness 2048 (perfect) is too complex for direct human interpretation but can be reduced by editing to a human-readable form.

> Robot wall-following: GP evolved a control program mapping 8 proximity sensors to 4 motion actions. No memory was available to the program; it had to compute the correct action purely from the current sensor state. Over 10 generations the evolved behaviour progressively improved from erratic movement to near-complete wall following, converging on a program functionally close to (though structurally different from) the manually designed optimal solution.
