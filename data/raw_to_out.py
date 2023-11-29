#!/bin/python3

import pandas as pd
import shutil
import os

def load_and_process_data(input_fname, backup_input_fname, transformed_fname):
    shutil.copy(input_fname, backup_input_fname)
    data = pd.read_csv(input_fname, header=None, names=["simTime", "id", "rssi"])
    os.remove(input_fname)

    num_groups = len(data) // 10
    new_simTime_values = [round(0.2 * i, 1) for i in range(num_groups) for _ in range(10)]
    data['simTime'] = new_simTime_values

    result_dict = {}
    for index, row in data.iterrows():
        time = row["simTime"]
        if time not in result_dict:
            result_dict[time] = {"simTime": time}
        result_dict[time][f"id_{int(row['id'])}"] = row["id"]
        result_dict[time][f"rssi_{int(row['id'])}"] = row["rssi"]

    df_result = pd.DataFrame.from_dict(result_dict, orient="index").sort_values(by="simTime")

    columns = ["simTime"] + [item for sublist in [[f"id_{i}", f"rssi_{i}"] for i in range(1, 11)] for item in sublist]
    df_result = df_result[columns]

    df_result.to_csv(transformed_fname, index=False)

if __name__ == '__main__':
    input_fname = 'raw.data.csv'
    backup_input_fname = 'old' + '.' + input_fname
    transformed_fname = 'out.data.csv'
    
    load_and_process_data(input_fname, backup_input_fname, transformed_fname)

