---
collection: notes
title: "Monte Carlo Path Tracing"
date: 2026-10-27
excerpt: "Unbiased estimation of the rendering equation, importance sampling, next-event estimation and Russian roulette."
hook: "The rendering equation is an integral over paths of light, and a random walk through the scene estimates it without bias at the cost of noise."
goals:
  - derive the path tracing estimator
  - reduce variance with importance sampling and next-event estimation
requires:
  - rendering-equation
  - monte-carlo-integration
  - importance-sampling
  - ray-tracing
defines:
  - {id: path-tracing, name: "path tracing", anchor: path-tracing}
  - {id: next-event-estimation, name: "next-event estimation", anchor: next-event-estimation}
  - {id: russian-roulette, name: "Russian roulette", anchor: russian-roulette}
tags:
  - Physics
  - Computation
  - Rendering
---
