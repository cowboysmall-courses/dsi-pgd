
import pandas as pd

from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/predictive_modelling/RESTAURANT SALES DATA.csv")
data.head()
#    RESTAURANT  NOH LOCATION   SALES
# 0           1  155  highway  131.27
# 1           2   93  highway   68.14
# 2           3  128  highway  114.95
# 3           4  114  highway  102.93
# 4           5  158  highway  131.77


# %% 2 - data info
data.info()
# RangeIndex: 16 entries, 0 to 15
# Data columns (total 4 columns):
#  #   Column      Non-Null Count  Dtype
# ---  ------      --------------  -----
#  0   RESTAURANT  16 non-null     int64
#  1   NOH         16 non-null     int64
#  2   LOCATION    16 non-null     object
#  3   SALES       16 non-null     float64
# dtypes: float64(1), int64(2), object(1)
# memory usage: 644.0+ bytes


# %% 3 - convert LOCATION to category
data['LOCATION'] = data['LOCATION'].astype('category')
data['LOCATION'].cat.categories
# Index(['highway', 'mall', 'street'], dtype='object')


# %% 4 - build model
model = ols('SALES ~ NOH + LOCATION', data = data).fit()
model.summary()
# """
#                             OLS Regression Results
# ==============================================================================
# Dep. Variable:                  SALES   R-squared:                       0.970
# Model:                            OLS   Adj. R-squared:                  0.963
# Method:                 Least Squares   F-statistic:                     130.0
# Date:                Fri, 15 Dec 2023   Prob (F-statistic):           2.05e-09
# Time:                        18:08:51   Log-Likelihood:                -56.250
# No. Observations:                  16   AIC:                             120.5
# Df Residuals:                      12   BIC:                             123.6
# Df Model:                           3
# Covariance Type:            nonrobust
# ======================================================================================
#                          coef    std err          t      P>|t|      [0.025      0.975]
# --------------------------------------------------------------------------------------
# Intercept              2.1892      8.592      0.255      0.803     -16.531      20.910
# LOCATION[T.mall]      37.0524      5.814      6.373      0.000      24.385      49.720
# LOCATION[T.street]     7.1537      6.731      1.063      0.309      -7.513      21.820
# NOH                    0.8383      0.056     14.920      0.000       0.716       0.961
# ==============================================================================
# Omnibus:                        1.196   Durbin-Watson:                   2.713
# Prob(Omnibus):                  0.550   Jarque-Bera (JB):                0.403
# Skew:                          -0.387   Prob(JB):                        0.817
# Kurtosis:                       3.071   Cond. No.                         637.
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# """


# %% 5 - build model with reordered levels
model = ols("SALES ~ NOH + C(LOCATION, Treatment(reference = 'mall'))", data = data).fit()
model.summary()
# """
#                             OLS Regression Results
# ==============================================================================
# Dep. Variable:                  SALES   R-squared:                       0.970
# Model:                            OLS   Adj. R-squared:                  0.963
# Method:                 Least Squares   F-statistic:                     130.0
# Date:                Fri, 15 Dec 2023   Prob (F-statistic):           2.05e-09
# Time:                        18:09:14   Log-Likelihood:                -56.250
# No. Observations:                  16   AIC:                             120.5
# Df Residuals:                      12   BIC:                             123.6
# Df Model:                           3
# Covariance Type:            nonrobust
# =======================================================================================================================
#                                                           coef    std err          t      P>|t|      [0.025      0.975]
# -----------------------------------------------------------------------------------------------------------------------
# Intercept                                              39.2416     10.502      3.737      0.003      16.360      62.124
# C(LOCATION, Treatment(reference='mall'))[T.highway]   -37.0524      5.814     -6.373      0.000     -49.720     -24.385
# C(LOCATION, Treatment(reference='mall'))[T.street]    -29.8987      6.123     -4.883      0.000     -43.239     -16.558
# NOH                                                     0.8383      0.056     14.920      0.000       0.716       0.961
# ==============================================================================
# Omnibus:                        1.196   Durbin-Watson:                   2.713
# Prob(Omnibus):                  0.550   Jarque-Bera (JB):                0.403
# Skew:                          -0.387   Prob(JB):                        0.817
# Kurtosis:                       3.071   Cond. No.                         812.
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# """
