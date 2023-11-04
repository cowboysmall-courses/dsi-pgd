#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  4 09:05:12 2023

@author: jerry
"""


import pandas as pd
import scipy as sp
import statsmodels.api as sm

import statistics as st

from scipy.stats import ttest_1samp


data = pd.read_csv("../../../data/si/intro_and_parametric_tests/Normality Testing Data.csv")
data.info()


fig = sm.qqplot(data.csi, line = '45', fit = True)
fig = sm.qqplot(data.billamt, line = '45', fit = True)


sp.stats.shapiro(data.csi)
sp.stats.shapiro(data.billamt)


ttest_1samp(data.csi, popmean = 40, alternative = 'two-sided')
ttest_1samp(data.csi, popmean = 40)


st.mean(data.csi)
ttest_1samp(data.csi, popmean = 43.5)


m = st.mean(data.csi)
ttest_1samp(data.csi, popmean = m)

