#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec 16 09:03:34 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from math import sqrt
from patsy import dmatrices
from statsmodels.formula.api import ols
from statsmodels.stats.outliers_influence import variance_inflation_factor



# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/live_class/Motor_Claims.csv")
data.head()
#    vehage    CC  Length  Weight  claimamt
# 0       4  1495    4250    1023   72000.0
# 1       2  1061    3495     875   72000.0
# 2       2  1405    3675     980   50400.0
# 3       7  1298    4090     930   39960.0
# 4       2  1495    4250    1023  106800.0



# %% 2 - construct a scatter plot matrix
sns.pairplot(data)
plt.title('Scatter Plot Matrix')



# %% 3 - build model
model = ols('claimamt ~ Length + CC + vehage + Weight', data = data).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:               claimamt   R-squared:                       0.738
# Model:                            OLS   Adj. R-squared:                  0.737
# Method:                 Least Squares   F-statistic:                     700.3
# Date:                Sat, 16 Dec 2023   Prob (F-statistic):          1.83e-287
# Time:                        09:20:13   Log-Likelihood:                -10754.
# No. Observations:                1000   AIC:                         2.152e+04
# Df Residuals:                     995   BIC:                         2.154e+04
# Df Model:                           4                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept  -5.477e+04   5569.375     -9.833      0.000   -6.57e+04   -4.38e+04
# Length        35.4607      1.990     17.824      0.000      31.557      39.365
# CC            15.4133      2.114      7.292      0.000      11.265      19.561
# vehage     -6637.2134    154.098    -43.071      0.000   -6939.607   -6334.820
# Weight       -16.2547      3.678     -4.420      0.000     -23.472      -9.038
# ==============================================================================
# Omnibus:                        7.335   Durbin-Watson:                   2.094
# Prob(Omnibus):                  0.026   Jarque-Bera (JB):                9.587
# Skew:                          -0.058   Prob(JB):                      0.00828
# Kurtosis:                       3.466   Cond. No.                     6.33e+04
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 6.33e+04. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 4 - split dependent and independent variables
y, X = dmatrices('claimamt ~ Length + CC + vehage + Weight', data = data, return_type = "dataframe")
X.head()
#    Intercept  Length      CC  vehage  Weight
# 0        1.0  4250.0  1495.0     4.0  1023.0
# 1        1.0  3495.0  1061.0     2.0   875.0
# 2        1.0  3675.0  1405.0     2.0   980.0
# 3        1.0  4090.0  1298.0     7.0   930.0
# 4        1.0  4250.0  1495.0     2.0  1023.0



# %% 5 - calculate vif for the independent variables
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    240.261728
# Length         3.396171
# CC             5.881428
# vehage         1.038357
# Weight         6.552811
# dtype: float64



# %% 6 - rebuild model
model = ols('claimamt ~ Length + CC + vehage', data = data).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:               claimamt   R-squared:                       0.733
# Model:                            OLS   Adj. R-squared:                  0.732
# Method:                 Least Squares   F-statistic:                     910.3
# Date:                Sat, 16 Dec 2023   Prob (F-statistic):          8.79e-285
# Time:                        09:27:09   Log-Likelihood:                -10764.
# No. Observations:                1000   AIC:                         2.154e+04
# Df Residuals:                     996   BIC:                         2.156e+04
# Df Model:                           3                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept   -4.92e+04   5475.151     -8.985      0.000   -5.99e+04   -3.85e+04
# Length        32.0652      1.852     17.312      0.000      28.431      35.700
# CC             8.6886      1.481      5.867      0.000       5.783      11.595
# vehage     -6638.0765    155.525    -42.682      0.000   -6943.270   -6332.883
# ==============================================================================
# Omnibus:                       10.930   Durbin-Watson:                   2.081
# Prob(Omnibus):                  0.004   Jarque-Bera (JB):               15.892
# Skew:                          -0.072   Prob(JB):                     0.000354
# Kurtosis:                       3.600   Cond. No.                     5.99e+04
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 5.99e+04. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 7 - split dependent and independent variables
y, X = dmatrices('claimamt ~ Length + CC + vehage', data = data, return_type = "dataframe")
X.head()
#    Intercept  Length      CC  vehage
# 0        1.0  4250.0  1495.0     4.0
# 1        1.0  3495.0  1061.0     2.0
# 2        1.0  3675.0  1405.0     2.0
# 3        1.0  4090.0  1298.0     7.0
# 4        1.0  4250.0  1495.0     2.0



# %% 8 - calculate vif for the independent variables
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    227.959103
# Length         2.889718
# CC             2.833931
# vehage         1.038355
# dtype: float64



# %% 9 - calculate RMSE
data = data.assign(resi = pd.Series(model.resid))
sqrt((data.resi ** 2).mean())
# 11444.512861029949
