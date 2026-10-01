# Input Redundancy Toolbox

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This MATLAB toolbox provides structural analysis tools for input-redundant state-space systems.

This code accompanies the concepts detailed in the paper: 
> J. Kreiss and J.-F. Trégouët, “Input redundancy: Definitions, taxonomy, characterizations and application to over-actuated systems,” *Systems & Control Letters*, vol. 158, p. 105060, Dec. 2021. [DOI link](https://doi.org/10.1016/j.sysconle.2021.105060)

## 🎯 Scope and Features

This toolbox focuses on the fundamental structural properties of the system $(A,B,C,D)$.

## 🔗 Related Tools

For solving the actual control allocation problem using constrained optimization algorithms, we recommend the [Quadratic Control Allocation Toolbox (QCAT)](http://www.control.isy.liu.se/~ola/ControlAllocationToolbox/) developed by Ola Härkegård.

## 📁 Project Structure

* `src/`: Core functions (`ir.m`, `ir_decomp.m`,...).
* `examples/`: Scripts demonstrating how to use the functions.
* `init_toolbox.m`: A script to add the required folders to your MATLAB path.

## ⚙️ Installation

```matlab
git clone [https://github.com/TonPseudo/input-redundancy-toolbox.git](https://github.com/TonPseudo/input-redundancy-toolbox.git)
