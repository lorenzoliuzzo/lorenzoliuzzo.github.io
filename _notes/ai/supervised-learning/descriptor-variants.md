---
collection: notes
title: "FAST, SURF, Dense SIFT and Colour"
date: 2026-10-04
excerpt: "Four variations on the SIFT recipe, a faster corner test, a faster descriptor, a fixed grid instead of detection, and colour added by early or late fusion, and what each trades."
hook: "SIFT is a recipe with interchangeable parts, and each substitution buys speed, coverage or colour at the price of something else."
goals:
  - describe the FAST corner test and why it is quick
  - say when dense sampling is preferable to keypoint detection
  - combine colour and shape by early or late fusion
requires:
  - sift-descriptor
  - keypoint
defines:
  - {id: fast-detector, name: FAST detector, anchor: faster-detection-and-description}
  - {id: dense-sift, name: dense SIFT, anchor: dense-sampling}
  - {id: color-fusion, name: early and late fusion of colour, anchor: adding-colour}
read_time: true
tags:
  - Supervised Learning
  - Recognition and detection
---

The SIFT pipeline of the last notes is one design among many. Its stages can be swapped out, and the variants are what practical systems actually use.

# Faster detection and description

**FAST** (Features from Accelerated Segment Test) is a corner detector built for speed. For a pixel, look at the 16 pixels on a circle around it. If a run of $N$ contiguous pixels on the circle are all brighter, or all darker, than the centre by a threshold, the centre is a corner. A shortcut makes it cheap: test pixels 1, 5, 9 and 13 of the circle first, at least three of them must pass, and otherwise the candidate is discarded at once, which settles most pixels in a few comparisons.

**SURF** (Speeded-Up Robust Features, Bay 2004) approximates the SIFT steps with box filters. It is reported to be 3 to 7 times faster than SIFT with similar matching performance, and its descriptor has 64 numbers instead of 128.

# Dense sampling

**Dense SIFT** drops the detection stage and describes the points of a fixed grid.

| | Dense grid | Detected keypoints |
|---|---|---|
| Detection | none, faster | needed, slower |
| Smooth surfaces with few corners | covered | little to describe |
| Distinctiveness of the points | lower | corners are more reliable |
| Matching cost | many more descriptors, slower | fewer, faster |
{: .keyed}

The grid is a good choice when the goal is a description of the whole image, as in the bag of visual words, and detected keypoints when exact geometry is needed, as in matching with RANSAC.

# Adding colour

SIFT works on grayscale, which cannot tell apart two products that differ only in colour, such as two flavours of the same packaged food. There are two ways to mix colour and shape information.

- **Early fusion** computes the descriptor on each colour channel and concatenates them. For RGB this gives $3\times128=384$ numbers.
- **Late fusion** computes the SIFT descriptor ($128$ numbers) and a separate colour descriptor of $N$ numbers, such as a colour histogram, weights each, and concatenates them into a vector of $128+N$ numbers. The weights decide how much colour counts against shape.

> Late fusion costs one more weight to choose, but it lets colour be used only where it matters: shape finds the candidates, and colour disambiguates among the near-identical ones.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the FAST test fast?</summary>

Four fixed pixels of the circle are checked first and at least three must be brighter or darker than the centre, so most pixels are rejected after a handful of comparisons.
</details>

<details class="qa" markdown="1">
<summary>When is a fixed grid better than detected keypoints?</summary>

When no keypoint detection is wanted (speed) or the surfaces are smooth with few corners, and a description of the whole image matters more than exact points.
</details>

<details class="qa" markdown="1">
<summary>What is the difference between early and late fusion of colour?</summary>

Early fusion makes the descriptor on each colour channel and joins them. Late fusion joins a shape descriptor and a separate colour descriptor, each with a weight.
</details>
