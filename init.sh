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

    echo "export PATH=\"\$PATH:$OMNETPP_HOME/bin\"" >> $HOME/.bashrc
    echo "[ -f \"$OMNETPP_HOME/setenv\" ] && source \"$OMNETPP_HOME/setenv\" > /dev/null 2>&1" >> $HOME/.bashrc

	source $HOME/.profile
	source $HOME/.bashrc

        cd $OMNETPP_HOME
        source setenv -f
        ./configure
        #make -j $(( ( $(nproc) + 1 ) / 2 ))
	make -j $(nproc)

	# Verifying 
	cd $OMNETPP_HOME/samples/aloha
	./aloha
}

build_project() {
	sudo apt-get update
	sudo apt-get install -r rar
	(
		cd init
		./run.sh
	)
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

log "Starting project build"
build_project
log "Project build complete"
