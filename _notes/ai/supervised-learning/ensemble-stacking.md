---
collection: notes
title: "Ensemble Learning: Stacking"
date: 2026-07-31
excerpt: "Stacking Classifiers"
tags: 
  - Artificial Intelligence
  - Supervised Learning
---

# Stacking Classifiers in

## Dataset
The evaluation is conducted over a two-dimensional dataset consisting of 1200 observations. 

{% include figure.html 
   id="dataset"
   url="/assets/notes/supervised-learning/ensemble-stacking/dataset.png" 
   caption="Visual representation of the standardized dataset." %}

As shown in [](#dataset), the data features a non-linear, circular distribution where one class is nested within another. 

This geometry suggests that linear classifiers may struggle compared to kernel-based or neighborhood-based models.


## Models

## Results and Discussion

{% include table.html 
   id="results" 
   cols=2
   url="/assets/notes/supervised-learning/ensemble-stacking/model_performances.csv" 
   caption="Mean classification accuracy scores for different classifiers..." 
%}

{% include table.html 
   id="leakage" 
   cols=3
   url="/assets/notes/supervised-learning/ensemble-stacking/leakage_analysis.csv" 
   caption="Mean classification accuracy scores for different classifiers..." 
%}

