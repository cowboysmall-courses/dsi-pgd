#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 18 18:34:33 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import numpy as np
import seaborn as sns
import statsmodels.api as sm

from scipy import stats
from patsy import dmatrices
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split, cross_val_score, KFold
from sklearn.metrics import mean_squared_error, r2_score
from statsmodels.formula.api import ols
from statsmodels.stats.diagnostic import lilliefors
from statsmodels.stats.outliers_influence import variance_inflation_factor


np.random.seed(42)



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/case_study/Housing Prices.csv")
data.head()
#       CRIM    ZN  INDUS  CHAS    NOX  ...  RAD  TAX  PTRATIO  LSTAT  MEDV
# 0  0.00632  18.0   2.31     0  0.538  ...    1  296     15.3   4.98  24.0
# 1  0.02731   0.0   7.07     0  0.469  ...    2  242     17.8   9.14  21.6
# 2  0.02729   0.0   7.07     0  0.469  ...    2  242     17.8   4.03  34.7
# 3  0.03237   0.0   2.18     0  0.458  ...    3  222     18.7   2.94  33.4
# 4  0.06905   0.0   2.18     0  0.458  ...    3  222     18.7   5.33  36.2



# %% 2 - construct a heatmap of correlations
sns.heatmap(data = data.corr().round(2), annot = True)



