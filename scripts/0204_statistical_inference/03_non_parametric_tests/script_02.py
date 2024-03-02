#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 17:21:17 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy.stats import wilcoxon



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/03_non_parametric_tests/Wilcoxon Signed Rank test for paired data.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Wilcoxon Signed Rank Test.
wilcoxon(data.Before, data.After, alternative = 'less')
# WilcoxonResult(statistic=4.0, pvalue=0.001708984375)
