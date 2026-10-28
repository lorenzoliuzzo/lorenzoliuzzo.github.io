---
collection: notes
title: Random Numbers and Sampling
date: '2026-10-27'
excerpt: Pseudorandom generators, inverse-transform and rejection sampling.
hook: Every Monte Carlo result starts from uniform random numbers and a recipe for turning them into the distribution you need.
goals:
- generate samples from a given distribution
- test a generator
defines:
- id: pseudorandom-generator
  name: pseudorandom generator
  anchor: pseudorandom-generator
- id: rejection-sampling
  name: rejection sampling
  anchor: rejection-sampling
tags:
- Physics
- Computation
read_time: true
---

A Monte Carlo calculation is only as good as its random numbers. A computer cannot produce truly random ones, so it produces a deterministic sequence that passes for random, and then it turns uniform numbers into whatever distribution is needed.

# Pseudorandom generator

A **pseudorandom generator** is a deterministic rule that maps a state to a next state and to a number, so that the output behaves like independent draws from the uniform distribution on $[0,1)$. The classic example is the **linear congruential generator** (LCG),
$$ x_{n+1}=(a\,x_n+c)\bmod m,\qquad u_n=\frac{x_n}m. $$
The sequence is periodic, with a period of at most $m$, and it is fully determined by the **seed** $x_0$. Reproducibility is a feature: fixing the seed reproduces a simulation exactly.

Not every choice of $a$, $c$, $m$ works. Successive pairs $(u_n,u_{n+1})$ of an LCG lie on a lattice of parallel lines, and triples lie on planes. The figure shows the pairs for the poor choice $a=65$, $c=1$, $m=2048$: they fill the square with a regular lattice that no random pairs would form. The notorious RANDU generator, $a=65539$, $m=2^{31}$, has all consecutive triples on only $15$ planes, which spoiled many early simulations (a fact to check against the literature). A good generator has a very long period, passes statistical test batteries, and is used with a library implementation, such as the Mersenne Twister ($2^{19937}-1$) or PCG, instead of a hand-written LCG. For parallel runs, give each process its own stream or a separately seeded generator.

# Inverse-transform sampling

Let $F(x)=P(X\le x)$ be the cumulative distribution function of the target. If $U$ is uniform on $[0,1)$, then $X=F^{-1}(U)$ has distribution $F$, since $P(F^{-1}(U)\le x)=P(U\le F(x))=F(x)$. For the exponential density $\lambda e^{-\lambda x}$, $F(x)=1-e^{-\lambda x}$, so
$$ X=-\frac{\ln(1-U)}{\lambda}. $$
The left panel of the figure shows $20000$ samples of this transform against the exact density. The method needs $F^{-1}$ in closed form, which is available for the exponential, the uniform on an interval and a few others. For the Gaussian, the **Box-Muller transform** turns two uniforms $U_1,U_2$ into two independent standard normals, $\sqrt{-2\ln U_1}\cos2\pi U_2$ and $\sqrt{-2\ln U_1}\sin2\pi U_2$.

{% include fig.html src="computational-physics/sampling" id="fig-sampling" alt="On the left a histogram of twenty thousand exponential samples that follows the exact decaying curve. On the right the pairs of successive outputs of a poor congruential generator form a regular lattice of dots filling the unit square." caption="Left: $20000$ samples $x=-\ln(1-u)$ (bars) against the density $e^{-x}$. Right: successive pairs $(u_n,u_{n+1})$ of the poor LCG $a=65$, $c=1$, $m=2048$ lie on a regular lattice." %}

# Rejection sampling

When $F^{-1}$ is not available, **rejection sampling** uses a simpler **proposal** density $g(x)$ and a constant $M$ such that $f(x)\le Mg(x)$ everywhere. Draw $x$ from $g$ and an independent $u$ uniform on $[0,1)$, and accept $x$ if
$$ u\le\frac{f(x)}{M\,g(x)}. $$
The accepted points are distributed as $f$, because the density of an accepted point at $x$ is proportional to $g(x)\cdot f(x)/(Mg(x))=f(x)/M$. The probability of accepting a trial is $1/M$, so on average $M$ proposals are needed per sample; the closer the envelope $Mg$ is to $f$, the less is wasted.

Example: sample $f(x)=\tfrac{3}{2}(1-x^2)$ on $[-1,1]$ with a uniform proposal $g=\tfrac12$ on the same interval. The maximum of $f$ is $3/2$ at $x=0$, so the smallest valid constant is $M=3$, and $f/(Mg)=\tfrac32(1-x^2)/(3\cdot\tfrac12)=1-x^2$. A trial $x$ is accepted with probability $1-x^2$, and the overall acceptance rate is $1/M=1/3$.

In high dimensions $M$ grows exponentially, and rejection becomes hopeless. This is the reason for the Markov chain methods, Metropolis and its relatives, which give up independence to keep going.

> A sequence that fails a visual test, such as the lattice of pairs, can still pass a one-dimensional histogram of its values. Test pairs and triples, not just single values.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>What is a pseudorandom generator, and what goes wrong with a bad LCG?</summary>

A deterministic rule producing numbers that mimic uniform draws, repeatable by seed. A poor LCG has short periods and successive tuples on lattices of lines or planes.
</details>

<details class="qa" markdown="1">
<summary>How does inverse-transform sampling work?</summary>

If $U$ is uniform then $X=F^{-1}(U)$ has cumulative distribution $F$; for the exponential, $X=-\ln(1-U)/\lambda$.
</details>

<details class="qa" markdown="1">
<summary>How does rejection sampling work, and what does it cost?</summary>

Propose from $g$ with $f\le Mg$, accept with probability $f/(Mg)$. The acceptance rate is $1/M$, which falls rapidly in high dimension.
</details>
