---
collection: notes
title: "From Template Matching to Keypoints"
date: 2026-10-04
excerpt: "Why sliding a picture over an image cannot recognize an object, what SSD and normalized cross-correlation do and do not survive, and the keypoint pipeline that replaces them."
hook: "Comparing pixels cannot survive a change of scale, rotation or light, so recognition compares a few distinctive points described by vectors built to survive them."
goals:
  - compute SSD and normalized cross-correlation and say what each is invariant to
  - list the variations a recognizer has to survive
  - name the four steps of the keypoint pipeline
requires:
  - covariance-and-correlation
defines:
  - {id: instance-recognition, name: instance recognition, anchor: instances-and-classes}
  - {id: template-matching, name: template matching, anchor: template-matching}
  - {id: normalized-cross-correlation, name: normalized cross-correlation, anchor: template-matching}
  - {id: keypoint, name: keypoint, anchor: the-keypoint-pipeline}
  - {id: local-descriptor, name: local descriptor, anchor: the-keypoint-pipeline}
read_time: true
tags:
  - Supervised Learning
  - Keypoints
---

How does a program find one particular book cover in a photograph of a cluttered desk? The next five notes follow the classical answer, from the obvious approach and why it fails to the method that dominated recognition for a decade.

# Instances and classes

Recognition comes in two kinds. **Class recognition** asks whether an image contains *a car* or *an animal*: any member of a category will do. **Instance recognition** asks whether it contains *this* car or *this* copy of a book, seen from another place under other light. This part of the course is about instances; the [bag of visual words]({{ '/notes/ai/supervised-learning/bag-of-visual-words/' | relative_url }}) later extends the same tools to classes. For an instance the task has two sides: decide whether the object is present, and localize it precisely.

# Template matching

The obvious method is **template matching**: slide the picture of the object, the template $g$, over every position of the image $f$ and measure how well the patch under it agrees. Two classical scores are

$$ \mathrm{SSD}[m,n]=\sum_{k,l}\big(g[k,l]-f[m{+}k,\,n{+}l]\big)^2,\qquad \mathrm{NCC}[m,n]=\frac{\sum_{k,l}(g[k,l]-\bar g)(f[m{+}k,n{+}l]-\bar f_{m,n})}{\sqrt{\sum_{k,l}(g[k,l]-\bar g)^2\,\sum_{k,l}(f[m{+}k,n{+}l]-\bar f_{m,n})^2}} . $$

The **sum of squared differences** is small for a good match. The **normalized cross-correlation** subtracts the mean of the template and of the patch and divides by their spreads, so it is the correlation between the two patches, equal to 1 for a perfect match. A five-pixel template $(10,20,40,20,10)$ shows the difference.

| Patch | SSD | NCC |
|---|---:|---:|
| the same | 0 | 1.00 |
| brighter by 30 | 4500 | 1.00 |
| twice the contrast | 2600 | 1.00 |
| a different pattern (40, 20, 10, 20, 40) | 2700 | −0.91 |
{: .keyed}

SSD is fast, but a uniform brightness change is as bad as a different pattern, and doubled contrast almost as bad. NCC is slower and invariant to local average intensity and contrast.

# What the object does to its pixels

Neither score survives the other changes that a real object undergoes, and a template can be only one of them:

- **scale and translation**: the object can be anywhere and at any size;
- **rotation**, in the image plane and out of it, which changes the visible face;
- **illumination**: its intensity, direction and colour;
- **image quality**: noise, blur, compression.

To cover them a template search would have to try every combination of position, scale and rotation, and it would still fail on a cluttered scene: one chair template laid over a living room gives a response map that is "pretty much garbage".

# The keypoint pipeline

The alternative is to stop comparing whole images and compare a few distinctive **keypoints**. The method has four steps:

1. **Detection**: find points that can be found again in another image of the same object.
2. **Description**: describe the neighborhood of each point by a vector, its **local descriptor**, built to be robust to the variations above.
3. **Matching**: pair up similar descriptors across the two images.
4. **Scoring**: decide from the matched points whether the object is there.

Since the descriptors are designed to survive the variations, there is no search over combinations of them. Keypoint methods remain the better tool when accurate geometry matters, when real-time speed is needed, to compress a large image into a few numbers, and because they need no retraining for a new object. Learned descriptors have taken over much of their ground, and the expectation is that future systems combine deep networks with keypoint matching.

> Everything that follows is about making steps 1 and 2 invariant: a detector that returns the same points when the image is scaled or rotated, and a descriptor that returns the same vector.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>Why does SSD fail where NCC works, and when does NCC fail too?</summary>

SSD changes with the overall brightness and contrast of the patch even if the pattern is the same. NCC removes both. NCC still fails under scale, rotation and viewpoint changes, because the pattern itself then differs.
</details>

<details class="qa" markdown="1">
<summary>Why does the keypoint approach not need to try all combinations of scale and rotation?</summary>

The descriptors are constructed to be invariant to them, so matching compares vectors directly instead of searching over transformations of the image.
</details>

<details class="qa" markdown="1">
<summary>What is the difference between instance and class recognition?</summary>

An instance is one specific object seen under varying conditions. A class is a category of objects that differ from each other. Keypoint matching solves the first.
</details>
