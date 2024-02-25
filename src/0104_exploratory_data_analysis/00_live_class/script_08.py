#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 21 09:05:26 2023

@author: jerry
"""



# %%

import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import seaborn as sns




# %% 1 - import data, check top 6 rows...
vas_data = pd.read_csv("./data/0104_exploratory_data_analysis/live_class/VAS_DATA.csv")

# vas_data.info()
# vas_data.shape

vas_data.head(n = 6)
# vas_data.tail(n = 6)




# %% 2 - visualise baseline VAS score (VAS_before) by treatment group
plt.figure(figsize = (8, 6))

sns.set_style("darkgrid")
sns.set_context("paper")
sns.boxplot(x = 'Group', y = 'VAS_before', data = vas_data)

plt.xlabel('Group')
plt.ylabel('VAS_before')
plt.title('VAS_before by Group')

plt.show()




# %% 3 - summarise VAS_before by treatment group using appropriate measure of central tendency
vas_data_s = vas_data.groupby('Group')['VAS_before'].agg(['count', 'mean', 'median', 'std'])
vas_data_s = vas_data_s.rename(columns = {'count': 'Count', 'mean': 'Mean', 'median': 'Median', 'std': 'Std Dev'})
vas_data_s.round(2)

# vas_data_s = vas_data.groupby('Group')['VAS_before'].describe()[['count', 'mean', '50%', 'std']]
# vas_data_s = vas_data_s.rename(columns = {'count': 'Count', 'mean': 'Mean', '50%': 'Median', 'std': 'Std Dev'})
# vas_data_s.round(2)




# %% 4 - derive a new variable - change from baseline after 3 days of treatment
vas_data['Change'] = vas_data['VAS_before'] - vas_data['VAS_after']
vas_data.head()




# %% 5 - visualise the change by group
plt.figure(figsize = (8, 6))

sns.set_style("darkgrid")
sns.set_context("paper")
sns.boxplot(x = 'Group', y = 'Change', data = vas_data)

plt.xlabel('Group')
plt.ylabel('Change')
plt.title('Change by Group')

plt.show()




# %% 6 - derive a new variable indicating 20 point drop in VAS score from baseline
vas_data['Change_20'] = np.where(vas_data['Change'] > 20, 'Yes', 'No')
vas_data.head()




# %% 7 - obtain cross table of Change_20 with group
vas_data_c = pd.crosstab(vas_data['Change_20'], vas_data['Group'])
vas_data_c




# %% 8 - visualise the relationship between Change and VAS_before
plt.figure(figsize = (8, 6))

sns.set_style("darkgrid")
sns.set_context("paper")
# sns.scatterplot(x = 'Change', y = 'VAS_before', data = vas_data, s = 5)
sns.regplot(x = 'Change', y = 'VAS_before', data = vas_data, scatter_kws = {'s': 5})

plt.xlabel('Change')
plt.ylabel('VAS_before')
plt.title('Relationship between Change and VAS_before')

plt.show()




# %% 9 - obtain the correlation coefficient between Change and VAS_before
vas_data['VAS_before'].corr(vas_data['Change'])

np.corrcoef(vas_data['Change'], vas_data['VAS_before'])
