---
collection: notes
title: "The Second Law and Entropy"
date: 2026-10-27
excerpt: "Heat engines, the Clausius and Kelvin statements, entropy and the arrow of time."
hook: "Some processes never run backwards, and entropy is the state function that records which ones."
goals:
  - state the second law in two equivalent forms
  - compute entropy changes
requires:
  - first-law
defines:
  - {id: second-law, name: "second law", anchor: def-second-law}
  - {id: entropy, name: "entropy", anchor: def-entropy}
read_time: true
tags:
  - Physics
  - Thermodynamics
---

The first law allows any process that conserves energy, yet a cup of coffee never warms itself from the room. The second law says which processes are allowed, and entropy is the state function that keeps the score.

# Two statements of the second law

A **heat engine** takes heat $Q_h$ from a hot reservoir, rejects $Q_c$ to a cold one and delivers work $W=Q_h-Q_c$ by the first law; its **efficiency** is $\eta=W/Q_h$. Two observations about what such devices cannot do are the starting point.

> **Second law.** No process has as its only result the conversion of heat from a single reservoir entirely into work (Kelvin and Planck). Equivalently, no process has as its only result the transfer of heat from a colder to a hotter body (Clausius).
{: .definition #def-second-law title="Second law of thermodynamics"}

The two forms are equivalent. A machine that violated Clausius could move $Q_c$ from the cold to the hot reservoir for free; running an ordinary engine alongside it that takes $Q_h$ from the hot side and returns $Q_c$ would then turn the net heat $Q_h-Q_c$ from the hot reservoir into work with no other effect, which violates Kelvin. The same argument run the other way proves the converse.

Neither form says heat cannot go from cold to hot, only that it cannot do so *alone*: a refrigerator does it, at the price of work and of heat released into the room. What the law rules out is the free version.

# Entropy

Energy conservation is a statement about a state function, $U$. The second law turns out to be one too, but the function is not obvious, because $\delta Q$ is not a change of a state function.

> For a reversible cycle, $\oint\delta Q_{\mathrm{rev}}/T=0$ (Clausius). Hence $\delta Q_{\mathrm{rev}}/T$ is the differential of a state function.
{: .theorem #thm-clausius title="Clausius equality"}

> Cover the cycle in the $p$-$V$ plane by a grid of thin reversible Carnot cycles bounded by isotherms and adiabats. A Carnot cycle satisfies $Q_h/T_h+Q_c/T_c=0$, because its efficiency is $1-T_c/T_h$. Adding the cycles, the heat exchanged along each interior adiabat is zero and every interior isotherm is traversed twice in opposite directions, so only the boundary of the original cycle survives, and $\sum\delta Q_k/T_k\to\oint\delta Q_{\mathrm{rev}}/T=0$ as the cycles shrink.
{: .proof}

Dividing the heat by the temperature at which it crosses the boundary is what makes the integral path independent, which is why $1/T$ plays the role of an integrating factor. The function it defines is the entropy.

> The **entropy** $S$ is the state function with $dS=\delta Q_{\mathrm{rev}}/T$, defined up to an additive constant. Its unit is J/K. For a transition between equilibrium states $A$ and $B$, $\Delta S=\int_A^B\delta Q_{\mathrm{rev}}/T$ along any reversible path joining them.
{: .definition #def-entropy title="Entropy"}

The integral is taken along a reversible path even when the real process is not reversible: $S$ is a property of the states, so any convenient reversible path between the same endpoints gives the same $\Delta S$.

> For an isolated system, $\Delta S\ge0$, with equality exactly for reversible processes.
{: .law title="Entropy increase"}

For a system that exchanges heat with its surroundings, the statement applies to system plus surroundings together: $\Delta S_{\mathrm{system}}+\Delta S_{\mathrm{surroundings}}\ge0$. The system's own entropy may fall, as when water freezes, provided the surroundings gain more.

{% include fig.html src="thermodynamics/heat-flow-entropy" id="fig-heat-flow-entropy" alt="Three bars: a hot reservoir loses 2.50 joules per kelvin of entropy, a cold reservoir gains 3.33, and the total change is a gain of 0.83." caption="Heat $Q=1000$ J flows from $400$ K to $300$ K. The hot reservoir loses $Q/T_h=2.50$ J/K and the cold one gains $Q/T_c=3.33$ J/K, so the total rises by $0.83$ J/K: the transfer can happen spontaneously, and its reverse cannot." %}

The figure is the second law in numbers. Reversed, the same flow would give $-0.83$ J/K, which the entropy-increase law forbids; that is the Clausius statement.

# Computing entropy changes

A change of entropy is found by picking a reversible path and integrating. For an ideal gas, $\delta Q_{\mathrm{rev}}=nC_V\,dT+p\,dV$ with $p=nRT/V$, so
$$ \Delta S=nC_V\ln\frac{T_2}{T_1}+nR\ln\frac{V_2}{V_1}. $$
For a phase change at constant temperature, $\Delta S=Q/T$.

> In a free expansion an ideal gas doubles its volume into a vacuum: no heat flows and no work is done, so $T$ is unchanged. The process is irreversible, but $S$ is a state function, so we evaluate it along a reversible isothermal path: $\Delta S=nR\ln2=5.76$ J/K per mole. The surroundings do not change, so the entropy of the universe rises by that amount and the gas never gathers itself back.
{: .example title="Free expansion"}

> Melting one mole of ice at $273.15$ K absorbs about $6.01$ kJ at constant temperature, so $\Delta S=Q/T\approx22$ J/(mol K). The water is more disordered than the ice, and the heat taken from the surroundings is what pays for it.
{: .example title="Melting"}

The law also bounds engines. Suppose an engine takes $Q_h$ from a reservoir at $T_h$ and rejects $Q_c$ to one at $T_c$. The engine returns to its initial state, so only the reservoirs change: $\Delta S=Q_c/T_c-Q_h/T_h\ge0$. Therefore $Q_c/Q_h\ge T_c/T_h$ and
$$ \eta=1-\frac{Q_c}{Q_h}\le1-\frac{T_c}{T_h}. $$
Between $600$ K and $300$ K no engine can exceed $50\%$, whatever it is made of; the next notes build the engine that reaches the bound.

> Entropy increase does not forbid local decreases: a refrigerator lowers the entropy of its contents by dumping more into the room. Apply $\Delta S\ge0$ to the isolated whole, not to the part you care about.
{: .trap}

> Entropy is often glossed as "disorder", and that works for gases expanding and ice melting. It fails when order is not the right picture, as when hard spheres at high density crystallize and gain entropy. The reliable meaning, from statistical mechanics, is the logarithm of the number of microstates compatible with the macrostate, $S=k_B\ln\Omega$.
{: .remark title="Entropy and disorder"}

# Recap

<details class="qa" markdown="1">
<summary>Why are the Kelvin and Clausius statements the same law?</summary>

Each can be turned into the other: a machine that moves heat from cold to hot for free, combined with an ordinary engine, turns heat from one reservoir entirely into work, and the converse construction works too.
</details>

<details class="qa" markdown="1">
<summary>How do you find $\Delta S$ for an irreversible process?</summary>

Entropy is a state function, so you compute $\int\delta Q_{\mathrm{rev}}/T$ along any reversible path between the same initial and final states, and the result is the same.
</details>

<details class="qa" markdown="1">
<summary>Why can the entropy of a system decrease without violating the second law?</summary>

The law constrains the total of system and surroundings. A freezing liquid loses entropy while its surroundings gain more by receiving the released heat.
</details>
