#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:07:41 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy import stats



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/ONE SAMPLE t TEST.csv")

data.head()
data.describe(include = 'all')




# %% 2 - One Sample t-Test.
stats.ttest_1samp(data.Time, popmean = 90, alternative = 'greater')
# TtestResult(statistic=1.9176218472595046, pvalue=0.04074043079962237, df=11)
