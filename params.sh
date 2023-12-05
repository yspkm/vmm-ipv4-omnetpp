#!/bin/bash

file_path_header_fname="DataPath.h"
lte_phy_ue_header_fname="LtePhyUe.h"
lte_phy_ue_source_fname="LtePhyUe.cc"
ned_fname="MultiCell_Standalone.ned"
ini_fname="omnetpp.ini"

root_dir=$(pwd)
cpp_dir="$root_dir/simu5G/src/stack/phy/layer"
ini_dir="$root_dir/simu5G/simulations/NR/standalone_multicell"
ned_dir="$root_dir/simu5G/simulations/NR/networks"
inet_dir="$root_dir/inet4.5"
simu5g_dir="$root_dir/simu5G"

src_dir="$root_dir/src"
dat_dir="$root_dir/dat"
raw_dir="$dat_dir/raw_data"
cmp_dir="$dat_dir/raw_kf_compare_plot"
kf_dir="$dat_dir/kf_data"
venv_dir="$dat_dir/venv"



file_path_header_fname="DataPath.h"
lte_phy_ue_header_fname="LtePhyUe.h"
lte_phy_ue_source_fname="LtePhyUe.cc"
ned_fname="MultiCell_Standalone.ned"
ini_fname="omnetpp.ini"

raw_rssi_fname="raw_rssi_data.csv"
