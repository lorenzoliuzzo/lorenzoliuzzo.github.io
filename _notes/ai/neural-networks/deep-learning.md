---
collection: notes
title: "Deep Networks"
date: 2026-10-26
excerpt: "Why depth can replace width, what goes wrong when networks get deep (too many parameters, vanishing gradients) and the remedies the lectures list."
hook: "Depth can buy exponentially many linear pieces from a linear number of units, and what it costs is trainability: more parameters to overfit and a gradient that shrinks layer by layer."
goals:
  - explain with an example why a deep network can need far fewer units than a shallow one
  - bound the back-propagated gradient through many sigmoid layers and say why it vanishes
  - list the remedies for overfitting and for vanishing gradients and what each changes
requires:
  - universal-approximation-theorem
  - back-propagation
  - logistic-function
  - rectified-linear-unit
  - weight-decay
  - overfitting
defines:
  - {id: vanishing-gradient, name: vanishing gradient, anchor: why-deep-networks-are-hard-to-train}
  - {id: dropout, name: dropout, anchor: fighting-overfitting}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

One hidden layer is enough to approximate any continuous function, so why build networks with many? Because enough can be astronomically many. Deep learning means more than one hidden layer, and its depth is the length of the longest path in the network graph. Proofs are in the [reference (PDF)]({{ '/assets/notes/neural-networks/neural-networks-reference/neural-networks-reference.pdf' | relative_url }}).

# Why depth

The approximation theorem says nothing about how many hidden units a given accuracy takes, and more layers can reach the same accuracy with far fewer. The lectures illustrate it with the parity function of $n$ bits. A hidden unit for each input with output 1 needs about $2^{n-1}$ units, while a chain of exclusive-or blocks, each three threshold units, computes it with $3(n-1)$ units in $n-1$ layers.

> The parity example needs a correction. A single hidden layer can also compute parity with $n$ threshold units, each counting whether at least $k$ inputs are on, with output weights $+1,-1,+1,\dots$ (reference, remark). Only the construction of one unit per case is exponential, so parity is not a proof that depth is necessary.
{: .trap}

A function that does separate the two is built by composing a tent. The function $t(x)=2\max(0,x)-4\max(0,x-\tfrac12)$, two ReLU units, maps $[0,1]$ onto itself with a peak at $\tfrac12$. Composing it $k$ times, one layer of two units each, gives a sawtooth with $2^k$ linear pieces from $2k$ units. A network with one hidden layer of $m$ ReLU units has at most $m+1$ pieces on the line, one new break per unit, so it needs at least $2^k-1$ units for the same function (Telgarsky, 2016).

{% include fig.html src="neural-networks/depth-sawtooth" id="fig-sawtooth" alt="Three plots of a sawtooth on the unit interval. At depth 1 a single peak from two ReLU units, at depth 2 two peaks from four units and at depth 3 four peaks from six units." caption="The tent function composed $k$ times: the number of linear pieces doubles with each added layer of two units, while the number of units grows by two." %}

There is a second reason. A complete training set for a Boolean function of $n$ inputs has $2^n$ patterns, and real data sets have far fewer. A function that needs an exponential number of units in one layer cannot be learned from the data we have, while a deep network can represent it with few parameters, if the structure matches.

# Fighting overfitting

More layers mean more adjustable parameters and more room to fit the noise. The lectures list three remedies. **Weight decay** keeps weights small, as in the previous note. **Sparsity constraints** limit the number of hidden units, or require that only a few of them are active on average, as the autoencoder note will use. **Dropout** omits some units at random during training: each hidden or input unit is dropped with probability $p$ for one training step, the network trains as a different thinned network every step, and at test time all units are on, with the outputs scaled by $1-p$.

> Dropout stops units from relying on each other: no unit can count on a particular partner being present, so each has to be useful alone. It behaves like averaging a large family of thinned networks that share weights (Srivastava et al., 2014).
{: .idea}

# Why deep networks are hard to train

Back-propagation passes the error back from layer to layer. With $z_l$ the net input of layer $l$ and $\delta_l$ the derivative of the error with respect to it,

$$ \delta_l=\bigl(W_{l+1}^{\top}\delta_{l+1}\bigr)\odot\varphi'(z_l). $$

If the weights satisfy $\lVert W_l\rVert\le w$ and the slope $\lvert\varphi'\rvert\le c$, then $\lVert\delta_l\rVert\le(cw)^{L-l}\lVert\delta_L\rVert$. The logistic function has $c=\tfrac14$, so unless the weights have norm above 4 the signal shrinks geometrically as it goes back: the gradient in the first hidden layers, where the inputs are processed, **vanishes** and those layers learn very slowly.

A large weight can in principle make up for a small slope, but large weights drive the net input into the flat tails of the activation, where $\varphi'$ is smaller still. The remedy that the lectures give is another activation. The [rectified linear unit]({{ '/notes/ai/neural-networks/activation-functions/' | relative_url }}#the-rectified-family) has slope 1 on the positive side, so $c=1$ for active units and the bound no longer shrinks. Leaky and noisy variants, and the softplus, serve the same end.

Beyond the lectures, weight initialization matched to the layer widths, batch normalization and skip connections attack the same product of factors from other sides; they are the subject of later courses.

# Recap

<details class="qa" markdown="1">
<summary>What does the tent-map example show about depth?</summary>

A network of $k$ layers of two ReLU units computes a function with $2^k$ linear pieces, while a one-hidden-layer network needs at least $2^k-1$ units for as many, so depth can replace an exponential width.
</details>

<details class="qa" markdown="1">
<summary>Why does the gradient shrink in the early layers of a deep sigmoid network?</summary>

Each layer going back multiplies the error by a weight matrix and by an activation slope of at most $\tfrac14$, so unless the weights are large, the factors multiply to something that decays geometrically with depth.
</details>

<details class="qa" markdown="1">
<summary>How does dropout reduce overfitting?</summary>

It removes random units at every step, so units cannot adapt to each other's presence, and the final network acts like an average of many thinned ones.
</details>
