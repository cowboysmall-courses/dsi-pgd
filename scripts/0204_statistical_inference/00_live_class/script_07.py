#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 10:04:46 2023

@author: jerry
"""


# %%

import pandas as pd
import statsmodels.api as sm

from statsmodels.formula.api import ols



# %%

data = pd.read_csv("./data/0204_statistical_inference/02_analysis_of_variance/Two way anova.csv")
data.info()



# %%

model = ols('satindex ~ C(dept) + C(exp) + C(dept):C(exp)', data = data).fit()
sm.stats.anova_lm(model, type = 2)
sm.stats.anova_lm(model)
