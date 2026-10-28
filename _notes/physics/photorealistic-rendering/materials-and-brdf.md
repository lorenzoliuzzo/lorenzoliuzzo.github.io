---
collection: notes
title: "Materials, BRDFs and Shading"
date: 2026-10-27
excerpt: "The BRDF, reciprocity and energy conservation, Lambertian, Phong and microfacet models."
hook: "A material is a function that says how light arriving from one direction leaves towards another, and a plausible one must conserve energy."
goals:
  - state the properties of a physical BRDF
  - implement a diffuse and a specular model
requires:
  - radiance
  - rendering-equation
defines:
  - {id: brdf, name: "BRDF", anchor: brdf}
  - {id: lambertian-reflection, name: "Lambertian reflection", anchor: lambertian-reflection}
  - {id: microfacet-model, name: "microfacet model", anchor: microfacet-model}
tags:
  - Physics
  - Computation
  - Rendering
---
