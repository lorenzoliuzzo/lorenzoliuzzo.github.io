---
collection: notes
title: "Threshold Logic Units"
date: 2026-10-26
excerpt: "The McCulloch-Pitts unit as a hyperplane, which Boolean functions one unit can compute, how two layers compute all of them, and the delta rule that finds the weights when they exist."
hook: "One threshold unit cuts the input space with a single hyperplane, so it computes exactly the linearly separable functions; the delta rule finds the cut whenever it exists and never settles when it does not."
goals:
  - write a threshold unit as a hyperplane and read its output for a point
  - decide linear separability with the convex hull criterion and say why the biimplication fails
  - apply the delta rule online and in batch, and say when it terminates
  - build a two-layer network for any Boolean function
requires:
  - neural-network
  - network-input-function
  - fixed-learning-task
  - artificial-neuron
defines:
  - {id: threshold-logic-unit, name: threshold logic unit, anchor: the-unit-as-a-hyperplane}
  - {id: linear-separability, name: linear separability, anchor: linear-separability}
  - {id: delta-rule, name: delta rule, anchor: the-delta-rule}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

The threshold logic unit is the smallest network that learns: one unit, a weighted sum and a step. Everything it can and cannot do is geometric, and the limit it hits is the reason networks have layers. Proofs are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# The unit as a hyperplane

A **threshold logic unit** (TLU, the McCulloch-Pitts neuron) has inputs $x_1,\dots,x_n$, weights $w_1,\dots,w_n$ and a threshold $\theta$. It is the [unit of the introduction]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}#a-network-is-a-graph) with a weighted sum, a step at $\theta$ and the identity:

$$ y=\begin{cases}1 & \text{if } w\cdot x\ge\theta,\\ 0 & \text{otherwise.}\end{cases} $$

The conjunction $x_1\wedge x_2$ is the unit with $w=(1,1)$ and $\theta=\tfrac32$: only the input $(1,1)$ reaches the threshold. The implication $x_1\to x_2$ is $w=(-2,2)$ and $\theta=-1$, which fails only at $(1,0)$.

> **Rule** $y=1\iff w\cdot x\ge\theta$  
> **Boundary** hyperplane $w\cdot x=\theta$  
> **Normal** $w$, towards the 1 side  
> **Distance from 0** $\theta/\lVert w\rVert$
{: .margin .spec}

The equation $w\cdot x=\theta$ describes a line when $n=2$, a plane when $n=3$ and a hyperplane in general. The vector $w$ is normal to it and points to the side where $w\cdot x-\theta$ is positive, and the unit outputs 1 on that side and on the hyperplane itself. To classify a point, evaluate that one number.

{% include fig.html src="neural-networks/tlu-boolean" id="fig-boolean" alt="Three unit squares with corners 00, 01, 10 and 11. For the conjunction one line separates the filled corner 11 from the other three. For the implication one line separates the open corner 10 from the other three. For the biimplication the filled corners 00 and 11 and the open corners 01 and 10 sit on two crossing diagonals, and no line separates them." caption="Three Boolean functions as points of the unit square. The first two are one line each. The third, the biimplication, has its filled points on one diagonal and its open points on the other, and the diagonals cross." %}

> A threshold unit is a hyperplane with a normal vector. Learning its weights means moving that hyperplane.
{: .idea}

# Linear separability

Two sets of points are **linearly separable** when some hyperplane has the first set on one side and the second on the other, with points allowed on it as the unit permits. A unit computes a Boolean function exactly when the points with output 1 and those with output 0 are linearly separable. A test that needs no search uses the **convex hull** of a set, the smallest convex set containing it: two finite sets are linearly separable if and only if their convex hulls are disjoint.

For the biimplication $x_1\leftrightarrow x_2$ the hull of $\{(0,0),(1,1)\}$ and the hull of $\{(0,1),(1,0)\}$ are the two diagonals, and they meet at $(\tfrac12,\tfrac12)$. No unit computes it. Of the 16 Boolean functions of two inputs, 14 are separable and the two failures are the biimplication and the exclusive or. The share collapses with $n$: 104 of the 256 functions of three inputs, 1,882 of 65,536 for four (OEIS A000609).

> A unit with chosen weights that misclassifies a point proves nothing about separability. The question is whether some hyperplane works, not whether this one does.
{: .trap}

# Two layers compute everything

A hidden layer changes the coordinates so that the same points become separable. The biimplication is true when both inputs are true or both false. Let $h_1=x_1\wedge x_2$ and $h_2=\neg x_1\wedge\neg x_2$, each a TLU ($h_2$ has $w=(-1,-1)$ and $\theta=-\tfrac12$), and let $y=h_1\vee h_2$ be a third unit with $w=(1,1)$ and $\theta=\tfrac12$. In the $(h_1,h_2)$ plane the inputs $(0,1)$ and $(1,0)$ land on the same point, and one line separates it from the other two.

