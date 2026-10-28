---
collection: notes
title: "The Viola-Jones Cascade"
date: 2026-10-04
excerpt: "AdaBoost with one-feature stumps selects a few good Haar features, and a cascade of ever larger classifiers rejects most windows early, which made face detection real-time."
hook: "Most windows contain no face, so a chain of classifiers that each reject the obvious non-faces cheaply spends its time only on the few that are hard."
goals:
  - build a weak classifier from a feature, a threshold and a polarity, and select features by boosting
  - compute the detection and false-positive rates of a cascade from its stages
  - explain how the early stages of a cascade are trained
requires:
  - haar-feature
  - integral-image
  - adaboost
  - weak-learner
  - decision-stump
defines:
  - {id: viola-jones, name: Viola-Jones detector, anchor: boosting-selects-the-features}
  - {id: cascade-classifier, name: cascade classifier, anchor: the-cascade}
read_time: true
tags:
  - Supervised Learning
  - Recognition and detection
---

With Haar features cheap to compute, the remaining problems are which of the 180,000 to use and how to avoid evaluating them on every window of an image. Viola and Jones answered the first with AdaBoost and the second with a cascade. The detector slides a $24\times24$ window over every position and scale of the image, which gives tens of thousands of windows for one photo, so every part of the design is about cost.

# Boosting selects the features

The working hypothesis is that a very small number of features can be combined into an effective classifier, and the problem is to find them. The weak learner of [AdaBoost]({{ '/notes/ai/supervised-learning/adaboost/' | relative_url }}) is therefore restricted to a **single feature**, so each boosting round selects one. A weak classifier is a feature $f_j$, a threshold $\theta_j$ and a polarity $p_j\in\lbrace\pm1\rbrace$ giving the direction of the inequality,

{% include equation.html tex="h_j(x)=\begin{cases}1&\text{if }p_jf_j(x)<p_j\theta_j\\0&\text{otherwise,}\end{cases}" %}

which is a decision stump on one feature. For each feature the best threshold is the one misclassifying the least weighted data, and in each round the feature with the lowest weighted error $\epsilon_t$ is chosen. With labels $y_i\in\lbrace0,1\rbrace$ (0 for non-faces), $m$ negative and $l$ positive examples, the algorithm is AdaBoost in its own notation:

1. Initialize the weights to $\tfrac1{2m}$ for negatives and $\tfrac1{2l}$ for positives.
2. For $t=1,\dots,T$: normalize the weights; choose the single-feature classifier $h_t$ with the lowest weighted error $\epsilon_t$; update $w_{t+1,i}=w_{t,i}\,\beta_t^{1-e_i}$, where $e_i=0$ if example $i$ is classified correctly and 1 otherwise, and $\beta_t=\epsilon_t/(1-\epsilon_t)$.
3. The strong classifier says "face" if $\sum_t\alpha_th_t(x)\ge\tfrac12\sum_t\alpha_t$, with $\alpha_t=\ln(1/\beta_t)$.

Since $\epsilon_t<\tfrac12$, we have $\beta_t<1$, so correctly classified examples lose weight relative to the errors, exactly the AdaBoost update (after normalization). Boosting here is a feature selector and a classifier at once.

# The cascade

A strong classifier with hundreds of features is accurate but needs all of them on every window, and nearly every window is background. A **cascade classifier** chains strong classifiers into stages. A window is evaluated stage by stage: if a stage says *not a face* the window is discarded immediately, and if it says *maybe*, the window goes on to the next stage. Only a window that passes every stage is reported as a face. Each stage is a boosted classifier with more features than the one before, so the first stages are tiny and cheap, and the large, expensive ones see only the few windows that look like faces.

{% include fig.html src="supervised-learning/cascade-flow" id="fig-cascade" alt="Four boxes in a row labelled stage 1 to stage 4, with arrows between them. Above them the number of windows reaching each stage: 100,000, 30,000, 9,000 and 2,700; below, downward arrows labelled rejected 70,000, 21,000, 6,300 and 1,890. Right of the last stage, 810 windows pass all stages." caption="A cascade whose stages each pass 30% of the windows they receive. Of 100,000 windows, 70,000 are rejected by the cheapest stage and only 810 reach the end." %}

## Training the cascade

Two trade-offs shape the training. Classifiers with more features reach higher detection rates and lower false-positive rates, and they also take longer to compute. The designer fixes the maximum acceptable false-positive rate per stage $f$, the minimum acceptable detection rate per stage $d$, and a target overall false-positive rate $F_{target}$. Each stage is trained by adding features until it meets $f$ and $d$ on a validation set, and stages are added until $F_{target}$ is reached. Later stages are trained on the non-faces that the earlier stages wrongly accepted, which are the hard ones.

A window must survive every stage, so the rates multiply,

$$ F=\prod_{i=1}^{K}f_i,\qquad D=\prod_{i=1}^{K}d_i . $$

With ten stages each at $d=0.99$ and $f=0.3$, the cascade detects $0.99^{10}\approx90\%$ of the faces and lets through $0.3^{10}\approx6\times10^{-6}$ of the non-faces. A stage with a 30% false-positive rate is mediocre alone, but a false positive must pass them all.

> In the original detector a first stage of just two features already rejects about half of the non-faces while keeping nearly every face. The speed comes from the stage structure, not from any one classifier.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why is the weak learner of Viola-Jones limited to one feature?</summary>

With a single feature per round, boosting picks one feature at each step, so after $T$ rounds a small set of features has been selected out of about 180,000, and the strong classifier uses only those.
</details>

<details class="qa" markdown="1">
<summary>How are the detection and false-positive rates of a cascade related to those of its stages?</summary>

They are the products of the stage rates: $D=\prod d_i$ and $F=\prod f_i$. A modest false-positive rate per stage multiplies down to a very small one, while a detection rate near 1 per stage stays acceptable.
</details>

<details class="qa" markdown="1">
<summary>Why is a cascade so much faster than one strong classifier?</summary>

Most windows are background and are rejected by the first small stages, so the expensive stages run on only a tiny fraction of the windows.
</details>
