---
collection: notes
title: Ordinary Differential Equations
date: '2026-10-27'
excerpt: First-order equations, separation of variables, existence and uniqueness, and phase lines.
hook: A differential equation says how a quantity changes in terms of itself; its solutions are curves, and the initial condition picks one.
goals:
- solve separable and linear first-order equations
- state when a solution exists and is unique
defines:
- id: ode
  name: ordinary differential equation
  anchor: ordinary-differential-equation
- id: initial-value-problem
  name: initial value problem
  anchor: initial-value-problem
plan:
  sources: []
  figures:
  - direction field with solution curves
  - phase line with stable and unstable points
  verify:
  - solution of dx/dt = x(1 - x) is the logistic curve
  - Picard-Lindelof needs a Lipschitz right-hand side
tags:
- Mathematics
- Mathematical Methods
read_time: true
---

Nearly every law of motion, decay or growth is a statement about a rate of change. An ordinary differential equation encodes it, and its solutions are not numbers but whole functions.

# Ordinary differential equation

An **ordinary differential equation** (ODE) relates an unknown function $x(t)$ of one variable to its derivatives. Its **order** is the highest derivative present. Examples are $\dot x=-kx$, radioactive decay, and $m\ddot x=-kx$, the oscillator, which is of second order. A **solution** is a function that satisfies the equation on an interval. An equation like $\dot x=-kx$ has a whole family of solutions, $x=Ce^{-kt}$, indexed by a constant, and a general solution of an $n$-th order equation has $n$ free constants.

A first-order equation $\dot x=f(t,x)$ has a geometric reading. At each point $(t,x)$ of the plane it prescribes a slope $f(t,x)$, so it defines a **direction field**, and solutions are the curves tangent to it everywhere.

# Solving first-order equations

An equation of the form $\dot x=g(t)h(x)$ is **separable**: dividing by $h$ and integrating gives $\int dx/h(x)=\int g(t)\,dt$. For decay, $\int dx/x=-k\int dt$ gives $\ln|x|=-kt+c$, so $x=x_0e^{-kt}$.

A **linear** equation $\dot x+p(t)x=q(t)$ is solved with an integrating factor $\mu(t)=e^{\int p\,dt}$. Multiplying by $\mu$ makes the left side a total derivative, $(\mu x)'=\mu q$, and then $x=\mu^{-1}\big(\int\mu q\,dt+C\big)$. For $\dot x+x=1$, $\mu=e^t$, $(e^tx)'=e^t$ and $x=1+Ce^{-t}$: the solution decays to $1$ from any start.

The standard nonlinear example is **logistic growth**, $\dot x=x(1-x)$, population relative to a carrying capacity. It is separable, with $\frac1{x(1-x)}=\frac1x+\frac1{1-x}$, and the solution is
$$ x(t)=\frac1{1+(1/x_0-1)\,e^{-t}}. $$
Starting from any $x_0>0$ it tends to $1$; starting at $0$ it stays at $0$.

# Initial value problem

An ODE together with the value of the solution at one time is an **initial value problem** (IVP),
$$ \dot x=f(t,x),\qquad x(t_0)=x_0. $$
The initial condition picks one curve out of the family. For logistic growth with $x_0=0.2$ the solution rises slowly and then quickly toward $1$, with $x_0=1.4$ it falls toward $1$ and curves with $x_0$ between $0$ and $1$ never cross each other or the line $x=1$.

Does a solution exist, and is it unique? The **Picard-Lindelöf theorem** says: if $f$ is continuous and **Lipschitz** in $x$, meaning $|f(t,x)-f(t,y)|\le K|x-y|$, near $(t_0,x_0)$, then the IVP has exactly one solution on some interval around $t_0$. Lipschitz continuity holds whenever $\partial f/\partial x$ is continuous. Without it, uniqueness can fail: $\dot x=\sqrt{|x|}$ with $x(0)=0$ has the solutions $x\equiv0$ and $x=t^2/4$ for $t\ge0$, since $\sqrt{|x|}$ has an infinite slope at $0$. Existence on the whole line can also fail, even for smooth $f$: $\dot x=x^2$ with $x(0)=1$ has the solution $x=1/(1-t)$, which blows up at $t=1$.

{% include fig.html src="mathematical-methods/direction-field" id="fig-direction-field" alt="A field of short slope segments with four solution curves of the logistic equation approaching the horizontal line at one from above and below and a second horizontal line at zero." caption="Direction field of $\dot x=x(1-x)$ with solutions from $x_0=0.05,\,0.2,\,0.5,\,1.4$. Curves never cross; $x=1$ attracts and $x=0$ repels." %}

# Phase line

For an **autonomous** equation $\dot x=f(x)$, the right side has no time, and the behaviour is read from a line. The zeros of $f$ are the **equilibria**. Between them $\dot x$ has a fixed sign, so the solution moves monotonically up or down. An equilibrium is **stable** if solutions nearby approach it, which happens when $f'(x^*)<0$, and **unstable** if $f'(x^*)>0$. For $f=x(1-x)$, $f'(0)=1>0$ is unstable and $f'(1)=-1<0$ is stable, which is what the picture shows. No picture of the solution is needed to see that every positive start ends at the stable point.

# Recap

<details class="qa" markdown="1">
<summary>How are separable and linear first-order equations solved?</summary>

Separable: $\int dx/h(x)=\int g(t)\,dt$. Linear $\dot x+px=q$: multiply by $\mu=e^{\int p}$ so that $(\mu x)'=\mu q$ and integrate.
</details>

<details class="qa" markdown="1">
<summary>When does an initial value problem have a unique solution?</summary>

When $f(t,x)$ is continuous and Lipschitz in $x$ near the initial point (Picard-Lindelöf), for example when $\partial f/\partial x$ is continuous. The solution is local and may blow up.
</details>

<details class="qa" markdown="1">
<summary>How is stability read from a phase line?</summary>

An equilibrium $x^*$ with $f(x^*)=0$ is stable if $f'(x^*)<0$ and unstable if $f'(x^*)>0$.
</details>
