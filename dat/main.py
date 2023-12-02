#!/bin/python3

from src.visualizer import visualize_each, visualize_kf_and_raw
from src.raw_rssi_preprocessing import raw_preprocessing
from src.kalman_rssi_preprocessing import kf_preprocessing
from src.master_gnb_analysis import generate_ho_data
from src.ping_pong_rate_analysis import generate_ppr_data
from src.common import (RAW_RSSI_DATA_BASE_DIRNAME,
                        KF_RSSI_DATA_BASE_DIRNAME)

if __name__ == '__main__':
    raw_preprocessing()
    visualize_each(base_dir_name=RAW_RSSI_DATA_BASE_DIRNAME, description="Raw Data")
    generate_ho_data(base_dir_name=RAW_RSSI_DATA_BASE_DIRNAME)
    generate_ppr_data(base_dir_name=RAW_RSSI_DATA_BASE_DIRNAME)

    kf_preprocessing()
    visualize_each(base_dir_name=KF_RSSI_DATA_BASE_DIRNAME, description="Kalman Filtered Data")
    generate_ho_data(base_dir_name=KF_RSSI_DATA_BASE_DIRNAME)
    generate_ppr_data(base_dir_name=KF_RSSI_DATA_BASE_DIRNAME)

    visualize_kf_and_raw()
