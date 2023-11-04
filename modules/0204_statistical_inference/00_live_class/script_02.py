#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  4 09:28:00 2023

@author: jerry
"""


import pandas as pd
import scipy as sp
import statsmodels.api as sm

import statistics as st
import math

from scipy.stats import ttest_1samp


data = pd.read_csv("../../../data/si/intro_and_parametric_tests/ONE SAMPLE t TEST.csv")
data.info()


n = len(data.Time)
m = st.mean(data.Time)
s = st.stdev(data.Time)
e = s / math.sqrt(n)
t = (m - 90) / e

print('       Sample Size: %d' % n)
print('              Mean: %.4f' % m)
print('Standard Deviation: %.4f' % s)
print('    Standard Error: %.4f' % e)
print('Test Statistic (t): %.4f' % t)


fig = sm.qqplot(data.Time, line = '45', fit = True)
sp.stats.shapiro(data.Time)


ttest_1samp(data.Time, popmean = 90, alternative = 'greater')

