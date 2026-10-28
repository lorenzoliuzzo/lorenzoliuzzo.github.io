---
collection: notes
title: "Finite Differences for PDEs"
date: 2026-10-27
excerpt: "Discretizing the heat, wave and Laplace equations, stability and the CFL condition."
hook: "Replacing derivatives by differences turns a field equation into a recurrence, and its stability decides whether it is usable."
goals:
  - discretize a PDE on a grid
  - choose a step satisfying the stability condition
requires:
  - numerical-error
  - condition-number
defines:
  - {id: finite-difference, name: "finite difference", anchor: finite-difference}
  - {id: cfl-condition, name: "CFL condition", anchor: cfl-condition}
tags:
  - Physics
  - Computation
---
