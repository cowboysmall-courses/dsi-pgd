
# %% 0 - filter out warnings
import warnings
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf
import statsmodels.api as sm

from scipy import stats
from sklearn.preprocessing import StandardScaler
from statsmodels.stats.diagnostic import lilliefors
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.stats.stattools import durbin_watson


warnings.filterwarnings("ignore", category = FutureWarning)


# %% 1 -
plt.style.use("ggplot")



# %% 2 - import data and check the head
data = pd.read_csv("./data/0504_time_series_analysis/07_case_study/mktmix.csv")
data.head()
# 	Time period	Sales	Base_Price	Radio	InStore	TV
# 0	          1	19564	15.029276	245.0	15.452	101.780000
# 1	          2	19387	15.029276	314.0	16.388	76.734000
# 2	          3	23889	14.585093	324.0	62.692	131.590200
# 3	          4	20055	15.332887	298.0	16.573	119.627060
# 4	          5	20064	15.642632	279.0	41.504	103.438118



# %% 3 -
data.shape
# (104, 6)



# %% 4 -
data.dropna(inplace = True)
data.shape
# (100, 6)



# %% 5 -
model = smf.ols("Sales ~ Base_Price + Radio + InStore + TV", data = data).fit()
model.summary()
# """
#                             OLS Regression Results                            
# ==============================================================================
# Dep. Variable:                  Sales   R-squared:                       0.648
# Model:                            OLS   Adj. R-squared:                  0.633
# Method:                 Least Squares   F-statistic:                     43.65
# Date:                Sat, 23 Mar 2024   Prob (F-statistic):           9.64e-21
# Time:                        09:20:03   Log-Likelihood:                -825.76
# No. Observations:                 100   AIC:                             1662.
# Df Residuals:                      95   BIC:                             1675.
# Df Model:                           4                                         
# Covariance Type:            nonrobust                                         
# ==============================================================================
#                  coef    std err          t      P>|t|      [0.025      0.975]
# ------------------------------------------------------------------------------
# Intercept   4.757e+04   3019.360     15.756      0.000    4.16e+04    5.36e+04
# Base_Price -1952.5944    191.249    -10.210      0.000   -2332.271   -1572.918
# Radio          1.1928      1.109      1.076      0.285      -1.008       3.394
# InStore       35.0531      7.323      4.787      0.000      20.515      49.591
# TV             7.4444      2.217      3.357      0.001       3.042      11.847
# ==============================================================================
# Omnibus:                        3.728   Durbin-Watson:                   0.898
# Prob(Omnibus):                  0.155   Jarque-Bera (JB):                3.098
# Skew:                          -0.332   Prob(JB):                        0.212
# Kurtosis:                       3.551   Cond. No.                     9.63e+03
# ==============================================================================

# Notes:
# [1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
# [2] The condition number is large, 9.63e+03. This might indicate that there are
# strong multicollinearity or other numerical problems.
# """



# %% 6 - calculate VIF
vif_data = pd.DataFrame()
vif_data["Feature"] = model.model.exog_names[1:]
vif_data["VIF"] = [variance_inflation_factor(model.model.exog, i) for i in range(1, model.model.exog.shape[1])]
vif_data



# %% 7 - Shapiro-Wilk test
stats.shapiro(model.resid)
# ShapiroResult(statistic=0.9795467853546143, pvalue=0.12254950404167175)



# %% 8 - Kolmogorov-Smirnov test
lilliefors(model.resid)
# (0.07571751956383976, 0.181664148951344)



# %% 9 - 
dw_test = durbin_watson(model.resid)
dw_test
# 0.8981617202375777



# %% 10 - 
exog   = data[['Base_Price', 'Radio', 'InStore', 'TV']]
scaler = StandardScaler()
scaled = scaler.fit_transform(exog)

scaled_df = pd.DataFrame(scaled, columns = exog.columns, index = exog.index)
scaled_df.head()
#    Base_Price     Radio   InStore        TV
# 0   -0.488308 -0.135053 -1.252125 -0.888455
# 1   -0.488308  0.662095 -1.183318 -1.466690
# 2   -1.340611  0.777623  2.220582 -0.200230
# 3    0.094265  0.477249 -1.169718 -0.476422
# 4    0.688608  0.257744  0.663010 -0.850175



# %% 11 - 
model = sm.tsa.SARIMAX(data['Sales'], exog = scaled_df, order = (0, 0, 0), trend = 'c', error_ar = 1).fit()
model.summary()
# """
#                                SARIMAX Results                                
# ==============================================================================
# Dep. Variable:                  Sales   No. Observations:                  100
# Model:                        SARIMAX   Log Likelihood                -825.765
# Date:                Sat, 23 Mar 2024   AIC                           1663.530
# Time:                        09:46:31   BIC                           1679.161
# Sample:                             0   HQIC                          1669.856
#                                 - 100                                         
# Covariance Type:                  opg                                         
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# intercept   2.022e+04    107.340    188.362      0.000       2e+04    2.04e+04
# Base_Price -1017.6055    106.716     -9.536      0.000   -1226.764    -808.447
# Radio        103.2478    116.714      0.885      0.376    -125.508     332.003
# InStore      476.8354    106.885      4.461      0.000     267.344     686.327
# TV           322.4525     95.305      3.383      0.001     135.657     509.248
# sigma2       8.71e+05   1.17e+05      7.467      0.000    6.42e+05     1.1e+06
# ===================================================================================
# Ljung-Box (L1) (Q):                  31.23   Jarque-Bera (JB):                 3.10
# Prob(Q):                              0.00   Prob(JB):                         0.21
# Heteroskedasticity (H):               1.77   Skew:                            -0.33
# Prob(H) (two-sided):                  0.11   Kurtosis:                         3.55
# ===================================================================================

# Warnings:
# [1] Covariance matrix calculated using the outer product of gradients (complex-step).
# """



# %% 12 - 
base_price = [15.64, 15.49]
radio      = [279, 259]
instore    = [41.50, 20.40]
tv         = [103.44, 128.40]

test_df = pd.DataFrame({'Base_Price': base_price, 'Radio': radio, 'InStore': instore, 'TV': tv})

mean  = data[['Base_Price', 'Radio', 'InStore', 'TV']].mean()
std   = data[['Base_Price', 'Radio', 'InStore', 'TV']].std()
x     = test_df[['Base_Price', 'Radio', 'InStore', 'TV']]
x_var = (x - mean) / std
x_var
#    Base_Price     Radio   InStore        TV
# 0    0.680131  0.256452  0.659394 -0.845870
# 1    0.393752  0.026553 -0.883934 -0.272509



# %% 13 - 
model.forecast(steps = 2, exog = x_var)
# 100    19594.792428
# 101    19311.444928
# Name: predicted_mean, dtype: float64

