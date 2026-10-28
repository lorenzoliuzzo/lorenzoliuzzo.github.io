---
collection: notes
title: "Electric Potential"
date: 2026-10-27
excerpt: "Work, potential energy and potential, the field as the gradient of the potential, and equipotentials."
hook: "The electrostatic force does path-independent work, so the field can be replaced by a scalar, the potential, whose gradient gives the field back."
goals:
  - compute the potential of point charges and simple distributions
  - recover the field from the potential
  - sketch equipotentials and relate them to field lines
requires:
  - electric-field
  - gauss-law
defines:
  - {id: electric-potential, name: electric potential, anchor: def-electric-potential}
  - {id: equipotential, name: equipotential, anchor: def-equipotential}
  - {id: electrostatic-energy, name: electrostatic energy, anchor: def-electrostatic-energy}
read_time: true
tags:
  - Physics
  - Electromagnetism
---

The field of a charge distribution is a vector at every point, which makes it laborious to add up. The electrostatic force is conservative, so a single number at each point can carry the same information, and numbers add without worrying about direction.

# Work and potential

Moving a test charge $q$ through an electrostatic field $\mathbf E$ costs the work $-q\int\mathbf E\cdot d\mathbf l$. For a point charge this integral depends only on the endpoints: the radial component of $\mathbf E$ is the only one that does work, and it depends only on $r$. By superposition the same holds for any set of charges.

> The electrostatic field is conservative: $\oint\mathbf E\cdot d\mathbf l=0$ around every closed path, so the work done on a charge moved between two points does not depend on the path.
{: .property title="Path independence of electrostatic work"}

That property allows a definition.

> The **electric potential** at a point $P$ is $V(P)=-\displaystyle\int_{\mathrm{ref}}^{P}\mathbf E\cdot d\mathbf l$, the work per unit charge, with the opposite sign, to bring a test charge from a reference point to $P$. Its unit is the volt, $1\ \mathrm V=1\ \mathrm J/\mathrm C$. Only differences of $V$ have meaning; the reference is usually infinity or the ground.
{: .definition #def-electric-potential title="Electric potential"}

Applied to a point charge $Q$ with the reference at infinity, the definition gives
$$ V(r)=\frac{Q}{4\pi\varepsilon_0r}. $$
The potential is a scalar, so for a collection of charges one adds the numbers: $V=\sum_iQ_i/(4\pi\varepsilon_0r_i)$, or $V=\frac1{4\pi\varepsilon_0}\int\frac{dq}{r}$ for a continuous distribution. That is the practical gain. For a ring of charge $Q$ and radius $R$, every element is at distance $\sqrt{z^2+R^2}$ from a point on the axis, so
$$ V(z)=\frac{Q}{4\pi\varepsilon_0\sqrt{z^2+R^2}}, $$
with no integral left to do, whereas the field needs the components of every contribution.

# From potential back to field

> The field is minus the gradient of the potential, $\mathbf E=-\nabla V$. Equivalently, the potential difference between two nearby points is $dV=-\mathbf E\cdot d\mathbf l$.
{: .property #prop-field-from-potential title="Field from the potential"}

The ring gives a check. Differentiating along the axis, $E_z=-\dfrac{dV}{dz}=\dfrac{Q\,z}{4\pi\varepsilon_0(z^2+R^2)^{3/2}}$, which is what direct integration of the vector contributions gives; by symmetry the transverse components vanish on the axis.

> An **equipotential** is a surface on which $V$ is constant. The field is perpendicular to it at every point, and points toward decreasing $V$.
{: .definition #def-equipotential title="Equipotential"}

The perpendicularity follows from $\mathbf E=-\nabla V$, since the gradient is normal to the level surfaces. Moving along an equipotential costs no work. The spacing of equipotentials drawn at equal steps of $V$ shows the strength of the field: close together means large $|\nabla V|$.

{% include fig.html src="electromagnetism/point-charge-potential" id="fig-point-charge-potential" alt="Left, concentric circles around a point charge that crowd together toward the centre, with radial field lines. Right, the curve V equals one over r with points at equal steps in V and their distances, which bunch up as r shrinks." caption="Equipotentials of a point charge at equal steps of $V$ (left) and the same levels on the curve $V\propto1/r$ (right). Equal steps in $V$ need ever smaller steps in $r$ near the charge, where the slope, and so the field, is largest." %}

> A conductor in electrostatic equilibrium is an equipotential, with $\mathbf E=0$ inside, and the field at its surface is perpendicular to it. Field lines therefore leave a conductor at right angles.
{: .implication title="Conductors are equipotentials"}

> The potential can vanish where the field does not. At the midpoint of two equal and opposite charges $V=0$ but $\mathbf E\ne0$. The reverse also happens, as in the interior of a charged shell, where $\mathbf E=0$ and $V$ is a non-zero constant. $V=0$ depends on the reference, $\mathbf E$ does not.
{: .trap}

# Energy

> The **electrostatic energy** of a configuration of point charges is the work needed to assemble it from infinity, $U=\displaystyle\sum_{i<j}\frac{q_iq_j}{4\pi\varepsilon_0r_{ij}}=\frac12\sum_iq_iV_i$, where $V_i$ is the potential at charge $i$ due to all the others.
{: .definition #def-electrostatic-energy title="Electrostatic energy"}

Bringing in the first charge costs nothing. The second feels the potential of the first, the third that of both, and so on; the pair sum counts each interaction once, and the half in the second form removes the double counting. A charge $q$ in a potential $V$ has energy $qV$, and the unit most used at atomic scale is the electronvolt, the energy gained by a charge $e$ across one volt, $1\ \mathrm{eV}=1.602\times10^{-19}$ J.

> For the electron and proton of hydrogen at the Bohr radius $a_0=0.529$ Å, $U=-\dfrac{e^2}{4\pi\varepsilon_0a_0}$. Using $e^2/(4\pi\varepsilon_0)=14.40$ eV Å gives $U\approx-27.2$ eV, twice the binding energy of the ground state ($13.6$ eV). The rest is kinetic energy, which for a bound orbit equals minus half the potential energy.
{: .example title="Scale of atomic energies"}

The same bookkeeping applies to a continuous distribution, $U=\tfrac12\int\rho V\,dV$. The next note on conductors and capacitors uses it to show that a capacitor stores energy $\tfrac12CV^2$, and the energy can be assigned to the field itself, with density $\tfrac12\varepsilon_0E^2$.

> To find the potential, ask first whether the charge distribution is symmetric enough for Gauss's law to give $\mathbf E$ and then integrate, or whether it is easier to add $dq/r$ directly. For a finite distribution choose $V(\infty)=0$; for an infinite line or plane that choice fails, and one fixes the reference at a finite point.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why can the electrostatic field be replaced by a scalar potential?</summary>

The work done by the field between two points is path independent, so $\oint\mathbf E\cdot d\mathbf l=0$, and a function $V$ exists with $\mathbf E=-\nabla V$.
</details>

<details class="qa" markdown="1">
<summary>Why does summing potentials beat summing fields?</summary>

Potentials are scalars, so contributions add as numbers; the field needs vector components of each contribution. The field is then obtained by differentiating.
</details>

<details class="qa" markdown="1">
<summary>What can you say about the field at the surface of a conductor?</summary>

The conductor is an equipotential, so the field there is perpendicular to the surface; inside, the field is zero.
</details>
