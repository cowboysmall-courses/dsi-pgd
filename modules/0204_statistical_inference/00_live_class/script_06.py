#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 09:55:39 2023

@author: jerry
"""


# %%

import pandas as pd
import statsmodels.api as sm

from statsmodels.formula.api import ols



# %%

data = pd.read_csv("../../../data/0204_statistical_inference/analysis_of_variance/One way anova.csv")
data.info()



# %%

model = ols('satindex ~ C(dept)', data = data).fit()
sm.stats.anova_lm(model, type = 2)
