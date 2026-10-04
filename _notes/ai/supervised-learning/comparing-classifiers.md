---
collection: notes
title: "Comparing Classifiers"
date: 2026-10-04
excerpt: "When a higher average accuracy counts as evidence: the 5x2 cv t-test, McNemar's test, and the Friedman and Nemenyi tests for many classifiers on many data sets."
hook: "A gap in average error means something only against how much the error moves from split to split, and the right test depends on how many classifiers and data sets there are."
goals:
  - choose between the 5x2 cv t-test, McNemar's test and Friedman with Nemenyi for a given experiment
  - compute the t, chi-square and critical difference from their definitions
  - read a critical difference diagram
requires:
  - cross-validation
  - null-and-alternative
  - student-t
  - chi-square
defines:
  - {id: paired-cv-t-test, name: 5x2 cv paired t-test, anchor: two-classifiers-that-can-be-run-ten-times}
  - {id: mcnemar-test, name: McNemar's test, anchor: two-classifiers-run-once}
  - {id: friedman-test, name: Friedman test, anchor: many-classifiers-on-many-data-sets}
  - {id: critical-difference, name: critical difference, anchor: many-classifiers-on-many-data-sets}
read_time: true
tags:
  - Supervised Learning
  - The learning problem
---

Cross-validation gives each classifier an error estimate with some random scatter, and the next question is whether the difference between two of them is more than that scatter. This note gives three tests, chosen by how many classifiers and data sets are involved.

# Why averages are not enough

Compare two classifiers by their mean cross-validation error and the winner can change with the random partition. A **hypothesis test** puts the difference in context. The null hypothesis is that the two algorithms have the same error, and we reject it only if the observed difference would be unlikely under it, at a chosen significance level $\alpha$, usually 0.05 or 0.1. Failing to reject does not show the classifiers are equal, only that this experiment cannot tell them apart.

# Two classifiers that can be run ten times

The **$5\times2$ cv paired $t$-test** needs ten trainings per algorithm. Run five repetitions of 2-fold cross-validation. In repetition $i$ the data are split into halves, both algorithms $a$ and $b$ are trained on one half and tested on the other, in both directions, and the error differences are $d_i^{(1)}$ and $d_i^{(2)}$. Let

$$ \mu_i=\frac{d_i^{(1)}+d_i^{(2)}}{2},\qquad s_i^2=\big(d_i^{(1)}-\mu_i\big)^2+\big(d_i^{(2)}-\mu_i\big)^2 . $$

Under the null hypothesis the statistic

$$ \tilde t=\frac{d_1^{(1)}}{\sqrt{\tfrac15\sum_{i=1}^{5}s_i^2}} $$

follows a Student $t$ distribution with 5 degrees of freedom. The null is kept if $\tilde t$ lies in $[-t_{\alpha/2},t_{\alpha/2}]$, which for $\alpha=0.05$ means $\lvert\tilde t\rvert<2.571$.

# Two classifiers run once

When one run is all that can be afforded, **McNemar's test** uses only the instances on which the two classifiers disagree. Let $\operatorname{err}\_{01}$ count those the first gets wrong and the second gets right, and $\operatorname{err}\_{10}$ the reverse. If the algorithms have the same error, the two counts should be close, and

{% include equation.html tex="\frac{\big(\lvert\operatorname{err}_{01}-\operatorname{err}_{10}\rvert-1\big)^2}{\operatorname{err}_{01}+\operatorname{err}_{10}}\sim\chi^2_1 \quad\text{under the null.}" %}

The critical value at $\alpha=0.05$ is 3.841. With $\operatorname{err}\_{01}=30$ and $\operatorname{err}\_{10}=12$ the statistic is $17^2/42\approx6.9$, so the difference is significant.

> The instances both classifiers get right, or both get wrong, carry no information about which is better. McNemar's test ignores them, which is why it works from a single test set.
{: .idea}

# Many classifiers on many data sets

Comparing $k$ classifiers over $N$ data sets is the common case in a study, and accuracies across different data sets are not on a common scale. The **Friedman test** therefore works on ranks. On each data set the classifiers are ranked by performance, 1 for the best and average ranks for ties, and the ranks are averaged over the data sets to give $R_1,\dots,R_k$. If all classifiers were equivalent each would have expected average rank $(k+1)/2$, and the statistic

{% include equation.html tex="\chi^2_F=\frac{12N}{k(k+1)}\Big[\sum_{j=1}^{k}R_j^2-\frac{k(k+1)^2}{4}\Big]" %}

approximately follows a $\chi^2$ distribution with $k-1$ degrees of freedom when the null is true. Rejecting it says that some classifier differs, not which.

For that, the **Nemenyi** post-hoc test calls two classifiers different when their average ranks differ by at least the **critical difference**

$$ CD=q_\alpha\sqrt{\frac{k(k+1)}{6N}}, $$

where $q_\alpha$ is a tabulated critical value that depends on $\alpha$ and $k$. For $k=4$ classifiers on $N=30$ data sets, $q_{0.05}=2.569$ gives $CD\approx0.86$.

{% include fig.html src="supervised-learning/cd-diagram" id="fig-cd" alt="A horizontal rank axis from 1 to 4 with four classifiers. A sits at 1.20, B at 2.45, C at 2.55 and D at 3.80. A short scale bar at the top has length CD equal to 0.86. A thick bar joins B and C." caption="A critical difference diagram. Two classifiers are significantly different unless a bar joins them. A is better than all others, D worse than all others, and B and C cannot be told apart." %}

> Averaging ranks and applying the Friedman and Nemenyi tests assumes the data sets are independent, and it tests the *classifiers* across data sets, not their accuracy on any one. A full application, with the resampling protocol behind each score, is in [Robust Statistical Comparison of Classifiers Using the Friedman Test]({{ '/notes/ai/supervised-learning/friedman-test/' | relative_url }}).
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Which test would you use for two classifiers, and why does it depend on the budget?</summary>

The $5\times2$ cv $t$-test if ten trainings are affordable, because it accounts for the variability across splits. McNemar's test if each classifier can be trained only once, because it needs just the disagreements on one test set.
</details>

<details class="qa" markdown="1">
<summary>Why does the Friedman test use ranks instead of accuracies?</summary>

Accuracies on different data sets are not comparable and rarely satisfy the assumptions of an ANOVA. Ranks only say who beat whom on each data set, which can be pooled across data sets.
</details>

<details class="qa" markdown="1">
<summary>In a critical difference diagram, what does a bar joining two classifiers mean?</summary>

That their average ranks differ by less than $CD$, so the experiment cannot separate them at the chosen level. It does not mean they are equally good.
</details>
