---
collection: notes
title: "Markov Chain Monte Carlo"
date: 2026-10-27
excerpt: "The Metropolis algorithm, detailed balance, thermalization, autocorrelation and the Ising model."
hook: "A random walk built to satisfy detailed balance visits states with their Boltzmann weights, so one can simulate a magnet on a laptop."
goals:
  - implement Metropolis for the Ising model
  - estimate errors with autocorrelation
requires:
  - monte-carlo-integration
  - importance-sampling
defines:
  - {id: metropolis, name: "Metropolis algorithm", anchor: metropolis-algorithm}
  - {id: detailed-balance, name: "detailed balance", anchor: detailed-balance}
  - {id: autocorrelation-time, name: "autocorrelation time", anchor: autocorrelation-time}
tags:
  - Physics
  - Computation
---
