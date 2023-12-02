#!/bin/bash

source params.sh

rm -rf ./inet4.5
rm -rf ./simu5G
rm -rf ./dat/raw_rssi_data.csv ./dat/raw_data ./dat/kf_data ./dat/raw_kf_compare_plot

echo "Do you want to change the modulation? [y/N]"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Changing modulation..."
else
    echo "Modulation change cancelled."
fi

