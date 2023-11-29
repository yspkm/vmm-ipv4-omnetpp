# Correctly handling the data as per the user's request.
# We will create a CSV file for each UE with a fixed header.
# Each row will correspond to a 'Simtime' and have RSSI values for gNb=1 to gNb=5, in that order.
import pandas as pd
import csv
import os

# Read the raw data from the CSV file
df_raw = pd.read_csv('./raw.data.csv', header=None)
df_raw.columns = ['Simtime', 'UE', 'gNb', 'RSSI']

# Initialize an empty dictionary to store the data
data_by_ue = {}

# Get a list of all unique UEs and simtimes
ues = df_raw['UE'].unique()
simtimes = df_raw['Simtime'].unique()

# Initialize the data structure with empty lists
for ue in ues:
    data_by_ue[ue] = {simtime: {gnb: None for gnb in range(1, 6)} for simtime in simtimes}

# Populate the dictionary with RSSI values
for _, row in df_raw.iterrows():
    ue = row['UE']
    simtime = row['Simtime']
    gnb = row['gNb']
    rssi = row['RSSI']
    
    data_by_ue[ue][simtime][gnb] = rssi

# Now create a CSV file for each UE
for ue, simtime_data in data_by_ue.items():
    # Define the CSV filename
    filename = f'./ue_{ue}_data.csv'
    
    # Open the file for writing
    with open(filename, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        
        # Write the header
        header = ['Simtime (second)']
        for gnb in range(1, 6):
            header.extend([f'gNb', 'RSSI'])
        csvwriter.writerow(header)

        # Write the data rows
        for simtime, gnbs in simtime_data.items():
            row = [simtime]
            for gnb in range(1, 6):
                rssi = gnbs[gnb] if gnbs[gnb] is not None else ''
                row.extend([gnb, rssi])
            csvwriter.writerow(row)

# List the created files
created_files = [f'ue_{ue}_data.csv' for ue in ues]
created_files_paths = [os.path.join('./', file) for file in created_files]
print(created_files_paths)
