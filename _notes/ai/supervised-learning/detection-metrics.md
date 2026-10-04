---
collection: notes
title: "Evaluating Detectors: IoU, Precision-Recall and mAP"
date: 2026-10-04
excerpt: "How a predicted box is judged against the truth with intersection over union, and how ranked detections become a precision-recall curve, average precision and mAP."
hook: "A detection counts only if its box overlaps the truth enough, and the quality of a detector is the area under its precision-recall curve, averaged over classes."
goals:
  - compute the intersection over union of two boxes and label a detection as true or false positive
  - build a precision-recall curve from a ranked list of detections
  - compute average precision and say how mAP follows
defines:
  - {id: intersection-over-union, name: intersection over union, anchor: intersection-over-union}
  - {id: precision-and-recall, name: precision and recall, anchor: true-and-false-detections}
  - {id: average-precision, name: average precision, anchor: average-precision}
  - {id: mean-average-precision, name: mean average precision, anchor: average-precision}
read_time: true
tags:
  - Supervised Learning
  - Recognition and detection
---

A classifier is either right or wrong about an image. A detector returns boxes, and a box can be nearly right, so even the definition of a correct answer has to be made. The same definitions score the neural detectors of the later notes.

# Intersection over union

The agreement between a predicted box and the ground-truth box is their **intersection over union**,

$$ \mathrm{IoU}=\frac{\text{area of overlap}}{\text{area of union}}, $$

which is 1 for identical boxes and 0 for disjoint ones. For the boxes $[0,10]^2$ and $[2,12]^2$ the overlap is $8\times8=64$ and the union is $100+100-64=136$, so $\mathrm{IoU}\approx0.47$. As a rough guide, an IoU of 0.4 is a poor box, 0.7 a good one and 0.9 an excellent one.

# True and false detections

Fix an IoU threshold, commonly 0.5. A predicted box that overlaps an unmatched object above the threshold is a **true positive** (TP). A predicted box that matches no object, or duplicates one already matched, is a **false positive** (FP). An object with no matching box is a **false negative** (FN). From these,

$$ \text{precision}=\frac{TP}{TP+FP},\qquad \text{recall}=\frac{TP}{TP+FN}. $$

Precision is the share of the returned boxes that are right, and recall the share of the objects that are found. A true negative is not defined for detection: there are unboundedly many boxes that correctly contain nothing.

> The box in the example above, with IoU 0.47, is a false positive at threshold 0.5 and a true positive at 0.4. A detection is only as correct as the threshold says, so a metric must state it.
{: .trap}

# Average precision

Every detection comes with a confidence score, and precision and recall depend on how many detections are kept. Sort the detections by confidence, and after each one compute the precision and the recall of the list so far. Plotting precision against recall gives the **precision-recall curve**: it starts at high precision and low recall when only the most confident detections are kept, and trades precision for recall as the list grows.

{% include fig.html src="supervised-learning/precision-recall" id="fig-pr" alt="A precision-recall plot with an orange zigzag curve through ten points, starting at precision 1 with recall 0.17 and ending at precision 0.5 with recall 0.83. A shaded area under the step envelope of the curve is labelled average precision 0.70. Beside it, ten boxes show the ranked detections as TP or FP." caption="Ten ranked detections for six objects, five of them found. The orange curve is the precision after each detection. The shaded area, under the curve made monotone by taking the best precision at equal or higher recall, is the average precision." %}

To remove the zigzag, replace the precision at each recall by the best precision at that recall or higher. The area under that stepped curve is the **average precision** (AP) of the class. In the example it is $\tfrac26\cdot1+\tfrac26\cdot0.8+\tfrac16\cdot0.625\approx0.70$: the steps cover recall up to $2/6$ at precision 1, up to $4/6$ at 0.8, and up to $5/6$ at 0.625. Averaging AP over all the classes gives the **mean average precision** (mAP), the standard score of an object detector.

# Recap

<details class="qa" markdown="1">
<summary>Why does a detector need an IoU threshold, and what does changing it do?</summary>

Boxes are continuous, so "correct" needs a cut-off. A stricter threshold turns more detections into false positives and lowers precision and recall; a looser one does the opposite.
</details>

<details class="qa" markdown="1">
<summary>What do precision and recall each measure?</summary>

Precision is the fraction of the detections returned that are right. Recall is the fraction of the objects that were found. Raising one by relaxing the confidence cut-off usually lowers the other.
</details>

<details class="qa" markdown="1">
<summary>How does mAP follow from the precision-recall curve?</summary>

The area under a class's (monotone) precision-recall curve is its AP, and mAP is the mean of the APs over the classes.
</details>
