#!/bin/python3
import os

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from matplotlib.ticker import MaxNLocator

from src.common import (
    get_save_dir,
    get_load_dir,
    safe_make_directory,
    RAW_RSSI_DATA_BASE_DIRNAME,
    NUMERIC_DATA_DIRNAME,
    VISUALIZED_DATA_DIRNAME,
    KF_RAW_COMPARE_PLOT_DIRNAME,
    KF_RSSI_DATA_BASE_DIRNAME
)


def plot_ue_data(df: str, ue: str, save_path: str, description: str):
    sns.set(style="whitegrid")  # Seaborn style
    plt.figure(figsize=(12, 8))  # Adjust figure size

    for gnb in range(1, 6):
        plt.plot(df['sim_time'], df[f'{gnb}'], label=f'gNb{gnb}')  # Customize line style if needed

    plt.xlabel('Simtime (second)', fontsize=12)
    plt.ylabel('RSSI', fontsize=12)
    plt.title(f'{description} UE {ue} RSSI over Time', fontsize=14)
    plt.legend(fontsize=10, loc='best')  # Adjust legend
    plt.grid(True, linestyle='--', linewidth=0.5)  # Customize grid
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))

    plt.tight_layout()  # Optimize layout
    plt.savefig(os.path.join(save_path, f'ue_{ue}_graph.png'), dpi=300)  # Increase DPI for higher resolution
    plt.close()


def plot_combined_data(all_dfs, save_path):
    sns.set(style="whitegrid")  # Seaborn style
    plt.figure(figsize=(12, 8))  # Adjust figure size

    for ue, df in all_dfs.items():
        for gnb in range(1, 6):
            plt.plot(df['sim_time'], df[f'{gnb}'], label=f'UE{ue}_gNb{gnb}')  # Customize line style if needed

    plt.xlabel('Simtime (second)', fontsize=12)
    plt.ylabel('RSSI', fontsize=12)
    plt.title('All UEs RSSI over Time', fontsize=14)
    plt.legend(fontsize=10, loc='best')  # Adjust legend
    plt.grid(True, linestyle='--', linewidth=0.5)  # Customize grid
    plt.gca().xaxis.set_major_locator(MaxNLocator(integer=True))

    plt.tight_layout()  # Optimize layout
    plt.savefig(os.path.join(save_path, 'combined_graph.png'), dpi=300)  # Increase DPI
    plt.close()


def visualize_each(base_dir_name: str, description: str):
    data_dir = get_load_dir(base_dir_name=base_dir_name, load_dir_name=NUMERIC_DATA_DIRNAME)
    plot_dir = get_save_dir(base_dir_name=base_dir_name, save_dir_name=VISUALIZED_DATA_DIRNAME)

    all_data = {}
    for csv_file in os.listdir(data_dir):
        if csv_file.endswith('_data.csv'):
            ue = csv_file.split('_')[1]
            df = pd.read_csv(os.path.join(data_dir, csv_file))
            all_data[ue] = df
            plot_ue_data(df, ue, plot_dir, description)

    plot_combined_data(all_data, plot_dir)


def plot_data_kf_and_raw(df_kf: pd.DataFrame, df_raw: pd.DataFrame, ue: str, gnb: str, plot_dir: str):
    sns.set(style="whitegrid")  # Seaborn style
    plt.figure(figsize=(12, 8))
    sns.lineplot(x='sim_time', y=gnb, data=df_kf, label='KF', linestyle='--')
    sns.lineplot(x='sim_time', y=gnb, data=df_raw, label='rawRSSI', linewidth=1)

    plt.title(f'UE {ue} GNB {gnb} Signal Strength')
    plt.legend(title='Signal Type')
    plt.xlabel('Simulation Time')
    plt.ylabel('Signal Strength (dBm)')

    filename = f'ue_{ue}_gnb_{gnb}.png'
    # print(plot_dir)
    # print(filename)
    plt.savefig(os.path.join(plot_dir, filename), dpi=300)
    plt.close()


def get_path_kf_and_raw() -> tuple:
    kf_dir = get_load_dir(base_dir_name=KF_RSSI_DATA_BASE_DIRNAME, load_dir_name=NUMERIC_DATA_DIRNAME)
    raw_dir = get_load_dir(base_dir_name=RAW_RSSI_DATA_BASE_DIRNAME, load_dir_name=NUMERIC_DATA_DIRNAME)
    plot_dir = safe_make_directory(os.path.join(
        os.path.dirname(os.path.dirname(__file__)),
        KF_RAW_COMPARE_PLOT_DIRNAME
    ))

    return kf_dir, raw_dir, plot_dir


def visualize_kf_and_raw():
    kf_dir, raw_dir, plot_dir = get_path_kf_and_raw()
    for ue in range(1, 11):
        for gnb in range(1, 6):
            kf_file_path = os.path.join(kf_dir, f'ue_{ue}_data.csv')
            raw_file_path = os.path.join(raw_dir, f'ue_{ue}_data.csv')
            # print(kf_file_path)

            if os.path.exists(kf_file_path) and os.path.exists(raw_file_path):
                df_kf = pd.read_csv(kf_file_path)
                df_raw = pd.read_csv(raw_file_path)

                df_kf['sim_time'] = df_kf.index
                df_raw['sim_time'] = df_raw.index

                plot_data_kf_and_raw(df_kf, df_raw, str(ue), str(gnb), plot_dir)
            else:
                print(f"Data files for UE {ue} are missing.")
