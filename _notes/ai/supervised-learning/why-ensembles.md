---
collection: notes
title: "Why Combine Learners"
date: 2026-10-04
excerpt: "Why a committee of weak learners can be far more accurate than any member, how fast the error of a majority vote falls, and why diversity is the hard part."
hook: "Independent errors cancel, so a majority of weak learners can be arbitrarily accurate, and the design problem becomes making the learners different, not individually perfect."
goals:
  - state how fast the error of a majority vote falls with the number of independent classifiers
  - tell homogeneous from heterogeneous and sequential from parallel ensembles
  - explain why an ensemble needs diversity as well as accuracy
requires:
  - generalization-error
  - binomial
  - independence
defines:
  - {id: ensemble, name: ensemble, anchor: committees-of-learners}
  - {id: base-learner, name: base learner, anchor: committees-of-learners}
  - {id: weak-learner, name: weak learner, anchor: committees-of-learners}
  - {id: ensemble-diversity, name: ensemble diversity, anchor: diversity-is-the-hard-part}
read_time: true
tags:
  - Supervised Learning
  - Ensembles
---

A single learner has one chance to be right. An ensemble trains several and combines their answers, and the combination is often much more accurate than any of its members. This note shows why, and what it asks of the members.

# Committees of learners

**Ensemble methods** train multiple learners to solve the same problem and combine them, instead of building one learner from the training data. The learners are called **base learners** (or individual or component learners), and each is produced by a base learning algorithm such as a decision tree or a neural network. If all base learners come from the same algorithm the ensemble is **homogeneous**, and if several algorithms are used it is **heterogeneous**.

The attraction is that ensembles can boost **weak learners**, only slightly better than random guessing, into a **strong learner** whose predictions are very accurate. That is why base learners are often called weak learners. Three lines of work led to the field: combining classifiers in pattern recognition, ensembles of weak learners in machine learning, and mixtures of experts in neural networks.

# Why independence helps

Take binary classification with labels in $\lbrace+1,-1\rbrace$ and $T$ base classifiers that are each wrong with probability $\epsilon<\tfrac12$, independently of one another. Combine them by majority vote, $H(x)=\operatorname{sign}\big(\sum_{t=1}^{T}h_t(x)\big)$. The ensemble is wrong only if at least half of the base classifiers are, so by Hoeffding's inequality

{% include equation.html tex="P\big(H(x)\ne f(x)\big)=\sum_{k=0}^{\lfloor T/2\rfloor}\binom{T}{k}(1-\epsilon)^{k}\epsilon^{T-k}\ \le\ \exp\!\Big(-\tfrac12\,T\,(1-2\epsilon)^2\Big) ." %}

The error of the vote falls exponentially in $T$ and tends to zero. Figure [](#fig-vote) shows it on a logarithmic scale, where an exponential is a straight line.

{% include fig.html src="supervised-learning/majority-vote" id="fig-vote" alt="Error of a majority vote against the number of classifiers T from 1 to 101 on a logarithmic axis, for individual error 0.3 and 0.4. Each pair of curves, exact and bound, falls roughly linearly. The curves for 0.3 fall to about one in a hundred thousand at T equal to 101, the curves for 0.4 only to about two in a hundred." caption="Majority-vote error against the number of independent classifiers, exact (solid) and by Hoeffding's bound (dashed). The decay is exponential, and much slower when the individual error is close to ½." %}

With $\epsilon=0.3$, 21 classifiers already bring the error from 0.30 down to 0.026, and 101 bring it to $10^{-5}$. With $\epsilon=0.4$ it is still 0.021 at $T=101$: the closer the base learners are to coin flips, the more of them are needed.

# Diversity is the hard part

The proof assumed *independent* errors, and learners trained on the same data are never independent. In practice the real error falls more slowly than the formula says, and the work of ensemble design goes into making the learners as different as possible without making each of them poor. Accuracy and **diversity** pull against each other: two perfect classifiers are identical, so the more accurate the members are, the less room they have to disagree.

How the base learners are generated gives two families:

- **Sequential** ensembles generate learners one after another, each depending on the earlier ones (boosting). The dependence is used on purpose, to reduce the residual error step by step.
- **Parallel** ensembles generate learners independently (bagging, random forests), injecting randomness into the data or the features so that the errors decorrelate. They exploit independence directly, and since the learners do not depend on each other they train in parallel on multi-core machines.

> More learners help only while they keep making different mistakes. Adding a hundred copies of the same classifier changes nothing, which is why every method in this part is at heart a way of generating diversity.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why does a majority vote of weak classifiers become strong?</summary>

If their errors are independent, the vote is wrong only when about half of them are wrong at once, and that probability falls exponentially with their number, as long as each is better than a coin flip.
</details>

<details class="qa" markdown="1">
<summary>What goes wrong when the base learners are trained on the same data?</summary>

Their errors are correlated, so the independence behind the exponential bound fails and the improvement is smaller. Methods inject randomness, or reweight the data, to bring the errors apart.
</details>

<details class="qa" markdown="1">
<summary>What is the difference between sequential and parallel ensembles?</summary>

In a sequential ensemble each learner is built knowing the mistakes of the previous ones, to reduce what is left. In a parallel ensemble the learners are built independently and their errors are averaged out.
</details>
