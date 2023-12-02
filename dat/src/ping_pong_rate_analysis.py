import os

import pandas as pd

from src.common import MASTER_GNB_DATA_DIRNAME, PINGPONG_RATE_DATA_DIRNAME, get_load_dir, get_save_dir


def calculate_ping_pong_rates(file_path):
    df = pd.read_csv(file_path)
    total_handovers = len(df) - 1

    results = []

    for threshold in range(1, 61):
        df['previous_master'] = df['current_master'].shift(1)
        df['time_since_last_handover'] = df['sim_time'] - df['sim_time'].shift(1)
        df['is_ping_pong'] = ((df['current_master'] == df['previous_master'].shift(1)) &
                              (df['time_since_last_handover'] <= threshold))

        ping_pong_events = df['is_ping_pong'].sum()
        ping_pong_rate = (ping_pong_events / total_handovers) * 100 if total_handovers > 0 else 0
        results.append([threshold, ping_pong_rate])

    return results


def generate_ppr_data(base_dir_name: str):
    # Base directory

    data_dir = get_load_dir(base_dir_name=base_dir_name, load_dir_name=MASTER_GNB_DATA_DIRNAME)
    output_dir = get_save_dir(base_dir_name=base_dir_name, save_dir_name=PINGPONG_RATE_DATA_DIRNAME)

    # Process each file in the data directory
    for filename in os.listdir(data_dir):
        if filename.startswith("ue_") and filename.endswith(".csv"):
            file_path = os.path.join(data_dir, filename)
            results = calculate_ping_pong_rates(file_path)

            # Convert results to DataFrame and save to CSV
            results_df = pd.DataFrame(results, columns=['threshold', 'ping_pong_rate'])
            output_file_path = os.path.join(output_dir, filename)
            results_df.to_csv(output_file_path, index=False, float_format='%.2f%%')
            print(f"Processed {filename}")
