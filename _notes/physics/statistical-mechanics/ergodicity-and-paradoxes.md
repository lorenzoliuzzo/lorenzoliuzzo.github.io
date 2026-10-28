---
collection: notes
title: Ergodicity and Two Paradoxes
date: '2026-10-27'
excerpt: When time averages equal ensemble averages, the Gibbs paradox of mixing identical gases, and Maxwell's demon with the cost of erasing a bit.
hook: 'Two classical puzzles, the entropy of mixing identical gases and the demon that sorts molecules, are resolved by the same idea: entropy counts distinguishable microstates and information has a thermodynamic price.'
goals:
- state the ergodic hypothesis and say when it fails
- resolve the Gibbs paradox with the factor 1/N!
- state the Landauer bound and use it to dispose of Maxwell's demon
requires:
- shannon-entropy
- canonical-ensemble
- phase-space
- entropy
defines:
- id: ergodic-hypothesis
  name: ergodic hypothesis
  anchor: def-ergodic-hypothesis
- id: gibbs-paradox
  name: Gibbs paradox
  anchor: the-gibbs-paradox
- id: landauer-principle
  name: Landauer principle
  anchor: maxwells-demon-and-the-cost-of-a-bit
tags:
- Physics
- Statistical Mechanics
read_time: true
---

The ensemble is a device for computing averages, and the experiment measures one system over time. Two classical puzzles test whether the device is consistent {% cite landauer-1961 %}.

# Why an ensemble average predicts a measurement

A measurement on a single system takes a time average, and the theory computes an average over the ensemble.

> The **ergodic hypothesis** says they agree: over a long time the system visits every region of the energy shell in phase space in proportion to its volume, so the time average of an observable is its microcanonical average.
{: .definition #def-ergodic-hypothesis title="Ergodic hypothesis"}

The hypothesis is a statement about dynamics, which is why it is hard to prove and holds for some systems and not others.

It fails in a way every Ising simulation shows. Below the critical temperature a finite system flips between the all-up and all-down states only on an exponentially long time, and a run shorter than that explores one of them. The ensemble includes both, so the time average of the magnetisation is not zero while the ensemble average is. This is broken ergodicity: the accessible region splits into pieces that the dynamics cannot cross on experimental time scales. The ensemble must then be restricted to the sector the system is in, and the choice is itself a physical input.

> An ensemble average is a prediction about a long run. If the run is shorter than the time needed to cross between regions, the right average is the one over the region the system starts in.
{: .trap}

# The Gibbs paradox

Take two boxes of an ideal gas at the same temperature and density and open the partition. If the gases are different, they mix and the entropy rises by $2Nk\ln2$. If they are the same, nothing observable happens and the entropy cannot change. Counting microstates as if the particles were labelled, though, gives the same increase in both cases, and the entropy even fails to be extensive.

The resolution is that identical particles are indistinguishable: permuting them does not give a new state. In the classical partition function this means dividing the $N$-particle sum by $N!$, and the entropy becomes the extensive expression derived in the next note. Quantum mechanics supplies the reason, since the wave function of identical particles is symmetric or antisymmetric. The paradox also has an information reading: entropy counts the microstates we can tell apart, so whether mixing raises the entropy depends on whether the two gases are distinguishable.

# Maxwell's demon and the cost of a bit

A demon at a door between two boxes opens it for fast molecules going one way and for slow ones going the other. The gas ends up with a temperature difference and the entropy of the isolated pair has fallen, with no work done, in apparent violation of the second law.

The resolution is in the demon's memory. To act, it must record the molecule's speed, and to run in a cycle it must erase the record. Landauer's argument is that erasing one bit, resetting a two-state memory to a known state, cannot be done without dissipating at least

$$ Q\ge kT\ln2 $$

into the environment, which is the entropy $k\ln2$ that the memory loses when its two possible values merge into one. Over a full cycle this heat covers the entropy decrease of the gas, and the second law holds. Measurement can in principle be done without a cost, and the erasure is where it is paid.

{% capture t %}
| Puzzle | Naive count | Resolution |
|---|---|---|
| Mixing identical gases | entropy of mixing $2Nk\ln2$ | indistinguishable particles, divide by $N!$ |
| Maxwell's demon | entropy falls with no work | erasing the demon's memory costs $kT\ln2$ per bit |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-paradoxes" caption="The two paradoxes and their resolutions." body=t %}

The bound is tiny: $kT\ln2\approx3\times10^{-21}$ J at room temperature, far below what real computers dissipate per bit operation. It matters as a limit, and as a statement that the information a system holds and its thermodynamic entropy are one subject.

# Recap

<details class="qa" markdown="1">
<summary>What does the ergodic hypothesis say, and when does it fail?</summary>

Time averages equal microcanonical ensemble averages because the dynamics visits the whole energy shell. It fails when the accessible region splits into parts the system cannot cross in the observation time, as in the ordered phase of a magnet.
</details>

<details class="qa" markdown="1">
<summary>How does the factor $1/N!$ resolve the Gibbs paradox?</summary>

It removes the overcounting of states that differ only by permuting identical particles. The entropy becomes extensive and mixing identical gases gives no entropy change.
</details>

<details class="qa" markdown="1">
<summary>What does Landauer's bound say about Maxwell's demon?</summary>

Erasing one bit dissipates at least $kT\ln2$. The demon must erase its memory to repeat the cycle, and that dissipation pays for the entropy decrease it produced.
</details>
