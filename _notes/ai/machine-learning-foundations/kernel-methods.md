---
collection: notes
title: "Kernel Methods"
date: 2026-10-27
excerpt: "Feature maps, Mercer kernels, the kernel trick and kernel ridge regression."
hook: "A kernel computes the inner product of two examples in a huge feature space without building that space, so linear methods become nonlinear for free."
goals:
  - state Mercer's condition and check a kernel
  - fit kernel ridge regression
requires:
  - ridge-regression
  - spectral-theorem
  - inner-product
defines:
  - {id: mercer-kernel, name: "Mercer kernel", anchor: mercer-kernel}
  - {id: kernel-trick, name: "kernel trick", anchor: kernel-trick}
  - {id: kernel-ridge, name: "kernel ridge regression", anchor: kernel-ridge-regression}
tags:
  - Artificial Intelligence
  - Machine Learning
---
