---
collection: notes
title: "The Learning Problem"
date: 2026-10-04
excerpt: "What supervised learning asks of a model, why the error that matters cannot be computed, and how training and test error part ways as a model grows."
hook: "A model is judged on data it has not seen, and its training error only falls as it grows more flexible, so training error cannot choose between models."
goals:
  - tell classification from regression and name the roles of training, validation and test data
  - explain why the generalization error is estimated on held-out data and how precise that estimate is
  - read training and test error curves to tell underfitting from overfitting
defines:
  - {id: supervised-learning, name: supervised learning, anchor: the-setting}
  - {id: generalization-error, name: generalization error, anchor: the-error-that-matters}
  - {id: overfitting, name: overfitting, anchor: why-the-training-error-misleads}
read_time: true
tags:
  - Supervised Learning
  - The learning problem
---

Supervised learning fits a function to examples whose answers are known, in order to predict answers that are not. This note sets out the problem and shows why the obvious way of grading a model, by its error on the examples it was fitted to, is the wrong one.

# The setting

An **instance** is an object described by a **feature vector** $x$ of $d$ numbers, $d$ being the dimension of the data. In **supervised learning** each training instance also carries a **label** $y$, and the goal is to predict the label of instances never seen. If the label is a category (a class) the task is **classification**; if it is a number the task is **regression**. Without labels the task is unsupervised, as in clustering.

Formally, instances are drawn independently from a distribution $\mathcal{D}$ and labelled by an unknown target function $f$, so the training set is

{% include equation.html tex="D=\{(x_1,y_1),\dots,(x_m,y_m)\},\qquad x_i\ \text{i.i.d.}\sim\mathcal{D},\quad y_i=f(x_i)." %}

The result of learning is a **hypothesis** $h$, also called the learner, the model or the predictor. It is produced by a learning algorithm that searches a family of candidates, such as lines, trees or networks. With noisy labels $y$ is drawn from a distribution given $x$ rather than fixed by $f$, and everything below carries over.

# The error that matters

What we want is a hypothesis that is right on new instances. For classification this is the **generalization error**

$$ \operatorname{err}(h)=\mathbb{E}_{x\sim\mathcal{D}}\big[\mathbb{I}\big(h(x)\ne f(x)\big)\big], $$

the probability that $h$ is wrong on a fresh instance, where the indicator $\mathbb{I}$ is 1 for a mistake and 0 otherwise. For regression the indicator is replaced by a loss such as the squared difference.

This number cannot be computed, because it needs the distribution $\mathcal{D}$ and the labels of instances we do not have. What we can do is keep aside a **test set** of labelled instances that played no part in the fitting and use the error on it as an estimate. The estimate is itself random, but its precision is known: by Hoeffding's inequality, with $n$ test instances it lands within $\varepsilon$ of the truth with probability at least $1-2e^{-2n\varepsilon^2}$.

> With $n=1000$ test instances the error is pinned down to about $\pm0.043$ at 95% confidence, whatever the model. With $n=100$ it is $\pm0.136$, so a one-point gap between two models on such a test set means nothing.
{: .rule}

The data therefore plays three roles. The **training set** is what the algorithm fits. The **validation set** is what we use to tune the algorithm's settings (the [next note]({{ '/notes/ai/supervised-learning/validation-and-cross-validation/' | relative_url }}) is about it). The **test set** is touched once, at the end.

> A test set that has influenced any decision, even a choice between two models, no longer estimates the generalization error. It has become part of the training process, and the number it gives is optimistic.
{: .trap}

# Why the training error misleads

The error on the training set is the one number we can always compute, and it is the wrong one to optimize. Figure [](#fig-fits) shows 20 noisy points from a sine wave and three polynomial models of growing flexibility fitted to them.

{% include fig.html src="supervised-learning/overfitting" id="fig-fits" alt="Three panels with the same 20 noisy points of a sine wave. A degree 1 line misses the curve, a degree 3 polynomial follows it closely, and a degree 12 polynomial passes near every point but oscillates between them." caption="The same 20 points fitted by polynomials of degree 1, 3 and 12. The line is too rigid, degree 12 chases the noise, and degree 3 is close to the green true curve." %}

The line cannot follow the curve, so it is wrong even on the data it saw. The degree 12 polynomial passes close to every point and wiggles between them: it has learned the noise as well as the signal. Repeating the experiment on 200 independent training sets and averaging gives the error curves of Figure [](#fig-curves).

{% include fig.html src="supervised-learning/train-test-error" id="fig-curves" alt="Average squared error against polynomial degree from 1 to 12. The training error falls steadily from 0.31 to 0.03. The test error drops sharply at degree 3 to 0.11, then rises slowly to 0.17 at degree 12. A dashed line marks the noise floor at 0.09." caption="Training error keeps falling with the degree, test error is lowest at degree 3 and rises afterwards. No test error can go below the noise floor $\sigma^2=0.09$." %}

Training error falls all the way, from 0.31 at degree 1 to 0.03 at degree 12, and ends up below the noise floor, which is possible only by memorizing noise. Test error falls to 0.11 at degree 3 and climbs back to 0.17. Two failures are visible. **Underfitting** is a model too rigid for the data: both errors are high (degrees 1 and 2). **Overfitting** is a model that fits the sample instead of the source: training error is low and test error is higher (degrees 5 to 12).

> Training error rewards memorizing, only held-out error rewards generalizing.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why can the generalization error not be computed, and what stands in for it?</summary>

It is an expectation over the data distribution and needs the labels of instances we do not have. The error on a held-out test set is an unbiased estimate of it, with a precision that shrinks like $1/\sqrt n$.
</details>

<details class="qa" markdown="1">
<summary>Why can a model with zero training error be a bad model?</summary>

A flexible enough model can reproduce every training label, noise included. Its error on new instances then carries that noise too, and can be much larger than on the training data.
</details>

<details class="qa" markdown="1">
<summary>What stops a test set from being a fair judge?</summary>

Using it to make any choice, such as picking the better of two models. After that it is part of the fitting, and its error is optimistic. The choices belong to a validation set.
</details>
