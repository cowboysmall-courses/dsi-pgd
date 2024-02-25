
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from patsy import dmatrices
from statsmodels.formula.api import ols
from statsmodels.stats.outliers_influence import variance_inflation_factor


# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/assumptions_in_mlr/ridge regression data.csv")
data.head()
#                  MODEL  RESALE PRICE  ENGINE SIZE  HORSE POWER  WEIGHT  YEARS
# 0       Daihatsu Cuore          3870          846           32     650    2.9
# 1  Suzuki Swift 1.0 GL          4163          993           39     790    2.9
# 2   Fiat Panda Mambo L          3490          899           29     730    3.1
# 3       VW Polo 1.4 60          5714         1390           44     955    3.3
# 4  Opel Corsa 1.2i Eco          4950         1195           33     895    3.4


# %% 2 - construct a scatter plot matrix
sns.pairplot(data[['MODEL', 'RESALE PRICE', 'ENGINE SIZE', 'HORSE POWER', 'YEARS']])
plt.title('Scatter Plot Matrix')


# %% 3 - build model
data.columns = [c.replace(' ', '_') for c in data.columns]
model = ols('RESALE_PRICE ~ ENGINE_SIZE + HORSE_POWER + WEIGHT + YEARS', data = data).fit()
model.summary()
# """
#                             OLS Regression Results
# ==============================================================================
# Dep. Variable:           RESALE_PRICE   R-squared:                       0.748
# Model:                            OLS   Adj. R-squared:                  0.700
# Method:                 Least Squares   F-statistic:                     15.55
# Date:                Fri, 15 Dec 2023   Prob (F-statistic):           4.67e-06
# Time:                        18:14:25   Log-Likelihood:                -206.99
# No. Observations:                  26   AIC:                             424.0
# Df Residuals:                      21   BIC:                             430.3
# Df Model:                           4
# Covariance Type:            nonrobust
# ===============================================================================
#                   coef    std err          t      P>|t|      [0.025      0.975]
# -------------------------------------------------------------------------------
# Intercept    3173.3673    774.900      4.095      0.001    1561.875    4784.859
# ENGINE_SIZE     0.4462      0.969      0.460      0.650      -1.570       2.462
# HORSE_POWER    24.6222     16.724      1.472      0.156     -10.157      59.402
# WEIGHT          4.0855      1.498      2.727      0.013       0.969       7.202
# YEARS       -1028.7282    528.760     -1.946      0.065   -2128.345      70.889
# ==============================================================================
# Omnibus:                        1.693   Durbin-Watson:                   2.102
# Prob(Omnibus):                  0.429   Jarque-Bera (JB):                1.319
# Skew:                           0.537   Prob(JB):                        0.517
# Kurtosis:                       2.747   Cond. No.                     1.24e+04
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 1.24e+04. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """


# %% 5 - calculate vif for each variable
y, X = dmatrices('RESALE_PRICE ~ ENGINE_SIZE + HORSE_POWER + WEIGHT + YEARS', data = data, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
# Intercept      26.193279
# ENGINE_SIZE    15.759113
# HORSE_POWER    12.046734
# WEIGHT          9.113045
# YEARS          13.978640
