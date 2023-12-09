#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec  9 10:01:31 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import seaborn as sns

from patsy import dmatrices
from statsmodels.formula.api import ols
from statsmodels.stats.outliers_influence import variance_inflation_factor



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/live_class/car price data.csv")
data.head()



# %% 2 - construct a scatter plot matrix
sns.pairplot(data[['MODEL', 'RESALE PRICE', 'ENGINE SIZE', 'HORSE POWER', 'YEARS']])



# %% 3 - fix column names
data.columns = [c.replace(' ', '_') for c in data.columns]
data.head()



# %% 4 - build model
model = ols('RESALE_PRICE ~ ENGINE_SIZE + HORSE_POWER + WEIGHT + YEARS', data = data).fit()
model.summary()
"""
                            OLS Regression Results                            
==============================================================================
Dep. Variable:           RESALE_PRICE   R-squared:                       0.748
Model:                            OLS   Adj. R-squared:                  0.700
Method:                 Least Squares   F-statistic:                     15.55
Date:                Sat, 09 Dec 2023   Prob (F-statistic):           4.67e-06
Time:                        10:14:34   Log-Likelihood:                -206.99
No. Observations:                  26   AIC:                             424.0
Df Residuals:                      21   BIC:                             430.3
Df Model:                           4                                         
Covariance Type:            nonrobust                                         
===============================================================================
                  coef    std err          t      P>|t|      [0.025      0.975]
-------------------------------------------------------------------------------
Intercept    3173.3673    774.900      4.095      0.001    1561.875    4784.859
ENGINE_SIZE     0.4462      0.969      0.460      0.650      -1.570       2.462
HORSE_POWER    24.6222     16.724      1.472      0.156     -10.157      59.402
WEIGHT          4.0855      1.498      2.727      0.013       0.969       7.202
YEARS       -1028.7282    528.760     -1.946      0.065   -2128.345      70.889
==============================================================================
Omnibus:                        1.693   Durbin-Watson:                   2.102
Prob(Omnibus):                  0.429   Jarque-Bera (JB):                1.319
Skew:                           0.537   Prob(JB):                        0.517
Kurtosis:                       2.747   Cond. No.                     1.24e+04
==============================================================================

Notes:
[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
[2] The condition number is large, 1.24e+04. This might indicate that there are
strong multicollinearity or other numerical problems.
"""



# %% 5 - split dependent and independent variables
y, X = dmatrices('RESALE_PRICE ~ ENGINE_SIZE + HORSE_POWER + WEIGHT + YEARS', data = data, return_type = "dataframe")
X.head()
#    Intercept  ENGINE_SIZE  HORSE_POWER  WEIGHT  YEARS
# 0        1.0        846.0         32.0   650.0    2.9
# 1        1.0        993.0         39.0   790.0    2.9
# 2        1.0        899.0         29.0   730.0    3.1
# 3        1.0       1390.0         44.0   955.0    3.3
# 4        1.0       1195.0         33.0   895.0    3.4



# %% 6 - calculate vif for the independent variables
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept      26.193279
# ENGINE_SIZE    15.759113
# HORSE_POWER    12.046734
# WEIGHT          9.113045
# YEARS          13.978640



# %% 7 - rebuild model 
model = ols('RESALE_PRICE ~ HORSE_POWER + WEIGHT + YEARS', data = data).fit()
model.summary()
"""
                            OLS Regression Results                            
==============================================================================
Dep. Variable:           RESALE_PRICE   R-squared:                       0.745
Model:                            OLS   Adj. R-squared:                  0.710
Method:                 Least Squares   F-statistic:                     21.43
Date:                Sat, 09 Dec 2023   Prob (F-statistic):           1.00e-06
Time:                        10:27:54   Log-Likelihood:                -207.12
No. Observations:                  26   AIC:                             422.2
Df Residuals:                      22   BIC:                             427.3
Df Model:                           3                                         
Covariance Type:            nonrobust                                         
===============================================================================
                  coef    std err          t      P>|t|      [0.025      0.975]
-------------------------------------------------------------------------------
Intercept    3146.3362    758.705      4.147      0.000    1572.878    4719.794
HORSE_POWER    30.7421      9.962      3.086      0.005      10.081      51.403
WEIGHT          3.9840      1.455      2.738      0.012       0.966       7.002
YEARS        -924.2861    468.971     -1.971      0.061   -1896.873      48.301
==============================================================================
Omnibus:                        1.057   Durbin-Watson:                   2.020
Prob(Omnibus):                  0.590   Jarque-Bera (JB):                1.032
Skew:                           0.389   Prob(JB):                        0.597
Kurtosis:                       2.411   Cond. No.                     6.67e+03
==============================================================================

Notes:
[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
[2] The condition number is large, 6.67e+03. This might indicate that there are
strong multicollinearity or other numerical problems.
"""



# %% 8 - split dependent and independent variables
y, X = dmatrices('RESALE_PRICE ~ HORSE_POWER + WEIGHT + YEARS', data = data, return_type = "dataframe")
X.head()
#    Intercept  HORSE_POWER  WEIGHT  YEARS
# 0        1.0         32.0   650.0    2.9
# 1        1.0         39.0   790.0    2.9
# 2        1.0         29.0   730.0    3.1
# 3        1.0         44.0   955.0    3.3
# 4        1.0         33.0   895.0    3.4


# %% 9 - calculate vif for the independent variables
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept      26.042851
# HORSE_POWER     4.433599
# WEIGHT          8.915615
# YEARS          11.404687
# dtype: float64




