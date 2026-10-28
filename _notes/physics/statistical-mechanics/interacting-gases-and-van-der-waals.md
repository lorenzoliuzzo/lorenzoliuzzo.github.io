---
collection: notes
title: Interacting Gases and the van der Waals Equation
date: '2026-10-27'
excerpt: A pair potential with a hard core and a weak attraction, treated at mean-field level, gives an equation of state with a liquid-gas transition and a critical point.
hook: 'Add a repulsive core and a weak long-range attraction to the ideal gas and treat the attraction as an average field: the resulting equation of state describes a gas, a liquid and the critical point between them.'
goals:
- write the free energy of a gas with a pair potential in the mean-field approximation
- derive the van der Waals equation of state
- locate the critical point and write the equation in reduced variables
requires:
- ideal-gas-partition-function
- mean-field-approximation
- critical-point
- phase-transition
defines:
- id: pair-potential
  name: pair potential
  anchor: def-pair-potential
- id: van-der-waals-equation
  name: van der Waals equation
  anchor: def-van-der-waals-equation
- id: maxwell-construction
  name: Maxwell construction
  anchor: def-maxwell-construction
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The partition function of an interacting gas contains a $3N$-dimensional integral over positions that does not factorise, and there is no general solution. A mean-field treatment keeps its two qualitative effects, a minimum volume and a net attraction, and already shows a phase transition {% cite kardar-2007 %}.

# A pair potential with a core and a tail

> Particles interact through a **pair potential** $u(r)$, the interaction energy of two particles at distance $r$.
{: .definition #def-pair-potential title="Pair potential"}

Between neutral atoms it is strongly repulsive at short range, because electron clouds overlap, and weakly attractive at larger distances. Two ingredients of that shape are kept. The repulsive core means each particle excludes a volume $b$ to the others, so the free volume is $V-Nb$ and not $V$. The attractive tail is replaced by its average: each particle sits in an attractive potential proportional to the density of the others, and the interaction energy of the whole gas is $-aN^2/V$, with $a>0$ a measure of the tail's strength.

# The van der Waals equation

Applying both corrections to the ideal-gas free energy gives

$$ F=-NkT\Big[\ln\frac{V-Nb}{N\lambda^3}+1\Big]-\frac{aN^2}{V}. $$

> The pressure $p=-\partial F/\partial V$ is the **van der Waals equation**,
{: .definition #def-van-der-waals-equation title="Van der Waals equation"}

$$ \Big(p+\frac{aN^2}{V^2}\Big)(V-Nb)=NkT. $$

The entropy is that of the ideal gas with $V$ replaced by $V-Nb$, $S=Nk[\ln((V-Nb)/N\lambda^3)+5/2]$, so the attraction does not change it at this level of approximation. The approximation is mean-field in the sense that every particle feels the same average environment and correlations between neighbours are ignored.

# The critical point

Above a temperature $T_c$ the isotherms of $p(V)$ decrease monotonically. Below it they have a maximum and a minimum, a region where $\partial p/\partial V>0$, which is thermodynamically unstable. The critical isotherm has an inflection with zero slope, so $\partial p/\partial V=\partial^2p/\partial V^2=0$ at the critical point. Solving the two conditions gives

$$ v_c=3b,\qquad kT_c=\frac{8a}{27b},\qquad p_c=\frac{a}{27b^2},\qquad \frac{p_cv_c}{kT_c}=\frac38, $$

with $v=V/N$. In reduced variables $\tilde p=p/p_c$, $\tilde v=v/v_c$, $\tilde t=T/T_c$ the equation has no material constants left:

$$ \Big(\tilde p+\frac3{\tilde v^2}\Big)(3\tilde v-1)=8\tilde t. $$

{% include fig.html src="statistical-mechanics/vdw-isotherms" id="fig-vdw" alt="Three van der Waals isotherms in reduced variables. The upper one decreases monotonically, the middle has an inflection at the critical point, and the lower one has a maximum and a minimum with a dashed horizontal Maxwell line crossing it." caption="Reduced van der Waals isotherms at $0.85\,T_c$, $T_c$ and $1.15\,T_c$. The dot is the critical point. For the lower isotherm the dashed line is the Maxwell construction: the pressure at which gas and liquid coexist." %}

# Below the critical temperature

On the lower isotherm the wavy part cannot be an equilibrium state.

> The **Maxwell construction** replaces it with a horizontal line at the pressure where the areas above and below it are equal, which is the pressure at which the Gibbs free energies per particle of the two phases coincide.
{: .definition #def-maxwell-construction title="Maxwell construction"}

The volumes at the two ends of the line are those of the liquid and the gas, and between them the system is a mixture. The parts of the isotherm outside the line but inside the unstable region are metastable: superheated liquid and supercooled gas.

> The van der Waals loop is an artefact of mean field. The exact free energy of a finite system in a box is convex, with no loop. The approximation produces the loop because it fixes the density to be uniform.
{: .trap}

The ratio $p_cv_c/kT_c=3/8=0.375$ is the same for every van der Waals gas. Measured values for real fluids lie near $0.29$ to $0.31$, so the theory is qualitatively right and quantitatively off, a point the next note returns to.

# Recap

<details class="qa" markdown="1">
<summary>Which two features of the pair potential does the van der Waals equation keep?</summary>

The repulsive core, as an excluded volume $b$ per particle, and the attractive tail, as an average attraction that lowers the energy by $aN^2/V$.
</details>

<details class="qa" markdown="1">
<summary>How are the critical constants found?</summary>

By requiring that the first and second derivatives of $p$ with respect to $v$ vanish at the critical isotherm, which gives $v_c=3b$, $kT_c=8a/27b$ and $p_c=a/27b^2$.
</details>

<details class="qa" markdown="1">
<summary>What does the Maxwell construction determine?</summary>

The coexistence pressure at a given temperature below $T_c$, where the equal-area rule makes the free energies per particle of the liquid and gas equal. The ends of the line are the liquid and gas volumes.
</details>
