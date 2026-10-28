---
collection: notes
title: "Linear Differential Equations"
date: 2026-10-27
excerpt: "Linear equations with constant coefficients, the oscillator and resonance, and the method of variation of parameters."
hook: "Solutions of a linear equation add, so one solves it with exponentials; the damped and driven oscillator is the example behind half of physics."
goals:
  - solve homogeneous and driven linear equations
  - describe damped and resonant oscillation
requires:
  - ode
  - initial-value-problem
defines:
  - {id: linear-ode, name: "linear ODE", anchor: def-linear-ode}
  - {id: resonance, name: "resonance", anchor: def-resonance}
read_time: true
tags:
  - Mathematics
  - Mathematical Methods
---

A linear equation can be taken apart: solutions add, so a hard problem splits into easy ones. With constant coefficients the pieces are exponentials, and the damped, driven oscillator is the example that shows every feature.

# Superposition and exponentials

> A **linear ODE** of order $n$ for $y(t)$ has the form $a_n(t)y^{(n)}+\cdots+a_1(t)y'+a_0(t)y=f(t)$. It is **homogeneous** when $f=0$. The coefficients $a_k$ may depend on $t$; the unknown and its derivatives appear only to the first power.
{: .definition #def-linear-ode title="Linear ODE"}

> The solutions of the homogeneous equation form a vector space of dimension $n$: any combination $c_1y_1+c_2y_2$ of solutions is a solution. The general solution of the inhomogeneous equation is one particular solution $y_p$ plus the general homogeneous solution.
{: .theorem #thm-linear-ode-structure title="Structure of the solutions"}

> Differentiation is linear, so sums and multiples of homogeneous solutions are homogeneous solutions, and the difference of any two solutions of the inhomogeneous equation is a homogeneous solution. For the dimension, send a solution to its initial data $(y,y',\dots,y^{(n-1)})$ at a fixed time. This map is linear, and the existence and uniqueness of the initial value problem make it a bijection onto $\mathbb R^n$.
{: .proof}

The consequence is a method: find $n$ independent homogeneous solutions, find any one particular solution, and fix the $n$ constants from the initial conditions, which the initial value problem supplies.

When the coefficients are constants, the homogeneous equation has solutions $y=e^{\lambda t}$, because differentiation just multiplies by $\lambda$. Substituting turns the equation into a polynomial, the **characteristic equation**, $a_n\lambda^n+\cdots+a_1\lambda+a_0=0$, and each root gives a solution:

- a real root $\lambda$ gives $e^{\lambda t}$, and a root repeated $m$ times gives $e^{\lambda t},te^{\lambda t},\dots,t^{m-1}e^{\lambda t}$;
- a complex pair $\alpha\pm i\beta$ gives $e^{\alpha t}\cos\beta t$ and $e^{\alpha t}\sin\beta t$.

For $y''+3y'+2y=0$ the roots are $-1$ and $-2$, so $y=c_1e^{-t}+c_2e^{-2t}$; with $y(0)=1$ and $y'(0)=0$ the constants are $c_1=2$, $c_2=-1$. The real part of a root sets growth or decay and the imaginary part sets oscillation, which is how a system's stability is read off its roots.

# The damped oscillator

Mass, spring and friction give $m\ddot x+b\dot x+kx=0$, written with $\omega_0^2=k/m$ and $\gamma=b/m$ as
$$ y''+\gamma y'+\omega_0^2y=0,\qquad \lambda=-\frac\gamma2\pm\sqrt{\frac{\gamma^2}4-\omega_0^2}. $$
The sign of the discriminant decides everything.

{% capture t %}
| Damping | Roots | Motion |
|:--|:--|:--|
| $\gamma<2\omega_0$, under | complex, $-\frac\gamma2\pm i\omega_d$ | $e^{-\gamma t/2}\cos(\omega_dt+\phi)$, with $\omega_d=\sqrt{\omega_0^2-\gamma^2/4}$ |
| $\gamma=2\omega_0$, critical | real, double $-\gamma/2$ | $(c_1+c_2t)e^{-\gamma t/2}$, fastest return without oscillating |
| $\gamma>2\omega_0$, over | real, both negative | sum of two decaying exponentials |
{% endcapture %}
{% include tab.html id="tab-damping" caption="The three regimes of the damped oscillator." body=t %}
{: .booktabs}

In the underdamped case the number of oscillations before the amplitude falls by a factor $e$ is of order $Q=\omega_0/\gamma$, the **quality factor**; a large $Q$ means a nearly undamped oscillator.

# Driving and resonance

Now push the oscillator with a periodic force, $y''+\gamma y'+\omega_0^2y=F\cos\omega t$. By the structure theorem the solution is the homogeneous part, which decays, plus a particular solution, which stays. After the transient dies the oscillator moves at the driving frequency, $y_p=A\cos(\omega t-\delta)$, found by substitution (or with $e^{i\omega t}$ and complex amplitudes):
$$ A(\omega)=\frac{F}{\sqrt{(\omega_0^2-\omega^2)^2+\gamma^2\omega^2}},\qquad \tan\delta=\frac{\gamma\omega}{\omega_0^2-\omega^2}. $$

> **Resonance** is the large response of a weakly damped oscillator to a driving frequency near its natural one. The amplitude is largest at $\omega_r=\sqrt{\omega_0^2-\gamma^2/2}\approx\omega_0$, where for small damping $A\approx F/(\gamma\omega_0)=Q\,F/\omega_0^2$, a factor $Q$ above the static response $F/\omega_0^2$, and the peak has width of order $\gamma$.
{: .definition #def-resonance title="Resonance"}

{% include fig.html src="mathematical-methods/resonance-curves" id="fig-resonance-curves" alt="Three response curves against driving frequency. The weakly damped one has a tall narrow peak at the natural frequency, reaching ten times the static value. The moderately damped one peaks at a third of that, and the heavily damped one has no peak." caption="Steady-state amplitude, in units of the static response, for $\gamma=0.1,0.3,1.0$ in units of $\omega_0$. The peak height is about $Q=\omega_0/\gamma$ and its width about $\gamma$; for $\gamma\gtrsim\omega_0$ there is no peak." %}

The phase explains why. Well below resonance the oscillator follows the force; at $\omega=\omega_0$ the displacement lags the force by $90^\circ$, so the velocity is in phase with it and the force pushes the whole time, adding energy at the maximum rate; well above, it responds in antiphase. With no damping at all the amplitude grows linearly forever, $y_p=\dfrac{F}{2\omega_0}\,t\sin\omega_0t$.

> An undamped system driven at its natural frequency has no bounded steady state. In a real one the amplitude is capped by damping, and if the cap lies beyond what the structure tolerates, the system fails: what matters for design is $Q$ and how close the drive can come to $\omega_0$.
{: .implication title="Resonance and failure"}

> The width of the peak and the decay time of free oscillations are two views of the same $\gamma$: a narrow resonance means slow decay. Measuring one gives the other, which is how $Q$ is read off a spectrum.
{: .remark title="Width and decay"}

# Variation of parameters

When $f$ is not a sinusoid or exponential, guessing a particular solution fails. For $y''+py'+qy=f$ with homogeneous solutions $y_1,y_2$ and Wronskian $W=y_1y_2'-y_1'y_2\ne0$, one looks for $y_p=u_1y_1+u_2y_2$ and chooses the coefficients so that no extra terms appear, which gives
$$ y_p=-y_1\int\frac{y_2f}{W}\,dt+y_2\int\frac{y_1f}{W}\,dt. $$
For $y''+y=1/\cos t$ with $y_1=\cos t$, $y_2=\sin t$ and $W=1$ this gives $y_p=\cos t\,\ln|\cos t|+t\sin t$. The method works for any continuous $f$, and in the next notes it is what a Green's function packages: a response to a unit impulse, convolved with the force.

> Do not substitute a sinusoidal guess when the driving frequency equals a root of the characteristic equation: the guess is already a homogeneous solution and gives zero. The particular solution then has an extra factor $t$, as in the undamped resonance above.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why do constant-coefficient linear ODEs have exponential solutions?</summary>

Differentiating $e^{\lambda t}$ only multiplies it by $\lambda$, so substituting reduces the ODE to the characteristic polynomial, and each root gives a solution.
</details>

<details class="qa" markdown="1">
<summary>What distinguishes under-, critically and over-damped motion?</summary>

The roots of $\lambda^2+\gamma\lambda+\omega_0^2=0$: complex (oscillating decay), a double real root (fastest non-oscillating return) or two negative real roots (slow monotone decay).
</details>

<details class="qa" markdown="1">
<summary>What sets the height and the width of a resonance peak?</summary>

The damping: the peak height is about $Q=\omega_0/\gamma$ times the static response and its width is about $\gamma$.
</details>
