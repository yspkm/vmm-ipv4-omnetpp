import os

import numpy as np
import pandas as pd

from src.common import KF_RSSI_DATA_BASE_DIRNAME, get_save_dir, get_load_dir, RAW_RSSI_DATA_BASE_DIRNAME
from src.kalman_filter import KalmanFilter


def apply_kalman_filter_to_ue_data(df: pd.DataFrame) -> pd.DataFrame:
    initial_state = np.array([[0], [0]])
    state_transition = np.array([[1, 1], [0, 1]])
    process_noise = np.array([[0.0050, 0], [0, 0.0050]])
    measurement_noise = 20
    measurement_function = np.array([[1, 0]])

    # 현재 ue 파일을 기준으로 각 gnb에 대해 칼만필터 인스턴스 생성
    kf_gnbs = {gnb: KalmanFilter(initial_state.copy(), state_transition, process_noise, measurement_noise,
                                 measurement_function)
               for gnb in range(1, 6)}

    # 필터링된 데이터 임시 저장
    kf_data = []

    for _, row in df.iterrows():
        sim_time = int(row['sim_time'])
        kf_row = [sim_time]

        for gnb in range(1, 6):
            # rssi = row[gnb] if pd.notna(row[gnb]) else None
            rssi = row[str(gnb)] if pd.notna(row[str(gnb)]) else None
            kf = kf_gnbs[gnb]

            if rssi is not None:
                kf.predict()
                kf.update(np.array([[rssi]]))
                filtered_rssi = kf.state[0, 0]
            else:
                filtered_rssi = np.nan  # Using NaN for missing data

            kf_row.append(filtered_rssi)

        kf_data.append(kf_row)

    # Convert the list of data into a DataFrame
    kf_df = pd.DataFrame(kf_data, columns=['sim_time'] + [str(gnb) for gnb in range(1, 6)])
    return kf_df


def load_ue_data(data_dir: str, ue: int) -> pd.DataFrame:
    filename = os.path.join(data_dir, f'ue_{ue}_data.csv')
    df = pd.read_csv(filename)
    return df


def save_kf_data(df: pd.DataFrame, data_dir: str, ue: int):
    filename = os.path.join(data_dir, f'ue_{ue}_data.csv')
    df.to_csv(filename, index=False)


def kf_preprocessing():
    data_dir = get_load_dir(RAW_RSSI_DATA_BASE_DIRNAME, 'numeric_data')
    kf_data_dir = get_save_dir(base_dir_name=KF_RSSI_DATA_BASE_DIRNAME, save_dir_name='numeric_data')
    ues = range(1, 11)

    for ue in ues:
        df_ue = load_ue_data(data_dir, ue)
        kf_data_by_ue = apply_kalman_filter_to_ue_data(df_ue)
        save_kf_data(kf_data_by_ue, kf_data_dir, ue)
