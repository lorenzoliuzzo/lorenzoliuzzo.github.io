---
collection: notes
title: "Ampère's Law"
date: 2026-10-27
excerpt: "The circulation of the magnetic field, Ampère's law for steady currents, and fields of wires, solenoids and toroids."
hook: "The circulation of the magnetic field around a loop counts the current through it; with enough symmetry that is the field, just as Gauss's law gave the electric one."
goals:
  - compute the circulation of a field around a loop
  - apply Ampère's law to wires, sheets and solenoids
  - state the two static laws of magnetism
requires:
  - biot-savart-law
  - current-density
  - symmetry-argument
defines:
  - {id: circulation, name: circulation, anchor: def-circulation}
  - {id: amperes-law, name: Ampère's law, anchor: def-amperes-law}
  - {id: no-monopoles, name: no magnetic monopoles, anchor: def-no-monopoles}
read_time: true
tags:
  - Physics
  - Electromagnetism
---

Gauss's law turned the electric field of a symmetric charge distribution into a one-line calculation. The magnetic field has a companion law, but what it constrains is not the flux through a surface but the field's circulation around a loop.

# Circulation and Ampère's law

> The **circulation** of a vector field $\mathbf B$ around a closed curve $C$ is the line integral $\oint_C\mathbf B\cdot d\mathbf l$, the sum of the component of the field along the curve times the length element, taken once around in a chosen direction.
{: .definition #def-circulation title="Circulation"}

For an electrostatic field the circulation is always zero, which was the statement that it has a potential. For a magnetic field it is not. Around a long straight wire the field circles the wire with magnitude $\mu_0I/(2\pi s)$ at distance $s$, so on a circle of radius $s$ about the wire the circulation is $\frac{\mu_0I}{2\pi s}\cdot2\pi s=\mu_0I$. It does not depend on $s$, and the geometric reason is that $B\,dl\cos\alpha=\frac{\mu_0I}{2\pi}d\phi$ in terms of the angle $\phi$ swept around the wire, so any loop that encircles the wire once collects $\mu_0I$, whatever its shape, and a loop that does not encircle it collects zero.

> **Ampère's law.** For steady currents, the circulation of $\mathbf B$ around any closed curve equals $\mu_0$ times the current through any surface bounded by the curve: $\oint_C\mathbf B\cdot d\mathbf l=\mu_0I_{\mathrm{enc}}$, with $I_{\mathrm{enc}}=\int_S\mathbf J\cdot d\mathbf A$ and the direction of the surface normal given by the right-hand rule. In differential form, $\nabla\times\mathbf B=\mu_0\mathbf J$.
{: .law #def-amperes-law title="Ampère's law"}

Superposition extends the single-wire result to any set of steady currents: the law follows from the Biot-Savart law and is not an independent assumption. As Gauss's law is easy to use only with symmetry, so is this one.

# Fields from symmetry

The method mirrors the Gaussian surface. Choose an **Amperian loop** on which $\mathbf B$ is either tangent to the loop with constant magnitude, or perpendicular to it, or zero, so that the integral reduces to $B\times$ (length), and read off the enclosed current.

{% capture t %}
| Source | Amperian loop | Result |
|:--|:--|:--|
| long straight wire, current $I$ | circle of radius $s$ about the wire | $B=\dfrac{\mu_0I}{2\pi s}$ |
| solid cylinder, radius $a$, uniform $J$ | circle of radius $s<a$ | $B=\dfrac{\mu_0Is}{2\pi a^2}$ |
| ideal solenoid, $n$ turns per length | rectangle across the wall | $B=\mu_0nI$ inside, $0$ outside |
| toroid, $N$ turns | circle of radius $r$ inside | $B=\dfrac{\mu_0NI}{2\pi r}$ |
| infinite current sheet, $K$ per width | rectangle across the sheet | $B=\tfrac12\mu_0K$ on each side |
{% endcapture %}
{% include tab.html id="tab-amperian-loops" caption="Standard fields from Ampère's law." body=t %}
{: .booktabs}

The cylinder shows how the enclosed current decides the profile: inside, a circle of radius $s$ encloses a fraction $s^2/a^2$ of the current and the field grows linearly; outside, it encloses all of it and the field falls as $1/s$.

{% include fig.html src="electromagnetism/cylinder-field" id="fig-cylinder-field" alt="Graph of the field of a thick wire against distance from its axis. A straight line rises from zero to a peak at the wire's surface, then a curve falls away inversely with distance." caption="Field of a long wire of radius $a$ with uniform current. It rises linearly inside, peaks at the surface and falls as $1/s$ outside; only the current enclosed by the Amperian circle matters." %}

For the solenoid, take a rectangle with one side inside along the axis and one outside. For a long coil the field outside is negligible and the sides across the wall contribute nothing, so $B\ell=\mu_0(n\ell)I$ and $B=\mu_0nI$ independent of the radius and position inside. With $n=1000$ turns per metre and $I=2$ A, $B=\mu_0nI=2.5$ mT, and a ferromagnetic core would multiply it.

> A field line that follows $\mathbf B$ closes on itself or goes to infinity: it has no beginning and no end, so the circulation around such a line is nonzero and no potential exists in regions with current. This is the structural difference from the electrostatic field, whose lines end on charges.
{: .implication title="Magnetic field lines have no ends"}

# Divergence of B

The flux of $\mathbf B$ through a closed surface counts the field lines that end inside it, and the Biot-Savart law gives none.

> **No magnetic monopoles.** The magnetic flux through any closed surface is zero, $\oint\mathbf B\cdot d\mathbf A=0$, in differential form $\nabla\cdot\mathbf B=0$.
{: .law #def-no-monopoles title="Gauss's law for magnetism"}

Together with the circulation law, this completes the static magnetic equations:
$$ \nabla\cdot\mathbf B=0,\qquad\nabla\times\mathbf B=\mu_0\mathbf J, $$
the magnetic counterparts of $\nabla\cdot\mathbf E=\rho/\varepsilon_0$ and $\nabla\times\mathbf E=0$. An isolated magnetic charge would give a non-zero flux, and none has been observed; cutting a bar magnet gives two smaller magnets, each with both poles.

> Ampère's law as written holds only for steady currents. A charging capacitor has a current $I$ in the wire but none across the gap, so loops enclosing the wire through different surfaces would give different answers. A missing term, the displacement current, repairs it, and it is the subject of a later note.
{: .trap}

> Use Ampère's law when the geometry has a symmetry that makes $\mathbf B$ uniform on the loop: infinite lines, cylinders, plane sheets, long solenoids and toroids. Otherwise go back to Biot-Savart and integrate.
{: .rule}

# Recap

<details class="qa" markdown="1">
<summary>What does Ampère's law say, and when does it give the field directly?</summary>

The circulation of $\mathbf B$ around a loop equals $\mu_0$ times the enclosed current. It gives $\mathbf B$ directly when symmetry makes the field constant and tangent along the loop, so the integral is just $B$ times the length.
</details>

<details class="qa" markdown="1">
<summary>Why is the field inside an ideal solenoid uniform and independent of its radius?</summary>

A rectangular loop with one long side inside and one outside encloses $n\ell I$ regardless of where the inner side is placed, and the outside field is negligible, so $B=\mu_0nI$ everywhere inside.
</details>

<details class="qa" markdown="1">
<summary>What does $\nabla\cdot\mathbf B=0$ mean?</summary>

Magnetic field lines have no sources or sinks: they form closed loops, and no isolated magnetic charge exists.
</details>
