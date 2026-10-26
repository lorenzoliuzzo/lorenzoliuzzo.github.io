---
collection: notes
title: "Self-Organizing Maps"
date: 2026-10-26
excerpt: "A grid of units trained so that neighbouring units answer to neighbouring inputs, the update with decaying rate and radius, and what the map is used for."
hook: "A self-organizing map is learning vector quantization with a grid: the winner drags its neighbours along, so the grid unfolds over the data and keeps its neighbourhoods."
goals:
  - define a self-organizing map and the neighbourhood relation on its output units
  - write the update with a decaying learning rate and neighbourhood radius
  - explain what topology preservation means and how training can fail
  - say what a map is used for
requires:
  - learning-vector-quantization
  - winner-takes-all
  - free-learning-task
defines:
  - {id: self-organizing-map, name: self-organizing map, anchor: the-map}
  - {id: neighborhood-function, name: neighborhood function, anchor: training-the-map}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

The reference vectors of learning vector quantization are independent: moving one says nothing about the others. A self-organizing map ties them together with a grid, and the grid is what turns a quantizer into a map. The update rule and the failure conditions are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# The map

A **self-organizing map** (SOM, Kohonen map) is a two-layer feed-forward network like the [LVQ network]({{ '/notes/ai/neural-networks/learning-vector-quantization/' | relative_url }}#codebook-vectors), with one addition: the output units are arranged on a grid, usually two-dimensional, square or hexagonal, and a neighbourhood relation on that grid says which units are near each other. Each unit $u$ has a reference vector $r_u$ in the input space. The input of a unit is the distance to its reference vector, the activation is a radial function and the output is the identity, often discretized by winner-takes-all.

There are two spaces. The **data space** is usually of high dimension and holds the inputs and the reference vectors. The **grid** is usually two-dimensional and holds the units. The map assigns each input to the unit with the closest reference vector.

# Topology preservation

The aim is a **topology-preserving** mapping: inputs close in the data space land on units close on the grid. A map projection of the earth keeps this property while distorting distances, angles and areas, because countries that touch on the globe still touch on the map. The same holds for the SOM, which preserves neighbourhoods but not distances.

> The grid fixes the topology the map can represent. A two-dimensional grid can unfold along a surface of dimension two in the data, such as a sheet or a sphere's skin, but it cannot represent a three-dimensional blob without folding.
{: .trap}

# Training the map

Initialize the reference vectors, either at random in the data space or at randomly chosen training examples. Then repeat: choose a training pattern $x$, find the winner $u^*$, the unit with the closest reference vector, and move the reference vectors of the winner and of the units near it on the grid towards $x$:

$$ r_u\leftarrow r_u+\eta(t)\,f\bigl(d_{\text{grid}}(u,u^*),\varrho(t)\bigr)\,(x-r_u). $$

> **Distance** $d_{\text{grid}}$ counts steps on the grid  
> **Neighborhood** $f(d,\varrho)=e^{-d^2/2\varrho^2}$  
> **Rate** $\eta(t)$ decreases over time  
> **Radius** $\varrho(t)$ decreases over time
{: .margin .spec}

The **neighbourhood function** $f$ is a decreasing radial function of the grid distance. With $\varrho=0$ only the winner moves and the rule is hard LVQ. A function that is not a step has a soft border, so shrinking $\varrho$ over time reduces the neighbourhood smoothly. Large steps with a large neighbourhood at the start give the map its global shape, and small steps with a small neighbourhood at the end fit the details.

{% include fig.html src="neural-networks/som-training" id="fig-som" alt="Three squares showing an eight by eight grid of reference vectors with lines joining grid neighbours. At the start the lines form a tangle across the square. After 150 steps the grid has contracted into a small smooth patch left of the centre. After 3000 steps it is a regular grid covering most of the square." caption="An $8\times8$ map trained on uniform points of the square, with a Gaussian neighbourhood and a rate and radius that fall geometrically. The tangle first contracts to a patch, then unfolds over the square." %}

The picture shows why the schedule matters. Training can fail if the initial learning rate or the initial neighbourhood radius is too small: a small radius cannot untangle a random start, and the map stays twisted, with neighbouring units far apart in the data. Reference vectors also stay a little inside the edge of the data, because border units are pulled only from one side.

# What a map is for

Training a SOM is clustering with a layout. Each unit stands for a group of inputs, and groups that are near each other in the data are near on the grid, so the grid can be drawn, coloured by the number or the mean of its inputs, and read as a picture of the data. When the data space has more dimensions than the grid, as when a map trained on the surface of a sphere or on points from a parabola lives in three dimensions and the grid in two, the map performs dimensionality reduction without a probabilistic model, and the position of the winner is the reduced coordinate.

> Compare with the [autoencoder]({{ '/notes/ai/neural-networks/autoencoder/' | relative_url }}#the-bottleneck): both compress to a low-dimensional code, the autoencoder with a continuous code learned by reconstruction and the SOM with a discrete grid learned by competition.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>What does a self-organizing map add to learning vector quantization?</summary>

A neighbourhood relation on the output units. The winner's grid neighbours are updated with it, so units that are near on the grid end up with reference vectors near in the data.
</details>

<details class="qa" markdown="1">
<summary>Why do the learning rate and the neighbourhood radius decrease during training?</summary>

Large values at the start give the map its global shape and unfold it from a random state, and small values at the end let the units settle on local detail without disturbing their neighbours.
</details>

<details class="qa" markdown="1">
<summary>When does SOM training fail?</summary>

When the initial learning rate or the initial radius is too small: the map cannot unfold from its start and remains twisted, so grid neighbours are not data neighbours.
</details>
