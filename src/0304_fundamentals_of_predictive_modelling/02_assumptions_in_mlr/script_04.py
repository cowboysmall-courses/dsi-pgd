
import pandas as pd

from statsmodels.formula.api import ols
from statsmodels.graphics.regressionplots import influence_plot


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
# Date:                Fri, 15 Dec 2023   Prob (F-statistic):           2.47e-12
# Time:                        18:19:10   Log-Likelihood:                -85.916
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


# %% 3 - find influential observations
influence = model.get_influence()
influence.summary_frame()
#     dfb_Intercept  dfb_aptitude  ...  student_resid    dffits
# 0        0.122741     -0.148903  ...       1.073046  0.368781
# 1       -0.069745      0.116652  ...      -0.358542 -0.229924
# 2        0.007297     -0.008658  ...      -0.203007 -0.047285
# 3       -0.156961      0.094733  ...      -0.896332 -0.300194
# 4        0.053858     -0.010940  ...       0.318038  0.077783
# 5        0.244564     -0.167649  ...       0.955797  0.351269
# 6       -0.021876     -0.017310  ...      -0.063397 -0.038165
# 7       -0.168201      0.013234  ...       0.915805  0.277153
# 8       -0.008939      0.000748  ...       0.130801  0.035396
# 9        0.112049     -0.224749  ...      -0.837786 -0.340777
# 10      -0.180551      0.079534  ...      -0.637958 -0.232753
# 11      -0.340527      0.322926  ...       1.232747  0.475341
# 12      -0.002789      0.152126  ...       0.454661  0.214423
# 13       0.035353     -0.027137  ...       0.153265  0.077879
# 14      -0.060997      0.000016  ...       0.597002  0.205195
# 15      -0.026014     -0.056283  ...       0.785860  0.317896
# 16       0.005764      0.052259  ...       0.848673  0.303255
# 17      -0.470813      0.716128  ...       1.857938  0.968774
# 18      -0.002558     -0.004065  ...       0.043747  0.014103
# 19      -0.052127     -0.182788  ...      -0.968073 -0.287947
# 20      -0.097589      0.108405  ...      -0.268305 -0.152599
# 21      -0.031178     -0.009583  ...       0.178313  0.058365
# 22       0.221800      0.135613  ...       1.148903  0.478355
# 23      -0.125349     -0.091664  ...       0.881649  0.272397
# 24       0.178875     -0.187061  ...       0.997533  0.465663
# 25       0.276042      0.055035  ...      -1.809409 -0.545379
# 26       0.009642      0.230258  ...      -0.957953 -0.630117
# 27       0.094605      0.003629  ...      -0.921194 -0.457383
# 28      -0.105476      0.304572  ...      -2.397484 -1.167847
# 29       0.033915      0.013843  ...       0.810284  0.154674
# 30       0.005420     -0.008511  ...       0.062856  0.019261
# 31      -0.222359     -1.083859  ...      -2.582302 -1.448961
# 32       1.013902     -0.260599  ...      -1.636376 -1.456593

# [33 rows x 11 columns]


# %% 4 - construct an influence plot
fig = influence_plot(model, criterion = 'Cooks')
