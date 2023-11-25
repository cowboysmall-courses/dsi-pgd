#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 09:07:12 2023

@author: jerry
"""


# %%

import pandas as pd
import statsmodels.api as sm

from scipy import stats



# %%

data = pd.read_csv("../../../data/0204_statistical_inference/intro_and_parametric_tests/INDEPENDENT SAMPLES t TEST.csv")
data.info()



# %%

fig = sm.qqplot(data.dropna().time_g1, line = '45', fit = True)
stats.shapiro(data.dropna().time_g1)



# %%

fig = sm.qqplot(data.time_g2, line = '45', fit = True)
stats.shapiro(data.time_g2)



# %%

stats.ttest_ind(data['time_g1'], data['time_g2'], nan_policy = 'omit', equal_var = True)
