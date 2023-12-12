#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 17:16:05 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy.stats import mannwhitneyu



# %% 1 - Import data.
data = pd.read_csv("../../../data/0204_statistical_inference/non_parametric_tests/Mann Whitney test.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Mann-Whitney Test.
group1 = data[data.Group == 'G1']['aptscore']
group2 = data[data.Group == 'G2']['aptscore']

mannwhitneyu(group1, group2, alternative = 'two-sided')
# MannwhitneyuResult(statistic=18.0, pvalue=0.7307692307692307)
