---
collection: notes
title: "Lagrangian Neural Networks"
date: 2026-10-27
excerpt: "A neural ODE built on a learned Lagrangian: the Euler-Lagrange equations, solved for the acceleration, give the vector field, and the action is the natural loss."
hook: "A Lagrangian network needs no momenta: it learns a scalar $\\mathcal{L}_\\theta(q,\\dot q)$ and the Euler-Lagrange equations turn it into an acceleration."
goals:
  - derive the acceleration of a Lagrangian network from the Euler-Lagrange equations
  - say when the Hessian that has to be inverted exists and how a network keeps it invertible
  - explain why a trajectory loss determines the Lagrangian only up to a gauge
requires:
  - neural-ode
  - adjoint-sensitivity-method
  - hamiltonian-neural-network
  - lagrangian
  - principle-of-least-action
  - generalized-coordinates
defines:
  - {id: lagrangian-neural-network, name: "Lagrangian neural network", anchor: def-lagrangian-neural-network}
  - {id: lagrangian-gauge, name: "Lagrangian gauge freedom", anchor: what-the-data-cannot-fix}
tags:
  - Artificial Intelligence
  - AI Models For Physics
---

The Hamiltonian network needs canonical momenta, and those are often not measured: a camera records positions and velocities. The Lagrangian formulation works in $(q,\dot q)$, so it fits that data, at the price of a matrix inversion {% cite cranmer-2020 %}.

# The principle behind the loss

The action $S[q] = \int_{t_0}^{t_1}\mathcal{L}(q,\dot q,t)\,dt$ is a functional of the path, and the physical path makes it stationary. This has the same shape as the cost functional of the adjoint note, with the Lagrangian as the running loss density, and the Euler-Lagrange equations are the stationarity condition of that functional.

> A **Lagrangian neural network** parameterizes the density, $\mathcal{L}_\theta(q,\dot q)$, and asks that the trajectories of the model satisfy the equations that follow from it.
{: .definition #def-lagrangian-neural-network title="Lagrangian neural network"}

# The vector field from a Lagrangian

The Euler-Lagrange equations $\frac{d}{dt}\nabla_{\dot q}\mathcal{L} = \nabla_q\mathcal{L}$ contain $\ddot q$ once the total derivative is expanded with the chain rule:

$$ (\nabla_{\dot q}\nabla_{\dot q}^{\top}\mathcal{L})\,\ddot q + (\nabla_q\nabla_{\dot q}^{\top}\mathcal{L})\,\dot q = \nabla_q\mathcal{L}. $$

If the Hessian $W = \nabla_{\dot q}\nabla_{\dot q}^{\top}\mathcal{L}$ with respect to the velocities is invertible, solving for the acceleration gives a first-order system on the state $x = (q,\dot q)$, which is the **Lagrangian neural network**:

$$ \dot x = \begin{pmatrix}\dot q \\ \ddot q\end{pmatrix}, \qquad \ddot q = W^{-1}\Big[\nabla_q\mathcal{L}_\theta - (\nabla_q\nabla_{\dot q}^{\top}\mathcal{L}_\theta)\,\dot q\Big]. $$

This field is the one a neural ODE integrates, and training reuses the machinery of the previous notes. The cost is in the field itself: each evaluation needs a gradient, a mixed Jacobian and a Hessian of the network, so second derivatives sit inside every solver step, and the adjoint pass differentiates through them. Forward-mode automatic differentiation is the natural choice for the nested derivatives with respect to a handful of inputs.

> The network outputs one number, but the field it defines contains its second derivatives. The smoothness of the activation matters: a ReLU network has a zero Hessian almost everywhere.
{: .trap}

# Keeping the Hessian invertible

For a mechanical system with kinetic term $\tfrac12\dot q^{\top}M(q)\dot q$ the Hessian is the mass matrix $M$, positive definite. A generic network does not enforce that, and a Hessian that is singular or indefinite at some state makes the field blow up or turn the dynamics non-physical. Two measures are used. A small multiple of the identity is added before inverting, which bounds the condition number but changes the dynamics slightly. Or the Lagrangian is built from structured pieces, a network for a positive-definite mass matrix and one for the potential, which guarantees the property {% cite lutter-2019 %}.

{% capture t %}
| | Neural ODE | Hamiltonian network | Lagrangian network |
|---|---|---|---|
| Learns | the field $f$ | $H_\theta(q,p)$ | $\mathcal{L}_\theta(q,\dot q)$ |
| State | any | $(q,p)$ | $(q,\dot q)$ |
| Conserves | nothing | the learned energy | the symmetries of $\mathcal{L}_\theta$ |
| Extra work | none | one gradient | Hessian solve at every step |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-three-models" caption="Three neural ODE models of a physical system." body=t %}

The conserved quantities of a Lagrangian network come from Noether's theorem: a symmetry of $\mathcal{L}_\theta$ gives a conserved quantity of the learned flow, and a Lagrangian that does not depend explicitly on time conserves its energy function. None of that is imposed unless the architecture builds the symmetry in.

# What the data cannot fix

The equations of motion do not change if $\mathcal{L}$ is multiplied by a constant, or if a total time derivative $dF(q,t)/dt$ is added to it. Two different networks can therefore produce the same field, and a loss that compares trajectories cannot distinguish them. This is the **gauge freedom** of the Lagrangian. The optimizer can wander along these directions without changing the loss, so the learned $\mathcal{L}_\theta$ should be judged by its accelerations and not by its value.

> The harmonic oscillator $\ddot q = -25q$ comes from $\mathcal{L} = \tfrac12\dot q^2 - \tfrac{25}{2}q^2$, and equally from any multiple of it. A trained network can have a different overall scale and still be right.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why does a Lagrangian network need the Hessian with respect to velocities?</summary>

Expanding the Euler-Lagrange equations gives $W\ddot q$ plus lower-order terms, so the acceleration is obtained by inverting $W = \nabla_{\dot q}\nabla_{\dot q}^{\top}\mathcal{L}$. If $W$ is singular the acceleration is not determined.
</details>

<details class="qa" markdown="1">
<summary>Why is the learned Lagrangian determined only up to a gauge?</summary>

Scaling $\mathcal{L}$ or adding a total time derivative leaves the Euler-Lagrange equations unchanged. A loss on trajectories only sees the equations, so the optimizer has no signal to select one member of the family.
</details>

<details class="qa" markdown="1">
<summary>When is a Lagrangian network preferable to a Hamiltonian one?</summary>

When the measurements are positions and velocities and the canonical momenta are unknown, since the Lagrangian state is $(q,\dot q)$. The price is a Hessian inversion at every evaluation of the field.
</details>
