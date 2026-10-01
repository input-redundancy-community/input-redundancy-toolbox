# Control Allocation Toolbox

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This MATLAB toolbox provides structural analysis and design tools for input-redundant systems. It focuses on identifying **Input Redundancy (IR)** and synthesizing annihilators for control allocation.

This code accompanies the concepts detailed in the paper: 
> *Input redundancy: Definitions, taxonomy, characterizations and application to over-actuated systems*, J. Kreiss, J.-F. Trégouët, 2026. [DOI link](https://doi.org/10.1016/j.sysconle.2021.105060)

## 🎯 Scope and Features

Instead of providing standard constrained optimization solvers (which are already well covered by other tools), this toolbox focuses on the **structural properties** of the system $(A,B,C,D)$:

1. **Input Redundancy Analysis:** Determine if a given state-space system exhibits Input Redundancy (IR) and identify its specific type (e.g., static, dynamic, uniform).
2. **Annihilator Synthesis:** Automatically compute the appropriate annihilator (static matrix or dynamic filter) that maps the redundant inputs to the system's null space, ensuring the main regulation dynamics remain undisturbed.

## 📁 Project Structure

* `src/`: Core functions for IR analysis and annihilator synthesis.
* `examples/`: Simple scripts demonstrating how to use the functions on benchmark systems.
* `init_toolbox.m`: A quick script to add the required folders to your MATLAB path.

## ⚙️ Installation

```matlab
git clone [https://github.com/TonPseudo/control-allocation-toolbox.git](https://github.com/TonPseudo/control-allocation-toolbox.git)
