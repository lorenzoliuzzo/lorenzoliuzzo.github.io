---
collection: notes
title: Information and Entropy
date: '2026-10-27'
excerpt: Surprise as the logarithm of an inverse probability, Shannon entropy and its properties, and the maximum entropy principle as a rule for assigning probabilities.
hook: Entropy measures how much a probability distribution leaves open, and the distribution that leaves the most open while respecting what we know is the one to use.
goals:
- define the information of an outcome and the Shannon entropy of a distribution
- show that the uniform distribution maximises entropy
- derive the exponential family as the maximum entropy distribution under a mean constraint
requires:
- probability-axioms
- expectation
- entropy
defines:
- id: shannon-entropy
  name: Shannon entropy
  anchor: def-shannon-entropy
- id: maximum-entropy-principle
  name: maximum entropy principle
  anchor: def-maximum-entropy-principle
tags:
- Physics
- Statistical Mechanics
read_time: true
---

Thermodynamic entropy was introduced to say which processes run forwards. A second route to the same quantity starts from probability and asks how uncertain we are about the state of a system, and it will give the ensembles of the next note almost for free {% cite shannon-1948 %}.

# Information and probability

An outcome that is certain tells us nothing when it happens, and a rare outcome tells us a lot. Two independent outcomes with probabilities $p$ and $q$ jointly have probability $pq$, and the information they carry should add. The function with both properties is the logarithm, and the **information** of an outcome of probability $p$ is $-\ln p$. The choice of base only sets the unit: base 2 gives bits, the natural logarithm gives nats.

# Shannon entropy

> For a distribution $\{p_i\}$ over $W$ outcomes, the expected information is the **Shannon entropy**
{: .definition #def-shannon-entropy title="Shannon entropy"}

$$ S = -\sum_{i=1}^{W}p_i\ln p_i, $$

with $0\ln0=0$. Three properties matter. It is zero when one $p_i=1$ and the outcome is certain. It is additive for independent systems, $S_{AB}=S_A+S_B$. And it is largest for the uniform distribution, where it equals $\ln W$. Multiplied by Boltzmann's constant $k$, the same expression is the Gibbs entropy of statistical mechanics, and for a uniform distribution over $W$ microstates it reduces to $k\ln W$.

{% include fig.html src="statistical-mechanics/binary-entropy" id="fig-binary-entropy" alt="A dome-shaped curve of the entropy of a two-outcome distribution in bits against the probability p, zero at p equal 0 and 1 and equal to 1 at p equal one half." caption="The entropy of a two-outcome distribution in bits. It is zero for a certain outcome and maximal at $p=1/2$, the most uncertain case." %}

> Entropy is a property of the description, not of the system alone. Two observers with different information assign different distributions and so different entropies to the same system.
{: .idea}

# The maximum entropy principle

A physical system is known through a few numbers, such as its mean energy, and not through its microstate.

> The **maximum entropy principle** says to assign the distribution of largest entropy among those consistent with what is known {% cite jaynes-1957 %}.
{: .definition #def-maximum-entropy-principle title="Maximum entropy principle"}

It is a rule of inference: it adds no assumption beyond the stated data, because any other choice would claim information we do not have.

With no constraint beyond normalisation, maximise $S-\alpha\big(\sum_ip_i-1\big)$. Setting the derivative with respect to $p_i$ to zero gives $-\ln p_i-1-\alpha=0$, so every $p_i$ is the same and $p_i=1/W$. The uniform distribution is the answer, which is the equal a priori probability of the microcanonical ensemble.

Now add a known mean, $\sum_ip_if_i=\bar f$. The multiplier $\lambda$ for this constraint changes the stationarity condition to $-\ln p_i-1-\alpha-\lambda f_i=0$, so

$$ p_i=\frac{e^{-\lambda f_i}}{Z},\qquad Z=\sum_ie^{-\lambda f_i}. $$

The distribution is exponential in the constrained quantity, and the multiplier $\lambda$ is fixed by the value of $\bar f$. This is the Boltzmann distribution when $f$ is the energy, and the next note carries out that step.

{% capture t %}
| Known | Maximum entropy distribution |
|---|---|
| Nothing but normalisation | uniform, $p_i=1/W$ |
| Mean of $f$ | exponential, $p_i\propto e^{-\lambda f_i}$ |
| Mean and variance on the real line | Gaussian |
{: .booktabs}
{% endcapture %}
{% include tab.html id="tab-maxent" caption="Maximum entropy distributions for common constraints." body=t %}

> The principle does not say the system is in this state. It says which distribution to bet on. Agreement with experiment is a property of the physical system, and it is the reason the principle is useful in physics.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why is information the logarithm of the inverse probability?</summary>

Information from independent outcomes should add while their probabilities multiply, and the logarithm turns a product into a sum. Certain outcomes carry zero information.
</details>

<details class="qa" markdown="1">
<summary>What distribution maximises the entropy when only normalisation is known?</summary>

The uniform one, $p_i=1/W$, with entropy $\ln W$. Maximising with a Lagrange multiplier for normalisation makes every $p_i$ equal.
</details>

<details class="qa" markdown="1">
<summary>What form does the maximum entropy distribution take when a mean value is fixed?</summary>

An exponential in the constrained quantity, $p_i\propto e^{-\lambda f_i}$, with $\lambda$ set by the value of the mean.
</details>
