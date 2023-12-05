# Mobile Network Handover and Ping-Pong Effect Simulation

## Table of Contents

1. [Project Overview](#project-overview)
2. [Installation](#installation)
   - [Dependencies](#dependencies)
   - [Setup](#setup)
3. [Usage](#usage)
   - [Simulation Setup](#simulation-setup)
   - [Running the Simulation](#running-the-simulation)
   - [Data Extraction and Analysis](#data-extraction-and-analysis)
   - [Clean-Up](#clean-up)
4. [Project Structure](#project-structure)
5. [License](#license)

## Project Overview

This project is centered around the analysis of handover procedures and the ping-pong effect in 5G networks through a detailed simulation environment. The core objectives are to extract RSSI (Reference Signal Received Power) data from the simulation, apply Kalman filtering to this data, and perform comparative analyses.

### Key Concepts

- **Handover Procedure**: Transition of UE between gNBs.
- **Ping-Pong Effect**: Rapid switching of UE between gNodeBs at cell boundaries.
- **Kalman Filter**: Noise reduction in RSRP measurements.

## Installation

### Dependencies

- Ubuntu 22.04 LTS
- Python 3.10.x
- OMNeT++ 6.0.1

### Initial Setup

- Run `make install` to install necessary packages and set up the environment.
- You must aleady installed omnetpp 6.0.1

  ```bash
  make install
  ```

## Simulation

### General Help

- To view available make targets and their descriptions, use:

  ```bash
  make help
  ```

### Make all

- Use `Makefile` for install, setup, cli-run, and data-extraction

  ```bash
  make all
  ```

### Simulation Setup

- Use `Makefile` for simulation environment setup.
  ```bash
  make setup_simulation
  ```

### Running the Simulation

- **CLI Mode**:
  ```bash
  make run_simulation_cli
  ```
- **GUI Mode**:
  ```bash
  make run_simulation_gui
  ```

### Data Extraction and Analysis

- Process and visualize data post-simulation.
  ```bash
  make data_extraction
  ```

### Clean-Up

- Post-simulation environment clean-up.
  ```bash
  make clean
  ```

## Project Structure

- `Makefile`: Manages simulation setup, running, and cleanup.
- `init.sh`: Environment setup script.
- `run.sh`: Script containing simulation functions.
- `reset.sh`: Script containing simulation reset project.
- `dat/main.py`: Data processing and visualization Python script.

## License

This project is licensed under the GPL 3.0 License - see the LICENSE file for details.
