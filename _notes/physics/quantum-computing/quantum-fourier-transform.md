---
collection: notes
title: The Quantum Fourier Transform
date: '2026-10-27'
excerpt: The QFT circuit from Hadamards, controlled phases and swaps, and its relation to the discrete Fourier transform.
hook: The QFT applies the discrete Fourier transform to the amplitudes with about n squared gates instead of N log N, but the output cannot be read out in full.
goals:
- build the QFT circuit for n qubits
- check it against the classical discrete Fourier transform
requires:
- tensor-product-state
- fourier-transform
defines:
- id: quantum-fourier-transform
  name: quantum Fourier transform
  anchor: quantum-fourier-transform
- id: controlled-phase
  name: controlled phase
  anchor: controlled-phase
tags:
- Physics
- Quantum Computing
---
