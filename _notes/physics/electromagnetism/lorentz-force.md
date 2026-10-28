---
collection: notes
title: The Lorentz Force
date: '2026-10-27'
excerpt: The magnetic field defined by its force on a moving charge, and the motion of charges in uniform fields.
hook: A magnetic field acts only on charges that move, and always sideways to the motion, so it bends paths and never does work.
goals:
- write the force on a charge in electric and magnetic fields
- describe circular and helical motion in a uniform field
- find the force on a current-carrying wire
requires:
- electric-field
defines:
- id: magnetic-field
  name: magnetic field
  anchor: magnetic-force
- id: lorentz-force
  name: Lorentz force
  anchor: the-lorentz-force
- id: cyclotron-motion
  name: cyclotron motion
  anchor: motion-in-a-uniform-field
tags:
- Physics
- Electromagnetism
read_time: true
---

Electric charges at rest feel only the electric field. Charges in motion feel a second force that is perpendicular to their velocity, and that force is how we define the magnetic field.

# Magnetic force

Experiments show that a charge $q$ moving with velocity $\mathbf v$ in a region of space experiences a force that depends on $\mathbf v$ and, for a given point, is perpendicular to it. Its size is proportional to $q$, to $v$ and to the sine of the angle between $\mathbf v$ and a fixed direction at the point. The vector that packages this is the **magnetic field** $\mathbf B$, defined by
$$ \mathbf F=q\,\mathbf v\times\mathbf B. $$
The force is zero for a charge at rest and for motion along $\mathbf B$, and it is largest, $F=qvB$, for motion perpendicular to $\mathbf B$. The unit of $B$ is the tesla, $1\ \mathrm T=1\ \mathrm{N/(C\,m/s)}$. The Earth's field is about $5\times10^{-5}\ \mathrm T$ and a laboratory magnet reaches several tesla.

Since $\mathbf F\perp\mathbf v$, the power $\mathbf F\cdot\mathbf v$ is zero: a magnetic force changes the direction of the velocity and never its speed. **A magnetic field does no work.** Energy changes of charges come from electric fields, including those induced by changing magnetic fields.

# The Lorentz force

With both fields present, the total force on a charge is the **Lorentz force**
$$ \mathbf F=q\big(\mathbf E+\mathbf v\times\mathbf B\big). $$
This is a statement about how fields act on charges, and together with Maxwell's equations, which say how charges make fields, it covers all of classical electromagnetism. The electric part accelerates the charge along $\mathbf E$; the magnetic part bends the path.

A current-carrying wire is a set of moving charges, and the force on a segment of length $L$ carrying current $I$ is
$$ \mathbf F=I\,\mathbf L\times\mathbf B, $$
with $\mathbf L$ along the current. A straight wire of length $0.2\ \mathrm m$ carrying $10\ \mathrm A$ perpendicular to a field of $0.5\ \mathrm T$ feels $F=ILB=1\ \mathrm N$. This is the principle of the electric motor and of the loudspeaker.

# Motion in a uniform field

Take $\mathbf E=0$ and a uniform $\mathbf B$ along $z$. The force is perpendicular to $\mathbf v$ and has constant magnitude, so the speed is constant and the component of $\mathbf v$ perpendicular to $\mathbf B$ rotates. For a charge moving perpendicular to $\mathbf B$, the magnetic force supplies the centripetal force, $qvB=mv^2/r$, so
$$ r=\frac{mv}{qB},\qquad \omega=\frac vr=\frac{qB}m,\qquad T=\frac{2\pi m}{qB}. $$
The angular frequency $\omega$, the **cyclotron frequency**, does not depend on the speed or the radius. Fast particles go around larger circles in the same time. This is the principle of the cyclotron accelerator and of mass spectrometers, where the radius at fixed $v$ and $B$ is proportional to $m/q$.

For a proton with $v=10^6\ \mathrm{m/s}$ in $B=0.1\ \mathrm T$ the formulas give $r=0.104\ \mathrm m$, $\omega=9.58\times10^6\ \mathrm{rad/s}$ and a period of $656\ \mathrm{ns}$.

If $\mathbf v$ also has a component along $\mathbf B$, that component is unaffected, and the path is a **helix**: a circle in the plane perpendicular to $\mathbf B$ and a steady drift along it. Charged particles from the Sun spiral along the lines of the Earth's field in this way, which is why aurorae appear near the poles.

{% include fig.html src="electromagnetism/helix" id="fig-helix" alt="A helical path winding around a vertical arrow that marks the direction of the magnetic field." caption="A charge with a component of velocity along $\mathbf B$ moves on a helix. For a proton with $v=10^6\ \mathrm{m/s}$ in $B=0.1\ \mathrm T$, the radius is $r=mv/(qB)=0.104\ \mathrm m$ and the period $2\pi/\omega=656\ \mathrm{ns}$." %}

If a uniform $\mathbf E$ is added perpendicular to $\mathbf B$, the circle drifts sideways with speed $E/B$, independent of the charge and mass, because in a frame moving at that speed the electric field vanishes.

> The sign of $q$ matters for the direction of rotation, not for its size: a proton and an electron circle in opposite senses, and the electron's radius is smaller by $m_e/m_p$ at the same speed.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>How is the magnetic field defined, and why does it do no work?</summary>

By the force $\mathbf F=q\mathbf v\times\mathbf B$ on a moving charge. The force is perpendicular to $\mathbf v$, so $\mathbf F\cdot\mathbf v=0$; the speed is unchanged.
</details>

<details class="qa" markdown="1">
<summary>What is the Lorentz force, and the force on a wire?</summary>

$\mathbf F=q(\mathbf E+\mathbf v\times\mathbf B)$. For a wire of length $\mathbf L$ carrying current $I$, $\mathbf F=I\mathbf L\times\mathbf B$.
</details>

<details class="qa" markdown="1">
<summary>What are the radius and frequency of motion in a uniform $\mathbf B$?</summary>

$r=mv/(qB)$ and $\omega=qB/m$; the frequency does not depend on the speed. A velocity component along $\mathbf B$ makes the path a helix.
</details>
