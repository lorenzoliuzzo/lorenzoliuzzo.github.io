---
collection: notes
title: Kinetic Theory
date: '2026-10-27'
excerpt: The Maxwell-Boltzmann distribution, pressure and temperature from molecules, and transport.
hook: Pressure is molecules hitting a wall and temperature is their mean energy, which is the first bridge from mechanics to thermodynamics.
goals:
- derive pressure and temperature from molecular motion
- use the Maxwell-Boltzmann distribution
requires:
- ideal-gas
- temperature
defines:
- id: maxwell-boltzmann
  name: Maxwell-Boltzmann distribution
  anchor: maxwell-boltzmann-distribution
- id: mean-free-path
  name: mean free path
  anchor: mean-free-path
tags:
- Physics
- Thermodynamics
read_time: true
---

A gas is a crowd of molecules moving at many different speeds. Pressure, temperature and the rate at which a gas conducts heat all follow from the statistics of that motion.

# Pressure from collisions

Take $N$ molecules of mass $m$ in a box of volume $V$, with no interactions except elastic collisions with the walls. A molecule with velocity component $v_x$ hitting a wall perpendicular to $x$ bounces back, changing its momentum by $2mv_x$. In a time $dt$, those within $v_x\,dt$ of the wall arrive, a fraction $\tfrac12(N/V)\,v_x\,dt\,A$ of them, so the pressure is $p=\frac NVm\langle v_x^2\rangle$. By isotropy $\langle v_x^2\rangle=\tfrac13\langle v^2\rangle$, and
$$ p=\frac13\frac NVm\langle v^2\rangle. $$
Comparing with $pV=NkT$ identifies the temperature with the mean kinetic energy of translation, $\tfrac12m\langle v^2\rangle=\tfrac32kT$. The root-mean-square speed is $v_{\mathrm{rms}}=\sqrt{3kT/m}$.

# Maxwell-Boltzmann distribution

The molecules do not all have the same speed. In equilibrium the fraction with velocity in $d^3v$ is proportional to the Boltzmann factor $e^{-mv^2/2kT}$, so each Cartesian component is Gaussian with variance $kT/m$. Integrating over directions, the probability density of the **speed** is the **Maxwell-Boltzmann distribution**
$$ f(v)=4\pi\Big(\frac m{2\pi kT}\Big)^{3/2}v^2\,e^{-mv^2/2kT}. $$
The factor $v^2$ counts the velocities with a given speed, and the exponential suppresses high energies; the product has a peak. Three speeds characterise it:
$$ v_{\mathrm{mp}}=\sqrt{\frac{2kT}m},\qquad \langle v\rangle=\sqrt{\frac{8kT}{\pi m}},\qquad v_{\mathrm{rms}}=\sqrt{\frac{3kT}m}, $$
in the ratio $1:1.13:1.22$. For nitrogen ($m=28.0\ \mathrm u$) at $300\ \mathrm K$ they are $422$, $476$ and $517\ \mathrm{m/s}$.

{% include fig.html src="thermodynamics/maxwell-boltzmann" id="fig-maxwell-boltzmann" alt="Three bell-shaped curves with long tails of the speed distribution of nitrogen at three temperatures. The curve for the lowest temperature is tallest and narrowest, and the peak moves to higher speed as the temperature rises." caption="Maxwell-Boltzmann speed distributions of $\mathrm N_2$ at $300$, $600$ and $1200\ \mathrm K$. The peak speed grows as $\sqrt T$ and the curve widens, with the area fixed at $1$. At $300\ \mathrm K$: $v_{\mathrm{mp}}=422$, $\langle v\rangle=476$, $v_{\mathrm{rms}}=517\ \mathrm{m/s}$." %}

The distribution has long been confirmed by molecular-beam experiments. Heavier molecules are slower at the same temperature, which is why light gases such as hydrogen and helium escape from planetary atmospheres: a small fraction of the molecules in the tail exceeds the escape speed.

# Mean free path

Molecules collide with each other. If they are spheres of diameter $d$, a molecule sweeps a cylinder of cross-section $\pi d^2$ as it moves. It meets another molecule when the centre of one is within a distance $d$ of the other, and the number density is $n=N/V=p/kT$, so the **mean free path** between collisions is
$$ \lambda=\frac1{\sqrt2\,\pi d^2n}=\frac{kT}{\sqrt2\,\pi d^2p}. $$
The factor $\sqrt2$ corrects for the motion of the target molecules. For nitrogen, with $d=3.7\times10^{-10}\ \mathrm m$ (a textbook value) at $300\ \mathrm K$ and $1\ \mathrm{atm}$, $\lambda=67\ \mathrm{nm}$, about $180$ molecular diameters, while the mean time between collisions, $\lambda/\langle v\rangle$, is about $1.4\times10^{-10}\ \mathrm s$. The mean free path scales as $1/p$ at fixed $T$: at $10^{-3}\ \mathrm{Pa}$ it is $7\ \mathrm{m}$, larger than a typical vacuum chamber, and molecules fly from wall to wall.

The mean free path also sets the **transport** coefficients. Molecules carry momentum, energy and mass over a distance $\lambda$ before colliding, so the viscosity and the thermal conductivity are of order $\eta\sim\tfrac13nm\langle v\rangle\lambda$, which is independent of density: a surprising prediction, confirmed over a wide range of pressures.

# Recap

<details class="qa" markdown="1">
<summary>How does kinetic theory give the pressure and temperature of a gas?</summary>

Momentum transfer to a wall gives $p=\tfrac13(N/V)m\langle v^2\rangle$; comparing with $pV=NkT$ gives $\tfrac12m\langle v^2\rangle=\tfrac32kT$.
</details>

<details class="qa" markdown="1">
<summary>What is the Maxwell-Boltzmann speed distribution and its characteristic speeds?</summary>

$f(v)\propto v^2e^{-mv^2/2kT}$, with $v_{\mathrm{mp}}=\sqrt{2kT/m}$, $\langle v\rangle=\sqrt{8kT/\pi m}$ and $v_{\mathrm{rms}}=\sqrt{3kT/m}$.
</details>

<details class="qa" markdown="1">
<summary>What is the mean free path, and how does it depend on pressure?</summary>

$\lambda=kT/(\sqrt2\pi d^2p)$, the mean distance between collisions; it scales as $1/p$ and is $67\ \mathrm{nm}$ for nitrogen at atmospheric pressure.
</details>
