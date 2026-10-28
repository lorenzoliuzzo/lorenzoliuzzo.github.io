---
collection: notes
title: The First Law
date: '2026-10-27'
excerpt: Heat, work, internal energy and heat capacities.
hook: Energy is conserved once heat is counted as a form of it, and what you can do with it depends on the path.
goals:
- compute heat and work in standard processes
- relate heat capacities to the equation of state
requires:
- temperature
- ideal-gas
defines:
- id: first-law
  name: first law
  anchor: first-law
- id: heat-capacity
  name: heat capacity
  anchor: heat-capacity
tags:
- Physics
- Thermodynamics
read_time: true
---

Mechanics already has energy conservation. The first law extends it to include heat, which is energy that crosses the boundary of a system without any visible motion, and it tells us what quantities depend only on the state and which on the path.

# First law

A system has an **internal energy** $U$, a function of its state, the total energy of its molecules in the frame of the system. It can change in two ways: the system does **work** $W$ on its surroundings, and it absorbs **heat** $Q$ from them. The **first law** states that
$$ \Delta U=Q-W, $$
with the convention that $W>0$ when the system does work, and $Q>0$ when heat flows in. For small steps, $dU=\delta Q-\delta W$, where the slashed $\delta$ marks quantities that are not changes of a state function.

The point is the contrast. $U$ depends only on the state, so $\Delta U$ between two states is the same by every path. $Q$ and $W$ separately depend on the path. For a gas, the work in a quasi-static volume change is $W=\int p\,dV$, the area under the path in the $p$-$V$ plane. A gas of $N=2.4\times10^{22}$ molecules at $300\ \mathrm K$ goes from $1\ \mathrm L$ to $2\ \mathrm L$ by three paths, ending at the same temperature. For an ideal gas $U$ depends on $T$ alone, so $\Delta U=0$ and $Q=W$, but the work differs:

{% capture t %}
| Path | Work $W$ (J) |
|:--|:--|
| isothermal expansion, $W=NkT\ln2$ | 68.9 |
| isobaric at $99.4\ \mathrm{kPa}$, then cooling at fixed $V$ | 99.4 |
| cooling at fixed $V$ to $49.7\ \mathrm{kPa}$, then isobaric | 49.7 |
{% endcapture %}
{% include tab.html id="tab-paths" caption="Work done on three paths between the same states of an ideal gas." body=t %}
{: .booktabs}

{% include fig.html src="thermodynamics/work-paths" id="fig-work-paths" alt="A pressure-volume diagram with a hyperbola from one litre to two litres and two other paths between the same endpoints made of a horizontal and a vertical segment. The area under each path is the work." caption="Three paths from $(1\ \mathrm L,\,99.4\ \mathrm{kPa})$ to $(2\ \mathrm L,\,49.7\ \mathrm{kPa})$. The shaded region under the isotherm is $W=68.9\ \mathrm J$; the rectangle paths enclose $99.4\ \mathrm J$ and $49.7\ \mathrm J$." %}

Because $Q$ and $W$ depend on the path, we cannot speak of "the heat in a body". Heat is a name for a process, not a store.

# Heat capacity

The **heat capacity** is the heat needed per unit temperature rise, $C=\delta Q/dT$, and it depends on what is held fixed. At constant volume no work is done, so $\delta Q=dU$ and
$$ C_V=\Big(\frac{\partial U}{\partial T}\Big)_V. $$
At constant pressure the gas also expands, and the heat also pays for the work $p\,dV$. For an ideal gas, with $pV=NkT$, this adds exactly $Nk$:
$$ C_p=C_V+Nk,\qquad\text{per mole}\quad C_p-C_V=R. $$
For a monatomic gas, the molecules have only translational energy $\tfrac32kT$ each, so $U=\tfrac32NkT$, $C_V=\tfrac32Nk$ and $C_p=\tfrac52Nk$. Per mole that is $12.47$ and $20.79\ \mathrm{J/(mol\,K)}$, in agreement with measurements for helium and argon. Heating the sample above at fixed volume by $300\ \mathrm K$ takes $\tfrac32NkT=149\ \mathrm J$. The ratio $\gamma=C_p/C_V=5/3$ governs adiabatic processes, those with $Q=0$, for which $pV^\gamma$ is constant: with $dU=-p\,dV$ and $dU=C_VdT$, one finds $TV^{\gamma-1}=\text{const}$.

Gases with rotating molecules store more: a diatomic gas at room temperature has $C_V=\tfrac52Nk$, two extra quadratic terms from rotation, and $\gamma=7/5$. The pattern, $\tfrac12kT$ per quadratic degree of freedom, is the equipartition theorem, derived in statistical mechanics.

{% capture t %}
| Process | $\Delta U$ | $W$ | $Q$ |
|:--|:--|:--|:--|
| isochoric | $C_V\Delta T$ | $0$ | $C_V\Delta T$ |
| isobaric | $C_V\Delta T$ | $p\Delta V$ | $C_p\Delta T$ |
| isothermal | $0$ | $NkT\ln(V_2/V_1)$ | $=W$ |
| adiabatic | $C_V\Delta T$ | $-\Delta U$ | $0$ |
{% endcapture %}
{% include tab.html id="tab-processes-first" caption="The first law for the standard ideal-gas processes." body=t %}
{: .booktabs}

# Recap

<details class="qa" markdown="1">
<summary>What is the first law, and which of its terms depend on the path?</summary>

$\Delta U=Q-W$. The internal energy $U$ is a state function; $Q$ and $W$ separately depend on the path.
</details>

<details class="qa" markdown="1">
<summary>Why is $C_p$ larger than $C_V$ for an ideal gas?</summary>

At constant pressure the gas expands and does work $p\,dV$, which the heat must also supply; this adds $Nk$ per kelvin, so $C_p=C_V+Nk$.
</details>

<details class="qa" markdown="1">
<summary>What are $C_V$ and $\gamma$ for a monatomic ideal gas?</summary>

$C_V=\tfrac32Nk$, $C_p=\tfrac52Nk$ and $\gamma=5/3$.
</details>
