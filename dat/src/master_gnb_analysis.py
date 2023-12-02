import os

import pandas as pd

from src.common import get_save_dir, get_load_dir, NUMERIC_DATA_DIRNAME, MASTER_GNB_DATA_DIRNAME


def extract_current_master(df: pd.DataFrame) -> pd.DataFrame:
    df['current_master'] = df[['1', '2', '3', '4', '5']].idxmax(axis=1)
    df['master_changed'] = df['current_master'] != df['current_master'].shift(1)
    master_change_df = df[df['master_changed']][['sim_time', 'current_master']]
    return master_change_df


def generate_ho_data(base_dir_name: str):
    data_dir = get_load_dir(base_dir_name=base_dir_name, load_dir_name=NUMERIC_DATA_DIRNAME)
    master_gnb_dir = get_save_dir(base_dir_name=base_dir_name, save_dir_name=MASTER_GNB_DATA_DIRNAME)

    for csv_fiile in os.listdir(data_dir):
        if csv_fiile.endswith('_data.csv'):
            df = pd.read_csv(os.path.join(data_dir, csv_fiile))
            extract_current_master(df=df) \
                .to_csv(os.path.join(master_gnb_dir, csv_fiile), index=False)
