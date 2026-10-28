---
collection: notes
title: "Conductors and Capacitors"
date: 2026-10-27
excerpt: "A conductor in equilibrium, capacitance, capacitors in networks, and the energy stored in a field."
hook: "In equilibrium the field inside a conductor is zero and its surface is an equipotential; two such surfaces facing each other store charge and energy, which is a capacitor."
goals:
  - state the properties of a conductor in electrostatic equilibrium
  - compute the capacitance of the standard geometries
  - find the energy stored in a capacitor and in its field
requires:
  - electric-potential
  - gauss-law
  - electrostatic-energy
defines:
  - {id: conductor-in-equilibrium, name: conductor in equilibrium, anchor: def-conductor-in-equilibrium}
  - {id: capacitance, name: capacitance, anchor: def-capacitance}
  - {id: field-energy-density, name: energy density of the electric field, anchor: def-field-energy-density}
read_time: true
tags:
  - Physics
  - Electromagnetism
---

A metal contains charges that move freely, and this one fact fixes the electrostatics of conductors completely: the charges rearrange until nothing pushes them any more. Two conductors close together then store charge and energy, which is what a capacitor is.

# Conductors in equilibrium

> A **conductor in electrostatic equilibrium** is a conductor in which the free charges have stopped moving. In that state the field inside is zero, the net charge sits on the surface, the whole conductor is at one potential, and the field just outside the surface is perpendicular to it with magnitude $\sigma/\varepsilon_0$.
{: .definition #def-conductor-in-equilibrium title="Conductor in equilibrium"}

Each statement has a short argument. If the field inside were not zero, the free charges would feel a force and move, so equilibrium means $\mathbf E=0$ inside. Gauss's law then gives zero enclosed charge for every surface inside, so any net charge is on the boundary. With $\mathbf E=0$ the potential is constant in the conductor, so the surface is an equipotential and the field outside cannot have a tangential part: a tangential component would drive charge along the surface. Finally, a small pillbox through the surface encloses $\sigma A$ and has flux $EA$ through the outer face only, so $E=\sigma/\varepsilon_0$.

> A cavity inside a conductor, with no charge in it, has no field in it either. The shell screens its interior from outside fields, which is the principle behind a Faraday cage.
{: .implication title="Shielding"}

# Capacitance

> The **capacitance** of a pair of conductors carrying charges $+Q$ and $-Q$ is $C=Q/V$, where $V$ is the potential difference between them. It depends only on their geometry and the material between them, and is measured in farads, $1\,\mathrm F=1\,\mathrm C/\mathrm V$.
{: .definition #def-capacitance title="Capacitance"}

The field is proportional to $Q$, and so is the potential difference, which is why the ratio is a property of the geometry. Each standard case follows from Gauss's law, then $V=\int\mathbf E\cdot d\mathbf l$.

{% capture t %}
| Geometry | Capacitance |
|:--|:--|
| parallel plates, area $A$, spacing $d$ | $C=\varepsilon_0A/d$ |
| concentric spheres, radii $a<b$ | $C=4\pi\varepsilon_0\,ab/(b-a)$ |
| isolated sphere, radius $a$ | $C=4\pi\varepsilon_0a$ |
| coaxial cylinders, length $\ell$ | $C=2\pi\varepsilon_0\ell/\ln(b/a)$ |
{% endcapture %}
{% include tab.html id="tab-capacitances" caption="Capacitance of standard geometries, from Gauss's law." body=t %}
{: .booktabs}

For plates of area $100\ \mathrm{cm^2}$ spaced by $1$ mm, $C=\varepsilon_0A/d=88.5$ pF. The parallel-plate formula neglects the field at the edges, which is a good approximation when $d$ is much smaller than the plate size. Capacitors in parallel add, $C=C_1+C_2$, because they share the voltage; in series the inverses add, because they share the charge.

# Energy in the field

Charging a capacitor to $Q$ takes work $dW=V\,dq=(q/C)\,dq$, so the stored energy is
$$ U=\frac{Q^2}{2C}=\tfrac12CV^2. $$
For the plates above at $100$ V this is $0.44\ \mu$J. Writing it with the field, $E=V/d$ and $C=\varepsilon_0A/d$, gives $U=\frac12\varepsilon_0E^2\,(Ad)$: the energy is the volume of the gap times a density that depends on the field only.

> The electrostatic field stores energy with density $u=\tfrac12\varepsilon_0E^2$ per unit volume, so the total energy in a region is $U=\int\tfrac12\varepsilon_0E^2\,dV$. This holds for any field, not only between plates.
{: .law #def-field-energy-density title="Energy density of the electric field"}

It locates the energy in space, and it is the first step to the energy carried by electromagnetic waves.

{% include fig.html src="electromagnetism/capacitor-energy" id="fig-capacitor-energy" alt="Energy against plate spacing for a parallel-plate capacitor: a rising straight line for fixed charge and a falling curve for fixed voltage, crossing at 1 mm." caption="The same capacitor at 1 mm, with the plates then moved. At fixed charge the energy $Q^2d/2\varepsilon_0A$ grows linearly with the spacing; at fixed voltage $\varepsilon_0AV^2/2d$ falls as $1/d$." %}

> The force between the plates is not $QE$ with the full field: each plate feels only the field of the other, which is half of the total, $F=\tfrac12QE=Q^2/(2\varepsilon_0A)$. The same value follows from $F=-dU/dd$ at fixed charge, and for the example above, at $100$ V and $1$ mm, it is $0.44$ mN.
{: .trap}

> To find the capacitance of a geometry, put $\pm Q$ on the conductors, find $\mathbf E$ from Gauss's law, integrate it to get $V$ and take $Q/V$. For the energy use $Q^2/2C$ or integrate $\frac12\varepsilon_0E^2$.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What are the properties of a conductor in electrostatic equilibrium?</summary>

The field inside is zero, the charge is on the surface, the whole conductor is one potential, and the field at the surface is normal with magnitude $\sigma/\varepsilon_0$.
</details>

<details class="qa" markdown="1">
<summary>Why does capacitance depend only on geometry?</summary>

The field and hence $V$ are proportional to $Q$ by superposition, so $Q/V$ does not depend on the charge.
</details>

<details class="qa" markdown="1">
<summary>Where is the energy of a charged capacitor stored?</summary>

In the field, with density $\frac12\varepsilon_0E^2$. For plates, $\frac12CV^2$ equals this density times the volume $Ad$ of the gap.
</details>
