---
collection: notes
title: "Learning Vector Quantization"
date: 2026-10-27
excerpt: "A classifier made of a few labelled prototypes, the LVQ1 update, and how it compares with nearest neighbours and the self-organizing map."
hook: "Learning vector quantization keeps a few labelled prototypes and moves the nearest one towards a correct example and away from a wrong one, which places the decision boundary where the classes meet."
goals:
  - classify with the nearest-prototype rule and describe its decision regions
  - write the LVQ1 update and say why a wrong winner is pushed away
  - compare LVQ with k-nearest neighbours and the self-organizing map
requires:
  - competitive-learning
  - k-nn
defines:
  - {id: learning-vector-quantization, name: learning vector quantization, anchor: def-learning-vector-quantization}
  - {id: prototype, name: prototype, anchor: def-prototype}
  - {id: nearest-prototype-rule, name: nearest prototype rule, anchor: def-nearest-prototype-rule}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
  - Feed Forward Neural Networks
---

Nearest neighbours classifies by remembering every training example. Learning vector quantization keeps the same decision rule but remembers only a handful of well-placed prototypes, and learns where to put them.

# Prototypes as a classifier

> A **prototype** is a vector $w_j$ in the input space with a class label $\ell_j$.
{: .definition #def-prototype title="Prototype"}

> The **nearest prototype rule** assigns an input the label of the closest prototype.
{: .definition #def-nearest-prototype-rule title="Nearest prototype rule"}

The input space is thereby cut into the Voronoi cells of the prototypes, and the decision boundary between two classes is made of pieces of the bisecting hyperplanes between prototypes of different classes. Several prototypes per class let a class occupy a region of any shape, and the number of prototypes sets the flexibility of the model: with one prototype per training point the rule is 1-nearest-neighbour.

# The LVQ1 rule

The prototypes are trained on labelled examples $(x,t)$. Find the nearest prototype $w_c$ and update only it:

$$ w_c\leftarrow w_c+\eta(t)\,\big(x-w_c\big)\ \text{ if }\ \ell_c=t,\qquad w_c\leftarrow w_c-\eta(t)\,\big(x-w_c\big)\ \text{ otherwise.} $$

A correct winner is pulled towards the example, which makes its cell cover more of that class. A wrong winner is pushed away, which retreats its cell from a region where it does not belong.

> This is the **learning vector quantization** of Kohonen, a supervised relative of the self-organizing map {% cite kohonen-1990 %}.
{: .definition #def-learning-vector-quantization title="Learning vector quantization"}

The learning rate $\eta$ decays towards zero during training so that the prototypes settle.

> The update is the competitive learning rule of the [self-organizing map]({{ '/notes/ai/neural-networks/self-organizing-map/' | relative_url }}) with the sign controlled by the label. Only the winner moves, and there is no neighbourhood on a grid.
{: .idea}

Refinements update the two nearest prototypes when they carry different labels and the example lies close to the boundary between them, which concentrates the learning where the classes meet. They improve on LVQ1 mainly when the first pass leaves the prototypes poorly placed near the boundary.

# Choosing prototypes and distance

LVQ is sensitive to where it starts. A common initialization places prototypes at the class means or at the centres of a clustering done within each class, and the number per class can be chosen by validation. The distance matters as much: with the Euclidean distance, a feature on a large scale dominates the rule, so inputs must be standardized, and relevance variants learn a weight per feature as part of training.

{% capture t %}
| Method | Memory | Training |
|---|---|---|
| $k$-nearest neighbours | every training example | none |
| LVQ | a few labelled prototypes | online updates of the winner |
| self-organizing map | a grid of prototypes, unlabelled | winner and neighbours, no labels |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-prototype-methods" caption="Three prototype-based methods. LVQ is the one that uses labels to move its prototypes." body=t %}

Compared with a support vector machine, whose decision boundary is fixed by points on the margin, the prototypes of LVQ sit inside their classes and the boundary is an implied one between them. Each prototype is also an interpretable object, an example of what the class looks like, which is the reason LVQ remains in use.

> Prototypes are not guaranteed to converge to useful positions. A prototype that never wins is never updated, and a poor initialization can leave a class without a prototype near part of its data.
{: .trap}

Four prototypes are enough to carve a usable boundary.

{% include fig.html src="neural-networks/lvq-boundary" id="fig-lvq-boundary" alt="Scatter of two overlapping classes with four prototypes and a piecewise linear boundary between the shaded regions." caption="Decision regions of four LVQ prototypes on two overlapping classes. The boundary sits midway between prototypes of opposite classes, so a few points always land on the wrong side where the classes overlap." %}

# Recap

<details class="qa" markdown="1">
<summary>Why does LVQ1 push the winner away from an example of the wrong class?</summary>

A winner of the wrong class is claiming territory that belongs to another class. Moving it away shrinks its cell there, so the boundary moves towards where the classes actually meet.
</details>

<details class="qa" markdown="1">
<summary>How does LVQ differ from 1-nearest-neighbour?</summary>

The decision rule is the same, but LVQ stores a few learned prototypes instead of all the training data, so it is much smaller and faster at prediction.
</details>
