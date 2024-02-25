#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec 16 10:05:19 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/live_class/Motor_Claims.csv")
data.head()
#    vehage    CC  Length  Weight  claimamt
# 0       4  1495    4250    1023   72000.0
# 1       2  1061    3495     875   72000.0
# 2       2  1405    3675     980   50400.0
# 3       7  1298    4090     930   39960.0
# 4       2  1495    4250    1023  106800.0


# %% 2 - train test split
train, test = train_test_split(data, test_size = 0.2, random_state = 0)
train.shape
# (800, 5)
test.shape
# (200, 5)



# %% 3 - build the model
model = ols('claimamt ~ Length + CC + vehage', data = train).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:               claimamt   R-squared:                       0.730
# Model:                            OLS   Adj. R-squared:                  0.729
# Method:                 Least Squares   F-statistic:                     716.5
# Date:                Sat, 16 Dec 2023   Prob (F-statistic):          1.34e-225
# Time:                        09:53:07   Log-Likelihood:                -8620.0
# No. Observations:                 800   AIC:                         1.725e+04
# Df Residuals:                     796   BIC:                         1.727e+04
# Df Model:                           3                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept  -4.608e+04   6239.652     -7.386      0.000   -5.83e+04   -3.38e+04
# Length        30.9228      2.104     14.695      0.000      26.792      35.053
# CC             9.5299      1.631      5.842      0.000       6.328      12.732
# vehage     -6576.4510    175.484    -37.476      0.000   -6920.918   -6231.984
# ==============================================================================
# Omnibus:                        6.769   Durbin-Watson:                   2.031
# Prob(Omnibus):                  0.034   Jarque-Bera (JB):                9.269
# Skew:                          -0.013   Prob(JB):                      0.00971
# Kurtosis:                       3.527   Cond. No.                     6.04e+04
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 6.04e+04. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 4 - 
train = train.assign(pred = pd.Series(model.fittedvalues))
train = train.assign(resi = pd.Series(model.resid))
train.head()
#      vehage    CC  Length  Weight   claimamt          pred          resi
# 687       4  1405    3675     980  60000.000  54640.314351   5359.685649
# 500       3  1527    3495     875  59279.904  56813.309190   2466.594810
# 332       3  2609    4325    1880  69599.952  92790.604221 -23190.652221
# 979       5   796    3335     665  24000.000  31746.392441  -7746.392441
# 817       1  1405    3675     980  74095.680  74369.667214   -273.987214



# %% 5 - RMSE for the training data
np.sqrt((train.resi ** 2).mean())
# 0    11569.182885388027
# dtype: float64



# %% 6 - 
test = test.assign(pred = pd.Series(model.predict(test)))
test = test.assign(resi = pd.Series(test.claimamt - test.pred))
test.head()
#      vehage    CC  Length  Weight  claimamt          pred          resi
# 993       3   796    3335     665  30240.00  44899.294350 -14659.294350
# 859       1  1086    3565     854  72791.76  67928.116470   4863.643530
# 298       5  1343    4420    1100  50400.00  70510.500532 -20110.500532
# 553       6  1405    3675     980  28800.00  41487.412443 -12687.412443
# 672       1  1405    3675     980  90960.00  74369.667214  16590.332786



# %% 7 - RMSE for the test data
np.sqrt((test.resi ** 2).mean())
# 0    10949.77556791181
# dtype: float64
