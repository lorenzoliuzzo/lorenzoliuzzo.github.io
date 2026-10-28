---
collection: notes
title: The One-Dimensional Ising Model
date: '2026-10-27'
excerpt: The exact solution of the Ising chain by the transfer matrix, its correlation length, and why it has no transition at any positive temperature.
hook: The Ising chain can be solved exactly with a two-by-two matrix, and its solution shows that short-range interactions in one dimension cannot hold order against thermal fluctuations.
goals:
- write the partition function of the Ising chain as a trace of powers of a transfer matrix
- derive the spin correlation function and the correlation length
- explain with a domain-wall argument why there is no transition for T greater than zero
requires:
- ising-model
- partition-function
- eigenvalue
- mean-field-approximation
defines:
- id: transfer-matrix
  name: transfer matrix
  anchor: def-transfer-matrix
- id: correlation-length
  name: correlation length
  anchor: def-correlation-length
tags:
- Physics
- Statistical Mechanics
read_time: true
---

Ising solved the one-dimensional model himself and found no transition, a result he took to be general {% cite ising-1925 %}. The modern route is the transfer matrix, which also works for models with more states per site.

# The transfer matrix

Take $N$ spins on a ring with $s_{N+1}=s_1$ and $\mathcal H=-J\sum_is_is_{i+1}$ at zero field. Write $K=\beta J$. The Boltzmann weight is a product of factors $e^{Ks_is_{i+1}}$, one per bond.

> Each factor depends on two neighbouring spins and can be read as an entry of a $2\times2$ **transfer matrix**,
{: .definition #def-transfer-matrix title="Transfer matrix"}

$$ T_{s,s'}=e^{Kss'}=\begin{pmatrix}e^{K}&e^{-K}\\e^{-K}&e^{K}\end{pmatrix}, \qquad Z=\sum_{s_1\dots s_N}T_{s_1s_2}T_{s_2s_3}\cdots T_{s_Ns_1}=\operatorname{Tr}T^N. $$

The sum over intermediate spins is matrix multiplication, so the partition function is the trace of the $N$-th power. The eigenvalues are $\lambda_+=2\cosh K$ and $\lambda_-=2\sinh K$, and $Z=\lambda_+^N+\lambda_-^N$. Since $\lambda_+>\lambda_-$, for large $N$ the larger eigenvalue dominates and the free energy per spin is $f=-kT\ln(2\cosh K)$, analytic in $T$ for every $T>0$. No singularity means no phase transition.

# Correlations decay exponentially

Insert $s_r$ operators into the product. The correlation $\langle s_0s_r\rangle$ equals $\operatorname{Tr}[\sigma_zT^r\sigma_zT^{N-r}]/Z$ with $\sigma_z$ diagonal; in the eigenbasis of $T$ this gives, for large $N$,

$$ \langle s_0s_r\rangle=\Big(\frac{\lambda_-}{\lambda_+}\Big)^r=(\tanh K)^r=e^{-r/\xi},\qquad \xi=-\frac1{\ln\tanh K}. $$

> The **correlation length** $\xi$ is the distance over which spin correlations decay by a factor $e$: $\langle s_0s_r\rangle\sim e^{-r/\xi}$ for large $r$.
{: .definition #def-correlation-length title="Correlation length"}

> For the Ising chain $\xi$ is finite at every $T>0$ and grows as $T\to0$ like $\xi\approx e^{2K}/2=\tfrac12e^{2J/kT}$. In general it is set by the two largest eigenvalues of the transfer matrix: $\xi^{-1}=\ln(\lambda_1/\lambda_2)$.
{: .property #prop-ising1d-xi title="Correlation length of the chain"}

Order is present only at $T=0$, where $\xi$ diverges.

{% include fig.html src="statistical-mechanics/ising-1d-correlation" id="fig-ising1d-corr" alt="Three straight lines of the logarithm of the spin correlation against distance, with slopes that get shallower as the coupling beta J goes from 0.5 to 1 to 1.5, labelled with correlation lengths 1.3, 3.7 and 10." caption="The logarithm of the correlation $\langle s_0s_r\rangle=\tanh^rK$ against the distance, for three couplings. Every line has a finite slope at finite temperature, so correlations decay exponentially, with a length $\xi$ that grows as the temperature falls." %}

# Why there is no order

The same result follows from the cost of a domain wall. In the all-up state, flipping the spins on one side of a bond breaks a single bond, at an energy cost $2J$. In a chain of $N$ sites the wall can be placed in $N$ positions, so the entropy gained is $k\ln N$, and the free-energy change is

$$ \Delta F=2J-kT\ln N. $$

At any $T>0$ this becomes negative for large $N$. Walls proliferate, and the average magnetisation vanishes. The argument breaks down at $T=0$ only, where the entropy term has no weight. 
> An energy cost that does not grow with the system, set against an entropy that does, is the mechanism behind the lower critical dimension in a later note: below it, short-range order cannot survive at any temperature.
{: .implication}

> This does not mean there is no order in any one-dimensional model. With interactions of long enough range, such as $1/r^{\sigma}$ with $\sigma\le2$, the argument fails and the chain can order.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>How is the partition function of the Ising chain written with the transfer matrix?</summary>

As $\operatorname{Tr}T^N$, where $T$ is the $2\times2$ matrix with entries $e^{Kss'}$. For large $N$ it is dominated by the largest eigenvalue $2\cosh K$.
</details>

<details class="qa" markdown="1">
<summary>What is the correlation length of the chain?</summary>

$\xi=-1/\ln\tanh K$, finite for every $T>0$ and growing as $\tfrac12e^{2J/kT}$ when $T\to0$.
</details>

<details class="qa" markdown="1">
<summary>Why does a domain wall destroy order in one dimension?</summary>

Its energy $2J$ does not grow with the system size, but its entropy $k\ln N$ does, so the free energy of creating a wall becomes negative at any positive temperature.
</details>
