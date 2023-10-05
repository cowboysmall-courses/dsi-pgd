#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 13:16:16 2023

@author: jerry
"""


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


telecom_data = pd.read_csv("../../../data/data_visualisation/telecom.csv")
telecom_data.info()


plt.figure()
telecom_data.Calls.plot.box(label = 'Calls')
plt.title('Box Plot - Calls')
# plt.ylabel('Total Calls')


plt.figure()
telecom_data.boxplot(column = 'Calls', by = 'Age_Group', grid = False, patch_artist = True)
plt.title('Box Plot - Calls by Age Group')
plt.suptitle('')
# plt.ylabel('Total Calls')


plt.figure()
telecom_data.AvgTime.hist(bins = 12, grid = False, color = 'darkorange')
plt.title('Histogram - Average Call Time')
plt.ylabel('No. of Customers')


plt.figure()
telecom_data.Amt.plot.kde()
plt.title('Density - Amount')
plt.xlabel('Amount')


plt.figure()
plt.stem(telecom_data.Calls)
plt.title('Stem - Calls')
plt.xlabel('CustID')
plt.ylabel('Total Calls')


plt.figure()
plt.stem(telecom_data.Calls.sample(frac = 0.05))
plt.title('Stem - Calls')
plt.xlabel('CustID')
plt.ylabel('Total Calls')
