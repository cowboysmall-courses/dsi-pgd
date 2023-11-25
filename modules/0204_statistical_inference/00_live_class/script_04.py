#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 09:35:09 2023

@author: jerry
"""


# %%

import pandas as pd
import statsmodels.api as sm

from scipy import stats



# %%

data = pd.read_csv("../../../data/0204_statistical_inference/intro_and_parametric_tests/PAIRED t TEST.csv")
data.info()



# %%

fig = sm.qqplot(data['time_before'] - data['time_after'], line = '45', fit = True)
stats.shapiro(data['time_before'] - data['time_after'])



# %%

stats.ttest_rel(data['time_before'], data['time_after'], alternative = 'greater')
