#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:27:40 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy import stats



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/intro_and_parametric_tests/Correlation test.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Paired Sample t-Test.
stats.pearsonr(data.aptitude, data.job_prof)
# PearsonRResult(statistic=0.5144106946654771, pvalue=0.008517216152487185)
