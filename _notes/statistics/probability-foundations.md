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

Statistics is probability run backwards. Probability starts from a known mechanism and asks what data it will produce; statistics starts from the data and asks which mechanism could have produced it. So before doing any inference we need the rules of the forward direction, and there are only a few of them. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# The axioms

We start from a set $\Omega$ of possible outcomes and call any subset of it an event. A probability $P$ assigns a number to every event, subject to three conditions (Kolmogorov):

1. $P(A)\ge 0$;
2. $P(\Omega)=1$;
3. $P\big(\bigcup_i A_i\big)=\sum_i P(A_i)$ whenever the $A_i$ are pairwise disjoint.

That really is all of it. Every other rule is a short consequence of these three, and the handful below are the ones that keep coming back.

| Rule | Why it holds |
|---|---|
| $P(A^c)=1-P(A)$ | $A$ and $A^c$ are disjoint and together make up $\Omega$ |
| $A\subseteq B\Rightarrow P(A)\le P(B)$ | $B$ is $A$ plus the disjoint piece $B\setminus A$ |
| $P(A\cup B)=P(A)+P(B)-P(A\cap B)$ | adding $P(A)+P(B)$ counts $A\cap B$ twice |
| $P(\cup_i A_i)\le\sum_i P(A_i)$ | the **union bound**: overlaps are counted more than once |

The union bound is crude but it is the tool you reach for when the events overlap in ways you cannot compute, and it shows up in proofs about multiple testing later.

The axioms say nothing about what probability means. A frequentist reads $P(A)$ as the long-run frequency of $A$ over repeated trials. A Bayesian reads it as a degree of belief that gets updated as data arrive. The mathematics is identical; the real disagreement is about the unknown parameter $\theta$ of a model, which the frequentist treats as a fixed number and the Bayesian as a random quantity with its own distribution.

# Conditional probability and independence

Suppose we learn that $B$ happened. Only the outcomes inside $B$ are still possible, so we restrict attention to $B$ and rescale so that its total probability is one again:

$$ P(A\mid B)=\frac{P(A\cap B)}{P(B)},\qquad P(B)>0. $$

Read the other way round, this is the multiplication rule $P(A\cap B)=P(A\mid B)\,P(B)$, and chaining it gives the way joint probabilities are usually built up one factor at a time:

$$ P(A_1\cap\dots\cap A_n)=P(A_1)\,P(A_2\mid A_1)\cdots P(A_n\mid A_1\cap\dots\cap A_{n-1}). $$

Two events are **independent** when learning one tells us nothing about the other, that is $P(A\cap B)=P(A)\,P(B)$, or equivalently $P(A\mid B)=P(A)$. Two mistakes are common here. The first is to confuse independent with mutually exclusive: if $A$ and $B$ are disjoint and both possible, then knowing $A$ occurred tells us for certain that $B$ did not, which is as strong a dependence as there is. The second is to stop at pairs. For several events, independence means the product rule holds for every sub-collection, and pairwise independence alone is strictly weaker.

## Total probability and Bayes

Often the conditional probabilities are easy to specify while the overall probability is not. If $B_1,\dots,B_k$ partition $\Omega$ (they are disjoint and cover it, each with positive probability), we can split any event along the partition:

$$ P(A)=\sum_{i} P(A\mid B_i)\,P(B_i). $$

Now write $P(A\cap B_j)$ in the two possible ways, $P(A\mid B_j)P(B_j)=P(B_j\mid A)P(A)$, and replace $P(A)$ with the sum above. This is **Bayes' theorem**:

$$ P(B_j\mid A)=\frac{P(A\mid B_j)\,P(B_j)}{\sum_i P(A\mid B_i)\,P(B_i)}. $$

It is best read as an update. The **prior** $P(B_j)$ is what we believed before seeing $A$, the **likelihood** $P(A\mid B_j)$ says how well $B_j$ explains $A$, the denominator is the **evidence**, and the result is the **posterior**. What the theorem does is turn "how probable is the data if the hypothesis is true" into "how probable is the hypothesis given the data", and these two are easily mistaken for each other.

The standard illustration is a medical test. Say a disease has prevalence 1%, and the test is positive for 95% of the sick and also, wrongly, for 10% of the healthy. Given a positive result,

$$ P(D\mid +)=\frac{0.95\cdot 0.01}{0.95\cdot 0.01+0.10\cdot 0.99}\approx 0.088. $$

The probability of being sick is under 9%, not 95%. The sick are rare, so even a small false-positive rate applied to the huge healthy group produces more positives than the true cases do. Whenever a result looks surprisingly weak, check whether the prior was ignored.

# Recap

**Why can an accurate test still give a low probability of disease?** Because the posterior depends on the prior as well as the likelihood. With a rare condition the prior is tiny, so false positives from the large healthy group swamp the true positives.

**Are disjoint events independent?** No, the opposite. If both can happen, learning that one occurred rules the other out.
