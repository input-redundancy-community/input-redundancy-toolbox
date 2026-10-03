# Input Redundancy Toolbox

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23121420.svg)](https://doi.org/10.5281/zenodo.23121420)


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


## 📖 How to Cite

If you use this toolbox in your research or academic work, please cite it using the Zenodo DOI:

```bibtex
@software{jeremie_kreiss_2026_23121420,
  author       = {Jérémie Kreiss},
  title        = {input-redundancy-community/input-redundancy-
                   toolbox: v1.1.2- Release with improvments of
                   numerical computation
                  },
  month        = oct,
  year         = 2026,
  publisher    = {Zenodo},
  version      = {v1.1.2},
  doi          = {10.5281/zenodo.23121420},
  url          = {https://doi.org/10.5281/zenodo.23121420},
  swhid        = {swh:1:dir:a11003d9d7838d4402f93ba7407d318718164494
                   ;origin=https://doi.org/10.5281/zenodo.23121419;vi
                   sit=swh:1:snp:72ef142b596b9ff08488e96a34b00af2d0ec
                   4886;anchor=swh:1:rel:0c10f1e806051c5e4cc05b8eb6fa
                   7a7ec9f42ebf;path=input-redundancy-community-
                   input-redundancy-toolbox-641bdda
                  },
}

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

