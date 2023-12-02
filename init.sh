#!/bin/bash
#
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


install_omnetpp() {
    # Installing Prerequisite Packages
    sudo apt-get update
    sudo apt-get install -y build-essential clang lld gdb bison flex perl python3 python3-pip \
        qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5opengl5-dev libxml2-dev \
        zlib1g-dev doxygen graphviz libwebkit2gtk-4.0-37
    python3 -m pip install --user --upgrade numpy pandas matplotlib scipy seaborn posix_ipc

    # To use Qtenv with 3D visualization support
    sudo apt-get install -y libopenscenegraph-dev

    # To enable the optional parallel simulation support
    sudo apt-get install -y mpi-default-dev

    # Installing Omnetpp
    OMNETPP=omnetpp-6.0.1
    OMNETPP_HOME=$HOME/$OMNETPP
    OMNETPP_TGZ=$OMNETPP-linux-x86_64.tgz
    wget https://github.com/omnetpp/omnetpp/releases/download/$OMNETPP/$OMNETPP_TGZ
    tar xvfz $OMNETPP_TGZ
    rm $OMNETPP_TGZ
    mv $OMNETPP $HOME/
    echo "export PATH=\"\$PATH:$OMNETPP_HOME/bin\"" >> $HOME/.profile
    echo "[ -f \"$OMNETPP_HOME/setenv\" ] && source \"$OMNETPP_HOME/setenv\" > /dev/null 2>&1" >> $HOME/.profile
    (
	source $HOME/.profile
        cd $OMNETPP_HOME
        source setenv -f
        ./configure
        #make -j $(( ( $(nproc) + 1 ) / 2 ))
	make -j $(nproc)

	# Verifying 
	cd $OMNETPP_HOME/samples/aloha
	./aloha
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

build_project() {
	(
		source $HOME/.profile
		cd inet4.5
		source setenv -f
		make makefiles
		#make -j $(( ( $(nproc) + 1 ) / 2 ))
		make -j $(nproc)
	)
	(
		source $HOME/.profile
		cd simu5G
		source setenv -f
		make makefiles
		#make -j $(( ( $(nproc) + 1 ) / 2 ))
		make -j $(nproc)
	)
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

source ./params.sh

log "Starting Python environment installation"
install_python_environment
log "Python environment installation complete"

log "Starting OMNeT++ installation"
install_omnetpp
log "OMNeT++ installation complete"

log "Starting INET installation"
install_inet
log "INET installation complete"

log "Starting Simu5G installation"
install_simu5g
log "Simu5G installation complete"

log "Starting project build"
build_project
log "Project build complete"
