---
collection: notes
title: "Probability Foundations"
date: 2026-10-03
excerpt: "Sample spaces and events, the three axioms and what follows from them, conditional probability, independence and Bayes' theorem."
read_time: true
tags:
  - Statistics
  - Probability
---

Statistics is probability run backwards: probability starts from a known mechanism and asks what data it produces, statistics starts from data and asks what mechanism produced it. This note builds the first half of the probability side from the axioms up: events, the three rules everything else follows from, and conditioning. It is the first of three; the next, [Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}), turns outcomes into numbers.

The full statements and proofs for this note are in the [technical reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}), which covers all the statistics notes in one document. This page explains; the PDF is the thing to check a formula against.

# Sample space and events

A random experiment has a **sample space** $\Omega$, the set of all possible outcomes. An **event** is a subset $A\subseteq\Omega$ ("the outcome lies in $A$"). Events combine like sets:

- $A\cup B$: $A$ or $B$ (or both) occurs; $A\cap B$: both occur; $A^c$: $A$ does not occur.
- $A$ and $B$ are **mutually exclusive** (disjoint) if $A\cap B=\varnothing$.
- Events $B_1,B_2,\dots$ form a **partition** of $\Omega$ if they are disjoint and $\cup_i B_i=\Omega$: exactly one of them happens.

Rolling a die: $\Omega=\{1,\dots,6\}$, "even" is $A=\{2,4,6\}$, and $\{1,2,3\},\{4,5,6\}$ is a partition.

# The axioms

A **probability** $P$ assigns a number to every event so that (Kolmogorov, 1933):

1. $P(A)\ge 0$ for every event $A$;
2. $P(\Omega)=1$;
3. for pairwise disjoint events $A_1,A_2,\dots$: $\;P\big(\bigcup_i A_i\big)=\sum_i P(A_i)$ (countable additivity).

That is the whole theory. Everything else is derived.

## Consequences

Each of these follows from the three axioms in a line or two (the proofs are in the technical reference).

| Rule | Why |
|---|---|
| $P(\varnothing)=0$ | Axiom 3 applied to infinitely many empty sets |
| $P(A^c)=1-P(A)$ | $A$ and $A^c$ are disjoint and their union is $\Omega$ |
| If $A\subseteq B$ then $P(A)\le P(B)$ | $B=A\cup(B\setminus A)$, a disjoint union |
| $0\le P(A)\le 1$ | monotonicity with $B=\Omega$ |
| $P(A\cup B)=P(A)+P(B)-P(A\cap B)$ | adding $P(A)+P(B)$ counts $A\cap B$ twice |
| $P(\cup_i A_i)\le\sum_i P(A_i)$ | the **union bound**: overlaps are counted several times |

The union rule generalizes to **inclusion–exclusion**: add the single probabilities, subtract the pairwise intersections, add the triple intersections, and so on. When the outcomes are equally likely, probability reduces to counting, $P(A)=\lvert A\rvert/\lvert\Omega\rvert$, which is where permutations and the binomial coefficient $\binom nk$ enter.

A word on meaning. The axioms do not say what probability *is*. In the **frequentist** reading, $P(A)$ is the long-run relative frequency of $A$ in repeated trials. In the **Bayesian** reading it is a degree of belief, updated as data arrive. The mathematics is the same; the two schools differ in what they allow $\theta$ (an unknown parameter) to be: a fixed number, or a random quantity with its own distribution.

# Conditional probability and independence

The probability of $A$ once we know $B$ happened (with $P(B)>0$) is

$$ P(A\mid B)=\frac{P(A\cap B)}{P(B)} . $$

Conditioning shrinks the sample space to $B$ and renormalizes. Rearranged, it is the **multiplication rule** $P(A\cap B)=P(A\mid B)\,P(B)$, and chaining it gives $P(A_1\cap\dots\cap A_n)=P(A_1)\,P(A_2\mid A_1)\cdots P(A_n\mid A_1\cap\dots\cap A_{n-1})$.

$A$ and $B$ are **independent** if knowing one tells nothing about the other:

