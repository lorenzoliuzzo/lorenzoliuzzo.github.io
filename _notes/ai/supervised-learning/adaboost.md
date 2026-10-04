---
collection: notes
title: "AdaBoost"
date: 2026-10-04
excerpt: "AdaBoost derived from the exponential loss: the weight of each weak learner, the update of the example weights, a hand-run on XOR, and the multiclass extensions."
hook: "AdaBoost keeps a distribution over the examples and moves weight onto the ones the committee still gets wrong, so each new weak learner works on what the others could not."
goals:
  - derive the learner weight and the example-weight update from the exponential loss
  - run three rounds of AdaBoost by hand on a four-point data set
  - choose a strategy for more than two classes
requires:
  - ensemble
  - weak-learner
  - decision-stump
defines:
  - {id: boosting, name: boosting, anchor: the-boosting-scheme}
  - {id: exponential-loss, name: exponential loss, anchor: the-exponential-loss}
  - {id: adaboost, name: AdaBoost, anchor: the-algorithm}
read_time: true
tags:
  - Supervised Learning
  - Ensembles
---

Boosting is the sequential way to build an ensemble: train a weak learner, see where it fails, and make the next one concentrate there. AdaBoost is the algorithm that fills in the details.

# The boosting scheme

**Boosting** is a family of algorithms that turn weak learners into a strong one. Whether this was possible at all was an open question posed by Kearns and Valiant in 1989, and Schapire proved in 1990 that it was, by a construction. The general scheme is short. Start with a distribution $\mathcal{D}\_1$ over the training set. In round $t$, train a weak learner $h\_t$ under $\mathcal{D}\_t$, measure its error $\epsilon\_t$, and derive a new distribution $\mathcal{D}\_{t+1}$ that puts more weight on the examples $h\_t$ got wrong. Finally combine $h\_1,\dots,h\_T$. Two things are left open, how to adjust the distribution and how to combine the outputs, and AdaBoost settles both.

# The exponential loss

Take labels $y\in\lbrace+1,-1\rbrace$ and a weighted vote $H(x)=\sum_{t}\alpha_th_t(x)$ that predicts $\operatorname{sign}(H(x))$. AdaBoost minimizes the **exponential loss**

$$ \ell_{\exp}(H\mid\mathcal{D})=\mathbb{E}_{x\sim\mathcal{D}}\big[e^{-f(x)H(x)}\big], $$

which gives a simple update and is consistent with minimizing the classification error. It upper-bounds the 0-1 loss, since $e^{-f(x)H(x)}\ge\mathbb{I}(\operatorname{sign}H(x)\ne f(x))$, and its minimizer is $H(x)=\tfrac12\ln\frac{P(f(x)=1\mid x)}{P(f(x)=-1\mid x)}$, whose sign is the Bayes-optimal classifier.

> **The weight of a learner.** Let $h_t$ have weighted error $\epsilon_t$ under $\mathcal{D}_t$. Its loss when added with weight $\alpha$ is $e^{-\alpha}(1-\epsilon_t)+e^{\alpha}\epsilon_t$. Setting the derivative to zero gives $\alpha_t=\tfrac12\ln\frac{1-\epsilon_t}{\epsilon_t}$.
{: .derive}

A learner with small error gets a large weight, one at chance level ($\epsilon_t=\tfrac12$) gets weight zero, and one worse than chance would get a negative weight, which is why the algorithm stops if $\epsilon_t>\tfrac12$.

> **The distribution.** The next learner should minimize the exponential loss of $H\_{t-1}+h$. Expanding $e^{-fh}\approx1-fh+\tfrac12$ (because $f^2h^2=1$), this means maximizing $\mathbb{E}[e^{-fH\_{t-1}}fh]$, which is the same as minimizing the plain error under the distribution $\mathcal{D}\_t\propto\mathcal{D}\,e^{-fH\_{t-1}}$. Writing $H\_t=H\_{t-1}+\alpha\_th\_t$ gives $\mathcal{D}\_{t+1}=\mathcal{D}\_t\,e^{-\alpha\_tfh\_t}/Z\_t$.
{: .derive}

# The algorithm

