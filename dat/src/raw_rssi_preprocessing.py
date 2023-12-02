#!/bin/python3
import csv
import os

import pandas as pd
from pandas.api.extensions import ExtensionArray
from typing import Dict, Tuple, Optional

from src.common import get_save_dir, OUTPUT_RAW_RSSI_DATA_FILENAME, RAW_RSSI_DATA_BASE_DIRNAME


def read_data(filename):
    df_raw = pd.read_csv(filename, header=None)
    df_raw.columns = ['sim_time', 'ue', 'gnb', 'rssi']
    return df_raw


def process_data(df_raw: pd.DataFrame) -> pd.DataFrame:
    data_by_ue: dict = {}
    ues: ExtensionArray = df_raw['ue'].unique()
    simtimes: ExtensionArray = df_raw['sim_time'].unique()

    for ue in ues:
        data_by_ue[ue] = {simtime: {gnb: None for gnb in range(1, 6)} for simtime in simtimes}

    for _, row in df_raw.iterrows():
        ue, simtime, gnb, rssi = row['ue'], row['sim_time'], row['gnb'], row['rssi']
        data_by_ue[ue][simtime][gnb] = rssi

    return pd.DataFrame(data_by_ue)


def save_data(data_by_ue, data_dir):
    created_files = []
    for ue, simtime_data in data_by_ue.items():
        filename = os.path.join(data_dir, f'ue_{ue}_data.csv')
        created_files.append(filename)

        with open(filename, 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)
            header = ['sim_time'] + [str(gnb) for gnb in range(1, 6)]
            csvwriter.writerow(header)

            for simtime, gnbs in simtime_data.items():
                row = [simtime] + [gnbs[gnb] if gnbs[gnb] is not None else '' for gnb in range(1, 6)]
                csvwriter.writerow(row)

    return created_files


def raw_preprocessing():
    data_file = os.path.join(os.path.dirname(__file__), OUTPUT_RAW_RSSI_DATA_FILENAME)
    df_raw = read_data(data_file)
    data_by_ue = process_data(df_raw)

    data_dir = get_save_dir(base_dir_name=RAW_RSSI_DATA_BASE_DIRNAME, save_dir_name='numeric_data')
    created_files = save_data(data_by_ue, data_dir)

    created_files_paths = [os.path.join('./', os.path.basename(file)) for file in created_files]
    print(created_files_paths)
