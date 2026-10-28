---
collection: notes
title: Training a Boltzmann Machine
date: '2026-10-27'
excerpt: The log-likelihood gradient as a difference of two averages and contrastive divergence as its approximation.
hook: The gradient of the log-likelihood is a data average minus a model average, and the model average is the hard part, which sampling approximates.
goals:
- derive the gradient of the log-likelihood of an energy-based model as a difference of two averages
- explain what contrastive divergence replaces and the bias this introduces
- compare CD-k with the exact gradient on a model small enough to enumerate
requires:
- gibbs-sampling
- energy-based-model
- partition-function
- restricted-boltzmann-machine
defines:
- id: contrastive-divergence
  name: contrastive divergence
  anchor: def-contrastive-divergence
- id: positive-negative-phase
  name: positive and negative phase
  anchor: the-gradient-is-a-difference-of-two-averages
tags:
- Artificial Intelligence
- AI Models For Physics
read_time: true
---

Training a Boltzmann machine means raising the probability of the data, and the gradient of that probability contains the partition function. This note shows where it goes and the shortcut that replaced it {% cite hinton-2002 %}.

# The gradient is a difference of two averages

For an energy-based model $P(v) = \sum_he^{-E(v,h)}/Z$ the log-likelihood of one example is $\ln\sum_he^{-E(v,h)} - \ln Z$. Differentiating with respect to a parameter $\theta$ gives two terms:

$$ \frac{\partial\ln P(v)}{\partial\theta} = -\Big\langle\frac{\partial E}{\partial\theta}\Big\rangle_{P(h\mid v)} + \Big\langle\frac{\partial E}{\partial\theta}\Big\rangle_{P(v,h)}. $$

The first average is over the hidden units with the visible units clamped to the example: the **positive phase**. The second is over the model's own joint distribution: the **negative phase**. For an RBM with $\partial E/\partial W_{ij} = -v_ih_j$,

$$ \frac{\partial\ln P}{\partial W_{ij}} = \langle v_ih_j\rangle_{\rm data} - \langle v_ih_j\rangle_{\rm model}. $$

The positive phase is cheap, since the conditional of the hidden layer is a product of logistic functions. The negative phase is an expectation under $P(v,h)$, whose evaluation needs $Z$ and is a sum over all states.

> The gradient vanishes when the correlations of the model equal the correlations of the data. Learning is the adjustment of couplings until the model reproduces the pair statistics that the data contain.
{: .idea}

# Replacing the model average by a short chain

The negative phase can be estimated by sampling: run a Gibbs chain and average $v_ih_j$ along it. A chain that has reached equilibrium needs many sweeps, repeated at every gradient step.

> **Contrastive divergence** with $k$ steps (CD-$k$) starts the chain at the data example, runs $k$ steps of block Gibbs sampling, and uses the resulting $(v^{(k)},h^{(k)})$ in place of a model sample.
{: .definition #def-contrastive-divergence title="Contrastive divergence"}

{% capture t %}
| | Positive phase | Negative phase |
|---|---|---|
| Exact | $P(h\mid v)$, $v$ from the data | $P(v,h)$, needs $Z$ |
| CD-$k$ | the same | $k$ Gibbs steps from the data |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-cd" caption="What contrastive divergence changes." body=t %}

The estimate is biased: a chain started at the data and stopped early has not reached the model distribution, and it forgets only part of where it started. The bias is zero if $k\to\infty$ and vanishes when the model already matches the data, so it matters most early in training.

# How much the shortcut costs

The model can be small enough to compute the exact gradient by enumeration. The figure compares the exact gradient with CD-1 and CD-10 for an RBM with 4 visible and 3 hidden units, trained on the patterns $0000$, $1111$, $1010$ and $0101$.

{% include fig.html src="ai-models-for-physics/cd-vs-exact" id="fig-cd-vs-exact" alt="Average log-likelihood against epochs for three training methods, rising from about minus 2.8 towards the dashed best possible value; the exact and CD-10 curves nearly coincide and CD-1 lies slightly below." caption="Learning a four-pattern distribution. CD-10 follows the exact gradient; CD-1 trails it slightly. None has reached the best possible value $-\ln4$ after 800 epochs, because the weights grow slowly from a small start." %}

In this model a single step is already enough to learn, and a longer chain tracks the exact curve more closely. In larger models the picture is less benign: when the distribution has many modes, a short chain from the data never visits the ones the model has put in the wrong places, and the negative phase does not push their probability down.

> CD does not follow the gradient of the log-likelihood and does not converge to a maximum of it in general. It works because the data-side correction is the important one early in training, not because it is an unbiased estimate.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does the log-likelihood gradient of an RBM contain an expectation over the model?</summary>

The normalization $Z$ depends on the parameters, so differentiating $-\ln Z$ gives the average of $\partial E/\partial\theta$ under the model distribution. That average is the negative phase.
</details>

<details class="qa" markdown="1">
<summary>What does CD-$k$ do to the negative phase, and what does it cost?</summary>

It takes the average from a Gibbs chain of $k$ steps started at a data example. This removes the need for equilibrium sampling at the price of a bias that depends on how far the chain gets from its start in $k$ steps.
</details>
