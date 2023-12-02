#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

install_python_environment() {
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


build_project() {
	(
		source $HOME/.profile
		source $HOME/.bashrc
		cd inet4.5
		source setenv -f
		make makefiles
		#make -j $(( ( $(nproc) + 1 ) / 2 ))
		make -j $(nproc)
	)
	(
		source $HOME/.profile
		source $HOME/.bashrc
		cd simu5G
		source setenv -f
		make makefiles
		#make -j $(( ( $(nproc) + 1 ) / 2 ))
		make -j $(nproc)
	)
}

install_inet(){
	local INET_VERSION=4.5.0
	local INET_TGZ=inet-$INET_VERSION-src.tgz
	wget https://github.com/inet-framework/inet/releases/download/v$INET_VERSION/$INET_TGZ
	tar -zxvf $INET_TGZ
	rm $INET_TGZ
}

install_simu5g(){
	local SIMU5G_VERSION=1.2.2
	local SIMU5G=simu5G
	local SIMU5G_TGZ=v$SIMU5G_VERSION.tar.gz
	wget https://github.com/Unipisa/Simu5G/archive/refs/tags/$SIMU5G_TGZ
	tar -zxvf $SIMU5G_TGZ
	mv Simu5G-$SIMU5G_VERSION $SIMU5G
	rm $SIMU5G_TGZ
}


source ./params.sh

log "Starting Python environment installation"
install_python_environment
log "Python environment installation complete"

log "Starting INET4.5 installation"
install_inet
log "INET4.5 installation complete"

log "Starting Simu5G installation"
install_simu5g
log "Simu5G installation complete"

log "Starting project build"
build_project
log "Project build complete"
