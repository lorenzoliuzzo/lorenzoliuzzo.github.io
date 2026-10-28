---
collection: notes
title: "Hamiltonian Neural Networks"
date: 2026-10-27
excerpt: "A neural ODE whose vector field is the symplectic gradient of a learned scalar energy, so that the learned flow conserves that energy by construction."
hook: "Learn one scalar, the energy, and take its symplectic gradient: the flow then conserves the learned energy for any weights."
goals:
  - build the vector field of a Hamiltonian network from a scalar network
  - show that the learned energy and the phase-space volume are conserved for any parameters
  - choose between a derivative-matching loss and a trajectory loss
requires:
  - neural-ode
  - adjoint-sensitivity-method
  - hamiltonian
  - phase-space
  - symplectic-integrator
defines:
  - {id: hamiltonian-neural-network, name: "Hamiltonian neural network", anchor: a-scalar-in-place-of-a-field}
  - {id: symplectic-gradient, name: "symplectic gradient", anchor: def-symplectic-gradient}
tags:
  - Artificial Intelligence
  - AI Models For Physics
---

A plain neural ODE represents any vector field, including those with no physics in them. For a conservative system we know more: the field is the symplectic gradient of an energy. Building that in leaves one scalar function to learn {% cite greydanus-2019 %}.

# A scalar in place of a field

Let the state be $x = (q, p)$, with $q, p \in \mathbb{R}^n$ the coordinates and momenta, and let a network output one number, $H_\theta(q,p)$. A **Hamiltonian neural network** defines its dynamics through Hamilton's equations applied to $H_\theta$:

$$ \dot q = \frac{\partial H_\theta}{\partial p}, \qquad \dot p = -\frac{\partial H_\theta}{\partial q}, \qquad\text{i.e.}\qquad \dot x = J\,\nabla_x H_\theta,\quad J = \begin{pmatrix} 0 & I \\ -I & 0 \end{pmatrix}. $$

> The right-hand side is the **symplectic gradient** of $H_\theta$: the ordinary gradient rotated by $J$.
{: .definition #def-symplectic-gradient title="Symplectic gradient"}

Its evaluation needs one derivative of the network with respect to its input, which automatic differentiation provides, and training adds a derivative with respect to the weights on top of it.

# What holds for every set of weights

Two properties follow from the form of the equation alone, so they hold from the first untrained step.

Along a trajectory $\dot H_\theta = \nabla H_\theta^{\top} J\,\nabla H_\theta = 0$, because $J$ is antisymmetric and so $v^{\top}Jv = 0$ for any $v$. The learned energy is conserved. The divergence of the field is $\partial_q\partial_p H - \partial_p\partial_q H = 0$, so by Liouville's theorem the flow preserves phase-space volume.

> The network cannot output a spiral. Energy drift and shrinking phase-space volume, the usual failures of a generic neural ODE on a conservative system, are excluded by the architecture.
{: .idea}

The statement concerns $H_\theta$. If the data come from a true energy $H$, the model recovers it up to an additive constant, because only the gradient enters the loss, and only if the training data excite the region where the model is evaluated.

# Two ways to train

With measured states $x_i$ and their time derivatives $\dot x_i$, a **derivative-matching loss** compares the field to the data directly, with no ODE solve:

$$ \mathcal{C}_{\text{field}} = \sum_i \big\| J\,\nabla H_\theta(x_i) - \dot x_i \big\|^2 . $$

When only trajectories are available, or the derivatives are noisy, a **trajectory loss** integrates the model from an initial state and compares the predicted states to the data, which is a neural ODE problem and uses the adjoint method of the previous note. The first is cheap and local; the second constrains the long-time behaviour that the first does not.

{% capture t %}
| Loss | Needs | Solver in training | Fits |
|---|---|---|---|
| Derivative matching | $\dot x_i$ | no | the field at sample points |
| Trajectory | states at times $t_i$ | yes, with adjoint | the flow over an interval |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-hnn-losses" caption="Two ways to fit a Hamiltonian network." body=t %}

# A check against a known answer

For a unit-mass oscillator of angular frequency $\omega$ the data are $q = \sin\omega t$ and $p = \cos\omega t$, with $\dot q = \omega p$ and $\dot p = -\omega q$. The energy $H = \tfrac{\omega}{2}(q^2+p^2)$ gives $\partial H/\partial p = \omega p$ and $-\partial H/\partial q = -\omega q$, which are the derivatives. A small network with one tanh layer of 16 units, fitted to 64 samples with $\omega = 2\pi$, has to represent this quadratic bowl, so the learned $H_\theta$ can be plotted and compared with $\pi(q^2+p^2)$ up to a constant. The comparison tells whether the loss reached zero because the energy is right or because the network learned the sampled circle only.

> The data lie on a single circle of constant energy. They fix the gradient of $H$ on that circle but say little about its value off it, so a model can match them well and still be wrong between circles.
{: .trap}

# The integrator matters

The continuous flow conserves $H_\theta$, and a numerical solution does so only up to the integrator. A generic Runge-Kutta method lets the energy drift slowly. A symplectic integrator keeps a nearby modified energy bounded for long times, and is the better choice when the model is evaluated far beyond the training interval.

{% include fig.html src="ai-models-for-physics/energy-drift" id="fig-energy-drift" alt="Energy of a harmonic oscillator against time: explicit Euler rises quickly out of the plot, RK4 stays slightly below 0.5, and symplectic Euler oscillates in a narrow band around 0.5." caption="Energy of a unit oscillator integrated with the same step $h=0.2$. Explicit Euler gains energy, RK4 loses it slowly, and symplectic Euler stays in a bounded band, which is why it suits a conservative learned field." %}

The architecture also assumes canonical coordinates, a conservative system and no friction or driving. Dissipation breaks the antisymmetric structure, so models for open systems add a learned dissipative term to $J\nabla H_\theta$.

# Recap

<details class="qa" markdown="1">
<summary>Why does a Hamiltonian network conserve energy even before training?</summary>

Its field is $J\nabla H_\theta$ and $J$ is antisymmetric, so the derivative of $H_\theta$ along the flow is $\nabla H_\theta^{\top} J \nabla H_\theta = 0$ for any weights. Training changes which energy is conserved, not whether one is.
</details>

<details class="qa" markdown="1">
<summary>When is a trajectory loss preferable to a derivative-matching loss?</summary>

When the time derivatives are not measured or are noisy, and when long-time accuracy matters. The trajectory loss needs an ODE solve and the adjoint method; the derivative-matching loss does not but only constrains the field at the sampled states.
</details>

<details class="qa" markdown="1">
<summary>What can a model trained on one orbit not tell you about the true energy?</summary>

Its value away from the orbit, since the data fix only the gradient where they were sampled, and the additive constant, since the dynamics depend on gradients alone.
</details>
