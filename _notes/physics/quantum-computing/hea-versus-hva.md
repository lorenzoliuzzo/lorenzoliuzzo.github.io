---
collection: notes
title: 'Ansatz Comparison: HEA versus HVA'
date: '2026-10-27'
excerpt: A generic hardware-efficient ansatz against a Hamiltonian variational ansatz on the TFIM.
hook: An ansatz shaped like the Hamiltonian reaches a lower energy error and stays trainable as the chain grows, where a generic one does not.
goals:
- compare energy error of two ansatz families at fixed depth
- relate the result to barren plateaus
requires:
- barren-plateau
- transverse-field-ising-model
defines:
- id: hardware-efficient-ansatz
  name: hardware-efficient ansatz
  anchor: hardware-efficient-ansatz
- id: hamiltonian-variational-ansatz
  name: Hamiltonian variational ansatz
  anchor: hamiltonian-variational-ansatz
tags:
- Physics
- Quantum Computing
---
