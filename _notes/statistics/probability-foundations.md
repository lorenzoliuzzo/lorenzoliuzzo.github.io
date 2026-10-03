---
collection: notes
title: "Probability Foundations"
date: 2026-10-03
excerpt: "The three axioms and what follows from them, conditional probability, independence and Bayes' theorem."
read_time: true
tags:
  - Statistics
  - Probability
---

Statistics is probability run backwards: probability goes from a known mechanism to the data it produces, statistics from data to the mechanism. This note fixes the rules everything else uses. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# The axioms

$\Omega$ is the set of outcomes and an event is a subset of it. A probability $P$ on events satisfies (Kolmogorov):

1. $P(A)\ge 0$;
2. $P(\Omega)=1$;
3. $P\big(\bigcup_i A_i\big)=\sum_i P(A_i)$ for pairwise disjoint $A_1,A_2,\dots$

Everything else is derived. The consequences worth having at hand:

| Rule | Why |
|---|---|
| $P(A^c)=1-P(A)$ | $A,A^c$ are disjoint with union $\Omega$ |
| $A\subseteq B\Rightarrow P(A)\le P(B)$ | $B=A\cup(B\setminus A)$, disjoint |
| $P(A\cup B)=P(A)+P(B)-P(A\cap B)$ | $A\cap B$ is counted twice in the sum |
| $P(\cup_i A_i)\le\sum_i P(A_i)$ | **union bound**: overlaps are counted several times |

The axioms do not say what probability *is*. Frequentists read $P(A)$ as a long-run frequency, Bayesians as a degree of belief. The maths is the same; the schools differ on whether an unknown parameter $\theta$ is a fixed number or a random quantity with a distribution.

# Conditional probability and independence

$$ P(A\mid B)=\frac{P(A\cap B)}{P(B)},\qquad P(B)>0. $$

Conditioning restricts the sample space to $B$ and renormalizes. Rearranged it is the **multiplication rule** $P(A\cap B)=P(A\mid B)P(B)$, which chains: $P(A_1\cap\dots\cap A_n)=P(A_1)P(A_2\mid A_1)\cdots P(A_n\mid A_1\cap\dots\cap A_{n-1})$.

$A$ and $B$ are **independent** when $P(A\cap B)=P(A)P(B)$, equivalently $P(A\mid B)=P(A)$. Two traps:

- **Independent is not mutually exclusive.** Disjoint events with positive probability are strongly dependent: if $A$ happened, $B$ did not.
- **Pairwise independence is weaker than mutual independence.** The product rule must hold for every sub-collection, not just every pair.

## Total probability and Bayes

If $B_1,\dots,B_k$ partition $\Omega$ (disjoint, union $\Omega$, positive probability),

$$ P(A)=\sum_{i} P(A\mid B_i)P(B_i),\qquad P(B_j\mid A)=\frac{P(A\mid B_j)\,P(B_j)}{\sum_i P(A\mid B_i)\,P(B_i)}. $$

The second is **Bayes' theorem**: write $P(A\cap B_j)$ both ways and use the first for $P(A)$. Read it as an update: **prior** $P(B_j)$, times **likelihood** $P(A\mid B_j)$, divided by the **evidence** $P(A)$, gives the **posterior** $P(B_j\mid A)$. It converts "probability of the data given the hypothesis" into "probability of the hypothesis given the data", and the two are not equal.

**Base-rate example.** Disease prevalence 1%, test positive for 95% of the sick and 10% of the healthy:

$$ P(D\mid +)=\frac{0.95\cdot 0.01}{0.95\cdot 0.01+0.10\cdot 0.99}\approx 0.088 . $$

About 9%, not 95%: the healthy are so numerous that their false positives outnumber the true ones. Ignoring the prior is the classic error in reading tests.

# Recap

**What does Bayes' theorem do, and why can an accurate test still give a low posterior?** It reverses a conditional, $P(B\mid A)=P(A\mid B)P(B)/P(A)$, with $P(A)$ from total probability. When the condition is rare the prior is small, so even a high likelihood gives a small posterior.

**Are disjoint events independent?** No, the opposite: if both are possible, learning one occurred rules the other out.