1. Set $\mathcal{D}\_1(x\_i)=1/m$.
2. For $t=1,\dots,T$: train $h\_t$ under $\mathcal{D}\_t$; compute $\epsilon\_t=P\_{\mathcal{D}\_t}(h\_t(x)\ne f(x))$ and stop if $\epsilon\_t\gt 0.5$; set $\alpha\_t=\tfrac12\ln\frac{1-\epsilon\_t}{\epsilon\_t}$; update
   $$ \mathcal{D}_{t+1}(x)=\frac{\mathcal{D}_t(x)}{Z_t}\times\begin{cases}e^{-\alpha_t}&\text{if }h_t(x)=f(x)\\ e^{\alpha_t}&\text{otherwise,}\end{cases} $$
   with $Z\_t$ normalizing the weights to sum to 1.
3. Output $H(x)=\operatorname{sign}\big(\sum\_{t=1}^{T}\alpha\_th\_t(x)\big)$.

Correct examples lose weight and mistakes gain it, so the weak learner is forced to attend to the hard cases. If the weak learner cannot use weights directly, the training set of each round is *re-sampled* according to $\mathcal{D}\_t$ instead. The training error of the ensemble is at most $\exp\big(-2\sum\_t(\tfrac12-\epsilon\_t)^2\big)$, so it drops exponentially as long as every weak learner is even slightly better than chance.

# XOR by hand

Four points: $(\pm1,0)$ labelled $+1$ and $(0,\pm1)$ labelled $-1$. No line separates the classes, and none of the eight axis-parallel stumps (a threshold at $\pm0.5$ on either feature, in either orientation) does it either. Each round takes the stump with the lowest weighted error.

| Round | Weights of the four points | Lowest error $\epsilon_t$ | $\alpha_t$ |
|---|---|---:|---:|
| 1 | 0.25, 0.25, 0.25, 0.25 | 0.25 | 0.55 |
| 2 | 0.50, 0.17, 0.17, 0.17 | 0.17 | 0.80 |
| 3 | 0.50, 0.30, 0.10, 0.10 | 0.10 | 1.10 |
{: .keyed}

In round 1 every best stump misses exactly one point, so $\alpha_1=\tfrac12\ln3\approx0.55$ and the missed point's weight rises to 0.5. In round 2 the best stump misses a different point, and so on. In the weights column the first entry is the point missed in the previous round.

{% include fig.html src="supervised-learning/adaboost-xor" id="fig-xor" alt="Four small panels showing the four XOR points, two in each class. The first three panels show the region labelled by a single stump, with one point ringed as misclassified in each. The fourth panel shows the weighted vote, which labels all four points correctly with three vertical and horizontal bands." caption="Three stumps, each wrong on one point, and their weighted vote, which is right on all four. Three linear classifiers have produced a nonlinear one with zero training error." %}

# More than two classes, and regression

For $\lvert\mathcal{Y}\rvert>2$ classes there are two routes. The direct one keeps multiclass base learners and changes the weight to $\alpha_t=\ln\frac{1-\epsilon_t}{\epsilon_t}+\ln(\lvert\mathcal{Y}\rvert-1)$ (**SAMME**), which stays positive as long as the learner beats random guessing among $\lvert\mathcal{Y}\rvert$ classes. The other **decomposes** the task into binary problems, one-versus-rest ($\lvert\mathcal{Y}\rvert$ classifiers, AdaBoost.MH) or one-versus-one ($\lvert\mathcal{Y}\rvert(\lvert\mathcal{Y}\rvert-1)/2$ classifiers, AdaBoost.M2). For regression, an AdaBoost regressor fits copies of a regressor with example weights adjusted by the current error (AdaBoost.R2, AdaBoost.RT).

# Recap

<details class="qa" markdown="1">
<summary>Why does AdaBoost use the exponential loss?</summary>

It gives a closed form for the learner weight and a multiplicative update for the example weights, and it bounds the classification error from above. Its minimizer has the sign of the Bayes-optimal classifier.
</details>

<details class="qa" markdown="1">
<summary>What does a learner with weighted error $\epsilon_t=0.5$ contribute?</summary>

Nothing: $\alpha_t=0$. A learner worse than that would get a negative weight, so AdaBoost stops, because its assumption of a better-than-chance weak learner no longer holds.
</details>

<details class="qa" markdown="1">
<summary>How can a vote of linear classifiers solve XOR?</summary>

Each stump is wrong on one point, but the points they get wrong differ and the weights make each later stump fix the earlier mistakes. Their weighted sum is not linear, and it labels all four points correctly.
</details>
