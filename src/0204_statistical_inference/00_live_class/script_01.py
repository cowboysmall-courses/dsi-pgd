#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  4 09:05:12 2023

@author: jerry
"""


# %%

import pandas as pd
import statsmodels.api as sm

from scipy import stats



# %%

data = pd.read_csv("../../../data/0204_statistical_inference/intro_and_parametric_tests/Normality Testing Data.csv")
data.info()



# %%

fig = sm.qqplot(data.csi, line = '45', fit = True)
fig = sm.qqplot(data.billamt, line = '45', fit = True)



# %%

stats.shapiro(data.csi)
stats.shapiro(data.billamt)


# t = stats.shapiro(data.csi)
# t.statistic
# t.pvalue

# t = stats.shapiro(data.billamt)
# t.statistic
# t.pvalue



# %%

stats.ttest_1samp(data.csi, popmean = 40, alternative = 'two-sided')
# 'two-sided' is the default alternative
stats.ttest_1samp(data.csi, popmean = 40)


# st.mean(data.csi)
# stats.ttest_1samp(data.csi, popmean = 43.5)


# m = st.mean(data.csi)
# stats.ttest_1samp(data.csi, popmean = m)