$$ P(A\cap B)=P(A)\,P(B)\quad\Longleftrightarrow\quad P(A\mid B)=P(A). $$

Two traps. **Independent is not the same as mutually exclusive**: if $A$ and $B$ are disjoint and both possible, knowing $A$ happened tells you $B$ did not, so they are strongly dependent. And **pairwise independence is weaker than mutual independence**: for several events we need the product rule for every sub-collection, not just every pair.

## Law of total probability and Bayes' theorem

If $B_1,\dots,B_k$ partition $\Omega$ and each has positive probability, then splitting an event over the partition gives the **law of total probability**,

$$ P(A)=\sum_{i=1}^k P(A\mid B_i)\,P(B_i). $$

Writing $P(A\cap B_j)$ in the two possible ways, $P(A\mid B_j)P(B_j)=P(B_j\mid A)P(A)$, and substituting the law above for $P(A)$ gives **Bayes' theorem**:

$$ P(B_j\mid A)=\frac{P(A\mid B_j)\,P(B_j)}{\sum_{i}P(A\mid B_i)\,P(B_i)} . $$

Read it as an update rule. $P(B_j)$ is the **prior** (belief before seeing $A$), $P(A\mid B_j)$ the **likelihood** (how well $B_j$ explains $A$), the denominator $P(A)$ the **evidence**, and $P(B_j\mid A)$ the **posterior**. Bayes' theorem turns "probability of the data given the hypothesis" into "probability of the hypothesis given the data", which is what we actually want, and it is not the same thing.

**Worked example.** A disease affects 1% of a population. A test is positive for 95% of the sick (sensitivity) and also for 10% of the healthy (false-positive rate). Given a positive result, what is the chance of being sick? With $D$ for disease and $+$ for a positive test,

$$ P(D\mid +)=\frac{0.95\cdot 0.01}{0.95\cdot 0.01+0.10\cdot 0.99}=\frac{0.0095}{0.1085}\approx 0.088 . $$

Only about 9%, despite a "95% accurate" test: healthy people are so numerous that their false positives outnumber the true ones. Forgetting the prior (the **base rate**) is the classic error in reading tests.

# Vocabulary

The probability terms used here and in the notes that follow.

| Term | Meaning |
|---|---|
| **Sample space / event** | All possible outcomes / a set of outcomes |
| **Mutually exclusive** | Events that cannot occur together, $A\cap B=\varnothing$ |
| **Partition** | Disjoint events that together cover the sample space |
| **Conditional probability** | $P(A\mid B)=P(A\cap B)/P(B)$ |
| **Independent** | $P(A\cap B)=P(A)P(B)$: knowing one tells nothing about the other |
| **Prior / likelihood / posterior / evidence** | The four pieces of Bayes' theorem: belief before, how well the hypothesis explains the data, belief after, total probability of the data |

# Recap

The note in a handful of questions.

**What do the probability axioms say?** Probabilities are non-negative, the whole sample space has probability 1, and probabilities of disjoint events add. Everything else follows, for example $P(A^c)=1-P(A)$, monotonicity, and $P(A\cup B)=P(A)+P(B)-P(A\cap B)$.

**What is Bayes' theorem for?** It reverses a conditional: $P(B\mid A)=P(A\mid B)P(B)/P(A)$, with $P(A)$ from the law of total probability. It turns prior belief and a likelihood into a posterior, and it is the reason a positive result from an accurate test can still mean a low chance of disease when the condition is rare.

# Where this goes next

[Random variables]({{ '/notes/statistics/random-variables/' | relative_url }}) attaches numbers to outcomes and builds expectation, variance, covariance and the limit theorems on top of what is here. Everything in the notes on [estimation]({{ '/notes/statistics/point-estimation/' | relative_url }}), [intervals]({{ '/notes/statistics/confidence-intervals/' | relative_url }}) and [tests]({{ '/notes/statistics/hypothesis-tests/' | relative_url }}) rests on these rules, in particular Bayes' theorem for the Bayesian reading of a parameter.
