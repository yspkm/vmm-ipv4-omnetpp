#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

copy_file() {
    local fname=$1
    local src_dir=$2   
    local dst_dir=$3

    local src_path="$src_dir/$fname"
    local dst_path="$dst_dir/$fname"

    log "Copying file from $src_path to $dst_path..."
    if cp "$src_path" "$dst_path"; then echo "Successfully copied $fname to $dst_dir"
    else
        log "Failed to copy $fname from $src_dir to $dst_dir"
    fi
}

create_file_path_header() {
	local file_path_header=$src_dir/$file_path_header_fname
    echo '#pragma once' \
		> "$file_path_header"
    echo '' \
		>> $file_path_header
    echo "#define OUTPUT_RAW_RSSI_DATA_PATH \"$dat_dir/$raw_rssi_fname\""\
		>> $file_path_header
}

setup_simulation() {
	create_file_path_header

    copy_file $lte_phy_ue_header_fname $src_dir $cpp_dir
    copy_file $lte_phy_ue_source_fname $src_dir $cpp_dir
    copy_file $file_path_header_fname $src_dir $cpp_dir
    copy_file $ned_fname $src_dir $ned_dir  
    copy_file $ini_fname $src_dir $ini_dir


    (
		cd $root_dir/simu5G
    	source setenv -f
		make makefiles
		make -j $(( ( $(nproc) + 1 ) / 2 ))
	)
}

run_simulation_cli() {
    (
		cd $root_dir/simu5G
		source setenv -f
		cd $ini_dir 
		./run -u Cmdenv -f omnetpp.ini -c MultiCell
	)
}

run_simulation_gui() {
    (
		cd $root_dir/simu5G
		source setenv -f
		cd $ini_dir 
		./run
	)
}

data_extraction() {
	(
		cd $dat_dir
		source venv/bin/acitivate
		python3 main.py
	)
}

source ./params.sh
case "$1" in
    setup_simulation)
	log "setup_simulation"
        setup_simulation
        ;;
    run_simulation_gui)
	log "run_simulation_gui"
        run_simulation_gui
        ;;
    run_simulation_cli)
	log "run_simulation_cli"
        run_simulation_cli
        ;;
    data_extraction)
	log "data_extraction"
        data_extraction
        ;;
    *)
        echo "Usage: $0 {setup_simulation|run_simulation_gui|run_simulation_cli|data_extraction}"
        exit 1
        ;;
esac
