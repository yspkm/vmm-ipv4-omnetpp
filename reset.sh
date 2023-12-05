#!/bin/bash

echo "Do you want to change the modulation? [y/N]"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Changing modulation..."
	source params.sh
	rm -rf \
		$dat_dir/$raw_rssi_fname \
		$venv_dir \
		$raw_dir \
    	$kf_dir \
		$cmp_dir \
		$src_dir/$file_path_header_fname \
		$inet_dir \
		$simu5g_dir
else
    echo "Modulation change cancelled."
fi

