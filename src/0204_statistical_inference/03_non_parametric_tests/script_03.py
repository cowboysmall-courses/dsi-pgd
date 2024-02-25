#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 17:26:21 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy.stats import kruskal



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/non_parametric_tests/Kruskal Wallis Test.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Wilcoxon Signed Rank Test.
group1 = data[data.Group == 'GroupI']['aptscore']
group2 = data[data.Group == 'GroupII']['aptscore']
group3 = data[data.Group == 'GroupIII']['aptscore']

kruskal(group1, group2, group3)
# KruskalResult(statistic=2.230929090974231, pvalue=0.3277629827136111)
