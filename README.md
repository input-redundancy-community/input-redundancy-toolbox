# Input Redundancy Toolbox

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This MATLAB toolbox provides structural analysis and geometric control tools for input-redundant state-space systems.

This code accompanies the concepts detailed in the paper: 
> J. Kreiss and J.-F. Trégouët, “Input redundancy: Definitions, taxonomy, characterizations and application to over-actuated systems,” *Systems & Control Letters*, vol. 158, p. 105060, Dec. 2021. [DOI link](https://doi.org/10.1016/j.sysconle.2021.105060)

---

## 🎯 Scope and Features

The toolbox implements foundational algorithms from geometric control theory, offering an API using standard MATLAB conventions.

### Core Geometric Subspaces & Operations
* **$V^*$ (`vstar`)**: Computes the weakly unobservable subspace (controlled invariant). Optionally returns the associated friend matrix $F$.
* **$S^*$ (`sstar`)**: Computes the supremal conditioned invariant subspace via system duality.
* **$R^*$ (`rstar`)**: Computes the supremal reachability/controlled invariant subspace ($R^* = V^* \cap S^*$). Optionally returns its friend matrix $F$.
* **Intersections (`ints`)**: Computes the orthonormal basis of the intersection of two subspaces.
* **Inverse Images (`invt`)**: Computes the pull-back (inverse image) $B^{-1}\mathcal{V}$ under a linear mapping.
* **Friend Matrices (`effe`)**: Computes state feedback matrices $F$ ensuring controlled invariance and output-nulling invisibility.

### System Analysis & Redundancy Tools
* **Input Redundancy Check (`is_ir`)**: Evaluates whether a system is input redundancy or not
* **Input Redundancy Analysis (`ir`)**: Tests input redundancy and characterizes redundant properties.
* **Input Redundant Decomposition (`irDecomp`)**: Separates systems into uncontrollable/external dynamics and controllable internal dynamics.
* **Input Annihilator (`annihilator`)**: Computes the state-space realization of the input annihilator.

---

## 📁 Project Structure

* `src/`: Core toolbox functions (`ir.m`, `irDecomp.m`, `is_ir.m`, `annihilator.m`).
* `src/+geometric/`: Geometric control package containing core subspace algorithms (`vstar.m`, `sstar.m`, `rstar.m`, `ints.m`, `invt.m`, `effe.m`).
* `examples/`: Scripts demonstrating system decomposition, input redundancy checks, and annihilator extraction.
* `init_toolbox.m`: Initialization script to add the required directories to your MATLAB path.

---

## ⚙️ Installation & Quick Start

1. Clone the repository:
   ```bash
   git clone [https://github.com/kreiss1/control-allocation-toolbox.git](https://github.com/kreiss1/control-allocation-toolbox.git)