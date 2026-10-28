---
collection: notes
title: "SIFT: Finding Keypoints Across Scales"
date: 2026-10-04
excerpt: "How SIFT builds a scale space of blurred images, subtracts neighbouring levels to find blobs of every size, and filters the candidates down to stable keypoints."
hook: "Blurring the image at growing strengths and subtracting neighbouring levels finds blobs at every scale, so each keypoint comes with its own size."
goals:
  - build the Gaussian scale space and the difference-of-Gaussians pyramid
  - find extrema among the 26 neighbours of a pixel and filter the unstable ones
  - explain why the best scale of a detector reads off the size of the structure
requires:
  - keypoint
  - harris-detector
defines:
  - {id: sift, name: SIFT, anchor: from-harris-to-sift}
  - {id: scale-space, name: scale space, anchor: scale-space}
  - {id: difference-of-gaussians, name: difference of Gaussians, anchor: difference-of-gaussians}
read_time: true
tags:
  - Supervised Learning
  - Keypoints
---

The same object photographed from twice as far has half the size, and a detector that works at one size does not find the same points at the other. SIFT finds keypoints at all sizes at once.

# From Harris to SIFT

**SIFT** (Scale-Invariant Feature Transform, Lowe 1999 and 2004) improves on the Harris detector in two ways. It is scale invariant, which is the subject of this note, and it is also a *descriptor*, a vector computed around every keypoint, which is the subject of the next. The vector is robust to scale, rotation, illumination and moderate changes of viewpoint. The detection stage has four steps: build the scale space, find extrema in it, discard the bad points, and assign each remaining one an orientation.

# Scale space

To find a feature at any size, look at the image at several levels of blur. The **scale space** is the family of images

$$ L(x,y,\sigma)=G(x,y,\sigma)*I(x,y),\qquad G(x,y,\sigma)=\frac{1}{2\pi\sigma^2}\,e^{-(x^2+y^2)/2\sigma^2}, $$

where $*$ is convolution with a Gaussian. A larger scale parameter $\sigma$ means more blur and less detail. To save computation the images are arranged in **octaves**: after the blur has doubled, the image is halved in size and the process repeats, so most of the work is done on small images. The usual setting is 4 octaves with 5 blur levels each.

# Difference of Gaussians

Blobs show up as extrema of the Laplacian of Gaussian (LoG) across scale, but the LoG is expensive to compute. The **difference of Gaussians** (DoG) of two neighbouring levels,

$$ D(x,y,\sigma)=L(x,y,k\sigma)-L(x,y,\sigma)\ \approx\ (k-1)\,\sigma^2\nabla^2L , $$

approximates it with a subtraction. Doing this for each pair of neighbouring levels in each octave gives a stack of DoG images.

Why do extrema across scale reveal the size of a structure? A detector tuned to scale $\sigma$ responds most to structures of the matching size, and with the response multiplied by $\sigma^2$ so that scales are comparable, it responds equally well at every size.

{% include fig.html src="supervised-learning/scale-selection" id="fig-scale" alt="Response of a scale-normalized second-derivative detector against its scale from 0.5 to 24, for a narrow bar of half-width 4 and a wide bar of half-width 12. The first curve peaks at 4 and the second at 12, at the same height of about 0.48." caption="The normalized response at the centre of a bar peaks when the detector's scale equals the bar's half-width, at the same height for any size. Searching for the peak finds the size." %}

# Finding and cleaning keypoints

A pixel is a **candidate keypoint** if it is the maximum or the minimum among its 26 neighbours in the DoG stack: 8 around it in its own image, and 9 in each of the images one scale above and below. Most pixels are discarded after a few comparisons. Two kinds of candidate are then removed:

- **low-contrast points**, whose DoG value is below a threshold, since they are unstable under noise;
- **edges**, where the gradient is large in one direction only. This is the Harris idea again: in a flat region the differences in both directions are small, on an edge they are large in one direction only, and at a corner they are large in both, which is the only case kept.

What remains is a set of locations, each with a scale, and the next note gives each an orientation and a description.

> The scale of a keypoint is a measurement, not a parameter: it is the $\sigma$ at which the response peaks. That is what lets two views of the same object at different sizes produce the same keypoints.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why does SIFT compute a difference of Gaussians instead of the Laplacian?</summary>

The DoG approximates the Laplacian of Gaussian closely, and it needs only a subtraction of images already computed for the scale space, so it is very cheap.
</details>

<details class="qa" markdown="1">
<summary>Why are there 26 neighbours to compare against?</summary>

A pixel is compared with the 8 around it in its own DoG image and with the 9 closest in each of the two neighbouring scales.
</details>

<details class="qa" markdown="1">
<summary>Why are edge responses removed from the candidates?</summary>

A point on an edge is poorly localized, since it can slide along the edge, and it is unstable. Requiring large gradients in both directions keeps only corner-like points.
</details>
