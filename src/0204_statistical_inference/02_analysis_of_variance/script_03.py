#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 16:59:39 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd
import statsmodels.api as sm

from statsmodels.formula.api import ols



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/analysis_of_variance/Two way anova.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Two way ANOVA.
model = ols('satindex ~ C(dept) + C(exp) + C(dept):C(exp)', data = data).fit()
sm.stats.anova_lm(model, typ = 2)
#                      sum_sq    df         F    PR(>F)
# C(dept)          164.222222   2.0  1.678973  0.203624
# C(exp)            78.027778   1.0  1.595479  0.216274
# C(dept):C(exp)    20.222222   2.0  0.206748  0.814374
# Residual        1467.166667  30.0       NaN       NaN
