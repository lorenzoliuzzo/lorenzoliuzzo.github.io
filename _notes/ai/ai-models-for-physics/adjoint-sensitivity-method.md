---
collection: notes
title: "The Adjoint Sensitivity Method"
date: 2026-10-27
excerpt: "How to differentiate a loss through an ODE solver: a Lagrange multiplier turns the sensitivity into a second ODE, solved backward in time with constant memory."
hook: "Instead of backpropagating through every solver step, solve one more ODE backward in time, whose state is the sensitivity of the loss to the state."
goals:
  - derive the adjoint equation from a Lagrangian with a multiplier function
  - write the augmented system that returns the gradient with respect to the parameters
  - state what the method saves, and the price paid in accuracy of the gradient
requires:
  - neural-ode
  - ode
  - jacobian
  - backpropagation
defines:
  - {id: adjoint-state, name: "adjoint state", anchor: def-adjoint-state}
  - {id: adjoint-sensitivity-method, name: "adjoint sensitivity method", anchor: def-adjoint-sensitivity-method}
tags:
  - Artificial Intelligence
  - AI Models For Physics
---

Training a neural ODE needs the gradient of a loss with respect to the parameters of the vector field. Backpropagation through an adaptive solver would store every internal step and differentiate each one, so this note derives a cheaper route.

# The cost to differentiate through a solver

Take a loss accumulated along the trajectory, $\mathcal{C} = \int_{t_0}^{T} l(x(\tau),\tau;\theta)\,d\tau$, where $x$ solves $\dot x = f(x,\tau;\theta)$ from $x(t_0)=x_0$. A fit to measured states is of this kind, with $l$ the squared distance to the data. The gradient $d\mathcal{C}/d\theta$ depends on $\theta$ through the whole path of $x$, and the path is produced by a solver that may take hundreds of adaptive steps. Differentiating through the steps stores all of them, so memory grows with the number of function evaluations, and it differentiates the discretization rather than the equation.

