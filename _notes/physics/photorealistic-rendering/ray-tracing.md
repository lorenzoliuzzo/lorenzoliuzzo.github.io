---
collection: notes
title: "Ray Tracing"
date: 2026-10-27
excerpt: "Primary, shadow and reflected rays, recursion and the limits of the Whitted model."
hook: "Following rays backwards from the eye finds what is visible, and spawning more rays at each hit adds shadows, mirrors and glass."
goals:
  - write a ray tracer with shadows and reflection
  - explain what the Whitted model leaves out
requires:
  - ray-intersection
  - brdf
defines:
  - {id: ray-tracing, name: "ray tracing", anchor: ray-tracing}
  - {id: shadow-ray, name: "shadow ray", anchor: shadow-ray}
tags:
  - Physics
  - Computation
  - Rendering
---
