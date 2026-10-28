---
collection: notes
title: "The Magnetic Field of Currents"
date: 2026-10-27
excerpt: "Current density, the Biot-Savart law, and the field of wires, loops and solenoids by direct integration."
hook: "Moving charge makes a magnetic field, found by adding up the contribution of each bit of current; the Biot-Savart law is the magnetic Coulomb's law."
goals:
  - define current density and relate it to the current
  - apply the Biot-Savart law to a straight wire and a circular loop
  - compute the force between two parallel currents
requires:
  - magnetic-field
  - lorentz-force
  - superposition-principle
defines:
  - {id: current-density, name: current density, anchor: def-current-density}
  - {id: biot-savart-law, name: Biot-Savart law, anchor: def-biot-savart-law}
read_time: true
tags:
  - Physics
  - Electromagnetism
---

Coulomb's law adds up the field of every bit of charge. Moving charge makes a magnetic field, and the Biot-Savart law is the corresponding rule for adding up the contributions of every bit of current.

# Current density

The current $I$ through a wire is the charge per second crossing a section. Inside a conductor with $n$ charge carriers of charge $q$ per unit volume drifting at velocity $\mathbf v_d$, the useful local quantity is the current per unit area.

> The **current density** $\mathbf J=nq\,\mathbf v_d$ is the charge crossing unit area per unit time, a vector along the direction of flow. The current through a surface is $I=\int_S\mathbf J\cdot d\mathbf A$. In general $\mathbf J=\rho\mathbf v$ for charge density $\rho$ moving with velocity $\mathbf v$.
{: .definition #def-current-density title="Current density"}

Charge is neither created nor destroyed, so the current out of any closed surface equals the rate at which the charge inside decreases, $\oint\mathbf J\cdot d\mathbf A=-dQ/dt$. In a steady state the right side is zero, and the current entering any region equals the current leaving it.

> A current of $1$ A in a copper wire of cross-section $1$ mm$^2$ uses $n\approx8.5\times10^{28}$ electrons per m$^3$, so the drift speed is $v_d=I/(nqA)\approx7\times10^{-5}$ m/s, about a tenth of a millimetre per second. The signal in a circuit travels at nearly the speed of light because the field changes everywhere at once, while each electron barely moves.
{: .example title="Drift speed in a wire"}

# The Biot-Savart law

Static charges make $\mathbf E$, and moving charge makes $\mathbf B$. Take a thin wire carrying current $I$ and a short element $d\mathbf l$ pointing along the current. Experiments on wires show that the field of that element at a point displaced by $\mathbf r$ from it is proportional to $I\,d\mathbf l$, falls as $1/r^2$ and is perpendicular to both $d\mathbf l$ and $\mathbf r$.

> The **Biot-Savart law** gives the field of a steady current as the superposition
> $$ \mathbf B=\frac{\mu_0}{4\pi}\oint\frac{I\,d\mathbf l\times\hat{\mathbf r}}{r^2}, $$
> where $\hat{\mathbf r}$ is the unit vector from the element to the field point and $\mu_0\approx4\pi\times10^{-7}$ T m/A is the permeability of free space. For a distributed current, $I\,d\mathbf l\to\mathbf J\,dV$.
{: .law #def-biot-savart-law title="Biot-Savart law"}

It has the same $1/r^2$ shape as Coulomb's law, but the cross product changes the geometry: the field of an element circles the current, perpendicular both to $d\mathbf l$ and to the line joining the element to the point (right-hand rule: thumb along the current, fingers curl along $\mathbf B$). The integral is over a closed circuit, since steady currents flow in loops.

Two integrals are worth knowing. For a long straight wire, with $s$ the perpendicular distance, the contributions add up to
$$ B=\frac{\mu_0I}{2\pi s},\qquad\text{circling the wire.} $$
For a circular loop of radius $R$, the contributions of opposite elements cancel off the axis and add on it, giving at height $z$ on the axis
$$ B_z=\frac{\mu_0IR^2}{2(z^2+R^2)^{3/2}},\qquad B(0)=\frac{\mu_0I}{2R}. $$

{% include fig.html src="electromagnetism/loop-axis-field" id="fig-loop-axis-field" alt="The field on the axis of a circular loop, as a fraction of its centre value, falls smoothly from one at the centre. A dashed curve showing the inverse cube law lies above it and meets it at large distance." caption="The on-axis field of a loop of radius $R$ against $z/R$. Near the loop it is nearly flat; beyond $z\approx2R$ it follows the inverse-cube law of a magnetic dipole." %}

> A wire carrying $10$ A makes a field of $\mu_0I/(2\pi s)=0.2$ mT at $s=1$ cm, several times the Earth's field at the surface, which is a few tens of microtesla. A single loop of radius $5$ cm with the same current gives $\mu_0I/2R=0.13$ mT at its centre.
{: .example title="Orders of magnitude"}

# Forces between currents

A current in a magnetic field feels the Lorentz force on its charge carriers, $d\mathbf F=I\,d\mathbf l\times\mathbf B$. Two long parallel wires therefore interact: the first makes a field $\mu_0I_1/(2\pi d)$ at the second, perpendicular to it, and the force per unit length on the second wire is
$$ \frac{F}{L}=\frac{\mu_0I_1I_2}{2\pi d}. $$

> Parallel currents attract and antiparallel currents repel. Two wires $1$ m apart, each carrying $1$ A, pull on each other with $2\times10^{-7}$ N per metre, the value that used to define the ampere.
{: .implication title="Force between parallel currents"}

Note the contrast with static charges, where like charges repel. In the frame of the wires there is no net charge, yet the force exists: it is a magnetic force, and relativity later shows it to be the electric force seen from another frame.

> The Biot-Savart law holds for steady currents in closed circuits. An isolated current element $I\,d\mathbf l$ is not a physical source on its own, and the law does not apply to a charge accelerating or a current that changes with time; those need the time-dependent equations of the later notes.
{: .trap}

> For a straight wire or loop, prefer a symmetry argument and the next note's circulation law when the geometry allows it. Use Biot-Savart when the current path has no such symmetry, or when you need the field on the axis of a loop.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why is the drift velocity of electrons so small when circuits respond almost instantly?</summary>

The current density depends on the product of carrier density and drift speed, and the carrier density is huge, so a tiny drift gives amperes. The response travels as a change of field, not as a shift of electrons.
</details>

<details class="qa" markdown="1">
<summary>In which direction does the field of a current element point?</summary>

Perpendicular to both the element $d\mathbf l$ and the line to the field point, along $d\mathbf l\times\hat{\mathbf r}$, so the field lines circle the current in the right-hand sense.
</details>

<details class="qa" markdown="1">
<summary>Why do parallel currents attract?</summary>

Each wire sits in the circulating field of the other, and $I\,d\mathbf l\times\mathbf B$ points toward the other wire when the currents are parallel.
</details>
