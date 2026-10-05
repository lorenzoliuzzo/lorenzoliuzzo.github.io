---
collection: notes
title: "Probability Foundations"
date: 2026-10-03
excerpt: "The three axioms and what follows from them, conditional probability, independence and Bayes' theorem."
hook: "Everything in probability follows from three rules, and conditioning on what you learn is just rescaling inside the part that is still possible."
goals:
  - derive any probability identity from the three axioms
  - condition on an event and recognize when two events are independent
  - invert a conditional probability with Bayes' theorem, and see why the base rate matters
defines:
  - {id: probability-axioms, name: probability axioms, anchor: the-axioms}
  - {id: conditional-probability, name: conditional probability, anchor: conditional-probability-and-independence}
  - {id: independence, name: independence, anchor: conditional-probability-and-independence}
  - {id: bayes-theorem, name: "Bayes' theorem", anchor: total-probability-and-bayes}
read_time: true
tags:
  - Statistics
  - Probability
---

Statistics is probability run backwards. Probability starts from a known mechanism and asks what data it will produce; statistics starts from the data and asks which mechanism could have produced it. So before doing any inference we need the rules of the forward direction, and there are only a few of them. Proofs are in the [reference (PDF)]({{ '/assets/notes/statistics/statistics-reference/statistics-reference.pdf' | relative_url }}).

# The axioms

An **experiment** is any process whose outcome is uncertain. Its **sample space** $\Omega$ is the set of possible outcomes (finite for a die, countably infinite for "tosses until the first head", a continuum for a lifetime), and an **event** is a subset of it: the event occurs when the outcome lies in the subset. Events combine like sets, and two laws are worth knowing by heart, **De Morgan's laws** $(A\cup B)^c=A^c\cap B^c$ and $(A\cap B)^c=A^c\cup B^c$: "not (A or B)" means neither, "not (A and B)" means at least one fails. Draw $\Omega$ as a box and each event as a region (a Venn diagram) and every identity becomes visible.

We start from the set $\Omega$ and call any subset of it an event. A probability $P$ assigns a number to every event, subject to three conditions (Kolmogorov):

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