> The **adjoint sensitivity method** avoids both costs {% cite chen-2018 %}.
{: .definition #def-adjoint-sensitivity-method title="Adjoint sensitivity method"}

It was developed earlier for sensitivity analysis of differential equations, including the algebraic-constrained case {% cite cao-2003 %}, and a neural ODE is the case where the number of parameters is large and a gradient is needed at every training step.

# The multiplier and the adjoint equation

The trajectory must obey the ODE, so the minimization is constrained. We attach the constraint with a multiplier that is a function of time, $\lambda(\tau)$, written as a row vector:

$$ \mathcal{L} = \int_{t_0}^{T}\Big[\,l + \lambda^{\top}\big(f - \dot x\big)\Big]\,d\tau . $$

On a solution of the ODE the bracket's second term vanishes for any $\lambda$, so $d\mathcal{L}/d\theta = d\mathcal{C}/d\theta$. Differentiating under the integral and integrating the $\dot x_\theta$ term by parts gives

$$ \frac{d\mathcal{L}}{d\theta} = \int_{t_0}^{T}\Big[\,l_\theta + \lambda^{\top} f_\theta + \big(l_x + \lambda^{\top} f_x + \dot\lambda^{\top}\big)\,x_\theta\Big]\,d\tau \;-\; \lambda^{\top}x_\theta\Big|_{t_0}^{T}, $$

with $x_\theta = dx/d\theta$ and subscripts for partial derivatives. The expensive object is $x_\theta$, the sensitivity of the state to the parameters. Because $\lambda$ is free, we choose it so that the coefficient of $x_\theta$ vanishes:

$$ \dot\lambda^{\top} = -\lambda^{\top} f_x - l_x, \qquad \lambda(T) = 0. $$

> This is the **adjoint equation**, and $\lambda$ is the **adjoint state**.
{: .definition #def-adjoint-state title="Adjoint state"}

The terminal condition $\lambda(T)=0$ removes the boundary term at $T$, which is what makes it a terminal value problem. With a loss that also depends on the final state, $\Phi(x(T))$, the condition becomes $\lambda(T)^{\top} = \partial\Phi/\partial x$.

> The adjoint $\lambda(\tau)$ is the sensitivity of the loss to the state at time $\tau$. It obeys a linear ODE, driven by $l_x$ and propagated by the transpose of the Jacobian $f_x$.
{: .idea}

# Running the adjoint backward

With the coefficient of $x_\theta$ gone, no sensitivity of the state is needed, and what remains is

$$ \frac{d\mathcal{C}}{d\theta} = \lambda(t_0)^{\top}\frac{dx_0}{d\theta} + \int_{t_0}^{T}\big(l_\theta + \lambda^{\top} f_\theta\big)\,d\tau . $$

The first term vanishes when $x_0$ does not depend on $\theta$. To evaluate the integral we integrate backward from $T$ to $t_0$ a single augmented system for the state, the adjoint and the running gradient $g(\tau)$:

$$ \dot x = f, \qquad \dot\lambda^{\top} = -\lambda^{\top} f_x - l_x, \qquad \dot g = -\big(l_\theta + \lambda^{\top} f_\theta\big), $$

with $x(T)$ taken from the forward solve, $\lambda(T)=0$ and $g(T)=0$. The value $g(t_0)$ is the gradient. The products $\lambda^{\top} f_x$ and $\lambda^{\top} f_\theta$ are vector-Jacobian products, which reverse-mode automatic differentiation computes without forming a Jacobian. The solver is a black box, nothing from the forward pass is stored except $x(T)$, and memory does not grow with the number of steps.

> Because $\lambda$ is driven by $l_x$ at every time, a loss defined on many sample times is handled by integrating the adjoint in segments and adding a jump $\partial l/\partial x$ at each observation.
{: .rule}

# What it costs

The saving in memory is paid for elsewhere. The backward solve recomputes $x(\tau)$ by integrating the ODE in reverse, and for a dissipative field this reverse integration is unstable, so the recovered trajectory drifts from the forward one. The gradient that results is exact for the continuous equation but only approximately the gradient of the numerical loss that the optimizer is minimizing. Two common remedies keep a trade-off between memory and fidelity: store the forward solution as an interpolant, or save checkpoints and recompute short segments. A third approach designs the backward integrator so that the gradient is the exact gradient of the forward scheme with small memory {% cite matsubara-2021 %}.

{% include fig.html src="ai-models-for-physics/adjoint-reconstruction" id="fig-adjoint-reconstruction" alt="Logarithm of the error of the backward reconstruction against integration time for two damped oscillators and a conservative one. The damped curves rise linearly, the faster one steeply, and the conservative one stays flat." caption="Reconstructing $x(0)$ by integrating backward from a state perturbed by $10^{-6}$. For damped fields the perturbation is amplified exponentially in $T$; for a conservative oscillator it is not. This is the instability that interpolation and checkpoints are meant to avoid." %}

{% capture t %}
| Method | Memory | Gradient of |
|---|---|---|
| Backpropagation through the solver | grows with steps | the discretized loss, exactly |
| Adjoint, backward reconstruction | constant | the continuous loss, approximately |
| Adjoint with interpolation or checkpoints | between the two | the continuous loss, closer |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-adjoint-variants" caption="Memory and fidelity trade-offs of gradient methods for neural ODEs." body=t %}

> If the integral reaches the final state only through $\Phi(x(T))$ and the loss has no running term, the adjoint is homogeneous and starts from $\partial\Phi/\partial x$. Setting $\lambda(T)=0$ there would return a zero gradient.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why can the multiplier $\lambda$ be chosen freely, and what is it chosen to do?</summary>

On a solution of the ODE the constraint term is zero for any $\lambda$, so the loss gradient is unchanged. Choosing $\lambda$ to cancel the coefficient of the expensive sensitivity $dx/d\theta$ removes that quantity from the formula.
</details>

<details class="qa" markdown="1">
<summary>Why does the adjoint method use constant memory, and what does it give up?</summary>

It stores only the final state and recovers the trajectory by integrating backward, so the number of solver steps does not matter. It gives up exactness against the discretized loss, because the backward reconstruction of the state drifts, particularly for dissipative dynamics.
</details>

<details class="qa" markdown="1">
<summary>What happens to the terminal condition when the loss depends on the final state?</summary>

It becomes $\lambda(T)^{\top} = \partial\Phi/\partial x$ at $x(T)$, so the backward solve starts from the gradient of the terminal loss. For a purely running loss the adjoint starts from zero and is switched on by $l_x$.
</details>