{% include fig.html src="neural-networks/tlu-network" id="fig-network" alt="Left, the input square with two parallel lines, one cutting off the corner 11 and one cutting off the corner 00. Right, the plane of the two hidden outputs with filled points at 01 and 10 and an open point at 00, separated by one line." caption="The hidden layer moves the four inputs to new coordinates. The inputs 01 and 10 coincide in the hidden plane, and there a single line works." %}

The construction generalizes. For a Boolean function of $n$ inputs, take one hidden unit for each input vector $a$ with output 1: weights $w_i=2a_i-1$ and threshold $\theta=\sum_i a_i$ make it fire at $a$ and nowhere else on $\{0,1\}^n$. The output unit is a disjunction of these. So two layers of TLUs compute every Boolean function. The cost is up to $2^n$ hidden units, which the deep-learning note returns to when it asks why depth helps.

# The delta rule

Drawing lines by hand works for two or three inputs and fails beyond. The **delta rule** (Widrow and Hoff) finds $w$ and $\theta$ from the training patterns $(x,o)$ of a [fixed learning task]({{ '/notes/ai/neural-networks/introduction/' | relative_url }}#what-learning-means). Start from arbitrary values and, whenever the output $y$ differs from the desired $o$, change

$$ \theta\leftarrow\theta-\eta\,(o-y),\qquad w_i\leftarrow w_i+\eta\,(o-y)\,x_i, $$

with learning rate $\eta>0$. Patterns that are right change nothing. The signs push $w\cdot x-\theta$ the right way: after a correction it has moved by $\eta(o-y)(\lVert x\rVert^2+1)$, up when the unit said 0 for a 1 and down for the opposite.

> The number of wrong outputs is flat almost everywhere, so its gradient says nothing. The rule is instead gradient descent on the distance of a wrong pattern from the threshold, $e=\sum_{\text{wrong}}\lvert w\cdot x-\theta\rvert$, which does slope towards the answer.
{: .derive}

The corrections can be applied after every pattern (**online**) or summed over a pass through all patterns, an epoch, and applied once (**batch**). Both terminate, and when they do the weights solve the task.

# Convergence, and where it ends

If the 0 patterns and the 1 patterns are linearly separable, online and batch training stop after finitely many corrections. If they are not, the corrections never stop: the same wrong weights come back, and the error oscillates.

{% include fig.html src="neural-networks/tlu-training" id="fig-training" alt="Number of corrections per epoch over twelve epochs. For the conjunction it falls from two through three, three, two and one to zero at epoch six and stays there. For the biimplication it rises to four by epoch three and stays at four." caption="Online delta rule, $\eta=1$, starting from $w=(0,0)$ and $\theta=0$. The conjunction is solved after five epochs. The biimplication is corrected four times in every epoch." %}

The proof is the perceptron convergence argument, in the reference. After $k$ corrections the weights have gained alignment with a solution at least in proportion to $k$ but have grown in length at most like $\sqrt k$, and alignment cannot exceed length, so $k$ is bounded. The coding of the inputs matters for speed. With false $=0$, an input at 0 contributes nothing to $w_i$, so a correction cannot touch that weight. ADALINE codes false as $-1$ and true as $1$, so every weight moves at every correction.

One unit can be trained quickly and surely, but it computes only separable functions. A network of TLUs computes all functions and cannot be trained this way: the hidden units have no desired values, and many different hidden functions solve the same task. That gap is what the multi-layer note fills with smooth units and gradients.

# Recap

<details class="qa" markdown="1">
<summary>Why can no single threshold unit compute the biimplication, whatever its weights?</summary>

The unit's boundary is one hyperplane, so its 1 and 0 sets would have to be separable. The two sets have crossing diagonals as convex hulls, which share the point $(\tfrac12,\tfrac12)$.
</details>

<details class="qa" markdown="1">
<summary>How does a hidden layer make the biimplication computable?</summary>

It maps the four inputs to new coordinates, here $(h_1,h_2)$, where the two inputs that should give 1 together and the two that give 0 collapse to one point. The labels are then separable by one line.
</details>

<details class="qa" markdown="1">
<summary>Why does the delta rule stop for the conjunction and not for the biimplication?</summary>

Corrections occur only on wrong patterns and are bounded in number when a separating hyperplane exists. Without one, every choice of weights misclassifies some pattern, so corrections keep arriving.
</details>

<details class="qa" markdown="1">
<summary>Why cannot the delta rule train the hidden layer of a two-layer network?</summary>

It needs a desired output for each unit it corrects, and the training set gives desired values only for the output units.
</details>
