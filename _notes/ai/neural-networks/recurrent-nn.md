---
collection: notes
title: "Recurrent Neural Networks"
date: 2026-10-27
excerpt: "A hidden state carried through time, backpropagation through time, why the gradient vanishes or explodes, and how gated units keep it alive."
hook: "A recurrent network reuses one set of weights at every step and carries a hidden state forward; the same product of Jacobians that lets it remember also makes its gradient vanish or explode."
goals:
  - write the update of a simple recurrent network and unroll it in time
  - explain vanishing and exploding gradients through a product of Jacobians
  - describe how the gates of an LSTM keep a path along which the gradient does not shrink
requires:
  - multilayer-perceptron
  - vanishing-gradient
defines:
  - {id: recurrent-neural-network, name: recurrent neural network, anchor: a-state-that-carries-the-past}
  - {id: backpropagation-through-time, name: backpropagation through time, anchor: def-backpropagation-through-time}
  - {id: lstm, name: long short-term memory, anchor: gates}
  - {id: gradient-clipping, name: gradient clipping, anchor: vanishing-and-exploding-gradients}
read_time: true
tags:
  - Artificial Intelligence
  - Neural Networks
---

A feed-forward network sees one fixed-size input and forgets it. Sequences such as text, audio and sensor traces have variable length and an order that matters, and handling them needs a network with memory.

# A state that carries the past

A **recurrent neural network** processes a sequence $x_1,\dots,x_T$ one element at a time and keeps a hidden state $h_t$ that summarizes what it has seen:

$$ h_t=\tanh\big(W_hh_{t-1}+W_xx_t+b\big),\qquad \hat y_t=g(W_yh_t+c). $$

The same weights $W_h,W_x,W_y$ are used at every step, so the number of parameters does not depend on the length of the sequence, and the state is the only channel through which the past reaches the present. The simple form above is Elman's network {% cite elman-1990 %}. Which outputs are used depends on the task: the last $\hat y_T$ for classifying a whole sequence, every $\hat y_t$ for labelling each element, or a decoder that generates a new sequence from the final state.

# Unrolling in time

To train it, write out the loop. The network over $T$ steps is a feed-forward network with $T$ layers, one per time step, with the same weights in every layer.

> **Backpropagation through time** is ordinary backpropagation on this unrolled graph, with the gradients of the shared weights summed over steps.
{: .definition #def-backpropagation-through-time title="Backpropagation through time"}

For long sequences the cost and memory grow with $T$, so training is often truncated: gradients are propagated back only a fixed number of steps.

# Vanishing and exploding gradients

The gradient of the loss at step $T$ with respect to an earlier state $h_k$ is a product of one-step Jacobians,

$$ \frac{\partial h_T}{\partial h_k}=\prod_{t=k+1}^{T}\operatorname{diag}\big(\varphi'(z_t)\big)\,W_h. $$

If the largest singular value of $W_h$ times the largest derivative of the activation is below one, the norm of this product shrinks like a power of $T-k$, and the influence of distant inputs vanishes. If it is above one, the product can grow without bound. Hochreiter identified this in 1991 {% cite hochreiter-1991 %}. Memory over long spans is therefore exactly what plain recurrent networks learn badly.

> Exploding gradients have a cheap remedy: **gradient clipping** rescales the gradient whenever its norm exceeds a threshold. Vanishing gradients have no such remedy, because a gradient that has shrunk to nothing carries no direction to rescale. That needs a change of architecture.
{: .idea}

# Gates

The long short-term memory unit adds a cell state $c_t$ that is updated additively under the control of gates, each a sigmoid of the current input and previous state {% cite hochreiter-schmidhuber-1997 %}:

$$ c_t=f_t\odot c_{t-1}+i_t\odot\tilde c_t,\qquad h_t=o_t\odot\tanh(c_t). $$

The forget gate $f_t$ decides how much of the old cell to keep, the input gate $i_t$ how much of the new candidate $\tilde c_t$ to write, and the output gate $o_t$ how much of the cell to expose. The point is the derivative $\partial c_t/\partial c_{t-1}=f_t$: when the forget gate is near one, the gradient flows back along the cell with almost no shrinkage, over hundreds of steps. The gated recurrent unit merges the gates and the states into a lighter design with similar behaviour {% cite cho-2014 %}.

{% capture t %}
| Model | State | Gradient along time |
|---|---|---|
| simple RNN | $h_t$ | product of $\operatorname{diag}(\varphi')W_h$, shrinks or grows |
| LSTM | $h_t$ and cell $c_t$ | cell path multiplied by $f_t$, close to 1 when open |
| GRU | $h_t$ | blends the old and the new state through an update gate |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-recurrent" caption="Three recurrent designs and how the gradient travels back through time in each." body=t %}

Recurrent networks have a second limit that gating does not fix: step $t$ cannot be computed before step $t-1$, so training cannot be parallelized over time. Attention-based models avoid this by letting every position look at every other directly, as in [Transformers]({{ '/notes/ai/supervised-learning/transformers/' | relative_url }}).

Unrolling in time turns the recurrent network into a deep one that shares its weights.

{% include fig.html src="neural-networks/unrolled-rnn" id="fig-unrolled-rnn" alt="Five copies of the same cell in a row, linked by the hidden state, with inputs below, outputs above and a dashed backward path." caption="A recurrent network unrolled over five steps, with gradient flow drawn backwards. The forward pass reuses the same weights at each step; the backward gradient crosses one Jacobian per step, hence the vanishing or exploding behaviour." %}

# Recap

<details class="qa" markdown="1">
<summary>Why does the gradient of a simple RNN vanish over long sequences?</summary>

It is a product of one Jacobian per step, each containing the recurrent weights and the activation derivative. When their combined scale is below one, the product shrinks exponentially in the number of steps.
</details>

<details class="qa" markdown="1">
<summary>What does the LSTM change so that the gradient survives?</summary>

The cell state is updated additively and scaled by the forget gate, so the derivative along the cell is the gate value, which can stay close to one, instead of a product of weight matrices and squashing derivatives.
</details>
