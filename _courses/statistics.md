---
collection: courses
title: "Statistics"
excerpt: "Probability, statistical inference, regression, classification, model assessment and multivariate methods: the statistics course in reading order."
reference: /assets/notes/statistics/statistics-reference/statistics-reference.pdf
parts:
  - title: "Probability"
    summary: "Events and the axioms, random variables and their summaries, and the standard distributions."
    notes:
      - statistics/probability-foundations
      - statistics/random-variables
      - statistics/common-random-variables
  - title: "Inference"
    summary: "From samples to estimates, intervals and tests."
    notes:
      - statistics/sampling-distributions
      - statistics/point-estimation
      - statistics/confidence-intervals
      - statistics/hypothesis-tests
  - title: "Regression and smoothing"
    summary: "Least squares and its inference, shrinkage, and flexible fits."
    notes:
      - statistics/linear-regression
      - statistics/regularization
      - statistics/splines
      - statistics/gam-mars
      - statistics/robust-statistics
  - title: "Classification and trees"
    summary: "Linear classifiers, trees, and the ensembles built from them."
    notes:
      - statistics/linear-classification
      - statistics/decision-trees
      - statistics/bagging-random-forests
      - statistics/boosting
  - title: "Assessing models"
    summary: "Estimating prediction error, choosing between models, and prediction intervals."
    notes:
      - statistics/model-assessment
      - statistics/conformal-prediction
  - title: "Multivariate methods"
    summary: "Reducing dimension and modelling clusters."
    notes:
      - statistics/pca-factor-analysis
      - statistics/mixture-models
---

The notes below are meant to be read in order: each one uses the vocabulary of the ones before it. Notes marked *planned* are in the outline but not written yet.

The proofs and precise statements behind the probability and inference notes are collected in a single technical reference, linked below, instead of one PDF per note.
