import os
from pathlib import Path


RAW_RSSI_DATA_BASE_DIRNAME: str = 'raw_data'
KF_RSSI_DATA_BASE_DIRNAME: str = 'kf_data'
KF_RAW_COMPARE_PLOT_DIRNAME: str = 'raw_kf_compare_plot'

NUMERIC_DATA_DIRNAME: str = 'numeric_data'
VISUALIZED_DATA_DIRNAME: str = 'visualized_data'
MASTER_GNB_DATA_DIRNAME: str = 'master_gnb_data'
PINGPONG_RATE_DATA_DIRNAME: str = 'pingpong_rate_data'

# C++
OUTPUT_RAW_RSSI_DATA_FILENAME: str = '../raw_rssi_data.csv'


def safe_make_directory(directory_path: str) -> str:
    path = Path(directory_path)
    path.mkdir(parents=True, exist_ok=True)
    print(f"Directory '{directory_path}' is ready (created or already exists).")
    return path.__str__()


def get_save_dir(base_dir_name: str, save_dir_name: str) -> str:
    base_dir = os.path.join(os.path.dirname(
        os.path.dirname(__file__)), base_dir_name)

    safe_make_directory(base_dir)
    save_dir = os.path.join(base_dir, save_dir_name)
    safe_make_directory(save_dir)
    return save_dir


def get_load_dir(base_dir_name: str, load_dir_name: str) -> str:
    base_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), base_dir_name)
    load_dir = os.path.join(base_dir, load_dir_name)
    return load_dir
