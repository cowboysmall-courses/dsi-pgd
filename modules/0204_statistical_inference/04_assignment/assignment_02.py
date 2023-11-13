#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 12 14:56:48 2023

@author: jerry

 BACKGROUND:
   A new marketing campaign was tested in 12 randomly 
   selected stores of a large retail group. Usual campaign 
   was run in another 12 randomly selected stores during 
   the same month. The outcome variable is "Sales Growth". 

"""

import pandas as pd
import statsmodels.api as sm

from scipy import stats
from statsmodels.formula.api import ols




# 0 - read the data and test for normality
data = pd.read_csv("./assignment_02.csv")

data.head()
data.info()
data.describe(include = 'all')


stats.shapiro(data.Growth)

# ShapiroResult(statistic=0.926858127117157, pvalue=0.0829453244805336)

sm.stats.diagnostic.lilliefors(data.Growth)

# (0.13331963074112557, 0.33251566968178153)

# in both tests the p-value > 0.05, and hence 
# the data looks to have been drawn from a
# normal distribution




# 1 - test the effect of campaign on growth
model = ols('Growth ~ C(Campaign)', data = data).fit()
sm.stats.anova_lm(model)

#                df     sum_sq    mean_sq         F    PR(>F)
# C(Campaign)   1.0  17.681667  17.681667  7.768798  0.010742
# Residual     22.0  50.071667   2.275985       NaN       NaN

# as p-value < 0.05 we reject the null 
# hypothesis - there does seem to be a 
# significant difference between growth 
# across the different campaigns 




# 2 - test the effect of zone on growth
model = ols('Growth ~ C(Zone)', data = data).fit()
sm.stats.anova_lm(model)

#             df     sum_sq   mean_sq         F    PR(>F)
# C(Zone)    2.0   7.735833  3.867917  1.353376  0.279992
# Residual  21.0  60.017500  2.857976       NaN       NaN

# as p-value > 0.05 we fail to reject 
# the null hypothesis - there does not 
# seem to be significant difference 
# between growth across the different 
# zones 

# zone alone does not appear to be significant, 
# but lets see if it is significant when combined 
# with campaign 


# 3 - test the effect of the interaction of campaign and zone on growth
model = ols('Growth ~ C(Campaign) + C(Zone) + C(Campaign):C(Zone)', data = data).fit()
sm.stats.anova_lm(model)

#                        df     sum_sq    mean_sq         F    PR(>F)
# C(Campaign)           1.0  17.681667  17.681667  8.407608  0.009554
# C(Zone)               2.0   7.735833   3.867917  1.839189  0.187591
# C(Campaign):C(Zone)   2.0   4.480833   2.240417  1.065315  0.365373
# Residual             18.0  37.855000   2.103056       NaN       NaN

# neither zone, nor the interaction effect 
# of zone with campaign appear to be 
# significant
