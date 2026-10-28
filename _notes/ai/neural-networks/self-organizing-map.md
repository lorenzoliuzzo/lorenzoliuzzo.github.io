---
collection: notes
title: "Self-Organizing Maps"
date: 2026-10-27
excerpt: "A grid of prototypes trained by competition and neighbourhood cooperation, why topological order appears, and how to read and misread a map."
hook: "A self-organizing map pulls a grid of prototypes towards the data and drags each winner's neighbours with it, so that units next to each other on the grid end up responding to similar inputs."
goals:
  - write the winner selection and the neighbourhood update of a self-organizing map
  - explain why the map becomes ordered and the role of shrinking the neighbourhood
  - evaluate a map with quantization and topographic error and name what it does not preserve
requires:
  - artificial-neuron
defines:
  - {id: self-organizing-map, name: self-organizing map, anchor: def-self-organizing-map}
  - {id: competitive-learning, name: competitive learning, anchor: def-competitive-learning}
  - {id: neighbourhood-function, name: neighbourhood function, anchor: def-neighbourhood-function}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

Clustering groups data without labels but says nothing about how the groups relate. A self-organizing map does both at once: it summarizes the data by prototypes and lays the prototypes on a grid so that their arrangement reflects the arrangement of the data.

# A grid of prototypes

> A **self-organizing map** has units placed on a fixed low-dimensional grid, usually two-dimensional, and each unit $i$ carries a weight vector $w_i$ in the input space.
{: .definition #def-self-organizing-map title="Self-organizing map"}

The grid position $r_i$ is never changed; only the vectors move. Seen as a neuron, unit $i$ computes the distance between $x$ and $w_i$, and the unit with the smallest distance is the best matching unit. After training, each input is represented by the grid position of its best unit, so a high-dimensional input is displayed on a plane {% cite kohonen-1982 %}.

# The learning rule

> **Competitive learning** selects, for each input, the unit closest to it and moves that unit, and with cooperation its grid neighbours, towards the input.
{: .definition #def-competitive-learning title="Competitive learning"}

For each input $x$, find the winner $c=\arg\min_i\lVert x-w_i\rVert$ and move every unit towards $x$, by an amount that falls with its grid distance from the winner:

$$ w_i\leftarrow w_i+\eta(t)\,h_{ci}(t)\,\big(x-w_i\big),\qquad h_{ci}(t)=\exp\!\Big(-\frac{\lVert r_c-r_i\rVert^2}{2\sigma(t)^2}\Big). $$

> The function $h_{ci}(t)=\exp\!\big(-\lVert r_c-r_i\rVert^2/2\sigma(t)^2\big)$ is the **neighbourhood function**: it weights each unit by a factor that falls with its grid distance from the winner $c$.
{: .definition #def-neighbourhood-function title="Neighbourhood function"}

With $h_{ci}=0$ for $i\ne c$ this is plain online $k$-means: only the winner moves. The neighbourhood makes units near the winner on the grid follow it, so units that are close on the grid end up close in the input space. Both the learning rate $\eta(t)$ and the width $\sigma(t)$ shrink over training, commonly linearly or exponentially {% cite kohonen-1990 %}.

> The neighbourhood is what turns a clustering algorithm into a map. Without it the grid has no meaning; with it, grid neighbours are pulled together, and the net stretches over the data like an elastic sheet.
{: .idea}

# Why order appears

Training has two phases in effect. While $\sigma$ is large, each update moves a big part of the grid, which lays out the coarse shape: the sheet unfolds over the region of the data. As $\sigma$ shrinks, updates become local and the units settle onto the finer structure. If $\sigma$ falls too quickly, the sheet freezes with a twist in it, a fold that no later update can undo because only neighbours of a winner move.

# Reading a map

Two numbers evaluate a map. The **quantization error**, the mean distance from each input to its best unit, says how well the prototypes fit the data. The **topographic error**, the share of inputs whose two best units are not neighbours on the grid, says how well the order is preserved. A U-matrix shows the distance between neighbouring units as a landscape: high ridges mark boundaries between clusters and flat basins mark clusters.

{% capture t %}
| Quantity | What it measures | Warning sign |
|---|---|---|
| quantization error | how well prototypes fit the data | high when the grid is too small |
| topographic error | whether grid neighbours are data neighbours | high when the map is folded |
| U-matrix | distance between adjacent units | ridges mark cluster boundaries |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-som-quality" caption="Three ways to check a trained map." body=t %}

> Distances on the map are not distances in the data. Two units far apart on the grid can be close in the input space where the sheet is folded back, and equal grid steps correspond to unequal data steps.
{: .trap}

The map starts crumpled and unfolds over the data.

{% include fig.html src="neural-networks/som-grid" id="fig-som-grid" alt="Two grids of connected units: bunched at the centre at the start, spread over the whole square after training." caption="An 8 by 8 self-organizing map before and after training on a square. The lines join units that are neighbours on the grid, not in the data space. A good map keeps them untangled." %}

# Recap

<details class="qa" markdown="1">
<summary>What does the neighbourhood function add compared with $k$-means?</summary>

It moves the winner's grid neighbours along with it, so that nearby units come to represent nearby inputs. Without it, only the winner moves and the grid has no meaning.
</details>

<details class="qa" markdown="1">
<summary>Why must the neighbourhood width shrink during training?</summary>

A wide neighbourhood orders the grid but blurs every prototype towards the global mean. Shrinking it lets the units then settle onto local structure.
</details>
