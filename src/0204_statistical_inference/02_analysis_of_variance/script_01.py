#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:37:25 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd
import numpy as np

from scipy import stats



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/02_analysis_of_variance/F test for 2 variances.csv")

data.head()
data.describe(include = 'all')



# %% 2 - F-Test.
x = np.array(data.dropna().time_g1)
y = np.array(data.time_g2)

f = np.var(x, ddof = 1) / np.var(y, ddof = 1) #calculate F test statistic
p = 2 * (1 - stats.f.cdf(f, x.size - 1, y.size - 1))

print(f, p)
# 1.5434275971616587 0.4523632544892888
