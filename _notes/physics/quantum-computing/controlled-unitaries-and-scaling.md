---
collection: notes
title: Multi-Controlled Gates and Circuit Depth
date: '2026-10-27'
excerpt: Toffoli from CNOTs, SWAP from three CNOTs, and the exponential cost of many controls.
hook: A gate with n controls cannot be built from a few elementary gates, and the measured depth is what makes the cost of a decomposition concrete.
goals:
- decompose a Toffoli and a SWAP into CNOTs and single-qubit gates
- measure circuit depth against the number of controls
requires:
- tensor-product-state
defines:
- id: toffoli-gate
  name: Toffoli gate
  anchor: toffoli-gate
- id: circuit-depth
  name: circuit depth
  anchor: circuit-depth
- id: gate-decomposition
  name: gate decomposition
  anchor: gate-decomposition
tags:
- Physics
- Quantum Computing
---
