---
collection: notes
title: "Neural ODEs"
date: 2026-10-27
excerpt: "Residual networks as the Euler method, a layer defined by an ODE solver, and what depth, memory and invertibility mean once the layers are continuous."
hook: "A residual network is an Euler discretization of a vector field, so a neural ODE keeps the field and lets a solver decide how many steps the depth takes."
goals:
  - write a residual network as an Euler scheme and take its continuous limit
  - explain why the depth of a neural ODE is chosen by the solver and not by the architecture
  - say which maps a neural ODE cannot represent and why
requires:
  - ode
  - initial-value-problem
  - jacobian
  - backpropagation
defines:
  - {id: residual-network, name: "residual network", anchor: def-residual-network}
  - {id: explicit-euler-method, name: "explicit Euler method", anchor: residual-blocks-as-euler-steps}
  - {id: neural-ode, name: "neural ODE", anchor: a-layer-defined-by-a-solver}
tags:
  - Artificial Intelligence
  - AI Models For Physics
---

A deep network transforms its input in a sequence of small steps, and a differential equation describes a state that changes in small steps. This note makes that analogy exact, and the next three build on it.

# Residual blocks as Euler steps

> A **residual network** composes blocks of the form $x_{t+1} = x_t + f(x_t;\theta_t)$, where $f$ is a small network that keeps the dimension of $x$.
{: .definition #def-residual-network title="Residual network"}

The block adds an increment to its input, which is the update of the **explicit Euler method** for an initial value problem with step size $\Delta t = 1$:

$$ x_{t+1} = x_t + \Delta t\, f(x_t, t;\theta) \quad\longrightarrow\quad \frac{dx}{dt} = f(x,t;\theta). $$

If the blocks share their weights, or if $\theta_t$ varies smoothly with $t$, letting the step shrink while the number of blocks grows leaves the dynamics $\dot x = f$ in the limit. The network is then a **vector field**, and the transformation from input to output is the flow of that field over a time interval.

> A residual network with $N$ blocks is one numerical solution of an ODE, computed with $N$ Euler steps of fixed size.
{: .idea}

# A layer defined by a solver

A **neural ODE** takes the vector field as the model and defines the output as the solution of an initial value problem {% cite chen-2018 %}:

$$ x(T) = x_0 + \int_{t_0}^{T} f(x(\tau),\tau;\theta)\,d\tau, \qquad x(t_0) = x_0. $$

The integral is evaluated by a black-box ODE solver. The network that implements $f$ is evaluated many times, with a step size that the solver adapts to the local difficulty of the field. The architecture therefore contains no number of layers: what plays the part of depth is the number of function evaluations the solver spends, and that can be traded for accuracy at test time, with a loose tolerance when speed matters.

Three properties follow from the continuous definition and distinguish the model from a stack of residual blocks.

{% capture t %}
| Property | Residual network | Neural ODE |
|---|---|---|
| Depth | fixed, $N$ blocks | set by the solver and tolerance |
| Time axis | layer index | continuous $t$, any sample times |
| Inverse | not available | integrate backward from $x(T)$ |
| Memory for training | grows with $N$ | constant with the adjoint method |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-resnet-node" caption="A residual network against the continuous model it discretizes." body=t %}

Because $t$ is continuous, the model can be fitted to observations taken at irregular times, which a layered network cannot represent without padding. The map $x_0 \mapsto x(T)$ is invertible, since an ODE with a Lipschitz field can be integrated backward from $T$ to $t_0$ and returns the starting point. The last row of the table is the subject of the next note.

{% include fig.html src="ai-models-for-physics/euler-vs-flow" id="fig-euler-vs-flow" alt="The S-shaped logistic flow in black and three Euler approximations with 4, 8 and 32 steps that approach it as the number of steps grows." caption="A residual network with $N$ blocks is $N$ Euler steps of the field $\dot x = x(1-x)$ over a fixed time. As the blocks get smaller the stack approaches the flow, which is what a neural ODE defines." %}

# What a flow cannot do

Invertibility is also a limitation. Solutions of an ODE with a Lipschitz field cannot cross, because two trajectories that meet at one point would have to share the same future and the same past. The flow of a neural ODE is therefore a homeomorphism of the state space. A map that needs two trajectories to swap places is out of reach, and in one dimension this rules out any map that reverses the order of the points on the line.

> A neural ODE acting on $x \in \mathbb{R}$ cannot represent $x \mapsto -x$, since the trajectories starting at $+1$ and $-1$ would have to cross at $0$.
{: .trap}

The usual remedy is to add dimensions to the state, so that trajectories can pass around each other in the larger space. Stiffness is the practical limitation. A learned field can become stiff during training, the solver then takes many small steps, and the cost per training step grows with no change in the architecture.

# Why this matters for physics

A physical system is itself an initial value problem: the state evolves under a vector field the model has to discover. A neural ODE models that field directly and fits it to measured trajectories. It makes no assumption about the field, and for the same reason it learns no conservation law unless the data forces one. Hamiltonian and Lagrangian neural networks restrict the field to one that conserves energy by construction, and the cost of training such a model is the cost of differentiating through the solver, which the adjoint method makes manageable.

# Recap

<details class="qa" markdown="1">
<summary>Why does a neural ODE have no fixed number of layers?</summary>

Its output is defined by an integral, and the solver chooses how many evaluations of the vector field it needs for a given tolerance. A looser tolerance gives a cheaper and less accurate network from the same weights.
</details>

<details class="qa" markdown="1">
<summary>What does a residual network share with the Euler method?</summary>

Each block adds an increment computed from the current state to that state, which is one Euler step with $\Delta t = 1$. Taking the step to zero with shared weights gives the ODE $\dot x = f(x,t;\theta)$.
</details>

<details class="qa" markdown="1">
<summary>Why can a neural ODE on the real line not learn $x \mapsto -x$?</summary>

The flow of an ODE preserves the order of points on the line because trajectories cannot cross. Mapping $+1$ to $-1$ and $-1$ to $+1$ would force two trajectories through the same point.
</details>
