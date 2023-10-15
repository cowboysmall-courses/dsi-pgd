#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 14:16:25 2023

@author: jerry
"""


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import calendar


temp_data = pd.read_csv("../../../data/eda/data_visualisation/Average Temperatures in NY.csv")
temp_data.info()


temp_agg = pd.pivot_table(temp_data, index = ['Month '], columns = ['Year '])
temp_agg.columns = temp_data['Year '].unique()
temp_agg = temp_agg.reindex(calendar.month_abbr)


ax = sns.heatmap(temp_agg)
ax.set(title = 'Heatmap', xlabel = 'Year', ylabel = 'Age Group')
