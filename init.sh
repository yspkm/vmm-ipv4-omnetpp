#!/bin/bash


setup_project() {
	sudo apt-get update
	sudo apt-get install -y rar 
	(
		cd init
		./run.sh
	)
	(
		cd inet4.5
		source setenv -f
		make makefiles
		make -j $(( ( $(nproc) + 1 ) / 2 ))
	)
}


setup_python_environment() {
    sudo apt-get update 
    sudo apt-get install virtualenv -y
    sudo apt-get install python3 python3-pip python3-dev -y
    pip3 install --upgrade pip

    local data_dirname="dat"
    local venv_dirname="venv"
    local requirements_filename="requirements.txt"

    local root_dir=$(pwd)
    local data_dir="$root_dir/$data_dirname"
    local venv_dir="$data_dir/$venv_dirname"

    mkdir -p "$data_dir"
    virtualenv "$venv_dir"
    source "$venv_dir/bin/activate"
    pip3 install -r "$data_dir/$requirements_filename"
}


source ./params.sh
setup_project
#setup_python_environment

