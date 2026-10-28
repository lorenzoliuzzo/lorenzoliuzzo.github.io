---
collection: threads
title: "How Sure Are We That A Beats B?"
date: 2026-10-27
excerpt: "From a standard error to a comparison of classifiers: why a gap of a few points on a test set is usually not evidence, and what to do about it."
route:
  - {note: statistics/sampling-distributions, why: "A test score is one draw from a distribution; the standard error says how wide that distribution is."}
  - {note: statistics/confidence-intervals, why: "Turns the standard error into a range, and says what the 95% is a statement about."}
  - {note: statistics/hypothesis-tests, why: "Asks the question directly: could this gap be noise? Also power, and what happens when many comparisons are made."}
  - {note: ai/supervised-learning/friedman-test, why: "A worked comparison of three classifiers on four data sets, where the answer depends on the random seed."}
  - {note: statistics/model-assessment, why: "Cross-validation, the way to get several scores from one data set (planned)."}
  - {note: statistics/conformal-prediction, why: "Moves from 'which model is better' to 'how wrong is this one prediction' (planned)."}
cites:
  - dietterich-1998
tags:
  - Statistics
  - Artificial Intelligence
---

Model A scores 82% and model B scores 80%. The table in the paper puts A in bold. This thread asks how much that bold type is entitled to claim, and follows the answer through four notes that were written for other reasons.

# One score is one draw

A test accuracy is an average of $n$ right-or-wrong outcomes, so it has a sampling distribution. For a model that is right 80% of the time on $n=100$ test cases, the standard error is $\sqrt{0.8\cdot0.2/100}=0.04$. A 95% interval is then about $\pm0.08$, which is already wider than the two-point gap above. If the two models were scored on independent test sets, the standard error of their difference would be $\sqrt2\times0.04\approx0.057$, so a gap of 0.02 is a third of one standard error.

Two things change this picture and neither is subtle. Scoring both models on the same cases removes the part of the noise that comes from easy and hard cases, so paired comparisons are tighter than the figure above. And the width shrinks only as $1/\sqrt n$: to bring the standard error of one accuracy near 0.5 points at 80% takes about $6{,}000$ test cases, which is far more than most benchmarks used in papers.

# What the interval and the test say

An interval is the set of values the data do not rule out, and a test asks whether one particular value, here "no difference", is in that set. The two views agree: a 95% interval for the difference that contains zero is the same event as a failure to reject at the 5% level. The 95% belongs to the procedure, not to the single interval you computed, and a failure to reject is not evidence of equality; it can equally mean the test lacked the power to see a real difference.

> Power is the missing half of most comparisons. A test that would detect a one-point gap only a fifth of the time, when it is real, is not telling you that the gap is absent. Detecting a gap half as large takes about four times the data.
{: .rule}

# When there are many comparisons

A paper rarely compares two models on one data set. With ten data sets and five methods the number of pairwise comparisons is already forty-five, and at a 5% threshold a couple of them will look significant by chance alone. Corrections exist: Bonferroni divides the threshold by the number of tests, and the step-up procedure of Benjamini and Hochberg controls the expected share of false discoveries instead {% cite benjamini-hochberg-1995 %}. The Friedman test with a Nemenyi follow-up is the version designed for comparing several classifiers over several data sets at once.

The Friedman note on this site shows what that looks like when the number of data sets is small. With three classifiers on four data sets, one run gave a Friedman $p$-value of 0.0224, and the same experiment with a different random seed gave 0.0569, on opposite sides of the 5% line. Nothing in the classifiers changed; with four data sets, a single swapped rank moves the statistic that far. The conclusion "A differs from B" did not survive a change of seed, which is exactly what the sampling distribution in the first section predicted.

{% capture t %}
| Situation | What the standard error does | What to do |
|---|---|---|
| One test set of 100 cases | about 4 points at 80% accuracy | report the interval, not the bold |
| Same cases for both models | smaller for the difference | use a paired comparison |
| Several models, several data sets | the same noise, now many times | Friedman and a post-hoc test, with the number of data sets stated |
| Repeated train/test splits | overlapping data, so scores are not independent | use a test built for it, such as 5x2 cross-validation {% cite dietterich-1998 %} |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-comparisons" caption="Four common comparison setups and the question each raises." body=t %}

# From models to predictions

Everything above compares models. A related question is about a single prediction: how wrong could this one be? Conformal prediction answers it with a set rather than a number, and for exchangeable data its coverage guarantee holds whatever the model is {% cite vovk-2005 %}. The two questions share an attitude. Both start from the fact that data are a sample and refuse to report a point as if it were the population.

> Before reporting a comparison, write down the standard error of the difference. If the gap is smaller than twice that, say the models are not separated by this data, and say how much more data would separate them.
{: .try}

# Recap

<details class="qa" markdown="1">
<summary>A model scores 80% on 100 test cases. About how large is the standard error?</summary>

$\sqrt{0.8\cdot0.2/100}=0.04$, four percentage points.
</details>

<details class="qa" markdown="1">
<summary>Why is failing to reject "no difference" not evidence that the models are equal?</summary>

The test may have had little power. The interval for the difference would then be wide and contain both zero and large differences.
</details>