The union bound (also called Boole's inequality) is crude but it is the tool you reach for when the events overlap in ways you cannot compute, and it shows up in proofs about multiple testing later. The union rule extends to **inclusion–exclusion**: for three events, add the three single probabilities, subtract the three pairwise intersections, add back the triple intersection.

> A frequentist reads $P(A)$ as a long-run frequency, a Bayesian as a degree of belief. The axioms are the same for both. They disagree about the unknown parameter $\theta$ of a model: a fixed number, or a random quantity with a distribution.
{: .margin}

The axioms say nothing about what probability means, and the mathematics below does not depend on the reading. Nor do they fix the values: a coin with $P(\text{H})=p$ satisfies all three for every $p$. The values come from outside, in one of three ways.

- **Symmetry.** If the $N$ outcomes are equally likely, each has probability $1/N$ and $P(A)=N(A)/N$, so probability becomes counting (product rule, permutations, combinations). The chance a 5-card hand has no ace is $\binom{48}{5}/\binom{52}{5}\approx 0.66$.
- **Long-run frequency.** If $A$ occurs $n(A)$ times in $n$ independent repetitions, the ratio $n(A)/n$ fluctuates for small $n$ and then stabilizes; the objective interpretation calls the limit $P(A)$. The law of large numbers makes this precise, but the limit is never observed and the idea needs a repeatable experiment.
- **Belief.** The subjective reading lets different people with different information assign different values, and covers one-off events such as an election.

# Conditional probability and independence

Suppose we learn that $B$ happened. Only the outcomes inside $B$ are still possible, so we restrict attention to $B$ and rescale so that its total probability is one again:

$$ P(A\mid B)=\frac{P(A\cap B)}{P(B)},\qquad P(B)>0. $$

For instance, a plant makes components on two lines; of 18 components, line $A$ has 2 defective and 6 good, line $A'$ has 1 defective and 9 good. A random component is defective with probability $3/18$, but once we learn it is defective it is one of the 3 defectives, and $P(A\mid\text{defective})=2/3$ against $P(A)=8/18$. Read the other way round, this is the multiplication rule $P(A\cap B)=P(A\mid B)\,P(B)$, and chaining it gives the way joint probabilities are usually built up one factor at a time:

$$ P(A_1\cap\dots\cap A_n)=P(A_1)\,P(A_2\mid A_1)\cdots P(A_n\mid A_1\cap\dots\cap A_{n-1}). $$

Two events are **independent** when learning one tells us nothing about the other, that is $P(A\cap B)=P(A)\,P(B)$, or equivalently $P(A\mid B)=P(A)$. The definition looks asymmetric but is not: $P(B\mid A)=P(A\mid B)P(B)/P(A)$, which equals $P(B)$ exactly when $P(A\mid B)=P(A)$. If supplier 1's batch passes inspection with probability 0.8, supplier 2's with 0.9, and the two are independent, both pass with probability $0.8\cdot0.9=0.72$.

> **Independent is not the same as disjoint.** If $A$ and $B$ are disjoint and both possible, knowing that $A$ occurred tells us for certain that $B$ did not, which is as strong a dependence as there is. And for more than two events, independence means the product rule holds for every sub-collection: pairwise independence alone is strictly weaker.
{: .trap}

## Total probability and Bayes

Often the conditional probabilities are easy to specify while the overall probability is not. If $B_1,\dots,B_k$ partition $\Omega$ (they are disjoint and cover it, each with positive probability), we can split any event along the partition:

$$ P(A)=\sum_{i} P(A\mid B_i)\,P(B_i). $$

Now write $P(A\cap B_j)$ in the two possible ways, $P(A\mid B_j)P(B_j)=P(B_j\mid A)P(A)$, and replace $P(A)$ with the sum above. This is **Bayes' theorem**:

$$ P(B_j\mid A)=\frac{P(A\mid B_j)\,P(B_j)}{\sum_i P(A\mid B_i)\,P(B_i)}. $$

It is best read as an update. The **prior** $P(B_j)$ is what we believed before seeing $A$, the **likelihood** $P(A\mid B_j)$ says how well $B_j$ explains $A$, the denominator is the **evidence**, and the result is the **posterior**. What the theorem does is turn "how probable is the data if the hypothesis is true" into "how probable is the hypothesis given the data", and these two are easily mistaken for each other.

The standard illustration is a medical test. Say a disease has prevalence 1%, and the test is positive for 95% of the sick and also, wrongly, for 10% of the healthy. Given a positive result,

$$ P(D\mid +)=\frac{0.95\cdot 0.01}{0.95\cdot 0.01+0.10\cdot 0.99}\approx 0.088. $$

The figure shows why it comes out so low: count people instead of probabilities.

A sharper case: prevalence 1 in 1000, sensitivity 99%, false-positive rate 2%, gives $P(D\mid +)=0.00099/0.02097\approx0.047$. Total probability and Bayes also handle more than two causes. If brands 1, 2, 3 of a product hold 50%, 30%, 20% of sales and need warranty repair 25%, 20%, 10% of the time, then $P(\text{repair})=0.125+0.06+0.02=0.205$, and a returned machine is brand 1 with probability $0.125/0.205\approx0.61$, above its 50% share because it fails most.

{% include fig.html src="statistics/bayes-frequencies" id="fig-bayes" alt="Two bars of people drawn to the same scale. Of 1000 people, 10 are sick. Of the 108.5 who test positive, 9.5 are sick and 99 are healthy." caption="The same test, counted in people. The sick are a thin sliver of the population, so the 10% of healthy people who test positive outnumber the true cases about ten to one." %}

> A positive result from a 95% accurate test still leaves you under 9% likely to be sick. The sick are rare, so even a small false-positive rate on the huge healthy group produces more positives than the true cases do. When a result looks surprisingly weak, check whether the prior was ignored.
{: .idea}

# Recap

Answer before you open each one.

<details class="qa" markdown="1">
<summary>Why can an accurate test still give a low probability of disease?</summary>

The posterior depends on the prior as well as the likelihood. With a rare condition the prior is tiny, so false positives from the large healthy group swamp the true positives.
</details>

<details class="qa" markdown="1">
<summary>Are disjoint events independent?</summary>

No, the opposite. If both can happen, learning that one occurred rules the other out.
</details>

<details class="qa" markdown="1">
<summary>You know $P(A\mid B)$ and want $P(B\mid A)$. What else do you need?</summary>

The prior $P(B)$ and the total probability of $A$, which comes from splitting along a partition. Without the prior the inversion is undetermined.
</details>
