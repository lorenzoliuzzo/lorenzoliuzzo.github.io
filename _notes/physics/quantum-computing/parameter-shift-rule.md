---
collection: notes
title: Gradients and the Parameter-Shift Rule
date: '2026-10-27'
excerpt: Simulator differentiation against hardware-compatible gradients, and the shift rule for rotation gates.
hook: On hardware the gradient of a rotation parameter is an exact difference of two circuit runs at shifted angles, with no finite-difference error.
goals:
- derive the parameter-shift rule for a Pauli rotation
- compare it with backpropagation through a simulator
requires:
- parameterized-quantum-circuit
defines:
- id: parameter-shift-rule
  name: parameter-shift rule
  anchor: parameter-shift-rule
- id: hardware-gradient
  name: hardware-compatible gradient
  anchor: hardware-gradient
tags:
- Physics
- Quantum Computing
---
