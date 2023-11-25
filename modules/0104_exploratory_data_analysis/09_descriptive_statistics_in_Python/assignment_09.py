#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  3 12:42:56 2023

Jerry Kiely
Data Science Institute
Descriptive Statistics in Python
EDA T9 Assignment

@author: jerry
"""



# %%

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt




# %% 1 - Import Premiums data.
Premium = pd.read_csv("../../../data/0104_exploratory_data_analysis/assignment/Premiums.csv")

Premium.head()
#          POLICY_NO PRODUCT BRANCH_NAME  ... Premium  Sub_Plan Vintage_Period
# 0  A-2007073196522  TRAVEL        Pune  ...   525.0    Silver             14
# 1  A-2007080402998  TRAVEL       Anand  ...   325.0    Silver             30
# 2  A-2007081314381  TRAVEL  Chennai II  ...   300.0  Standard              4
# 3  A-2007082123389  TRAVEL      Baroda  ...   300.0  Standard             30
# 4  A-2007082123394  TRAVEL      Baroda  ...   300.0  Standard             30

# [5 rows x 10 columns]

Premium.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 4744 entries, 0 to 4743
# Data columns (total 10 columns):
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
# dtypes: float64(2), int64(1), object(7)
# memory usage: 370.8+ KB

Premium.describe(include = 'all')
#               POLICY_NO PRODUCT  ...  Sub_Plan Vintage_Period
# count              4744    4744  ...      4744    4744.000000
# unique             4744       1  ...         4            NaN
# top     A-2007073196522  TRAVEL  ...  Standard            NaN
# freq                  1    4744  ...      2162            NaN
# mean                NaN     NaN  ...       NaN      49.103288
# std                 NaN     NaN  ...       NaN      80.413759
# min                 NaN     NaN  ...       NaN       0.000000
# 25%                 NaN     NaN  ...       NaN       9.000000
# 50%                 NaN     NaN  ...       NaN      17.000000
# 75%                 NaN     NaN  ...       NaN      42.000000
# max                 NaN     NaN  ...       NaN     733.000000

# [11 rows x 10 columns]




# %% 2 - Obtain the Mode(max count) for the count of policies available across each Zone.
Premium['ZONE_NAME'].value_counts()
# South    2634
# North    2011
# East       99
# Name: ZONE_NAME, dtype: int64

# The mode is 'South' with frequency / count 2634




# %% 3 - Obtain box-whisker plots for Vintage period. Detect outliers if present.
Premium['Vintage_Period'].plot.box(label = 'Vintage Period', title = 'Box Plot')

Premium_Q1 = Premium['Vintage_Period'].quantile(0.25)
Premium_Q3 = Premium['Vintage_Period'].quantile(0.75)
Premium_IQR = Premium_Q3 - Premium_Q1

Premium_oup = Premium['Vintage_Period'][Premium['Vintage_Period'] > (Premium_Q3 + (1.5 * Premium_IQR))]
Premium_oup
# 5       446
# 174     365
# 180     182
# 181     365
# 184     180

# 4710    168
# 4721    365
# 4722    233
# 4731    337
# 4743    365
# Name: Vintage_Period, Length: 569, dtype: int64

Premium_oup.count()
# 569

# 569 outliers in the upper range


Premium_odn = Premium['Vintage_Period'][Premium['Vintage_Period'] < (Premium_Q1 - (1.5 * Premium_IQR))]
Premium_odn
# Series([], Name: Vintage_Period, dtype: int64)

Premium_odn.count()
# 0

# 0 outliers in the lower range




# %% 4 - Find skewness and kurtosis of Premium amount by Zone
Premium.groupby('ZONE_NAME')['Premium'].skew()
Premium.groupby('ZONE_NAME')['Premium'].apply(pd.DataFrame.kurt)




# %% 5 - Draw a scatter plot of Premium and Vintage period. Find the correlation coefficient between Premium and Vintage period and interpret the value.
plt.scatter(Premium['Premium'], Premium['Vintage_Period'], color = 'red')
plt.xlabel('Premium')
plt.ylabel('Vintage Period')

np.corrcoef(Premium['Premium'], Premium['Vintage_Period'])

# The Correlation Coefficient of 0.36414866 is greater than zero, and hence implies a 
# positive correlation, but the value is low, and hence would imply a low correlation.
