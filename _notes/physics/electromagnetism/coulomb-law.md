---
collection: notes
title: Coulomb's Law and Superposition
date: '2026-10-27'
excerpt: Charge, the force between two point charges, the field as force per unit charge, and why fields add.
hook: Two charges push or pull along the line between them with a force that falls as the inverse square of the distance; the electric field is that force with the test charge divided out.
goals:
- state Coulomb's law and the superposition principle
- define the electric field of a point charge and of a few charges
- draw field lines and read strength and direction from them
defines:
- id: coulomb-law
  name: Coulomb's law
  anchor: force-between-charges
- id: electric-field
  name: electric field
  anchor: the-field
- id: superposition-principle
  name: superposition principle
  anchor: superposition
plan:
  sources: []
  figures:
  - field lines of one charge and of a dipole
  - superposition of two point-charge fields on a line
  verify:
  - 1/(4 pi epsilon0) = 8.99e9 N m^2 / C^2
  - the field of a dipole falls as 1/r^3 on axis
tags:
- Physics
- Electromagnetism
read_time: true
---

Rub two rods and they attract or repel, with no contact. Electrostatics begins by saying exactly how strongly, and then replaces the force between charges by something that exists at every point in space.

# Force between charges

Matter carries a property called **electric charge**, of two kinds that we label positive and negative. Like charges repel and unlike charges attract. Charge is conserved, and in isolated systems it comes in integer multiples of the elementary charge $e=1.602\times10^{-19}\ \mathrm{C}$.

For two point charges $q_1$ and $q_2$ at rest, separated by a distance $r$, **Coulomb's law** gives the magnitude of the force
$$ F=\frac{1}{4\pi\varepsilon_0}\frac{|q_1q_2|}{r^2}, $$
directed along the line joining them: repulsive when $q_1q_2>0$, attractive when $q_1q_2<0$. With the vacuum permittivity $\varepsilon_0=8.854\times10^{-12}\ \mathrm{C^2/(N\,m^2)}$, the constant is $1/4\pi\varepsilon_0=8.99\times10^{9}\ \mathrm{N\,m^2/C^2}$. In vector form, the force on $q_2$ from $q_1$ is
$$ \mathbf F_{21}=\frac{q_1q_2}{4\pi\varepsilon_0}\frac{\hat{\mathbf r}_{21}}{r^2}, $$
where $\hat{\mathbf r}_{21}$ points from $q_1$ to $q_2$. The form is the same as Newton's law of gravitation, with one difference of kind: the electric force can repel, and for the proton and electron in hydrogen it is stronger than gravity by a factor of about $10^{39}$.

# The field

To describe the force on $q$ without mentioning the source, divide it by $q$. The **electric field** at a point $\mathbf r$ is the force per unit test charge,
$$ \mathbf E(\mathbf r)=\lim_{q\to0}\frac{\mathbf F}{q},\qquad\text{so}\qquad \mathbf F=q\mathbf E. $$
The limit means the test charge is small enough not to disturb the sources. A point charge $Q$ at the origin produces
$$ \mathbf E=\frac{Q}{4\pi\varepsilon_0}\frac{\hat{\mathbf r}}{r^2}, $$
pointing away from $Q$ if it is positive and towards it if it is negative. The unit is N/C, equal to V/m.

The field is more than bookkeeping. A change in the sources reaches distant points with a delay, which a force acting instantly at a distance would not explain, and a field can carry energy and momentum. In this note the field is just the force with $q$ divided out, which is enough for statics.

**Field lines** are curves tangent to $\mathbf E$ at every point, drawn leaving positive charges and ending on negative ones. Their direction is the direction of $\mathbf E$ and their density is a measure of its magnitude: close lines mean a strong field. Two lines never cross, because $\mathbf E$ has one direction at each point.

# Superposition

Experiment shows that the force on a charge from several others is the vector sum of the forces from each alone. This is the **superposition principle**, and it is an assumption about nature, not a theorem: the presence of a second charge does not change the force from the first. It makes the field of a collection of point charges $q_i$ at positions $\mathbf r_i$ a sum,
$$ \mathbf E(\mathbf r)=\sum_i\frac{q_i}{4\pi\varepsilon_0}\frac{\mathbf r-\mathbf r_i}{|\mathbf r-\mathbf r_i|^3}, $$
and a continuous distribution an integral of the same form over its charge density. Because the sum is of vectors, symmetry often cancels most of it.

For an **electric dipole**, charges $+q$ and $-q$ a distance $d$ apart, put the origin at the midpoint with the charges on the $x$ axis. At a distance $r\gg d$ on that axis the two fields nearly cancel. Expanding the difference gives
$$ E\approx\frac{1}{4\pi\varepsilon_0}\frac{2p}{r^3},\qquad p=qd, $$
where $p$ is the dipole moment. The field falls as $1/r^3$, faster than the $1/r^2$ of a single charge, because the two contributions have opposite sign. A numerical check with $q=1$, $d=2$ and the exact sum of the two point fields gives $E\,r^3/(2p)=1.005$ at $r=10d$ (in units where $1/4\pi\varepsilon_0=1$), consistent with the leading term and a correction of order $(d/r)^2$.

{% include fig.html src="electromagnetism/dipole-field" id="fig-dipole-field" alt="Field lines of a pair of opposite charges. Lines leave the positive charge on the left in all directions, and those that curve around end on the negative charge on the right, while others extend outward to the edge of the figure." caption="Field lines of a dipole, traced numerically from the positive charge (left) by integrating the direction of the summed field. The lines are densest between the charges, where the field is strongest." %}

{% capture t %}
| Source | Field at distance $r$ | Falls as |
|:--|:--|:--|
| point charge $Q$ | $Q/(4\pi\varepsilon_0r^2)$ | $r^{-2}$ |
| dipole, on the axis | $2p/(4\pi\varepsilon_0r^3)$ | $r^{-3}$ |
{% endcapture %}
{% include tab.html id="tab-fields" caption="Far fields of a point charge and a dipole." body=t %}
{: .booktabs}

> Superposition applies to the fields and the forces, which are vectors. It does not apply to the energy or to the squares of the field: the energy stored in two charges is not the sum of the energies of each alone.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>What does Coulomb's law say?</summary>

The force between two point charges at rest has magnitude $|q_1q_2|/(4\pi\varepsilon_0r^2)$, acts along the line joining them, and is repulsive for charges of the same sign.
</details>

<details class="qa" markdown="1">
<summary>What is the electric field?</summary>

The force per unit test charge, $\mathbf E=\mathbf F/q$. A point charge $Q$ gives $Q\hat{\mathbf r}/(4\pi\varepsilon_0r^2)$.
</details>

<details class="qa" markdown="1">
<summary>What does superposition allow, and how does a dipole field fall off?</summary>

The field of several charges is the vector sum of the fields of each. For a dipole the sum nearly cancels at large distance, leaving a field $\propto1/r^3$.
</details>
