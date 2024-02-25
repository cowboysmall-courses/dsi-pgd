#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 17:33:42 2023

@author: jerry
"""


# %% 0 - Import libraries.

import pandas as pd

from scipy.stats import chi2_contingency



# %% 1 - Import data.
data = pd.read_csv("./data/0204_statistical_inference/non_parametric_tests/chi square test of association.csv")

data.head()
data.describe(include = 'all')



# %% 2 - Wilcoxon Signed Rank Test.
chi2_contingency(pd.crosstab(data.performance, data.source))
# Chi2ContingencyResult(statistic=107.37856396477088, 
#        pvalue=2.6359873347121296e-22, 
#        dof=4, 
#        expected_freq=array([[110.        ,  83.33333333,  96.66666667],
#        [113.79310345,  86.20689655, 100.        ],
#        [106.20689655,  80.45977011,  93.33333333]]))
