#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  3 12:42:56 2023

Jerry Kiely
Data Science Institute
Descriptive Statistics in Python
EDA T10 Assignment

@author: jerry
"""


import pandas as pd
import seaborn as sns




# %% 1 - Import Premium and Claim data and merge both data sets into one data
Premium = pd.read_csv("./data/0104_exploratory_data_analysis/06_assignment/Premiums.csv")
Claim = pd.read_csv("./data/0104_exploratory_data_analysis/06_assignment/Claims.csv")

Premium_join = pd.merge(Premium, Claim, how = 'outer')
Premium_join.info()
# <class 'pandas.core.frame.DataFrame'>
# Int64Index: 4744 entries, 0 to 4743
# Data columns (total 11 columns):
#  #   Column          Non-Null Count  Dtype  
# ---  ------          --------------  -----  
#  0   POLICY_NO       4744 non-null   object 
#  1   PRODUCT         4744 non-null   object 
#  2   BRANCH_NAME     4744 non-null   object 
#  3   REGION          4744 non-null   object 
#  4   ZONE_NAME       4744 non-null   object 
#  5   Plan            4744 non-null   object 
#  6   Sum_Assured     4744 non-null   float64
#  7   Premium         4744 non-null   float64
#  8   Sub_Plan        4744 non-null   object 
#  9   Vintage_Period  4744 non-null   int64  
#  10  Claim_Status    4744 non-null   object 
# dtypes: float64(2), int64(1), object(8)
# memory usage: 444.8+ KB




# %% 2 - For each zone, obtain the mean Premium and plot a bar chart showing the mean Premium over zone
Premium_means = Premium_join.groupby('ZONE_NAME')['Premium'].mean()
Premium_means
# ZONE_NAME
# East      990.203468
# North    1238.206659
# South    1083.202966
# Name: Premium, dtype: float64

Premium_means.plot.bar(title = 'Bar Chart - Mean Premiums by Zone', xlabel = 'Zone', ylabel = 'Mean Premiums')




# %% 3 - Obtain a stacked bar chart for all the Zones over Sub plans by the Premium amount
Premium_pt = pd.pivot_table(Premium_join, index = ['Sub_Plan'], columns = ['ZONE_NAME'], values = ['Premium'], aggfunc = 'count')
Premium_pt
#           Premium            
# ZONE_NAME    East North South
# Sub_Plan                     
# Gold            9   400   463
# Platinum       14   139   236
# Silver         37   537   747
# Standard       39   935  1188

Premium_pt.plot.bar(title = 'Stacked Bar Chart - Zone over Sub Plan', stacked = True, xlabel = 'Sub Plan', ylabel = 'Premium Counts')




# %% 4 - Obtain a heat map of Plan and Zone with respective average Premium
Premium_hm1 = pd.pivot_table(Premium_join, index = ['Plan'], columns = ['ZONE_NAME'], values = ['Premium'])
Premium_hm1.columns = Premium_join['ZONE_NAME'].unique()
Premium_hm1 = Premium_hm1.reindex(Premium_join['Plan'].unique())
Premium_hm1
#                           South        North         East
# Plan                                                     
# Asia Silver Plan     436.000000   363.714286   431.985075
# Asia Standard Plan   322.666667   306.111111   403.500000
# Individual          1315.690000          NaN   498.000000
# Family  Gold Plan   1246.000000  2679.369565  1851.535714
# Family  Standard P   973.333333  2573.407407  1395.108696
# Individual  Standa   991.107917  1057.574879  1029.293929
# Individual  Platin   923.428571  1624.039185  1394.853951
# Individual  Silver  1023.767857  1186.489382  1017.105695
# Individual  Gold P  1793.437500  1403.621018  1270.958715
# Schengen                    NaN          NaN   563.316667

ax = sns.heatmap(Premium_hm1)
ax.set(title = 'Heatmap', xlabel = 'Zone', ylabel = 'Plan')



Premium_hm2 = pd.pivot_table(Premium_join, index = ['ZONE_NAME'], columns = ['Plan'], values = ['Premium'])
Premium_hm2.columns = Premium_join['Plan'].unique()
Premium_hm2 = Premium_hm2.reindex(Premium_join['ZONE_NAME'].unique())
Premium_hm2
#            Asia Silver Plan  Asia Standard Plan  ...  Individual  Gold P    Schengen
# ZONE_NAME                                        ...                                
# South            431.985075          403.500000  ...         1029.293929  563.316667
# North            363.714286          306.111111  ...         1057.574879         NaN
# East             436.000000          322.666667  ...          991.107917         NaN

# [3 rows x 10 columns]

ax = sns.heatmap(Premium_hm2)
ax.set(title = 'Heatmap', xlabel = 'Plan', ylabel = 'Zone')




# %% 5 - Obtain a pie chart for Premium amount across different sub plans
Premium_cts = Premium_join.groupby('Sub_Plan')['Premium'].count()
Premium_cts
# Sub_Plan
# Gold         872
# Platinum     389
# Silver      1321
# Standard    2162
# Name: Premium, dtype: int64

Premium_cts.plot.pie(title = 'Pie Chart', label = 'Sub Plans')
