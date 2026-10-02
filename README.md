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
* 𝒱\* **(`vstar`)**: Computes the weakly unobservable subspace (controlled invariant). Optionally returns the associated friend matrix $F$.
* 𝒮\* **(`sstar`)**: Computes the supremal conditioned invariant subspace via system duality.
* ℛ\* **(`rstar`)**: Computes the supremal reachability/controlled invariant subspace (ℛ\* = 𝒱\* ∩ 𝒮\*). Optionally returns its friend matrix $F$.
* **Intersections (`ints`)**: Computes the orthonormal basis of the intersection of two subspaces.
* **Inverse Images (`invt`)**: Computes the pull-back (inverse image) $B^{-1}𝒱$ under a linear mapping.
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


## 📖 How to Cite - BibteX

If you use this toolbox in your research or academic work, please cite it as follows:

  ```bibtex
  @software{Kreiss2026_InputRedundancyToolbox,
    author = {Kreiss, Jérémie and Trégouët, Jean-François},
    title = {Input Redundancy Toolbox for MATLAB},
    year = {2026},
    publisher = {GitHub},
    journal = {GitHub repository},
    howpublished = {\url{https://github.com/input-redundancy-community/input-redundancy-toolbox}}
  }
  ```

## Installation

### Option 1: MATLAB Add-On (Recommended)
The easiest way to install the toolbox is via the MATLAB Add-On package:

1. Go to the [Releases](../../releases/latest) page of this repository.
2. Download the `input-redundancy-toolbox.mltbx` file attached to the latest release.
3. Double-click the downloaded file, or drag and drop it directly into your MATLAB workspace.
4. Click **Install**. The `+geometric` namespace and core functions will automatically be added to your MATLAB path.

### Option 2: Clone from Source (For Developers)
If you wish to modify the code or contribute to the toolbox:

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/input-redundancy-community/input-redundancy-toolbox.git