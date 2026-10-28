---
title: "Fundamentals & Core Learning Algorithms"
date: 2026-08-24
collection: notes
layout: single
order: 1
read_time: true
toc: true
toc_sticky: true
tags:
  - Artificial Intelligence
  - Supervised Learning
  - Model Evaluation
---

## Core Concepts & Data Representation
* **Data Structure:** Input data is organized into feature vectors living in $d$-dimensional space, paired with ground-truth labels for classification or continuous values for regression[cite: 6, 8, 9, 13].
* **Generalization Goal:** Machine learning models aim to minimize prediction error on unseen data rather than memorize training samples[cite: 6, 8, 9, 13].
* **Data Splits:** Datasets are partitioned into training sets (parameter optimization), validation sets (hyperparameter tuning and model selection), and test sets (final unseen performance measurement)[cite: 6, 8, 9, 13, 15].

## Baseline Supervised Learning Algorithms
* **Linear Discriminant Analysis (LDA):** Classifies instances by projecting features onto a subspace that maximizes class separability[cite: 6, 8].
* **Decision Trees & K-NN:** Decision trees partition feature space non-linearly; K-Nearest Neighbors classifies instances based on local distance metrics[cite: 6, 8].
* **Support Vector Machines (SVMs):** Large-margin classifiers that optimize separation hyperplanes using hinge loss[cite: 6, 8, 13]. Non-linear problems are mapped into high-dimensional Reproducing Kernel Hilbert Spaces (RKHS) via kernel tricks (e.g., Gaussian RBF)[cite: 13].
* **Neural Networks:** Layered parametric models trained via backpropagation error minimization[cite: 6, 8, 13, 15].

## Statistical Evaluation & Algorithm Comparison
* **Cross-Validation:** Performance is validated using $t$-times $k$-fold cross-validation protocols to obtain reliable variance estimates[cite: 6, 8, 13].
* **McNemar Test:** Used to statistically compare two classifiers trained once on the same dataset by assessing misclassification symmetry using a $\chi^2$ distribution[cite: 6, 8, 13]:
  $$\frac{(|err_{12} - err_{21}| - 1)^2}{err_{12} + err_{21}} \sim \chi^2$$[cite: 13]
* **Friedman Test & Critical Difference Diagrams:** Non-parametric tests used to evaluate multiple learning algorithms across multiple benchmark datasets[cite: 6, 8, 13].