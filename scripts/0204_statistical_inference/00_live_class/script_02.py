#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  4 09:28:00 2023

@author: jerry
"""


# %%

import pandas as pd
import statsmodels.api as sm
import statistics as st
import math

from scipy import stats



# %%

data = pd.read_csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/ONE SAMPLE t TEST.csv")
data.info()



# %%

fig = sm.qqplot(data.Time, line = '45', fit = True)
stats.shapiro(data.Time)



# %%

n = len(data.Time)
m = st.mean(data.Time)
s = st.stdev(data.Time)
e = s / math.sqrt(n)
t = (m - 90) / e
p = 1 - stats.t.cdf(t, df = n - 1)

print(f'       Sample Size: {n:5d}')
print(f'              Mean: {m:>10.4f}')
print(f'Standard Deviation: {s:>10.4f}')
print(f'    Standard Error: {e:>10.4f}')
print(f'Test Statistic (t): {t:>10.4f}')
print(f'           p-value: {p:>10.4f}')



# %%

stats.ttest_1samp(data.Time, popmean = 90, alternative = 'greater')