# %% 3 - test for multicollinearity
y, X = dmatrices('MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + LSTAT', data = data, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    535.526619
# CRIM           1.767486
# ZN             2.298459
# INDUS          3.987181
# CHAS           1.071168
# NOX            4.369093
# RM             1.912532
# AGE            3.088232
# DIS            3.954037
# RAD            7.445301
# TAX            9.002158
# PTRATIO        1.797060
# LSTAT          2.870777
# dtype: float64



# %% 4 - drop TAX and re-run test for multicollinearity
y, X = dmatrices('MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + PTRATIO + LSTAT', data = data, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    529.480235
# CRIM           1.767349
# ZN             2.184172
# INDUS          3.217951
# CHAS           1.055023
# NOX            4.343300
# RM             1.902642
# AGE            3.085756
# DIS            3.952445
# RAD            2.772208
# PTRATIO        1.787049
# LSTAT          2.870408
# dtype: float64



# %% 4 - split into train and test data
train, test = train_test_split(data, test_size = 0.2, random_state = 42)
train.shape
# (404, 13)
test.shape
# (102, 13)



# %% 5 - build the model
model = ols('MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + PTRATIO + LSTAT', data = train).fit()
print(model.summary())
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                   MEDV   R-squared:                       0.735
# Model:                            OLS   Adj. R-squared:                  0.728
# Method:                 Least Squares   F-statistic:                     98.99
# Date:                Mon, 18 Dec 2023   Prob (F-statistic):          7.75e-106
# Time:                        19:23:43   Log-Likelihood:                -1206.6
# No. Observations:                 404   AIC:                             2437.
# Df Residuals:                     392   BIC:                             2485.
# Df Model:                          11                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     35.2203      5.555      6.340      0.000      24.299      46.141
# CRIM          -0.1266      0.036     -3.556      0.000      -0.197      -0.057
# ZN             0.0189      0.016      1.196      0.232      -0.012       0.050
# INDUS         -0.0452      0.064     -0.712      0.477      -0.170       0.080
# CHAS           3.3202      0.975      3.406      0.001       1.404       5.237
# NOX          -19.3122      4.327     -4.463      0.000     -27.819     -10.805
# RM             4.3369      0.473      9.168      0.000       3.407       5.267
# AGE           -0.0034      0.015     -0.225      0.822      -0.033       0.026
# DIS           -1.4400      0.232     -6.205      0.000      -1.896      -0.984
# RAD            0.0794      0.047      1.687      0.092      -0.013       0.172
# PTRATIO       -0.9248      0.148     -6.269      0.000      -1.215      -0.635
# LSTAT         -0.5345      0.057     -9.412      0.000      -0.646      -0.423
# ==============================================================================
# Omnibus:                      122.472   Durbin-Watson:                   2.171
# Prob(Omnibus):                  0.000   Jarque-Bera (JB):              473.320
# Skew:                           1.302   Prob(JB):                    1.66e-103
# Kurtosis:                       7.620   Cond. No.                     2.06e+03
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 2.06e+03. This might indicate that there are
# strong multicollinearity or other numerical problems.



# %% 6 - rebuild the model dropping insignificant predictors
model = ols('MEDV ~ CRIM + CHAS + NOX + RM + DIS + PTRATIO + LSTAT', data = train).fit()
print(model.summary())
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                   MEDV   R-squared:                       0.732
# Model:                            OLS   Adj. R-squared:                  0.727
# Method:                 Least Squares   F-statistic:                     154.2
# Date:                Mon, 18 Dec 2023   Prob (F-statistic):          6.26e-109
# Time:                        19:24:34   Log-Likelihood:                -1209.4
# No. Observations:                 404   AIC:                             2435.
# Df Residuals:                     396   BIC:                             2467.
# Df Model:                           7                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     31.8452      5.073      6.278      0.000      21.872      41.818
# CRIM          -0.0925      0.031     -2.938      0.003      -0.154      -0.031
# CHAS           3.3351      0.974      3.425      0.001       1.421       5.249
# NOX          -18.2416      3.613     -5.049      0.000     -25.344     -11.139
# RM             4.5754      0.447     10.225      0.000       3.696       5.455
# DIS           -1.2243      0.184     -6.660      0.000      -1.586      -0.863
# PTRATIO       -0.8962      0.122     -7.317      0.000      -1.137      -0.655
# LSTAT         -0.5316      0.054     -9.842      0.000      -0.638      -0.425
# ==============================================================================
# Omnibus:                      137.650   Durbin-Watson:                   2.160
# Prob(Omnibus):                  0.000   Jarque-Bera (JB):              610.512
# Skew:                           1.426   Prob(JB):                    2.69e-133
# Kurtosis:                       8.304   Cond. No.                         558.
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.



# %% 7 - predicted and residual values
train = train.assign(pred = pd.Series(model.fittedvalues))
train = train.assign(resi = pd.Series(model.resid))
train.head()
#          CRIM    ZN  INDUS  CHAS  ...  LSTAT  MEDV       pred      resi
# 477  15.02340   0.0  18.10     0  ...  24.91  12.0   9.606448  2.393552
# 15    0.62739   0.0   8.14     0  ...   8.47  19.9  19.836562  0.063438
# 332   0.03466  35.0   6.06     0  ...   7.83  19.4  24.010658 -4.610658
# 423   7.05042   0.0  18.10     0  ...  23.29  13.4  14.957532 -1.557532
# 19    0.72580   0.0   8.14     0  ...  11.28  18.2  18.703620 -0.503620
# 
# [5 rows x 15 columns]

# model.predict()      # returns NaNs
# model.predict(train) # works as expected
# model.fittedvalues   # works as expected



# %% 8 - residual analysis
train.plot.scatter(x = 'pred', y = 'resi')

fig = sm.graphics.qqplot(train.resi, line = '45', fit = True)

stats.shapiro(train.resi)
# ShapiroResult(statistic=0.9116807579994202, pvalue=1.2912867356060145e-14)

lilliefors(train.resi)
# (0.10330391317988474, 0.0009999999999998899)



# %% 9 - model validation
rmse = np.sqrt(mean_squared_error(train.MEDV, train.pred))
r2   = r2_score(train.MEDV, train.pred)

print('Train')
print('RMSE: {}'.format(rmse))
# RMSE: 4.828905476132975
print('  R2: {}'.format(r2))
#   R2: 0.7315826585744917

pred = model.predict(test)
pred.head()
# 173    28.967561
# 274    35.300716
# 491    18.194906
# 72     25.438994
# 452    16.996801
# dtype: float64

rmse = np.sqrt(mean_squared_error(test.MEDV, pred))
r2   = r2_score(test.MEDV, pred)

print('Test')
print('RMSE: {}'.format(rmse))
# RMSE: 5.104988833926639
print('  R2: {}'.format(r2))
#   R2: 0.6446261208488171



# %% 10 - k-fold cross validation
X = data.drop(['MEDV', 'ZN', 'INDUS', 'RAD', 'AGE'], axis = 1)
Y = data.MEDV

model = LinearRegression()
folds = KFold(n_splits = 4, shuffle = True, random_state = 100)

rmse = cross_val_score(model, X, Y, cv = folds, scoring = 'neg_mean_squared_error')
r2   = cross_val_score(model, X, Y, cv = folds, scoring = 'r2')

print('K-Fold')
print('RMSE: {}'.format(np.sqrt(-(np.mean(rmse)))))
# 4-Fold RMSE: 5.017099097638693
print('  R2: {}'.format(np.mean(r2)))
# 4-Fold R2: 0.7017401987251717



# %% 11 - final model validation
model = ols('MEDV ~ CRIM + CHAS + NOX + RM + DIS + PTRATIO + LSTAT', data = data).fit()
print(model.summary())
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                   MEDV   R-squared:                       0.718
# Model:                            OLS   Adj. R-squared:                  0.715
# Method:                 Least Squares   F-statistic:                     181.6
# Date:                Tue, 19 Dec 2023   Prob (F-statistic):          1.10e-132
# Time:                        13:29:20   Log-Likelihood:                -1519.5
# No. Observations:                 506   AIC:                             3055.
# Df Residuals:                     498   BIC:                             3089.
# Df Model:                           7                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept     35.1688      4.611      7.626      0.000      26.108      44.229
# CRIM          -0.0654      0.030     -2.195      0.029      -0.124      -0.007
# CHAS           3.1238      0.882      3.543      0.000       1.392       4.856
# NOX          -17.8133      3.243     -5.493      0.000     -24.184     -11.442
# RM             4.1943      0.407     10.295      0.000       3.394       4.995
# DIS           -1.1631      0.166     -6.994      0.000      -1.490      -0.836
# PTRATIO       -0.9635      0.114     -8.472      0.000      -1.187      -0.740
# LSTAT         -0.5452      0.049    -11.223      0.000      -0.641      -0.450
# ==============================================================================
# Omnibus:                      188.076   Durbin-Watson:                   1.037
# Prob(Omnibus):                  0.000   Jarque-Bera (JB):              879.882
# Skew:                           1.594   Prob(JB):                    8.63e-192
# Kurtosis:                       8.619   Cond. No.                         564.
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.

y, X = dmatrices('MEDV ~ CRIM + CHAS + NOX + RM + DIS + PTRATIO + LSTAT', data = data, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept    445.644176
# CRIM           1.375716
# CHAS           1.048660
# NOX            2.952924
# RM             1.713693
# DIS            2.564486
# PTRATIO        1.267771
# LSTAT          2.517101
# dtype: float64

pred = model.predict(data)
pred.head()
# 0    30.948872
# 1    25.833746
# 2    31.824281
# 3    29.689071
# 4    29.008530
# dtype: float64

rmse = np.sqrt(mean_squared_error(data.MEDV, pred))
r2   = r2_score(data.MEDV, pred)

print('Data')
print('RMSE: {}'.format(rmse))
# RMSE: 4.874865477341117
print('  R2: {}'.format(r2))
#   R2: 0.7184975318016213
