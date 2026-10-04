---
collection: notes
title: "Haar Features and the Integral Image"
date: 2026-10-04
excerpt: "Rectangle-difference features that respond to edges and lines, and the integral image that sums any rectangle from four values, making thousands of features cheap."
hook: "Summing the pixels of any rectangle takes four lookups in the integral image, so thousands of rectangle features cost almost nothing."
goals:
  - compute a two-, three- or four-rectangle Haar feature of an image patch
  - build the integral image in one pass
  - sum any rectangle from four values of the integral image
defines:
  - {id: haar-feature, name: Haar-like feature, anchor: haar-like-features}
  - {id: integral-image, name: integral image, anchor: the-integral-image}
read_time: true
tags:
  - Supervised Learning
  - Recognition and detection
---

The Viola–Jones detector of 2001 finds faces fast enough to run in real time, and it does so with two simple ideas used together. This note has the first two: the features it looks at and the trick that makes them cheap. The next note adds the learning.

# Haar-like features

The detector classifies an image window by the value of simple features that recall Haar basis functions. Each is a difference of rectangle sums, and three kinds are used:

- the **two-rectangle** feature: the difference between the pixel sums in two adjacent rectangles of the same size, side by side or one above the other;
- the **three-rectangle** feature: the sum in the two outer rectangles subtracted from the sum in the centre one;
- the **four-rectangle** feature: the difference between the two diagonal pairs of rectangles.

The value of a feature is the sum of the pixels under its black rectangles minus the sum under its white ones. The kinds respond to edges, straight lines and diagonals, and a few of them describe a face well. The eye region is darker than the cheeks below it (a two-rectangle feature), and the bridge of the nose is brighter than the eyes on both sides (a three-rectangle feature).

The trouble is the number of features. Every size, shape and position of a rectangle pattern inside a $24\times24$ window is a different feature, and there are about 180,000 of them. Evaluating even one means summing many pixels, and a detector must do it for every feature in every window at every scale.

# The integral image

The **integral image** $ii$ is an intermediate representation of the image $i$. Its value at $(x,y)$ is the sum of all the pixels above and to the left, inclusive:

{% include equation.html tex="ii(x,y)=\sum_{x'\le x,\ y'\le y}i(x',y') ." %}

It is computed in one pass over the image, with the running sums $s(x,y)=s(x,y-1)+i(x,y)$ and $ii(x,y)=ii(x-1,y)+s(x,y)$. For example,

{% include equation.html tex="i=\begin{pmatrix}1&12&45&10\\6&5&11&4\\3&7&10&8\\5&9&4&7\end{pmatrix},\qquad ii=\begin{pmatrix}1&13&58&68\\7&24&80&94\\10&34&100&122\\15&48&118&147\end{pmatrix}." %}

The point of the representation is that the sum over **any rectangle** needs only four values. Call the rectangle $D$ and the three regions that complete the picture $A$, $B$ and $C$. Then the corner values are $ii(1)=A$, $ii(2)=A+B$, $ii(3)=A+C$ and $ii(4)=A+B+C+D$.

{% include fig.html src="supervised-learning/integral-image" id="fig-integral" alt="A rectangle divided into four regions, A at the top left, B at the top right, C at the bottom left and a shaded D at the bottom right. The four corners of D are marked 1, 2, 3 and 4. To the right, the formula D equals ii(4) plus ii(1) minus ii(2) minus ii(3)." caption="The sum over the shaded rectangle $D$ is read off four corner values of the integral image: add the far corner and the near corner, subtract the other two." %}

Hence

$$ \sum_Di=ii(4)+ii(1)-ii(2)-ii(3) . $$

In the example above, the sum of the lower-right $3\times3$ block (5, 11, 4, 7, 10, 8, 9, 4, 7) is $147+1-(68+15)=65$, which agrees with adding the nine numbers.

Since neighbouring rectangles share corners, a two-rectangle feature needs 6 values, a three-rectangle one 8 and a four-rectangle one 9, whatever the size of the rectangles. A bigger feature costs no more than a small one, which also makes scaling free: instead of resizing the image into a pyramid, the detector enlarges the features.

> The integral image turns a cost proportional to the area of a rectangle into a constant. It is what makes it affordable to treat all 180,000 features as candidates.
{: .idea}

# Recap

<details class="qa" markdown="1">
<summary>What does a three-rectangle Haar feature compute, and what does it respond to?</summary>

The sum in the two outer rectangles subtracted from the sum in the centre one. It responds to a line or a bar of different brightness from its surroundings, such as the bridge of the nose.
</details>

<details class="qa" markdown="1">
<summary>Why is $D=ii(4)+ii(1)-ii(2)-ii(3)$?</summary>

$ii(4)$ is everything above and left of the far corner, which includes $A$, $B$, $C$ and $D$. Subtracting $ii(2)=A+B$ and $ii(3)=A+C$ removes $B$ and $C$ but removes $A$ twice, so $ii(1)=A$ is added back.
</details>

<details class="qa" markdown="1">
<summary>Why does the cost of a feature not depend on its size?</summary>

Any rectangle sum is four lookups in the integral image, however many pixels the rectangle contains.
</details>
