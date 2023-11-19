#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 14:28:10 2023

@author: jerry
"""


# %%

import pandas as pd
import matplotlib.pyplot as plt



# %%

telco_data = pd.read_csv("../../../data/eda/data_visualisation/TelecomData_WeeklyData.csv")
telco_data.info()



# %%

telco_trend = telco_data.groupby('Week')['Calls'].sum().to_frame().reset_index()

plt.figure()
plt.plot(telco_trend['Calls'], marker = 'o')
plt.title('Trend Line')
plt.xlabel('Week')
plt.ylabel('No. of Calls')
