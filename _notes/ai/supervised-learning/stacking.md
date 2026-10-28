---
collection: notes
title: "Stacking"
date: 2026-10-04
excerpt: "Training a meta-classifier on the predictions of other classifiers, and why those predictions must come from folds the classifiers did not train on."
hook: "Stacking learns how to combine classifiers, but only honestly if the combiner trains on predictions made on data those classifiers never saw."
goals:
  - describe the two levels of a stacked classifier
  - produce out-of-fold level-one predictions with k-fold cross-validation
  - explain why stacking deeper than two levels rarely pays
requires:
  - ensemble
  - cross-validation
  - overfitting
defines:
  - {id: stacking, name: stacking, anchor: two-levels}
  - {id: meta-classifier, name: meta-classifier, anchor: two-levels}
  - {id: out-of-fold-predictions, name: out-of-fold predictions, anchor: avoiding-leakage}
read_time: true
tags:
  - Supervised Learning
  - Ensembles
---

Voting and averaging treat every base learner alike. Stacking asks the data how much to trust each one.

# Two levels

In **stacking**, the predictions of several classifiers $C_1,\dots,C_n$, the *level-one* classifiers, become the features of a **meta-classifier** that makes the final prediction. The level-one classifiers can be of any type, which makes this the standard heterogeneous ensemble, and the meta-classifier can be any classifier, chosen like any other model. If $C_1$ is reliable on one kind of instance and $C_2$ on another, the meta-classifier can learn to listen to each where it is good.

What the meta-classifier receives is a new, small data set. Each row is a training example and its columns are the level-one outputs, with the original label as target. Passing class probabilities instead of hard labels keeps more information, since a classifier that is 51% sure and one that is 99% sure then look different.

| Example | $C_1$ | $C_2$ | $C_3$ | Label |
|---|---:|---:|---:|---|
| 1 | 0.92 | 0.40 | 0.85 | yes |
| 2 | 0.15 | 0.62 | 0.10 | no |
| 3 | 0.55 | 0.90 | 0.48 | yes |
{: .keyed}

The numbers are the probability of *yes* from each level-one classifier. In row 3 only $C_2$ is confident, and a meta-classifier that has learned $C_2$ is reliable on such cases can follow it.

# Avoiding leakage

There is one thing that must be done right. If the level-one predictions used for training the meta-classifier were made on the same data those classifiers were trained on, they would be too good: a classifier usually predicts its own training examples well. The meta-classifier would learn to over-trust the level-one outputs, and its performance on new data would disappoint. Information about the target has **leaked** from the labels into the features.

The rule is that the level-one predictions used to train the meta-classifier come from examples the classifiers were not trained on. A robust way to satisfy it is $k$-fold cross-validation. Split the training data into $k$ folds. For each fold, train the level-one classifiers on the other $k-1$ folds and let them predict the held-out one. Putting the held-out predictions of all folds together gives one honest level-one prediction for every training example, the **out-of-fold predictions**, and the meta-classifier trains on those. For the final model, the level-one classifiers are retrained on all the training data.

> The same discipline applies one level up. The meta-classifier's own performance must be estimated on data that neither level has used, or it is optimistic again. [Ensemble Learning: Stacking]({{ '/notes/ai/supervised-learning/ensemble-stacking/' | relative_url }}) works through the effect of leakage on a real data set.
{: .trap}

Nothing prevents a third level, with a second layer of meta-classifiers over the first. The structure then starts to look like a neural network in which every neuron is itself a classifier, and each layer adds training cost and room to overfit. Two levels are the usual practical limit.

# Recap

<details class="qa" markdown="1">
<summary>What is the difference between stacking and a majority vote?</summary>

A vote weights every classifier equally and fixes the rule in advance. A stack trains a meta-classifier that learns, from out-of-fold predictions, which classifiers to trust and in which cases.
</details>

<details class="qa" markdown="1">
<summary>What goes wrong if the meta-classifier is trained on in-sample level-one predictions?</summary>

Those predictions are optimistic, so the meta-classifier over-trusts the classifiers that overfit most, and its accuracy on new data is lower than its training suggested.
</details>

<details class="qa" markdown="1">
<summary>How do out-of-fold predictions stay honest?</summary>

Each is made by classifiers trained on the other folds only, so no level-one classifier has seen the example it predicts.
</details>
