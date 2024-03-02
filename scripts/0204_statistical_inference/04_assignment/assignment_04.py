#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 12 14:57:13 2023

@author: jerry

 BACKGROUND:
   The survey is conducted within a large organization to
   assess satisfaction level of employees in various
   functions. The satisfaction level is measured on 1-5
   scale where higher a number indicates more satisfaction.

"""


# %% 0 - Import libraries.

import pandas as pd
import numpy as np
import statsmodels.api as sm

from scipy import stats




# %% 1 - Import EMPLOYEE SATISFACTION SURVEY data. Check for
#     normality of the data.
data = pd.read_csv("./data/0204_statistical_inference/04_assignment/EMPLOYEE SATISFACTION SURVEY.csv")

data.head()
data.info()
data.describe(include = 'all')



fig = sm.qqplot(data.satlevel, line = '45', fit = True)

stats.shapiro(data.satlevel)
# ShapiroResult(statistic=0.8754845857620239, pvalue=6.048248542356305e-05)

# as p-value < 0.05, we reject the null hypothesis
# that the data was drawn from a normal distribution

sm.stats.diagnostic.lilliefors(data.satlevel, pvalmethod = 'approx')
# (0.24072017102693422, 4.681597733242897e-08)

# as p-value < 0.05, we reject the null hypothesis
# that the data was drawn from a normal distribution




# %% 2 - Find median satisfaction level for 'IT', 'Sales' and
#     'Finance'. Test whether the satisfaction level among
#     three roles differ significantly.
data_I = data[data['dept'] == 'IT']
data_S = data[data['dept'] == 'SALES']
data_F = data[data['dept'] == 'FINANCE']


data_I.satlevel.median()
# 3
data_S.satlevel.median()
# 3
data_F.satlevel.median()
# 4

# alternatively approach
data.groupby('dept')['satlevel'].agg(['median'])
data.groupby('dept')['satlevel'].median()


stats.kruskal(data_I.satlevel, data_S.satlevel, data_F.satlevel)
# KruskalResult(statistic=25.51305974929314, pvalue=2.8834303621370563e-06)

# since p < 0.05 we reject the null hypothesis that there is
# no significant difference between satisfaction levels and
# department




# %% 3 - Is there any association between satisfaction level
#     and experience level? Experience level is defined as
#     midlevel (greater than 2 years) and Junior (less than
#     or equal to 2 years).
data['explevel'] = np.where(data['exp'] <= 2, 'junior', 'midlevel')
data.head()

table = pd.crosstab(data.satlevel, data.explevel)
stats.chi2_contingency(table)

# Chi2ContingencyResult(statistic=1.7757787772780276, pvalue=0.6202198757608164, dof=3, expected_freq=array([[ 3.98076923,  5.01923077],
#        [ 9.28846154, 11.71153846],
#        [ 6.19230769,  7.80769231],
#        [ 3.53846154,  4.46153846]]))

# since p > 0.05 we fail to reject the null hypothesis that
# there is no association between satisfaction levels and
# experience level




# %% 4 - Find number of employees with satisfaction score
#     greater than 3 in each department
data_I[data_I.satlevel > 3].shape[0]
# 4
data_S[data_S.satlevel > 3].shape[0]
# 2
data_F[data_F.satlevel > 3].shape[0]
# 16

data[data.satlevel > 3].shape[0]
# 22 (4 + 2 + 16)

# alternative approach
data[data.satlevel > 3].groupby('dept')['satlevel'].agg(['count'])
data[data.satlevel > 3].groupby('dept')['satlevel'].count()
