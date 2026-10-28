---
collection: notes
title: "Linear Discriminant Analysis"
date: 2026-10-04
excerpt: "Fisher's linear discriminant: the direction on which two classes are far apart and each is compact, in closed form, and what that makes LDA good and bad at."
hook: "LDA does not look for the line that fits the classes but for the direction on which their centres are far apart and each class is tight."
goals:
  - write Fisher's criterion and its closed-form solution
  - place the bias term and classify with the sign of w·x + b
  - say when LDA is optimal and what it cannot do
requires:
  - covariance-and-correlation
defines:
  - {id: linear-classifier, name: linear classifier, anchor: a-linear-classifier}
  - {id: linear-discriminant-analysis, name: linear discriminant analysis, anchor: fishers-criterion}
read_time: true
tags:
  - Supervised Learning
  - Classic learners
---

The simplest classifier that learns from data draws a straight boundary. Linear discriminant analysis is the oldest way of choosing it, and it has a closed form: no iteration, no hyper-parameter.

# A linear classifier

A **linear classifier** has a weight vector $w$ and a bias $b$, and labels an instance by which side of a hyperplane it falls on,

$$ y=\operatorname{sign}\big(w^\top x+b\big). $$

It works in two steps. The instance space is mapped onto the line through $w$, which turns each instance into the single number $w^\top x$. A point on that line is then chosen to separate the positives from the negatives, which is the role of $b$. Learning a linear classifier means choosing $w$ and $b$, and different algorithms (this one, the perceptron, logistic regression, the SVM) differ in how.

# Fisher's criterion

Take two classes with means $\mu_+,\mu_-$ and covariance matrices $\Sigma_+,\Sigma_-$, estimated from the positive and the negative training instances. A good direction $w$ pushes the projected classes apart while keeping each one narrow. Fisher turned this into two numbers: the squared distance between the projected centres and the total variance of the projected classes,

$$ S_B(w)=\big(w^\top\mu_+-w^\top\mu_-\big)^2,\qquad S_W(w)=w^\top\Sigma_+w+w^\top\Sigma_-w . $$

**Linear discriminant analysis** (LDA) maximizes their ratio $J(w)=S_B(w)/S_W(w)$.

> Write $S_W=\Sigma_++\Sigma_-$ and $d=\mu_+-\mu_-$, so that $J(w)=(w^\top d)^2/(w^\top S_Ww)$. Setting the gradient to zero gives $(w^\top S_Ww)\,d=(w^\top d)\,S_Ww$, hence $S_Ww\propto d$. Only the direction of $w$ matters, not its length.
{: .derive}

The solution is

$$ \hat w=(\Sigma_++\Sigma_-)^{-1}(\mu_+-\mu_-) . $$

The factor $(\Sigma_++\Sigma_-)^{-1}$ is what separates this from simply joining the two means. It turns the direction away from the axes along which the classes are already widely scattered, because projecting onto those axes mixes them. Figure [](#fig-lda) shows two elongated classes: projected on the line through the means they overlap heavily, projected on Fisher's direction they are almost separate.

{% include fig.html src="supervised-learning/lda-projection" id="fig-lda" alt="Left: a scatter of two elongated classes with two dashed lines, one along the difference of the means and one along Fisher's direction. Right: two pairs of histograms of the projected data; the pair for the difference of means overlaps heavily, the pair for Fisher's direction is nearly separated." caption="The classes are long in the direction that joins their centres, so projecting on that line overlaps them. Fisher's direction tilts away from the long axis and separates them." %}

After $\hat w$ is found the bias is set at the middle of the projected centres,

$$ \hat b=-\tfrac12\,\hat w^\top(\mu_++\mu_-). $$

# What LDA can and cannot do

The middle-point bias is optimal when the two classes are normally distributed with the same covariance and equal prior probability. Then the boundary is exactly the Bayes-optimal one, and LDA is hard to beat with so little computation.

> LDA draws a straight boundary, whatever the data. Two classes that are not linearly separable, such as one nested inside the other, are beyond it. The remedies are the learners of the next notes: trees, margins with kernels, networks.
{: .trap}

There is also a practical limit. The matrix $\Sigma_++\Sigma_-$ must be inverted, and it is singular if there are fewer training instances than features. With few instances in high dimension the covariance estimates are unreliable even when they can be inverted, and the matrix is usually regularized.

# Recap

<details class="qa" markdown="1">
<summary>Why does LDA not simply use the line through the two class means?</summary>

That direction ignores the shape of the classes. If they are elongated along it, their projections overlap. The inverse covariance in $\hat w$ tilts the direction away from the axes of large within-class spread.
</details>

<details class="qa" markdown="1">
<summary>Where does the bias come from?</summary>

Once the direction is fixed, the threshold on the projected line is placed halfway between the projected class means, which gives $\hat b=-\tfrac12\hat w^\top(\mu_++\mu_-)$.
</details>

<details class="qa" markdown="1">
<summary>Under what assumption is LDA the best possible classifier?</summary>

When both classes are Gaussian with a common covariance matrix and equal priors. Its boundary then coincides with the Bayes-optimal one.
</details>
