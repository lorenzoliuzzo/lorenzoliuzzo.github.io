---
collection: notes
title: "Faraday's Law of Induction"
date: 2026-10-27
excerpt: "Magnetic flux, induced emf, Lenz's rule and motional emf."
hook: "A changing magnetic flux through a loop drives a current, so a changing magnetic field produces an electric field that is not conservative."
goals:
  - compute the emf induced by a changing flux
  - use Lenz's rule to find the direction of the current
  - explain why the induced electric field has no potential
requires:
  - magnetic-field
  - lorentz-force
  - electric-potential
defines:
  - {id: magnetic-flux, name: magnetic flux, anchor: def-magnetic-flux}
  - {id: faraday-law, name: Faraday's law, anchor: def-faraday-law}
  - {id: lenz-rule, name: Lenz's rule, anchor: def-lenz-rule}
read_time: true
tags:
  - Physics
  - Electromagnetism
---

Static charges give a field that has a potential. Time-dependent magnetic fields break that: they produce an electric field that circulates, and the work it does on a charge around a closed loop is not zero. That is the principle of every generator and transformer.

# Magnetic flux

> The **magnetic flux** through a surface $S$ is $\Phi_B=\int_S\mathbf B\cdot d\mathbf A$, the surface integral of the normal component of the field. It is measured in webers, $1\,\mathrm{Wb}=1\,\mathrm{T\,m^2}$.
{: .definition #def-magnetic-flux title="Magnetic flux"}

For a flat loop of area $A$ in a uniform field at angle $\alpha$ between $\mathbf B$ and the loop normal, $\Phi_B=BA\cos\alpha$. Flux through a closed surface is zero because $\nabla\cdot\mathbf B=0$, so the flux through a loop depends only on the loop and not on the surface chosen to span it.

# Faraday's law

> **Faraday's law.** The electromotive force around a closed loop equals minus the rate of change of the magnetic flux through it: $\mathcal E=\oint\mathbf E\cdot d\mathbf l=-\dfrac{d\Phi_B}{dt}$, in differential form $\nabla\times\mathbf E=-\partial\mathbf B/\partial t$.
{: .law #def-faraday-law title="Faraday's law"}

The flux can change in three ways: the field changes in time, the loop changes its area, or the loop turns. All three induce the same emf for the same rate of change of flux. A coil of $N$ turns multiplies it by $N$.

Consider a loop of area $A=0.01\ \mathrm{m^2}$ rotating at $50$ Hz in a uniform field $B=0.5$ T. Its flux is $\Phi=BA\cos\omega t$ with peak $5$ mWb, and the emf is $\mathcal E=BA\omega\sin\omega t$ with $\omega=2\pi\cdot50=314\ \mathrm{s^{-1}}$, so the peak is $1.57$ V. This is the alternating-current generator.

{% include fig.html src="electromagnetism/rotating-loop-emf" id="fig-rotating-loop-emf" alt="Two sinusoids over one period of 20 milliseconds, flux starting at its maximum and emf starting at zero, a quarter period apart." caption="Flux and emf of a loop turning at 50 Hz in a field of 0.5 T. The emf peaks where the flux passes through zero, since the emf follows the slope of the flux." %}

# Lenz's rule

> **Lenz's rule.** The direction of the induced current is such that its own magnetic field opposes the change of flux that produced it. The minus sign in Faraday's law expresses this.
{: .law #def-lenz-rule title="Lenz's rule"}

It is conservation of energy at work. If the induced current reinforced the change, a small push would produce a larger current, which would push more, and the system would gain energy for free. Pushing a magnet towards a loop therefore meets a repulsion, and the work done against it is what appears as heat in the loop.

> A bar magnet falling through a copper tube drops much more slowly than a non-magnetic one. The moving field induces circulating currents in the tube, and by Lenz's rule their field resists the motion, converting the potential energy to heat instead of speed.
{: .application title="Eddy-current braking"}

# The induced field has no potential

> The electric field induced by a changing magnetic field is not conservative: its circulation around a loop is $-d\Phi_B/dt\ne0$, so no scalar potential exists for it, and the work per unit charge depends on the path.
{: .implication title="Induced fields are not conservative"}

This is the difference from the electrostatic field, which has $\oint\mathbf E\cdot d\mathbf l=0$. In a circuit, the voltmeter reading between two points can then depend on the path of its leads through the changing flux, which is the reason Kirchhoff's voltage law needs care near a changing field.

> The emf is a property of the loop and not of the wire. Cutting the wire so the loop is open leaves the emf unchanged but no current flows, and the terminals sit at a potential difference equal to the emf.
{: .remark}

> Use Faraday's law to get $\mathcal E$ from the rate of change of the flux, with the normal fixed by the right-hand rule on the direction you choose to go round the loop. Then obtain the sign of the current from Lenz's rule, and use $I=\mathcal E/R$ for a resistive loop.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What does Faraday's law say?</summary>

The emf around a loop equals $-d\Phi_B/dt$, whether the flux changes because $\mathbf B$ varies, the loop moves or it rotates.
</details>

<details class="qa" markdown="1">
<summary>What does the minus sign mean?</summary>

Lenz's rule: the induced current opposes the change in flux, as required by energy conservation.
</details>

<details class="qa" markdown="1">
<summary>Why is the induced electric field not derived from a potential?</summary>

Its circulation around a closed loop is not zero, so the line integral depends on the path and cannot equal a difference of potentials.
</details>
