#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:24:48 2023

@author: jerry
"""

# %% 0 - Import libraries.

import pandas as pd

from scipy import stats



# %% 1 - Import data.
data = pd.read_csv("../../../data/0204_statistical_inference/intro_and_parametric_tests/PAIRED t TEST.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Paired Sample t-Test.
stats.ttest_rel(data.time_before, data.time_after, alternative = 'greater')
# TtestResult(statistic=8.22948711672449, pvalue=4.918935850301797e-07, df=14)
