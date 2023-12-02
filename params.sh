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

src_dir="$root_dir/src"
dat_dir="$root_dir/dat"


file_path_header_fname="DataPath.h"
lte_phy_ue_header_fname="LtePhyUe.h"
lte_phy_ue_source_fname="LtePhyUe.cc"
ned_fname="MultiCell_Standalone.ned"
ini_fname="omnetpp.ini"

raw_rssi_fname="raw_rssi_data.csv"
