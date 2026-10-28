---
collection: notes
title: Integrating Equations of Motion
date: '2026-10-27'
excerpt: Euler, Runge-Kutta and symplectic integrators, with their error and stability.
hook: A good integrator for a Hamiltonian system keeps the energy near its value for millions of steps, which an ordinary one does not.
goals:
- implement and compare Euler, Runge-Kutta and leapfrog
- explain stability and order of accuracy
defines:
- id: numerical-error
  name: truncation and round-off error
  anchor: truncation-and-round-off-error
- id: symplectic-integrator
  name: symplectic integrator
  anchor: symplectic-integrator
tags:
- Physics
- Computation
read_time: true
---

Most equations of motion have no closed-form solution, so we step through time. The scheme that does this decides whether a computed orbit or oscillation is trustworthy over many periods, and the cheapest scheme is often the worst.

# Stepping the equation

Write the equations of motion as $\dot{\mathbf y}=\mathbf F(\mathbf y)$ with $\mathbf y=(x,v)$ and advance in steps of size $h$. The simplest rule is **Euler's method**: $\mathbf y_{n+1}=\mathbf y_n+h\mathbf F(\mathbf y_n)$, which follows the tangent for one step. For the harmonic oscillator $\ddot x=-x$ it reads
$$ x_{n+1}=x_n+hv_n,\qquad v_{n+1}=v_n-hx_n. $$
**Runge-Kutta 4** (RK4) evaluates $\mathbf F$ four times per step, at the start, twice in the middle and at the end, and averages the slopes with weights $1,2,2,1$. It costs four evaluations per step and gains a lot of accuracy. **Leapfrog** (velocity Verlet) updates the velocity by a half step, the position by a full step and the velocity by the other half step:
$$ v_{n+1/2}=v_n+\tfrac h2a(x_n),\quad x_{n+1}=x_n+hv_{n+1/2},\quad v_{n+1}=v_{n+1/2}+\tfrac h2a(x_{n+1}). $$
It needs one new force evaluation per step.

# Truncation and round-off error

A single step of a method of **order** $p$ has an error of order $h^{p+1}$, and after integrating to a fixed time the **truncation error** is of order $h^p$. Euler has $p=1$, leapfrog $p=2$, RK4 $p=4$. Halving $h$ divides the error by $2$, $4$ and $16$ respectively. Truncation error comes from dropping the higher terms of the Taylor series of the exact solution.

The second source is **round-off error**. Floating-point numbers carry about $16$ digits, and each operation may add an error of $10^{-16}$ in relative size. With $N=T/h$ steps these accumulate, roughly as $\sqrt N$ or $N$ times $10^{-16}$. Total error is the sum of a term that falls with $h$ and one that grows as $h$ falls, so there is a best step size, below which refining makes things worse.

**Stability** is a separate issue from accuracy. Euler applied to $\dot x=-\lambda x$ gives $x_{n+1}=(1-\lambda h)x_n$, which blows up when $\lambda h>2$ however accurate the formula is for smaller $h$. Stiff equations, with very different time scales, force $h$ to be small for stability and need implicit methods.

# Symplectic integrator

For conservative systems the energy should stay constant. Take $h=0.1$ for the oscillator with $x_0=1$, $v_0=0$, and integrate to $t=100$, about $16$ periods:

{% capture t %}
| Method | order | $\lvert\Delta E/E_0\rvert$ at $t=100$ | behaviour |
|:--|:--|:--|:--|
| Euler | 1 | $2.1\times10^{4}$ | grows by the factor $1+h^2$ every step |
| RK4 | 4 | $1.4\times10^{-5}$ | slow steady drift |
| leapfrog | 2 | $\le2.5\times10^{-3}$ | oscillates, no drift |
{% endcapture %}
{% include tab.html id="tab-integrators" caption="Energy error of three integrators on the harmonic oscillator, $h=0.1$." body=t %}
{: .booktabs}

Euler multiplies the energy by exactly $1+h^2$ at each step, so after $1000$ steps it is $1.01^{1000}\approx2\times10^4$ times too large. RK4 is far more accurate for this $h$ but still drifts, because its error is not structured: it grows without bound given time. Leapfrog has a worse error at any fixed time than RK4 and yet it never drifts.

{% include fig.html src="computational-physics/energy-drift-integrators" id="fig-energy-drift-integrators" alt="Three curves of the logarithm of the relative energy error against time. The Euler curve rises steadily, the Runge-Kutta curve rises slowly and stays low, and the leapfrog curve oscillates between a narrow band." caption="Relative energy error $|\Delta E/E_0|$ of three methods for $\ddot x=-x$, $h=0.1$, on a logarithmic scale. Euler grows exponentially, RK4 drifts slowly, leapfrog oscillates within a bounded band." %}

The reason is that leapfrog is **symplectic**: each step is a canonical transformation, so it preserves the phase-space area exactly, as the true flow does. A symplectic integrator exactly solves a nearby Hamiltonian, the **shadow Hamiltonian** $\tilde H=H+O(h^2)$, so $\tilde H$ is conserved exactly and $H$ only oscillates around it. This holds for millions of steps. It is why molecular dynamics and orbit calculations use leapfrog-like schemes, and why a non-symplectic scheme should not be used for long Hamiltonian runs unless its error is small enough over the full time.

# Recap

<details class="qa" markdown="1">
<summary>What is the order of a method, and how do Euler, leapfrog and RK4 compare?</summary>

The global error falls as $h^p$. Euler has $p=1$, leapfrog $p=2$ and RK4 $p=4$, at one, one and four force evaluations per step.
</details>

<details class="qa" markdown="1">
<summary>What are truncation and round-off error, and what limits the step size?</summary>

Truncation error comes from the dropped Taylor terms and falls with $h$; round-off error comes from finite precision and grows with the number of steps. Stability can also forbid large $h$, as for Euler with $\lambda h>2$.
</details>

<details class="qa" markdown="1">
<summary>Why does a symplectic integrator keep the energy bounded?</summary>

It follows exactly the flow of a nearby shadow Hamiltonian, so $H$ oscillates around a conserved value instead of drifting.
</details>
