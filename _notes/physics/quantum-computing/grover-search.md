---
collection: notes
title: Grover Search
date: '2026-10-27'
excerpt: Amplitude amplification, the diffusion operator, the optimal number of iterations and several marked items.
hook: Grover rotates the state by a fixed angle toward the marked item at each step, so sqrt(N) steps suffice and more steps overshoot.
goals:
- derive the rotation angle per iteration
- choose the iteration count for M marked items among N
requires:
- oracle
- bloch-sphere
defines:
- id: grover-iteration
  name: Grover iteration
  anchor: grover-iteration
- id: diffusion-operator
  name: diffusion operator
  anchor: diffusion-operator
- id: amplitude-amplification
  name: amplitude amplification
  anchor: amplitude-amplification
tags:
- Physics
- Quantum Computing
---
