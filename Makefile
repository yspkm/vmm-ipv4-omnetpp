SHELL := /bin/bash

help:
	@echo "Usage:"
	@echo "  make all                  - Install, Sets up simulation, runs it in CLI mode, and extracts data."
	@echo "  make install              - Installation, initial settings."
	@echo "  make setup_simulation     - Prepares the simulation environment."
	@echo "  make run_simulation_gui   - Runs the simulation in GUI mode."
	@echo "  make run_simulation_cli   - Runs the simulation in CLI mode."
	@echo "  make data_extraction      - Extracts and processes data after the simulation."
	@echo "  make docs                 - Create API Documentations."
	@echo "  make clean                - Cleans up the environment after the simulation."

all: install setup_simulation run_simulation_cli data_extraction

install: 
	@echo "Install initial requirements..."
	@bash ./init.sh

docs: dat/src dat/main.py Doxyfile
	@echo "Create API Documentations..."
	@doxygen Doxyfile
	@make -C docs
	@cp docs/refman.pdf structure.pdf
	@make -C docs clean

setup_simulation: 
	@echo "Setting up simulation..."
	@bash ./run.sh setup_simulation

run_simulation_gui: 
	@echo "Running simulation in GUI mode..."
	@bash ./run.sh run_simulation_gui

run_simulation_cli: 
	@echo "Running simulation in CLI mode..."
	@bash ./run.sh run_simulation_cli

data_extraction: 
	@echo "Extracting data..."
	@bash ./run.sh data_extraction

clean:
	@echo "Cleaning up..."
	@bash ./reset.sh

