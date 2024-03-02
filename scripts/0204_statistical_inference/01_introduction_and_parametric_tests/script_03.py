#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:16:57 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy import stats



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/INDEPENDENT SAMPLES t TEST.csv")

data.head()
data.describe(include = 'all')




# %% 2 - Indepndent Samples t-Test.
stats.ttest_ind(data.time_g1, data.time_g2, nan_policy = 'omit', equal_var = True)
# TtestResult(statistic=0.22345590920212569, pvalue=0.8250717960964379, df=24.0)


stats.ttest_ind(data.time_g1, data.time_g2, nan_policy = 'omit', equal_var = False)
# TtestResult(statistic=0.21965992515741178, pvalue=0.8282468548302411, df=21.10307990872962)
