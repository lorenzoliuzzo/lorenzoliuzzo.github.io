---
collection: notes
title: "Filtering and Antialiasing"
date: 2026-10-27
excerpt: "Sampling and reconstruction, pixel filters, aliasing and denoising."
hook: "A pixel is an average over an area, and sampling it badly gives jagged edges that no later processing can repair."
goals:
  - explain aliasing with the sampling theorem
  - choose a pixel filter
requires:
  - path-tracing
  - fourier-transform
defines:
  - {id: antialiasing, name: "antialiasing", anchor: antialiasing}
  - {id: pixel-filter, name: "pixel filter", anchor: pixel-filter}
tags:
  - Physics
  - Computation
  - Rendering
---
