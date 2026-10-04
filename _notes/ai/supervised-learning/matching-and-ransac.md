---
collection: notes
title: "Matching Keypoints and RANSAC"
date: 2026-10-04
excerpt: "Matching descriptors by distance with the ratio test, the homography that relates two views of a plane, and RANSAC, which finds it despite wrong matches."
hook: "Descriptor matching makes mistakes, and RANSAC finds the one geometric transformation that most matches agree on while ignoring the rest."
goals:
  - match descriptors by nearest neighbour with the ratio test
  - say what a homography is and how many point pairs determine it
  - run RANSAC and compute how many trials it needs
requires:
  - sift-descriptor
defines:
  - {id: descriptor-matching, name: descriptor matching, anchor: matching-descriptors}
  - {id: ratio-test, name: ratio test, anchor: matching-descriptors}
  - {id: homography, name: homography, anchor: homography}
  - {id: ransac, name: RANSAC, anchor: ransac}
read_time: true
tags:
  - Supervised Learning
  - Keypoints
---

Two images of the same object now each have a set of 128-number descriptors. This note pairs them up, gets rid of the wrong pairs, and turns what is left into a decision.

# Matching descriptors

Each keypoint of one image is paired with its **nearest neighbour** among the descriptors of the other, in Euclidean distance in the 128-dimensional space,

$$ d(\mathbf{x},\mathbf{y})=\sqrt{\sum_{i=1}^{128}(x_i-y_i)^2} . $$

The nearest neighbour is not always the right one. A repeated texture produces several descriptors that are almost the same, and the closest of them is then a coin flip. The **ratio test** keeps a match only if the nearest neighbour is clearly closer than the second nearest, that is, if $\mathrm{dis}_1/\mathrm{dis}_2$ is small. A distinctive point has one very close match and the rest far away. An ambiguous one has two similar candidates, and is dropped.

# Homography

Some wrong matches survive. What exposes them is that the object is rigid, so the true matches obey a single geometric transformation. For a planar object, such as a book cover or a painting, the transformation is a **homography**: a $3\times3$ matrix $H$ that maps points of one plane to the other in homogeneous coordinates,

{% include equation.html tex="s\begin{pmatrix}x'\\y'\\1\end{pmatrix}=H\begin{pmatrix}x\\y\\1\end{pmatrix},\qquad H=\begin{pmatrix}h_{11}&h_{12}&h_{13}\\h_{21}&h_{22}&h_{23}\\h_{31}&h_{32}&h_{33}\end{pmatrix}." %}

The matrix is defined up to a scale factor, so it has 8 degrees of freedom, and each point pair gives two equations. **Four** matched pairs therefore determine $H$ exactly.

# RANSAC

Fitting $H$ to all the matches by least squares would let a few wrong ones drag it far off. **RANSAC** (RANdom SAmple Consensus) is a way to fit a model that ignores outliers:

1. Pick the minimum number of matched pairs at random (four for a homography).
2. Compute the model they define exactly.
3. Count the **inliers**: the other matches that agree with it within a small tolerance.
4. Repeat many times and keep the model with the most inliers.
5. Re-estimate the model by least squares on all its inliers.

{% include fig.html src="supervised-learning/ransac-line" id="fig-ransac" alt="Two panels with the same 24 points, 16 near a rising line and 8 scattered. The left panel shows a line through two scattered points with a tolerance band and only 2 inliers. The right panel shows the best of 20 trials, a line along the rising points with 17 points inside the band." caption="RANSAC on a line. A trial through two bad points collects only 2 inliers; the best of 20 trials follows the true points, with 17 inliers, although a third of the data are outliers." %}

The figure uses a line because it is the simplest model, and the procedure is identical for a homography with four pairs per trial. RANSAC works even when most points are outliers. How many trials does it need? If a fraction $e$ of the matches is wrong and each trial draws $s$ pairs, the chance that a trial uses only inliers is $(1-e)^s$, and to see at least one such trial with probability $p$ takes

$$ N=\frac{\ln(1-p)}{\ln\big(1-(1-e)^s\big)} $$

trials. For $s=4$, $e=50\%$ and $p=99\%$ this is $N\approx71.4$, so 72 trials.

# Deciding that the object is there

With the inlier matches in hand, the last step is a score. One used in practice adds up a contribution from every geometrically consistent match,

{% include equation.html tex="w=\sum_{\text{correct matches}}\cos\!\Big(\frac{\pi}{2}\sqrt{\frac{\mathrm{dis}_1}{\mathrm{dis}_2}}\Big)," %}

where $\mathrm{dis}_1$ and $\mathrm{dis}_2$ are the distances to the nearest and second-nearest neighbour. A distinctive match ($\mathrm{dis}_1\ll\mathrm{dis}_2$) adds almost 1 and an ambiguous one almost 0. If $w$ passes a threshold the two images are declared to contain the same object, and the homography says where.

Because the output is a transformation, not only a yes or no, the same pipeline supports **panorama stitching** (warp one photo onto another through the homography), **video stabilization** (estimate and cancel the motion between frames), and **augmented reality** (recognize a printed page and overlay content on it).

# Recap

<details class="qa" markdown="1">
<summary>Why is the nearest neighbour not enough, and what does the ratio test add?</summary>

For a repeated pattern, several candidates are almost as close as the nearest one, so the choice is arbitrary. Requiring the nearest to be clearly closer than the second keeps only matches that are distinctive.
</details>

<details class="qa" markdown="1">
<summary>Why do four point pairs determine a homography?</summary>

It has 9 entries but is defined only up to scale, so 8 degrees of freedom, and each pair of corresponding points supplies two independent equations.
</details>

<details class="qa" markdown="1">
<summary>Why does RANSAC fit a model better than least squares on all the matches?</summary>

Least squares gives every match an influence, so outliers bend the fit. RANSAC builds each candidate from a minimal sample, and chooses by the number of matches that agree, which outliers cannot raise.
</details>
