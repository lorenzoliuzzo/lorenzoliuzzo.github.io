---
collection: notes
title: "SIFT: Orientation and the Descriptor"
date: 2026-10-04
excerpt: "How each keypoint gets a dominant orientation, and how a grid of orientation histograms measured relative to it becomes a 128-number descriptor robust to rotation and light."
hook: "Histograms of gradient directions, measured relative to the keypoint's own orientation, make a description that survives rotation and changes of light."
goals:
  - assign one or more orientations to a keypoint from a gradient histogram
  - build the 128-number descriptor from a 4x4 grid of 8-bin histograms
  - explain how normalization and clipping give robustness to illumination
requires:
  - sift
  - local-descriptor
defines:
  - {id: keypoint-orientation, name: keypoint orientation, anchor: orientation}
  - {id: sift-descriptor, name: SIFT descriptor, anchor: the-128-number-descriptor}
read_time: true
tags:
  - Supervised Learning
  - Keypoints
---

The detector returned a set of locations, each with a scale. Matching two images needs more: a description of what surrounds each location that comes out the same when the object is rotated or lit differently.

# Orientation

To be **rotation invariant**, every keypoint is given a dominant orientation, and everything computed next is measured relative to it. In the blurred image at the keypoint's scale, the gradient at a pixel has magnitude and direction

$$ m(x,y)=\sqrt{\big(L(x{+}1,y)-L(x{-}1,y)\big)^2+\big(L(x,y{+}1)-L(x,y{-}1)\big)^2},\qquad \theta(x,y)=\tan^{-1}\frac{L(x,y{+}1)-L(x,y{-}1)}{L(x{+}1,y)-L(x{-}1,y)} . $$

The gradient directions in a neighbourhood are collected in a histogram of 36 bins of 10 degrees, each pixel voting with its magnitude. The tallest bin gives the keypoint's orientation, and any other peak above 80% of the tallest creates an extra keypoint with the same location and scale and a different orientation.

# The 128-number descriptor

The descriptor is a fingerprint of the keypoint's surroundings. Take the $16\times16$ pixel window around the keypoint, rotated to the keypoint's orientation, and divide it into a $4\times4$ grid of cells. In each cell build an 8-bin histogram of the gradient directions, weighted by gradient magnitude, and by a Gaussian that fades the contribution of pixels far from the keypoint. Concatenating the 16 histograms of 8 bins gives a vector of

$$ 4\times4\times8=128\ \text{numbers.} $$

{% include fig.html src="supervised-learning/descriptor-grid" id="fig-descriptor" alt="A square window divided into a four by four grid of cells. In each cell eight short lines radiate from the centre in different directions, with lengths showing the strength of each orientation. The cells near the centre have longer lines than the ones at the corners." caption="The descriptor: 16 cells, each an 8-direction histogram of gradients, faded away from the keypoint. The 128 lengths are the vector." %}

Two final steps give the robustness. For **rotation**, the keypoint's orientation is subtracted from every gradient direction, so a rotated copy of the same patch yields the same histograms. For **illumination**, the vector is normalized to unit length, which cancels a uniform change of contrast; then every entry is clipped at 0.2, which limits the influence of a few very large gradients caused by non-linear lighting effects such as saturation; and the vector is normalized again.

| Stage | Steps in order |
|---|---|
| Detection | scale space; difference of Gaussians; extrema among 26 neighbours; discard edges and low contrast; orientation |
| Description | $4\times4$ sub-windows; weighted orientation histograms; Gaussian weighting; L2 normalization; subtract the orientation; clip at 0.2 and renormalize |
{: .keyed}

> Gradients, not intensities, are described, and their directions are taken relative to the keypoint. A brighter or lower-contrast copy of the patch changes the intensities but, after normalization, not the gradient pattern.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why can one location produce more than one keypoint?</summary>

If the orientation histogram has several strong peaks (above 80% of the highest), each becomes a keypoint with its own orientation, so that an ambiguous patch can match under any of its plausible orientations.
</details>

<details class="qa" markdown="1">
<summary>Where does the number 128 come from?</summary>

A $4\times4$ grid of cells with an 8-bin orientation histogram in each: $4\cdot4\cdot8=128$.
</details>

<details class="qa" markdown="1">
<summary>How does the descriptor become robust to lighting changes?</summary>

Normalizing to unit length removes a uniform change of contrast, and clipping entries at 0.2 followed by renormalizing stops a few huge gradients from dominating the vector.
</details>
