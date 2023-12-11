#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  4 18:37:41 2023

@author: jerry
"""


# %% 0 - import libraries

import numpy as np
import pandas as pd
import seaborn as sns

from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()
#    empid    jpi  aptitude    tol  technical  general
# 0      1  45.52     43.83  55.92      51.82    43.58
# 1      2  40.10     32.71  32.56      51.49    51.03
# 2      3  50.61     56.64  54.84      52.29    52.47
# 3      4  38.97     51.53  59.69      47.48    47.69
# 4      5  41.87     51.35  51.50      47.59    45.77



# %% 2 - construct a scatter plot matrix
sns.pairplot(data)



# %% 3 - build model
model = ols('jpi ~ tol + aptitude + technical + general', data = data).fit()
model.params
# Intercept   -54.282247
# tol           0.033372
# aptitude      0.323562
# technical     1.095467
# general       0.536834
# dtype: float64



# %% 3.5
X = data[['tol', 'aptitude', 'technical', 'general']]
X.insert(loc = 0, column = 'Intercept', value = pd.Series([1] * data.shape[0]))
P = X.T.dot(X)

Y = data['jpi']

pd.DataFrame(np.linalg.pinv(P.values), P.columns, P.index).dot(X.T.dot(Y))


# %% 4 - model summary
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                    jpi   R-squared:                       0.877
# Model:                            OLS   Adj. R-squared:                  0.859
# Method:                 Least Squares   F-statistic:                     49.81
# Date:                Mon, 04 Dec 2023   Prob (F-statistic):           2.47e-12
# Time:                        19:03:42   Log-Likelihood:                -85.916
# No. Observations:                  33   AIC:                             181.8
# Df Residuals:                      28   BIC:                             189.3
# Df Model:                           4                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept    -54.2822      7.395     -7.341      0.000     -69.429     -39.135
# tol            0.0334      0.071      0.468      0.643      -0.113       0.179
# aptitude       0.3236      0.068      4.774      0.000       0.185       0.462
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



# %% 5 - rebuild model omitting tol
model = ols('jpi ~ aptitude + technical + general', data = data).fit()
model.params
# Intercept   -54.406443
# aptitude      0.333346
# technical     1.116627
# general       0.543157
# dtype: float64



# %% 5.5
X = data[['aptitude', 'technical', 'general']]
X.insert(loc = 0, column = 'Intercept', value = pd.Series([1] * data.shape[0]))
P = X.T.dot(X)

Y = data['jpi']

pd.DataFrame(np.linalg.pinv(P.values), P.columns, P.index).dot(X.T.dot(Y))




# %% 6 - new model summary
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                    jpi   R-squared:                       0.876
# Model:                            OLS   Adj. R-squared:                  0.863
# Method:                 Least Squares   F-statistic:                     68.18
# Date:                Mon, 04 Dec 2023   Prob (F-statistic):           3.03e-13
# Time:                        19:17:24   Log-Likelihood:                -86.045
# No. Observations:                  33   AIC:                             180.1
# Df Residuals:                      29   BIC:                             186.1
# Df Model:                           3                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept    -54.4064      7.290     -7.464      0.000     -69.315     -39.497
# aptitude       0.3333      0.064      5.241      0.000       0.203       0.463
# technical      1.1166      0.173      6.444      0.000       0.762       1.471
# general        0.5432      0.156      3.489      0.002       0.225       0.862
# ==============================================================================
# Omnibus:                        2.163   Durbin-Watson:                   1.392
# Prob(Omnibus):                  0.339   Jarque-Bera (JB):                1.960
# Skew:                          -0.515   Prob(JB):                        0.375
# Kurtosis:                       2.396   Cond. No.                     1.07e+03
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 1.07e+03. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 7 - add fitted and residuals
data = data.assign(pred = pd.Series(model.fittedvalues))
data = data.assign(resi = pd.Series(model.resid))
data.head()
#    empid    jpi  aptitude    tol  technical  general       pred      resi
# 0      1  45.52     43.83  55.92      51.82    43.58  41.738503  3.781497
# 1      2  40.10     32.71  32.56      51.49    51.03  41.709731 -1.609731
# 2      3  50.61     56.64  54.84      52.29    52.47  51.362151 -0.752151
# 3      4  38.97     51.53  59.69      47.48    47.69  41.691486 -2.721486
# 4      5  41.87     51.35  51.50      47.59    45.77  40.711451  1.158549



# %% 8 - predictions for new data set
pred = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index new.csv")
pred = pred.assign(pred = pd.Series(model.predict(pred)))
pred = pred.assign(resi = pd.Series(pred.jpi - pred.pred))
pred.head()
#    empid    jpi    tol  technical  general  aptitude       pred      resi
# 0     34  66.35  59.20      57.18    54.98     66.74  61.552576  4.797424
# 1     35  56.10  64.92      52.51    55.78     55.45  53.008978  3.091022
# 2     36  48.95  63.59      57.76    52.08     51.73  55.621537 -6.671537
# 3     37  43.25  64.90      50.13    42.75     45.09  39.820600  3.429400
# 4     38  41.20  51.50      47.89    45.77     50.85  40.879766  0.320234



# %% 9 - predictions with 95% confidence interval
result = model.get_prediction(pred)
result.conf_int()
# array([[59.00955719, 64.09559387],
#        [50.67791702, 55.34003898],
#        [53.65401364, 57.58906082],
#        [37.73389546, 41.90730465],
#        [39.23363549, 42.52589584],
#        [45.41626758, 47.98650295]])



# %% 9 - predictions with 90% confidence interval
result.conf_int(alpha = 0.1)
# array([[59.43989777, 63.6652533 ],
#        [51.07238925, 54.94556675],
#        [53.9869665 , 57.25610796],
#        [38.08701664, 41.55418346],
#        [39.51220077, 42.24733056],
#        [45.63374076, 47.76902977]])
