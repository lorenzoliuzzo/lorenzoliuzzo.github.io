---
collection: notes
title: "Validation and Cross-Validation"
date: 2026-10-04
excerpt: "How to choose a model and its settings on held-out data, and how stratified k-fold cross-validation does it when labelled examples are scarce."
hook: "Every choice made with the help of data belongs on data other than the test set, and cross-validation lets every labelled example serve in both roles."
goals:
  - choose a hyper-parameter or a model with a validation set
  - run stratified, repeated and leave-one-out cross-validation and say what each costs
  - explain why the test set is used once and where preprocessing can leak into it
requires:
  - generalization-error
  - overfitting
defines:
  - {id: hyperparameter, name: hyper-parameter, anchor: choosing-with-a-validation-set}
  - {id: validation-set, name: validation set, anchor: choosing-with-a-validation-set}
  - {id: stratification, name: stratification, anchor: splitting-the-data}
  - {id: cross-validation, name: cross-validation, anchor: k-fold-cross-validation}
read_time: true
tags:
  - Supervised Learning
  - The learning problem
---

The previous note ended with a rule: the training error cannot choose between models, and the test set must stay untouched. This note is the working answer, a way to make choices and still have an honest estimate at the end.

# Choosing with a validation set

Most learners have settings that the algorithm does not fit by itself: the degree of a polynomial, the number of neighbours $k$, the penalty $C$ of an SVM, the depth of a tree. These are **hyper-parameters**. Picking them, or picking between whole algorithms, is **model selection**, and it needs an estimate of each candidate's generalization error.

The estimate comes from a **validation set**: labelled data kept out of the fitting. Fit every candidate on the training part, measure its error on the validation part, and keep the one with the lowest error. The labels of the validation set are used to choose, so its error is no longer an unbiased estimate of the chosen model's error: the winner was selected for doing well on exactly this data. That is why a separate test set is kept, to be used once on the final model.

# Splitting the data

Splitting a data set in two at random can distort it. A class that makes up 5% of the data may end up with 1% or 9% of a small validation set, and the error estimate then says little about the true proportions. **Stratification** (stratified sampling) splits each class separately, so that both parts keep the class percentages of the whole.

A single split has two further costs. Labels spent on validation are not used for training, and the estimate depends on which examples happened to fall in the validation set. When labelled data is scarce, both costs hurt.

# K-fold cross-validation

**Cross-validation** removes both costs by letting every example be used for validation once. Partition the data, with stratification, into $k$ disjoint folds of equal size $D_1,\dots,D_k$. In round $i$, train on the union of all folds except $D_i$ and validate on $D_i$. The estimate for the candidate is the mean of the $k$ validation errors, and the candidate with the lowest mean wins.

{% include fig.html src="supervised-learning/cv-folds" id="fig-folds" alt="Five rows of five boxes, one row per round. In round r the r-th box is marked validate and the other four train. A separate dashed column of boxes on the right is labelled test set and untouched." caption="Five-fold cross-validation. Each fold is the validation set in exactly one round. The test set sits outside the whole procedure." %}

The usual variations trade cost against stability:

- **$t$-times $k$-fold** repeats the whole procedure with $t$ different random partitions and averages, which reduces the noise that any one partition adds. Common settings are $10\times10$ and $5\times2$.
- **Leave-one-out** takes $k=m$, so each validation set is a single example. It uses almost all the data for training in every round, but it costs $m$ trainings.
- Typical choices of $k$ are 5 and 10. A larger $k$ trains each model on more data and so gives a less pessimistic estimate, at the price of $k$ trainings.

> Anything learned from data must be learned inside each round: standardizing the features, selecting features, choosing the vocabulary of a bag of words. If it is done once on the whole data set before splitting, information about the validation fold has already reached the training folds, and the estimate is optimistic.
{: .trap}

Cross-validation estimates how well a *procedure* works, not how well one fitted model works. Once the winning candidate is chosen, it is refitted on all the data that was used for selection, and the test set judges it once.

# Recap

<details class="qa" markdown="1">
<summary>Why is the validation error of the selected model still optimistic?</summary>

The model was selected for having the lowest validation error among several, so part of its advantage is luck on that particular data. A fresh test set removes that selection effect.
</details>

<details class="qa" markdown="1">
<summary>What does stratification protect against?</summary>

A random split can give the parts class proportions that differ from the whole, especially for small classes. Splitting each class separately keeps the proportions equal in every part.
</details>

<details class="qa" markdown="1">
<summary>Why can scaling the features on the full data before cross-validation inflate the score?</summary>

The mean and variance used for scaling contain information from the validation folds. The model is then partly prepared on the data it is evaluated on, so the estimate is too good.
</details>
