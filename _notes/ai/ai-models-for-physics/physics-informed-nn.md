---
collection: notes
title: Physics-Informed Neural Networks
date: 2026-07-31
excerpt: A network trained on data and on the residual of a differential equation at collocation points, the loss terms and their balance, and hard constraints.
read_time: true
toc: true
toc_sticky: true
tags:
- Artificial Intelligence
- AI Models For Physics
goals:
- write the loss of a physics-informed network and name its three terms
- explain why the residual term constrains the solution where there are no labels
- say why the loss weights matter and how a hard constraint removes one term
defines:
- id: physics-informed-neural-network
  name: physics-informed neural network
  anchor: def-physics-informed-neural-network
- id: collocation-point
  name: collocation point
  anchor: the-loss-has-three-terms
requires:
- pde
- ode
- backpropagation
- initial-value-problem
hook: A physics-informed network is fitted to data and also asked to satisfy a differential equation at points where there is no data at all.
---

A network fitted to a handful of measurements of a physical field says nothing reliable between them. If the field obeys a known differential equation, that equation is extra information, and it can enter the loss {% cite raissi-2019 %}.

# A network as the trial solution

> A **physics-informed neural network** (PINN) represents the unknown solution $u(x,t)$ of a differential equation by a network $u_\theta(x,t)$.
{: .definition #def-physics-informed-neural-network title="Physics-informed neural network"}

Because $u_\theta$ is a composition of smooth functions, its derivatives with respect to the inputs, $\partial_tu_\theta$, $\partial_x^2u_\theta$ and so on, are exact and are obtained by automatic differentiation, the same procedure that gives the derivatives with respect to the weights. No mesh and no finite differences are involved. A differential operator $\mathcal{N}$ applied to $u_\theta$ is another function of the inputs, and the equation $\mathcal{N}[u]=0$ becomes a statement that this function should vanish.

> The derivative with respect to the input and the derivative with respect to the weights are two uses of one tool. Training differentiates the equation's residual with respect to $\theta$, so second derivatives in space appear inside a first derivative in the weights.
{: .idea}

# The loss has three terms

Let $\mathcal{N}[u]=0$ hold on a domain, with initial or boundary data $u=g$ on its edge, and let measurements $u_i$ be available at some points $x_i$. The loss is a weighted sum,

$$ \mathcal{C}(\theta)=w_{\text{d}}\,\frac1{N_{\text{d}}}\sum_i\big|u_\theta(x_i)-u_i\big|^2 + w_{\text{r}}\,\frac1{N_{\text{r}}}\sum_j\big|\mathcal{N}[u_\theta](x_j)\big|^2 + w_{\text{b}}\,\frac1{N_{\text{b}}}\sum_k\big|u_\theta(x_k)-g(x_k)\big|^2. $$

The first term fits the data. The second is the **residual** of the equation, evaluated at **collocation points** $x_j$ scattered through the domain, and these points need no labels because the target is zero. The third enforces the initial and boundary conditions. The residual term is what distinguishes a PINN from a regression: it reaches into regions with no measurements.

# What the residual term buys

Take $u''+u=0$ with five noisy measurements of $\sin t$ on $[0,2]$, and ask for the solution on $[0,6]$. A flexible model fitted to the data alone is free to do anything outside $[0,2]$. Adding the residual $u''+u$ at points all the way to $t=6$ removes that freedom: among the functions that match the data, the loss prefers one that obeys the equation. The figure uses a degree-14 polynomial in place of a network so that the minimiser is a single linear solve. The loss, the collocation points and the effect are the ones a PINN has, and with a network only the solver changes.

{% include fig.html src="ai-models-for-physics/pinn-fit" id="fig-pinn-fit" alt="A sine curve on the interval zero to six, five noisy points on zero to two, a fit to the data alone that wiggles and flattens beyond two, and a fit with the equation residual that follows the sine to six." caption="The same model fitted to five noisy points (dots), with and without the residual of $u''+u=0$ at 61 collocation points on $[0,6]$. The data alone fix the fit only where the points are; the equation carries it to the end of the interval." %}

Two limits of this picture are worth saying. The residual constrains the solution only up to the solutions of the homogeneous problem, here $\sin t$ and $\cos t$, so the data must still fix their two coefficients. And collocation is a finite sample: an equation obeyed at 61 points need not be obeyed between them.

# Why training is hard

The terms of the loss compete. Their gradients can differ by orders of magnitude, and a residual term with large derivatives can dominate the boundary term, so that the network satisfies the equation with the wrong solution. Weights chosen by hand sometimes work and sometimes do not. Analysis of the gradients explains the imbalance and proposes weights that adapt during training {% cite wang-2021 %}.

{% capture t %}
| Symptom | Likely cause | Remedy |
|---|---|---|
| Residual small, boundary values wrong | $w_{\text{r}}$ too large against $w_{\text{b}}$ | adaptive weights |
| Smooth, wrong solution for a multiscale problem | the network learns low frequencies first | Fourier features, domain splitting |
| Fails far from the data in time | errors accumulate along $t$ | train on successive time windows |
| Boundary condition never exact | it is only penalised | a hard constraint |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-pinn-failures" caption="Common failures of a PINN and the usual remedies." body=t %}

# Hard constraints

The boundary term can be removed. If the initial condition is $u(0)=u_0$, write the trial solution as $u_\theta(t)=u_0+t\,N_\theta(t)$ with $N_\theta$ a free network. The condition holds for every $\theta$, and the loss keeps only the data and residual terms {% cite lagaris-1998 %}. The price is that the construction depends on the geometry and works easily only for simple domains.

> A condition that is only penalised is satisfied approximately, and by an amount that depends on $w_{\text{b}}$. If an exact conservation law or boundary value matters downstream, build it into the trial function.
{: .rule}

A PINN is not a replacement for a numerical solver on a forward problem with a known equation: a finite-element code is faster and its error is understood. The method pays off for inverse problems, where an unknown coefficient is added to $\theta$ and fitted along with the network, and where data and equation must be combined on one domain.

# Recap

<details class="qa" markdown="1">
<summary>What are the three terms of a PINN loss?</summary>

A data term comparing the network with measurements, a residual term that squares the differential operator applied to the network at collocation points, and a term enforcing the initial and boundary conditions.
</details>

<details class="qa" markdown="1">
<summary>Why can the residual be evaluated at points with no measurements?</summary>

Its target is zero. The equation says the residual vanishes everywhere, so any point of the domain provides a constraint without a label.
</details>

<details class="qa" markdown="1">
<summary>How does a hard constraint differ from a penalty?</summary>

A hard constraint builds the condition into the form of the trial solution, so it holds exactly for every weight setting, while a penalty only makes violations costly and satisfies it approximately.
</details>
