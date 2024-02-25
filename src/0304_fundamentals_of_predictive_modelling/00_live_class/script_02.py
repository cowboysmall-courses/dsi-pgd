#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec  9 09:01:23 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import statsmodels.api as sm

from patsy import dmatrices
from scipy import stats
from statsmodels.formula.api import ols
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.stats.diagnostic import lilliefors



# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()
#    empid    jpi  aptitude    tol  technical  general
# 0      1  45.52     43.83  55.92      51.82    43.58
# 1      2  40.10     32.71  32.56      51.49    51.03
# 2      3  50.61     56.64  54.84      52.29    52.47
# 3      4  38.97     51.53  59.69      47.48    47.69
# 4      5  41.87     51.35  51.50      47.59    45.77



# %% 2 - build model
model = ols('jpi ~ aptitude + tol + technical + general', data = data).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                    jpi   R-squared:                       0.877
# Model:                            OLS   Adj. R-squared:                  0.859
# Method:                 Least Squares   F-statistic:                     49.81
# Date:                Sat, 09 Dec 2023   Prob (F-statistic):           2.47e-12
# Time:                        09:51:45   Log-Likelihood:                -85.916
# No. Observations:                  33   AIC:                             181.8
# Df Residuals:                      28   BIC:                             189.3
# Df Model:                           4                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept    -54.2822      7.395     -7.341      0.000     -69.429     -39.135
# aptitude       0.3236      0.068      4.774      0.000       0.185       0.462
# tol            0.0334      0.071      0.468      0.643      -0.113       0.179
# technical      1.0955      0.181      6.039      0.000       0.724       1.467
# general        0.5368      0.158      3.389      0.002       0.212       0.861
# ==============================================================================
# Omnibus:                        2.124   Durbin-Watson:                   1.379
# Prob(Omnibus):                  0.346   Jarque-Bera (JB):                1.944
# Skew:                          -0.544   Prob(JB):                        0.378
# Kurtosis:                       2.518   Cond. No.                     1.25e+03
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 1.25e+03. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 3 - split dependent and independent variables
y, X = dmatrices('jpi ~ aptitude + tol + technical + general', data = data, return_type = "dataframe")
X.head()
#    Intercept  aptitude    tol  technical  general
# 0        1.0     43.83  55.92      51.82    43.58
# 1        1.0     32.71  32.56      51.49    51.03
# 2        1.0     56.64  54.84      52.29    52.47
# 3        1.0     51.53  59.69      47.48    47.69
# 4        1.0     51.35  51.50      47.59    45.77



# %% 4 - calculate vif for the independent variables
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    143.239081
# aptitude       1.179906
# tol            1.328205
# technical      2.073907
# general        2.024968
# dtype: float64



# %% 5 - residual vs. predicted plot
data = data.assign(pred = pd.Series(model.fittedvalues))
data = data.assign(resi = pd.Series(model.resid))
data.head()
#    empid    jpi  aptitude    tol  technical  general       pred      resi
# 0      1  45.52     43.83  55.92      51.82    43.58  41.927964  3.592036
# 1      2  40.10     32.71  32.56      51.49    51.03  41.188286 -1.088286
# 2      3  50.61     56.64  54.84      52.29    52.47  51.324072 -0.714072
# 3      4  38.97     51.53  59.69      47.48    47.69  41.997266 -3.027266
# 4      5  41.87     51.35  51.50      47.59    45.77  40.755485  1.114515

data.plot.scatter(x = 'pred', y = 'resi')



# %% 6 - Q-Q plot
fig = sm.graphics.qqplot(data.resi, line = '45', fit = True)



# %% 7 - Shapiro-Wilk test
stats.shapiro(data.resi)
# ShapiroResult(statistic=0.949862003326416, pvalue=0.13180887699127197)



# %% 8 - Kolmogorov-Smirnov test
lilliefors(data.resi)
# (0.11686753293886099, 0.3093852027477401)
