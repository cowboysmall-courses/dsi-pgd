#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 15:50:22 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd
import statsmodels.api as sm

from scipy import stats



# %% 1 - Import data.
data = pd.read_csv("../../../data/0204_statistical_inference/intro_and_parametric_tests/Normality Testing Data.csv")

data.head()
#    id    csi  billamt
# 0   1  38.35    34.85
# 1   2  47.02    10.99
# 2   3  36.96    24.73
# 3   4  43.07     7.90
# 4   5  38.77     9.38

data.info()
# RangeIndex: 80 entries, 0 to 79
# Data columns (total 3 columns):
#  #   Column   Non-Null Count  Dtype  
# ---  ------   --------------  -----  
#  0   id       80 non-null     int64  
#  1   csi      80 non-null     float64
#  2   billamt  80 non-null     float64
# dtypes: float64(2), int64(1)
# memory usage: 2.0 KB

data.describe(include = 'all')
#             id        csi    billamt
# count  80.0000  80.000000  80.000000
# mean   40.5000  43.797875  13.316250
# std    23.2379   9.227251   5.923724
# min     1.0000  23.050000   5.300000
# 25%    20.7500  37.715000   9.060000
# 50%    40.5000  43.975000  11.550000
# 75%    60.2500  49.935000  16.797500
# max    80.0000  63.800000  34.850000



# %% 2 - test for normality - Q-Q Plot.
fig1 = sm.graphics.qqplot(data.csi, line = '45', fit = True)
fig2 = sm.graphics.qqplot(data.billamt, line = '45', fit = True)



# %% 3 - test for normality - Shapiro-Wilks Test.
stats.shapiro(data.csi)
# ShapiroResult(statistic=0.9919633269309998, pvalue=0.9037835597991943)
stats.shapiro(data.billamt)
# ShapiroResult(statistic=0.890307605266571, pvalue=4.858379270444857e-06)



# %% 3 - test for normality - Kolmogorov-Smirnof Test.
sm.stats.diagnostic.lilliefors(data.csi)
# (0.04238708824708459, 0.9859314950919987)
sm.stats.diagnostic.lilliefors(data.billamt)
# (0.1424429511673755, 0.0009999999999998899)
