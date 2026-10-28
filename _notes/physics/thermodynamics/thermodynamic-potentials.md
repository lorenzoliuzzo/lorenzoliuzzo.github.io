---
collection: notes
title: "Thermodynamic Potentials"
date: 2026-10-27
excerpt: "Free energies, Legendre transforms, Maxwell relations and equilibrium conditions."
hook: "Which potential is minimized depends on what the surroundings hold fixed, and the Maxwell relations connect quantities that look unrelated."
goals:
  - choose the potential for given constraints
  - derive relations between response functions
requires:
  - entropy
  - first-law
defines:
  - {id: free-energy, name: "free energy", anchor: def-free-energy}
  - {id: maxwell-relations, name: "Maxwell relations", anchor: def-maxwell-relations}
read_time: true
tags:
  - Physics
  - Thermodynamics
---

The second law bounds what a system can do, but in a laboratory one rarely holds the energy and entropy fixed. One holds the temperature, or the pressure, and the right question is which function the system minimizes under those conditions.

# Changing variables with the Legendre transform

For a closed system of fixed composition the first and second laws combine into
$$ dU=T\,dS-p\,dV, $$
so $U$ is naturally a function of the entropy and the volume. Entropy is hard to control; temperature is easy. Replacing $S$ by $T$ as the variable is done by subtracting the product $TS$, which is a **Legendre transform**: the tangent to $U(S)$ with slope $T$ meets the vertical axis at $U-TS$, and the family of tangent lines, indexed by $T$, contains the same information as $U(S)$ when $U$ is convex.

{% include fig.html src="thermodynamics/legendre-free-energy" id="fig-legendre-free-energy" alt="A convex curve U of S with two tangent lines. The steeper tangent meets the vertical axis at a lower point, marked as the free energy U minus T S." caption="The free energy as a Legendre transform. The tangent to $U(S)$ with slope $T$ crosses the axis at $F=U-TS$. Changing the slope moves the intercept, so $F$ is a function of $T$." %}

