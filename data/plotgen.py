#!/bin/python3

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Read the data
df = pd.read_csv('out.data.csv')

# Setting up the aesthetics
sns.set_style('whitegrid')
plt.figure(figsize=(14, 8))

# Plotting each rssi_* series
for i in range(1, 11):
    sns.lineplot(x=df['simTime'], y=df[f'rssi_{i}'], label=f'RSSI from ID {i}')

plt.title('RSSI values over time for different IDs')
plt.xlabel('Simulation Time')
plt.ylabel('RSSI Value')
plt.legend()
plt.tight_layout()

# Save the plot
plt.savefig('../doc/midterm-report/rssi_plot.png', dpi=300)  # dpi is for higher resolution
plt.show()

