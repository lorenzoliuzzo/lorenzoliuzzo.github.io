---
collection: notes
title: "Bag of Visual Words"
date: 2026-10-04
excerpt: "Treating an image as an orderless bag of local patches: cluster the descriptors into a visual vocabulary, encode each image as a histogram of words, and feed it to a classifier."
hook: "Cluster the descriptors, call the centres words, and an image becomes a histogram of words: a fixed-length vector for a classifier, at the price of forgetting where things are."
goals:
  - build a visual vocabulary by clustering local descriptors
  - encode an image as a histogram of visual words
  - say what the representation gains and what it gives up
requires:
  - local-descriptor
  - sift-descriptor
defines:
  - {id: bag-of-visual-words, name: bag of visual words, anchor: from-text-to-images}
  - {id: visual-vocabulary, name: visual vocabulary, anchor: learning-the-vocabulary}
read_time: true
tags:
  - Supervised Learning
  - Recognition and detection
---

Matching keypoints recognizes a specific object, but not *a dog*: no two dogs share keypoints. The fix borrows a trick from text retrieval and turns the whole image into one fixed-length vector that an ordinary classifier can use.

# From text to images

To represent the topic of a document compactly, a surprisingly good method throws away the word order and keeps the frequency of each word of a dictionary. A speech with many occurrences of "Iraq" and "terrorists" is about one thing, one with "Cuba" and "missiles" about another, without any grammar. Fei-Fei and Perona carried the idea over to images: an object is a **bag of visual words**, an unordered collection of local patches. Because it ignores where the patches are, the representation works for deformable objects (the same rider in any pose) and for whole classes (any dog, any parrot).

# Learning the vocabulary

The method has two phases, one run once on a training set and one for every image. The first phase builds the vocabulary.

1. **Extract local features**: sample patches from the training images, from a keypoint detector or a dense grid, and compute a descriptor such as SIFT for each. The result is a large cloud of points in descriptor space.
2. **Cluster** the cloud. Similar patches, such as the corner of a window or a bit of fur, fall close together. The standard algorithm is $k$-means, which looks for $K$ centres $\mathbf{m}\_1,\dots,\mathbf{m}\_K$ minimizing the squared distance from each descriptor to its nearest centre,
   $$ D(X,M)=\sum_{k=1}^{K}\ \sum_{\mathbf{x}\in\text{cluster }k}\lVert\mathbf{x}-\mathbf{m}_k\rVert^2 . $$
   It alternates assigning each descriptor to the nearest centre and moving each centre to the mean of its descriptors (see [the clustering algorithms]({{ '/notes/ai/unsupervised-learning/cluster-analysis/algorithms/' | relative_url }})).

The $K$ cluster centres are the **visual words**, and together they are the **visual vocabulary** (also the codebook). Looked at as image patches, a vocabulary learned from pictures of cars is made of recognizable parts: wheels, windows, headlights. Learning it uses no labels.

The size $K$ is a hyper-parameter. Too few words merge different patches and the histograms lose power to discriminate. Too many split similar patches among different words, and the histograms become sparse and noisy.

# Encoding an image

For a new image, extract its descriptors, replace each by its **nearest visual word**, and count how many times each word occurs. The result is a histogram of length $K$, usually normalized to sum to 1 so that images with more or fewer patches are comparable. Any classifier can then be trained on the histograms: nearest neighbour, SVM, naive Bayes.

{% include fig.html src="supervised-learning/visual-vocabulary" id="fig-vocabulary" alt="Left: a cloud of points in a two-dimensional descriptor space in three clusters, blue, orange and violet, each with a ringed centre labelled W1, W2 and W3. Right: a bar chart for one image with three bars labelled W1, W2 and W3 of heights 0.4, 0.2 and 0.4." caption="Clustering descriptors gives three visual words. An image whose ten descriptors fall four, two and four times on them is the vector $(0.4,\,0.2,\,0.4)$." %}

Images of the same class share their characteristic words in similar proportions: the histogram of a car has tall bars on the wheel and window words, which is what the classifier learns.

> The histogram forgets *where* each patch was. A face and a scrambled face made of the same patches give the same vector. The loss is what buys tolerance to deformation, and it can be partly repaired by computing histograms over a grid of image regions and joining them.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is the vocabulary learned with k-means and no labels?</summary>

Only the grouping of similar descriptors is needed, not what they mean. Labels enter later, when a classifier is trained on the histograms.
</details>

<details class="qa" markdown="1">
<summary>What does the choice of $K$ trade off?</summary>

A small $K$ merges distinct patches and weakens the representation. A large $K$ splits similar patches and makes the histograms sparse and unstable.
</details>

<details class="qa" markdown="1">
<summary>Why can the representation handle deformable objects?</summary>

It keeps only which parts occur and how often, not their arrangement, so the same parts in a different pose give nearly the same histogram.
</details>
