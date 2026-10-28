---
collection: notes
title: The Variational Quantum Eigensolver
date: '2026-10-27'
excerpt: The variational principle with a circuit state, ground-state search and optimizer choice.
hook: The energy of any trial state bounds the ground energy from above, so minimising it over circuit parameters approaches the ground state from above.
goals:
- write a VQE loop for a small Hamiltonian
- judge convergence against an exact diagonalization
requires:
- parameter-shift-rule
- eigenvalue
defines:
- id: vqe
  name: variational quantum eigensolver
  anchor: vqe
- id: variational-principle
  name: variational principle
  anchor: variational-principle
tags:
- Physics
- Quantum Computing
---
