#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:45:11 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd
import statsmodels.api as sm

from statsmodels.formula.api import ols



# %% 1 - Import data.
data = pd.read_csv("../../../data/0204_statistical_inference/analysis_of_variance/One way anova.csv")

data.head()
data.describe(include = 'all')



# %% 2 - One way ANOVA.
model = ols('satindex ~ C(dept)', data = data).fit()
sm.stats.anova_lm(model)
#             df       sum_sq     mean_sq         F    PR(>F)
# C(dept)    2.0   220.059945  110.029972  2.308047  0.114836
# Residual  34.0  1620.858974   47.672323       NaN       NaN
