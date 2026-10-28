---
collection: notes
title: "Shapes and Intersections"
date: 2026-10-27
excerpt: "Implicit and parametric surfaces, triangle meshes, ray-object intersection and bounding volumes."
hook: "Everything a renderer does asks one question, where does this ray first hit the scene, and the answer depends on how the objects are described."
goals:
  - intersect a ray with a sphere, a plane and a triangle
  - speed up queries with a bounding volume hierarchy
requires:
  - homogeneous-coordinates
  - quadratic-form
defines:
  - {id: ray-intersection, name: "ray-object intersection", anchor: ray-object-intersection}
  - {id: bvh, name: "bounding volume hierarchy", anchor: bounding-volume-hierarchy}
tags:
  - Physics
  - Computation
  - Rendering
---
