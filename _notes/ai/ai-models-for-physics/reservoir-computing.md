---
title: Reservoir Computing
date: 2026-08-24
collection: notes
read_time: true
toc: true
toc_sticky: true
tags:
- Artificial Intelligence
- AI Models For Physics
goals:
- write the update of an echo state network and its linear readout
- state the echo state property and the role of the spectral radius
- fit the readout by ridge regression and judge a free-running forecast
defines:
- id: reservoir-computing
  name: reservoir computing
  anchor: a-recurrent-network-that-is-not-trained
- id: echo-state-property
  name: echo state property
  anchor: def-echo-state-property
requires:
- recurrent-neural-network
- ridge-regression
- eigenvalue
- initial-value-problem
excerpt: A fixed random recurrent network whose state is read out by a linear layer, the echo state property that makes it usable, and a chaotic forecast.
hook: 'A reservoir is a recurrent network that is never trained: random fixed weights turn the input history into a rich state, and only a linear readout is fitted.'
---

Training a recurrent network means differentiating through time, which is expensive and unstable. Reservoir computing removes the problem by not training the recurrent part at all {% cite jaeger-2004 %}.

# A recurrent network that is not trained

An **echo state network**, the standard form of **reservoir computing**, has a state $r_t\in\mathbb{R}^N$ driven by the input $u_t$:

$$ r_{t+1} = \tanh\big(W r_t + W_{\text{in}}u_t\big), \qquad y_t = W_{\text{out}}\,[\,r_t;1\,]. $$

The matrices $W$ and $W_{\text{in}}$ are drawn at random once and kept fixed. Only the readout $W_{\text{out}}$ is learned. The reservoir plays the role of a large, fixed bank of nonlinear features of the whole input history: each unit is a different mixture of recent inputs, and a linear readout can pick out whichever combination is useful.

> The reservoir is a physical system with fading memory, and the readout is a measurement of it. This is why reservoirs can be built from materials as well as software: any system with rich enough dynamics can serve.
{: .idea}

# The echo state property

For the readout to be a function of the input and not of the arbitrary initial state, the state must forget where it started.

> The **echo state property** asks that two reservoir trajectories driven by the same input converge to each other whatever their initial states.
{: .definition #def-echo-state-property title="Echo state property"}

A sufficient condition for the tanh map is that the matrix norm $\|W\|_2<1$, which makes the update a contraction. A looser condition, the spectral radius $\rho(W)<1$, is necessary for the property in the absence of input and is the quantity people tune, with the weights rescaled to a target $\rho$.

The spectral radius sets the memory. For $\rho$ small the reservoir forgets quickly and tracks only the present input. As $\rho$ approaches one the memory lengthens, and past it the input no longer determines the state and the reservoir becomes unusable. The best value for a task usually lies just below the edge, close to the order-chaos boundary, which is the same place a critical system keeps its longest correlations.

# Training is linear regression

Run the reservoir on the training input, collect the states into a matrix $R$ with one row per time step, and let $Y$ hold the targets. The readout minimises the squared error plus a penalty, which is ridge regression:

$$ W_{\text{out}} = \arg\min_W\ \|RW-Y\|^2+\beta\|W\|^2 = (R^{\top}R+\beta I)^{-1}R^{\top}Y. $$

This is one linear solve, with no backpropagation through time and no vanishing gradient. The penalty $\beta$ guards against fitting the noise of a state vector that has far more entries than the data constrain. The first few hundred steps, the washout, are discarded so that the state has forgotten its initial condition.

# A chaotic forecast

The standard test is a chaotic system. Train the readout to predict the next sample of the Lorenz series, then close the loop: feed each prediction back as the next input and let the reservoir run freely. A chaotic orbit cannot be followed forever, since any small error grows as $e^{\lambda t}$ with the Lyapunov exponent $\lambda$, so the figure of merit is how many Lyapunov times the forecast stays on the true orbit. The method was extended to a spatiotemporally chaotic partial differential equation {% cite pathak-2018 %}.

{% include fig.html src="ai-models-for-physics/esn-forecast" id="fig-esn-forecast" alt="Time series of the Lorenz x coordinate in blue and a dashed orange free-running forecast that overlays it for about five time units before the two drift apart." caption="A 200-unit echo state network with a ridge readout, trained on the Lorenz series and then run freely. This one reservoir follows the orbit for about five Lyapunov times; the validity time varies strongly with the random draw." %}

The caption's last sentence is the honest part. Across random draws of the same reservoir the forecast time changes a great deal, so a result from one draw, as in the figure, says what the method can do and not what it will do. Papers average over many reservoirs.

{% capture t %}
| | Trained RNN | Echo state network |
|---|---|---|
| Parameters trained | all, through time | readout only |
| Training cost | backpropagation through time | one linear solve |
| Main difficulty | vanishing and exploding gradients | choosing $\rho$, size and input scale |
| Memory | learned | set by the spectral radius |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-esn-vs-rnn" caption="An echo state network against a trained recurrent network." body=t %}

> A reservoir with $N$ units and a readout fitted on $T$ samples needs $T$ well above $N$, or the ridge term carries the fit. Too small a $\beta$ gives an accurate one-step predictor whose free run explodes.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>What is fixed and what is trained in an echo state network?</summary>

The recurrent weights $W$ and input weights $W_{\text{in}}$ are random and fixed. Only the linear readout $W_{\text{out}}$ is trained, by ridge regression on the collected states.
</details>

<details class="qa" markdown="1">
<summary>What does the echo state property guarantee, and how is it enforced in practice?</summary>

That the state is determined by the input history and not by the initial state. In practice the recurrent matrix is rescaled to a spectral radius a little below one.
</details>

<details class="qa" markdown="1">
<summary>Why is a one-step training error a poor measure of a reservoir forecast?</summary>

In the free run the model's own errors are fed back and amplified by the chaotic dynamics. The relevant measure is how many Lyapunov times the forecast stays close to the true orbit.
</details>
