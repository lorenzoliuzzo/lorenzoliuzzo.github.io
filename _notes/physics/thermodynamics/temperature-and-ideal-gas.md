---
collection: notes
title: Temperature and the Ideal Gas
date: '2026-10-27'
excerpt: Thermal equilibrium, temperature, equations of state and the ideal gas.
hook: Temperature is what two bodies share when nothing flows between them, and the ideal gas is the simplest thing that has one.
goals:
- state the zeroth law and define temperature
- use the ideal gas law and its processes
defines:
- id: temperature
  name: temperature
  anchor: temperature
- id: ideal-gas
  name: ideal gas
  anchor: ideal-gas
plan:
  sources: []
  figures:
  - p-V isotherms of an ideal gas
  - gas thermometer extrapolating to absolute zero
  verify:
  - pV = NkT with k = 1.380649e-23 J/K
  - kinetic energy per molecule is 3kT/2
tags:
- Physics
- Thermodynamics
read_time: true
---

A thermometer works because bodies in contact eventually stop exchanging heat, and because the readings of any two good thermometers can be compared. Thermodynamics turns those two facts into a definition and builds its first equation of state on it.

# Temperature

Two systems in contact through a wall that passes heat reach **thermal equilibrium**, a state in which nothing changes macroscopically. The **zeroth law** says that if $A$ is in equilibrium with $C$ and $B$ is in equilibrium with $C$, then $A$ and $B$ are in equilibrium with each other. Equilibrium is therefore an equivalence relation, and the class label is what we call **temperature**: the quantity two bodies share when nothing flows between them. $C$ plays the part of the thermometer.

The law fixes what temperature is, not a scale. A scale needs a thermometric property, such as the length of a mercury column or the pressure of a gas at fixed volume, and fixed points. Different substances give slightly different scales except for dilute gases, which agree with each other. A gas thermometer reads $p=aT+b$ at fixed volume. Whatever the gas and the amount, the lines extrapolate to $p=0$ at the same temperature, $-273.15\,^\circ$C, which defines the zero of the **absolute scale** in kelvin. Since 2019 the kelvin is defined by fixing the Boltzmann constant at $k=1.380649\times10^{-23}\ \mathrm{J/K}$, and $T=t+273.15\ \mathrm{K}$.

{% include fig.html src="thermodynamics/gas-thermometer" id="fig-gas-thermometer" alt="Three straight lines of pressure against temperature in degrees Celsius for three amounts of gas at fixed volume. All three lines meet the horizontal axis at minus 273.15 degrees." caption="Pressure of a fixed volume of ideal gas against Celsius temperature, for three amounts. The lines have different slopes and the same intercept at $-273.15\,^\circ$C." %}

> Temperature is a property of a state of equilibrium. A single molecule or a gas that is still being stirred has none, and heat is not the same thing: heat is energy in transit between bodies at different temperatures.
{: .idea}

# Ideal gas

The gas thermometer works because a dilute gas obeys a simple **equation of state**, a relation among $p$, $V$, $T$ and the amount. For an **ideal gas** of $N$ molecules,
$$ pV=NkT=nRT, $$
with $n=N/N_A$ moles and $R=N_Ak\approx8.314\ \mathrm{J/(mol\,K)}$. The three classical gas laws are special cases: Boyle's law $pV=$ const at fixed $T$, Charles's law $V\propto T$ at fixed $p$, and Gay-Lussac's law $p\propto T$ at fixed $V$.

The idealisation is that the molecules are points that interact only by collisions. It holds when the gas is dilute and hot compared to the scale of the intermolecular attraction, which is why ordinary air near room conditions follows it closely. As a check on the constants, at $T=273.15\ \mathrm{K}$ and $p=101325$ Pa the formula gives a number density $N/V=p/kT=2.69\times10^{25}\ \mathrm{m}$$^{-3}$, the Loschmidt number.

A kinetic argument gives the same equation and connects $T$ to the motion of the molecules. Molecules bouncing off a wall exert a pressure $p=\tfrac13 (N/V)m\langle v^2\rangle$. Comparing this with $pV=NkT$ gives
$$ \tfrac12m\langle v^2\rangle=\tfrac32kT. $$
The average translational kinetic energy per molecule is $3kT/2$, at room temperature $T=300\ \mathrm{K}$ about $6.2\times10^{-21}\ \mathrm{J}$, independent of the gas. Temperature in this sense is a measure of random molecular energy, which a later note on kinetic theory develops.

# Processes of an ideal gas

A **process** is a path in the $p$-$V$ plane. An **isotherm** keeps $T$ fixed, so $p=NkT/V$ is a hyperbola, and higher temperatures give hyperbolas farther from the axes. An **isochoric** step keeps $V$ fixed and moves vertically; an **isobaric** step keeps $p$ fixed and moves horizontally. Doubling the volume at $300\ \mathrm{K}$ halves the pressure, from $99\ \mathrm{kPa}$ to $50\ \mathrm{kPa}$ in the example below, and heating the gas back to $600\ \mathrm{K}$ at the new volume doubles it again.

{% include fig.html src="thermodynamics/ideal-isotherms" id="fig-ideal-isotherms" alt="Three hyperbolas of pressure against volume for temperatures of 300, 450 and 600 kelvin. Two marked points on the lowest curve correspond to one and two litres, and a vertical dashed line joins the two-litre point to the 600 kelvin curve." caption="Isotherms $p=NkT/V$ for $2.4\times10^{22}$ molecules. The dashed step is isochoric: at fixed volume the pressure is proportional to the temperature." %}

{% capture t %}
| Process | Fixed | Relation |
|:--|:--|:--|
| isothermal | $T$ | $pV=$ const |
| isobaric | $p$ | $V/T=$ const |
| isochoric | $V$ | $p/T=$ const |
{% endcapture %}
{% include tab.html id="tab-processes" caption="The three simplest processes of an ideal gas." body=t %}
{: .booktabs}

# Recap

<details class="qa" markdown="1">
<summary>What does the zeroth law say, and what does it make possible?</summary>

If $A$ and $B$ are each in thermal equilibrium with $C$, they are in equilibrium with each other. Equilibrium is then an equivalence relation, and its classes are labelled by temperature.
</details>

<details class="qa" markdown="1">
<summary>Why do gas thermometers define an absolute zero?</summary>

At fixed volume the pressure of any dilute gas is linear in temperature and extrapolates to zero at $-273.15\,^\circ$C, independent of the gas and the amount.
</details>

<details class="qa" markdown="1">
<summary>What is the average kinetic energy of a molecule of an ideal gas?</summary>

$3kT/2$ for translation, from comparing the kinetic pressure $\tfrac13(N/V)m\langle v^2\rangle$ with $pV=NkT$.
</details>