> The **free energies** are the Legendre transforms of $U$ that trade entropy for temperature, and volume for pressure. The Helmholtz free energy is $F=U-TS$ and the Gibbs free energy is $G=U-TS+pV$; the enthalpy is $H=U+pV$.
{: .definition #def-free-energy title="Free energy"}

Differentiating, and using $dU=T\,dS-p\,dV$, gives the differentials, each in its natural variables:

{% capture t %}
| Potential | Definition | Differential | Natural variables |
|:--|:--|:--|:--|
| internal energy | $U$ | $dU=T\,dS-p\,dV$ | $S,V$ |
| enthalpy | $H=U+pV$ | $dH=T\,dS+V\,dp$ | $S,p$ |
| Helmholtz free energy | $F=U-TS$ | $dF=-S\,dT-p\,dV$ | $T,V$ |
| Gibbs free energy | $G=H-TS$ | $dG=-S\,dT+V\,dp$ | $T,p$ |
{% endcapture %}
{% include tab.html id="tab-potentials" caption="The four potentials. Each is a function of the variables in the last column, and its derivatives with respect to them are the other thermodynamic quantities." body=t %}
{: .booktabs}

Reading $dF=-S\,dT-p\,dV$ shows the point: $S=-(\partial F/\partial T)_V$ and $p=-(\partial F/\partial V)_T$. One function $F(T,V)$ gives the entropy and the equation of state, and so contains the whole thermodynamics of the system.

# Which potential is minimized

Put a system in contact with a reservoir at temperature $T$ and hold its volume fixed. A heat $Q$ enters the system from the reservoir, so the reservoir's entropy changes by $-Q/T$. The second law for system plus reservoir says $\Delta S-Q/T\ge0$. With no work done at fixed $V$, $Q=\Delta U$, so $\Delta U-T\Delta S\le0$.

> At fixed temperature and volume, a system evolves to decrease its Helmholtz free energy, and equilibrium is the minimum of $F$. At fixed temperature and pressure, the same argument gives that equilibrium is the minimum of $G$.
{: .law title="Equilibrium conditions"}

Free energy also says how much work a process can deliver. At constant temperature the maximum work extractable from a change of state is $-\Delta F$, reached by a reversible process; the rest of $\Delta U$ must leave as heat, $T\Delta S$ or more.

> One mole of ideal gas at $300$ K expands reversibly and isothermally to twice its volume. $U$ does not change, and the free-energy change is $\Delta F=-nRT\ln2=-1.73$ kJ, which is the work done on the piston. The same $1.73$ kJ is absorbed as heat from the reservoir, because $\Delta S=nR\ln2$.
{: .example title="Free energy and work"}

> Each potential is minimized only under its own constraints. $F$ decreases at fixed $T$ and $V$, but a system at fixed $T$ and $p$, such as a reaction open to the air, is governed by $G$. Using the wrong one gives the wrong sign for the spontaneous direction.
{: .trap}

# Maxwell relations

The differentials in the table are exact, and mixed second derivatives of a smooth function are equal. Applying that to each potential gives equalities between derivatives that look unrelated.

> **Maxwell relations.** From $dF$, $dG$, $dU$ and $dH$ respectively,
> $$ \Big(\frac{\partial S}{\partial V}\Big)_T=\Big(\frac{\partial p}{\partial T}\Big)_V,\quad \Big(\frac{\partial S}{\partial p}\Big)_T=-\Big(\frac{\partial V}{\partial T}\Big)_p,\quad \Big(\frac{\partial T}{\partial V}\Big)_S=-\Big(\frac{\partial p}{\partial S}\Big)_V,\quad \Big(\frac{\partial T}{\partial p}\Big)_S=\Big(\frac{\partial V}{\partial S}\Big)_p. $$
{: .theorem #def-maxwell-relations title="Maxwell relations"}

> Each potential has an exact differential, for example $dF=-S\,dT-p\,dV$. For $dF=A\,dT+B\,dV$ the equality of mixed second derivatives gives $\partial_VA=\partial_TB$, here $-(\partial S/\partial V)_T=-(\partial p/\partial T)_V$. The other three follow in the same way from $dG=-S\,dT+V\,dp$, $dU=T\,dS-p\,dV$ and $dH=T\,dS+V\,dp$.
{: .proof}

Their value is that the left sides involve entropy, which cannot be measured directly, while the right sides are measured from the equation of state. For an ideal gas the first gives $(\partial S/\partial V)_T=(\partial p/\partial T)_V=nR/V$, which integrates to the entropy change $nR\ln(V_2/V_1)$ used in the previous note. The second says that squeezing a body isothermally lowers its entropy by $-V\alpha\,dp$, with $\alpha$ its thermal expansion coefficient.

> The difference of the heat capacities follows from the relations: $C_p-C_V=TV\alpha^2/\kappa_T\ge0$, with $\kappa_T$ the isothermal compressibility. For an ideal gas $\alpha=1/T$ and $\kappa_T=1/p$, so $C_p-C_V=pV/T=nR$.
{: .implication title="Heat capacities"}

> To derive a relation, write the differential of the potential whose natural variables are the ones held fixed, then equate the mixed second derivatives. If the answer has a derivative at fixed $S$, convert it with the chain rule to ones you can measure.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>Why does a system at fixed $T$ and $V$ minimize $F$ rather than $U$?</summary>

Heat flows between the system and the reservoir, so the system's entropy can change. Requiring that total entropy not decrease gives $\Delta U-T\Delta S\le0$, that is $\Delta F\le0$.
</details>

<details class="qa" markdown="1">
<summary>What is the use of the Maxwell relations?</summary>

They replace a derivative of the entropy, which is not measurable, with a derivative of $p$, $V$ or $T$, which is, so entropy changes can be computed from the equation of state.
</details>

<details class="qa" markdown="1">
<summary>How much work can be extracted from a system at constant temperature?</summary>

At most $-\Delta F$, attained by a reversible process; any irreversibility reduces it.
</details>
