---
collection: notes
title: Gauss's Law
date: '2026-10-27'
excerpt: Flux, Gauss's law in integral form, and the symmetric charge distributions it solves in one line.
hook: The flux of the electric field through a closed surface counts the charge inside; when the symmetry is right, that one statement gives the field without any integration.
goals:
- compute the flux through a closed surface
- choose a Gaussian surface from the symmetry of a charge distribution
- find the field of spheres, cylinders and planes of charge
requires:
- electric-field
- superposition-principle
- charge-density
defines:
- id: flux
  name: electric flux
  anchor: flux
- id: gauss-law
  name: Gauss's law
  anchor: gausss-law
- id: symmetry-argument
  name: symmetry argument
  anchor: choosing-a-surface
tags:
- Physics
- Electromagnetism
read_time: true
---

Coulomb's law with superposition determines every electrostatic field, but the sums and integrals are usually heavy. Gauss's law says the same thing in a global form, and for symmetric charge distributions it gives the field in one line.

# Flux

The **flux** of a vector field $\mathbf E$ through a surface $S$ counts how much of the field passes through it. For a small patch of area $dA$ with unit normal $\hat{\mathbf n}$, the flux is $\mathbf E\cdot\hat{\mathbf n}\,dA$, and for a whole surface
$$ \Phi=\int_S\mathbf E\cdot d\mathbf A. $$
Only the component perpendicular to the surface counts. For a uniform field $E$ through a flat area $A$ tilted by $\theta$ from the field, $\Phi=EA\cos\theta$. For a **closed** surface the normal points outward, so flux leaving is positive.

Field lines give the picture: the flux through a surface is proportional to the number of lines that cross it. A line that enters a closed surface also has to leave unless it ends on a charge, which anticipates the law.

# Gauss's law

For a point charge $Q$ at the centre of a sphere of radius $r$, the field $E=Q/(4\pi\varepsilon_0r^2)$ is perpendicular to the sphere and constant on it, so
$$ \Phi=E\cdot4\pi r^2=\frac Q{\varepsilon_0}, $$
independent of $r$. The decrease of $E$ as $1/r^2$ exactly cancels the growth of the area. This holds for any closed surface around the charge, since the same field lines cross it, and for a charge outside the surface the flux is zero: every line that enters also leaves. Adding charges by superposition, one obtains **Gauss's law**
$$ \oint_S\mathbf E\cdot d\mathbf A=\frac{Q_{\text{enc}}}{\varepsilon_0}, $$
where $Q_{\text{enc}}$ is the total charge inside $S$, with $Q_{\text{enc}}=\int\rho\,dV$ for a charge density $\rho$. It is equivalent to Coulomb's law for static charges, and it is the first of the Maxwell equations.

> The law holds for every closed surface, but $\mathbf E$ in it is the total field, including charges outside. Outside charges contribute nothing to the flux and still contribute to $\mathbf E$ at each point.
{: .trap}

# Choosing a surface

Gauss's law gives $\mathbf E$ directly only when symmetry lets us pull $E$ out of the integral. Choose a **Gaussian surface** on which $\mathbf E$ is either perpendicular to the surface with constant magnitude, or parallel to it (contributing no flux). Three symmetries are enough for most problems.

{% capture t %}
| Symmetry | Gaussian surface | Result |
|:--|:--|:--|
| sphere, charge $Q$ (outside, $r>R$) | sphere of radius $r$ | $E=\dfrac{Q}{4\pi\varepsilon_0r^2}$ |
| infinite line, $\lambda$ per length | coaxial cylinder, radius $r$ | $E=\dfrac{\lambda}{2\pi\varepsilon_0r}$ |
| infinite plane, $\sigma$ per area | pillbox across the plane | $E=\dfrac{\sigma}{2\varepsilon_0}$ |
{% endcapture %}
{% include tab.html id="tab-gauss" caption="Fields found with Gauss's law." body=t %}
{: .booktabs}

For a plane, the pillbox has two end faces of area $A$ and no flux through its sides, so $2EA=\sigma A/\varepsilon_0$. For the line, the cylinder of length $\ell$ has flux $E\cdot2\pi r\ell=\lambda\ell/\varepsilon_0$ through its side and none through its ends.

Inside a uniformly charged sphere of radius $R$ and total charge $Q$, a Gaussian sphere of radius $r<R$ contains only the fraction $(r/R)^3$ of the charge, so $E\cdot4\pi r^2=Q\,r^3/(R^3\varepsilon_0)$, and
$$ E(r)=\frac{Q\,r}{4\pi\varepsilon_0R^3}\quad(r<R),\qquad E(r)=\frac{Q}{4\pi\varepsilon_0r^2}\quad(r>R). $$
The field rises linearly to the surface and then falls as $1/r^2$, with the two pieces agreeing at $r=R$.

{% include fig.html src="electromagnetism/sphere-field" id="fig-sphere-field" alt="The field of a uniformly charged sphere plotted against distance in units of the radius, rising linearly to one at the surface and falling as an inverse square outside." caption="The field of a uniformly charged sphere of radius $R$, in units of $E(R)=Q/(4\pi\varepsilon_0R^2)$. Inside, $E\propto r$ because the enclosed charge grows as $r^3$ while the area grows as $r^2$; outside, $E\propto1/r^2$." %}

# Recap

<details class="qa" markdown="1">
<summary>What does Gauss's law say?</summary>

The flux of $\mathbf E$ through any closed surface is the enclosed charge divided by $\varepsilon_0$: $\oint\mathbf E\cdot d\mathbf A=Q_{\text{enc}}/\varepsilon_0$.
</details>

<details class="qa" markdown="1">
<summary>When can the law be used to find $\mathbf E$?</summary>

When symmetry (spherical, cylindrical or planar) makes $\mathbf E$ perpendicular and constant, or parallel, on each part of a Gaussian surface, so that $E$ comes out of the integral.
</details>

<details class="qa" markdown="1">
<summary>What is the field inside and outside a uniformly charged sphere?</summary>

Inside, $E=Qr/(4\pi\varepsilon_0R^3)$; outside, $E=Q/(4\pi\varepsilon_0r^2)$, the field of a point charge at the centre.
</details>
