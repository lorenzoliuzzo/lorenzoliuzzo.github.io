---
collection: notes
title: Trainability and Barren Plateaus
date: '2026-10-27'
excerpt: Vanishing gradient variance with qubit number and how ansatz structure avoids it.
hook: For generic deep circuits the gradient is exponentially small in the number of qubits, so structure in the ansatz is a requirement and not a refinement.
goals:
- explain the exponential decay of gradient variance
- say when a symmetry-respecting ansatz avoids it
requires:
- vqe
defines:
- id: barren-plateau
  name: barren plateau
  anchor: barren-plateau
- id: gradient-variance
  name: gradient variance
  anchor: gradient-variance
tags:
- Physics
- Quantum Computing
---
