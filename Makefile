SHELL := /bin/bash

all: setup_simulation run_simulation_cli data_extraction

setup_simulation: 
	@echo "Setting up simulation..."
	@bash ./run.sh setup_simulation

run_simulation_gui: 
	@echo "Running simulation..."
	@bash ./run.sh run_simulation_gui

run_simulation_cli: 
	@echo "Running simulation..."
	@bash ./run.sh run_simulation_cli

data_extraction: 
	@echo "Extracting data..."
	@bash ./run.sh data_extraction

clean:
	@echo "Cleaning up..."
	@bash ./reset.sh

