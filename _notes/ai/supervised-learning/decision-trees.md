---
collection: notes
title: "Decision Trees: ID3, C4.5 and CART"
date: 2026-10-04
excerpt: "How a tree is grown by asking the question that leaves the purest answers, with entropy, gain ratio and the Gini index, and how pruning stops it memorizing."
hook: "A tree grows by asking the question that leaves the purest answers, and it overfits by asking questions until the answers are trivially pure."
goals:
  - compute the information gain, gain ratio and Gini reduction of a candidate split
  - explain what C4.5 corrects in ID3
  - prune a tree with a validation set
requires:
  - overfitting
  - validation-set
defines:
  - {id: decision-tree, name: decision tree, anchor: growing-a-tree}
  - {id: information-gain, name: information gain, anchor: three-ways-to-score-a-split}
  - {id: gain-ratio, name: gain ratio, anchor: three-ways-to-score-a-split}
  - {id: gini-index, name: Gini index, anchor: three-ways-to-score-a-split}
  - {id: pruning, name: pruning, anchor: pruning}
  - {id: decision-stump, name: decision stump, anchor: decision-stumps}
read_time: true
tags:
  - Supervised Learning
  - Classic learners
---

A decision tree classifies by asking a sequence of simple questions about the features. This note shows how the questions are chosen, why a tree that answers every training example correctly is usually worse than a smaller one, and how to cut it back.

# Growing a tree

A **decision tree** is a set of tests organized in a divide-and-conquer way. Each non-leaf node holds a test on one feature and sends the instances that reach it to different children according to the outcome. Each leaf holds a label. To predict, an instance walks down from the root, answering one test per node, until it reaches a leaf.

Learning is recursive. Given a set of instances, choose a test, divide the set by its outcome, and repeat on each part until a part is pure or nothing is left to test. The entire difficulty is in choosing the test. For a numerical feature the candidates are thresholds, usually the midpoints between consecutive sorted values, and each threshold is a binary test "feature $\le t$".

# Three ways to score a split

A good split leaves parts that are as **pure** as possible, containing mostly one class. The three classical algorithms measure purity differently.

**ID3** uses the entropy of the labels, $\operatorname{Ent}(D)=-\sum_y P(y\mid D)\log_2P(y\mid D)$, and scores a split of $D$ into $D_1,\dots,D_k$ by the **information gain**,

$$ G(D;D_1,\dots,D_k)=\operatorname{Ent}(D)-\sum_{i=1}^{k}\frac{\lvert D_i\rvert}{\lvert D\rvert}\operatorname{Ent}(D_i) . $$

Information gain favors features with many values, whatever their relevance: a feature that gives every instance its own value splits the data into perfectly pure singletons and scores the maximum. **C4.5** corrects this with the **gain ratio**, which divides the gain by the entropy of the split itself,

$$ \text{gain ratio}=\frac{G(D;D_1,\dots,D_k)}{-\sum_{i}\frac{\lvert D_i\rvert}{\lvert D\rvert}\log_2\frac{\lvert D_i\rvert}{\lvert D\rvert}} , $$

and picks the highest ratio among the features whose gain is above average. **CART** uses the **Gini index** $I(D)=1-\sum_yP(y\mid D)^2$, the probability that two instances drawn from $D$ have different labels, and picks the split with the lowest weighted Gini of its parts, $\sum_i\frac{\lvert D_i\rvert}{\lvert D\rvert}I(D_i)$. CART splits are binary.

# A worked split

Thirteen people are labelled by whether they are sporty, 7 yes and 6 no. The root has $I=1-(7/13)^2-(6/13)^2\approx0.497$. Two candidate questions:

| Split | Left (yes / no) | Right (yes / no) | Weighted Gini |
|---|---|---|---:|
| Gender: f vs m | 5 / 2 | 2 / 4 | 0.425 |
| Age: ≤ 25 vs > 25 | 5 / 1 | 2 / 5 | 0.348 |
{: .keyed}

For age, the left part has 6 people and $I=1-(5/6)^2-(1/6)^2\approx0.278$, the right part has 7 and $I=1-(2/7)^2-(5/7)^2\approx0.408$, so the weighted value is $\tfrac{6}{13}\cdot0.278+\tfrac{7}{13}\cdot0.408\approx0.348$. Age lowers the Gini by $0.149$ against $0.072$ for gender, so it becomes the root test. Information gain agrees here, with 0.231 bits against 0.107.

> In practice the Gini index and the entropy rank splits almost identically. The choice of criterion matters much less than whether the tree is pruned.
{: .rule}

# Pruning

Grown until every leaf is pure, a tree is perfect on the training set and usually worse than a smaller one on new data, because its deep tests fit noise and peculiarities of the sample. **Pruning** cuts the tree back, and it needs a validation set to decide where. *Pre-pruning* refuses to grow a branch if growing it does not lower the validation error. *Post-pruning* grows the full tree and then removes a branch whenever removing it lowers the validation error. Post-pruning keeps more of the structure, because it sees which branches turn out to be useful, but costs a full tree first.

# Decision stumps

A tree of height one is a **decision stump**: a single test on a single feature. Trees are nonlinear in general, but a stump is a very restricted linear classifier, a threshold on one coordinate. Alone it is weak, only a little better than guessing on hard problems. Combined by the methods of the [ensembles part]({{ '/notes/ai/supervised-learning/why-ensembles/' | relative_url }}), stumps give strong classifiers, which is why they are the standard weak learner.

# Recap

<details class="qa" markdown="1">
<summary>Why is information gain biased, and what does C4.5 do about it?</summary>

A feature with many distinct values splits the data into tiny, nearly pure parts and so shows a large gain without being informative. The gain ratio divides by the entropy of the split, which is large exactly when there are many parts.
</details>

<details class="qa" markdown="1">
<summary>What does the Gini index of a node mean?</summary>

The probability that two instances drawn at random from the node have different labels. It is 0 for a pure node and largest when the classes are evenly mixed.
</details>

<details class="qa" markdown="1">
<summary>Why does a tree that fits the training set perfectly generalize badly?</summary>

To make every leaf pure it must create tests that isolate individual noisy examples. Those tests do not describe the source, so new instances land on leaves that encode noise.
</details>
