
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pmdarima as pm
import statsmodels.api as sm

from arch.unitroot import ADF
from pmdarima.arima.utils import ndiffs
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.statespace.tools import diff
from statsmodels.stats.diagnostic import acorr_ljungbox

# from statsmodels.tsa.statespace.sarimax import SARIMAX
# from statsmodels.tsa.arima.model import ARIMA



# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")



# %% 2 - import data and check the head
data = pd.read_csv("./data/0504_time_series_analysis/06_assignment/USA FIRM SALES DATA.csv")
data.head()
#   Year	    Month	  BU1	  BU2	  BU3
# 0	2015	 February	125.1	115.5	113.8
# 1	2015	    March	123.6	115.7	113.8
# 2	2015	    April	123.1	116.5	114.0
# 3	2015	      May	123.1	117.7	114.1
# 4	2015	     June	123.4	118.3	114.7



# %% 3 - 
# series_rng = pd.date_range('2015-02-01', '2017-12-31', freq = 'M')
series_rng = pd.date_range('2015-02-01', '2017-12-31', freq = 'ME')

series1 = pd.Series(data.BU1.values, series_rng)
series2 = pd.Series(data.BU2.values, series_rng)
series3 = pd.Series(data.BU3.values, series_rng)



# %% 4 -
decomp1 = sm.tsa.seasonal_decompose(series1.interpolate())
decomp1.plot()


# %% 5 -
decomp2 = sm.tsa.seasonal_decompose(series2.interpolate())
decomp2.plot()


# %% 6 -
decomp3 = sm.tsa.seasonal_decompose(series3.interpolate())
decomp3.plot()



# %% 7 -
fig, axs = plt.subplots(3, 2, figsize = (16, 9))
axs[0, 0].plot(series1, color = 'red')
plot_acf(series1, ax = axs[0, 1])
axs[1, 0].plot(series2, color = 'red')
plot_acf(series2, ax = axs[1, 1])
axs[2, 0].plot(series3, color = 'red')
plot_acf(series3, ax = axs[2, 1])
plt.show()

# COMMENT:
# looking at the plots: the sales data of all three business units are trending upwards,
# and it appears that all three business units have seasonal characteristics - while BU2
# and BU3 do not appear to have strong seasonal characteristics. Also, all three series
# appear to be non-stationary, which we can confirm with the Dickey-Fuller test



# %% 8 -
adf = ADF(series1, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                  1.683
# P-value                         0.978
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """

# COMMENT:
# the time series is non-stationary as the value of the test statistic is
# greater than the 5pct critical value



# %% 9 -
adf = ADF(series2, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                  5.295
# P-value                         1.000
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """

# COMMENT:
# the time series is non-stationary as the value of the test statistic is
# greater than the 5pct critical value



# %% 10 -
adf = ADF(series3, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                  8.486
# P-value                         1.000
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """

# COMMENT:
# the time series is non-stationary as the value of the test statistic is
# greater than the 5pct critical value



# %% 11 -
ndiffs(series1)
# 1


# %% 12 -
ndiffs(series2)
# 1


# %% 13 -
ndiffs(series3)
# 1



# %% 14 -
diff1 = diff(series1)
diff2 = diff(series2)
diff3 = diff(series3)



# %% 15 -
fig, axs = plt.subplots(3, 2, figsize = (16, 9))
axs[0, 0].plot(diff1, color = 'red')
plot_acf(diff1, ax = axs[0, 1])
axs[1, 0].plot(diff2, color = 'red')
plot_acf(diff2, ax = axs[1, 1])
axs[2, 0].plot(diff3, color = 'red')
plot_acf(diff3, ax = axs[2, 1])
plt.show()

# COMMENT:
# looking at the plots after differencing it appears that all of the 
# business units are now stationary - we can confirm this by running 
# the Dickey-Fuller test



# %% 16 -
adf = ADF(diff1, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -2.963
# P-value                         0.003
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.64 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """

# COMMENT:
# the differenced time series is stationary as the value of the test
# statistic is less than the 5pct critical value


# %% 17 -
adf = ADF(diff2, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -2.578
# P-value                         0.010
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.64 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """

# COMMENT:
# the differenced time series is stationary as the value of the test
# statistic is less than the 5pct critical value


# %% 18 -
adf = ADF(diff3, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -1.615
# P-value                         0.100
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.64 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """

# COMMENT:
# the differenced time series is still non-stationary as the value of the test
# statistic is slightly greater than the 5pct critical value, but it is close
# enough to proceed




# %% 19 -
model1 = pm.auto_arima(series1, d = 1, max_p = 2, max_q = 2, seasonal = True, m = 12, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,1,2)(1,1,1)[12]             : AIC=inf, Time=0.44 sec
#  ARIMA(0,1,0)(0,1,0)[12]             : AIC=78.215, Time=0.01 sec
#  ARIMA(1,1,0)(1,1,0)[12]             : AIC=76.714, Time=0.04 sec
#  ARIMA(0,1,1)(0,1,1)[12]             : AIC=74.500, Time=0.04 sec
#  ARIMA(0,1,1)(0,1,0)[12]             : AIC=73.767, Time=0.02 sec
#  ARIMA(0,1,1)(1,1,0)[12]             : AIC=74.500, Time=0.03 sec
#  ARIMA(0,1,1)(1,1,1)[12]             : AIC=76.500, Time=0.04 sec
#  ARIMA(1,1,1)(0,1,0)[12]             : AIC=inf, Time=0.08 sec
#  ARIMA(0,1,2)(0,1,0)[12]             : AIC=inf, Time=0.06 sec
#  ARIMA(1,1,0)(0,1,0)[12]             : AIC=76.954, Time=0.01 sec
#  ARIMA(1,1,2)(0,1,0)[12]             : AIC=inf, Time=0.09 sec
#  ARIMA(0,1,1)(0,1,0)[12] intercept   : AIC=75.364, Time=0.02 sec
# 
# Best model:  ARIMA(0,1,1)(0,1,0)[12]          
# Total fit time: 0.898 seconds


# %% 20 -
model1.summary()
# """
#                                       SARIMAX Results                                      
# ===========================================================================================
# Dep. Variable:                                   y   No. Observations:                   35
# Model:             SARIMAX(0, 1, 1)x(0, 1, [], 12)   Log Likelihood                 -34.884
# Date:                             Thu, 11 Apr 2024   AIC                             73.767
# Time:                                     22:45:21   BIC                             75.949
# Sample:                                 02-28-2015   HQIC                            74.281
#                                       - 12-31-2017                                         
# Covariance Type:                               opg                                         
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# ma.L1          0.7167      0.204      3.512      0.000       0.317       1.117
# sigma2         1.3506      0.357      3.786      0.000       0.651       2.050
# ===================================================================================
# Ljung-Box (L1) (Q):                   0.28   Jarque-Bera (JB):                 0.38
# Prob(Q):                              0.59   Prob(JB):                         0.83
# Heteroskedasticity (H):               2.55   Skew:                            -0.12
# Prob(H) (two-sided):                  0.24   Kurtosis:                         3.60
# ===================================================================================

# Warnings:
# [1] Covariance matrix calculated using the outer product of gradients (complex-step).
# """


# %% 21 -
model1.params()
# ma.L1     0.716674
# sigma2    1.350645
# dtype: float64


# %% 22 -
model1.aic()
# 73.76709547666287


# %% 23 -
resi1 = model1.resid()


# %% 23 -
acorr_ljungbox(resi1, lags = 1, boxpierce = True)
#     lb_stat  lb_pvalue   bp_stat  bp_pvalue
# 1  0.002027   0.964091  0.001863   0.965576

# COMMENT:
# fail to reject the null hypothesis that the residuals are a white noise
# process




# %% 24 -
# model2 = pm.auto_arima(series2, max_p = 2, max_q = 2, d = 1, seasonal = True, m = 12, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,1,2)(1,0,1)[12] intercept   : AIC=inf, Time=0.35 sec
#  ARIMA(0,1,0)(0,0,0)[12] intercept   : AIC=52.313, Time=0.01 sec
#  ARIMA(1,1,0)(1,0,0)[12] intercept   : AIC=53.201, Time=0.04 sec
#  ARIMA(0,1,1)(0,0,1)[12] intercept   : AIC=51.944, Time=0.04 sec
#  ARIMA(0,1,0)(0,0,0)[12]             : AIC=71.361, Time=0.01 sec
#  ARIMA(0,1,1)(0,0,0)[12] intercept   : AIC=51.754, Time=0.01 sec
#  ARIMA(0,1,1)(1,0,0)[12] intercept   : AIC=52.651, Time=0.04 sec
#  ARIMA(0,1,1)(1,0,1)[12] intercept   : AIC=inf, Time=0.20 sec
#  ARIMA(1,1,1)(0,0,0)[12] intercept   : AIC=53.400, Time=0.03 sec
#  ARIMA(0,1,2)(0,0,0)[12] intercept   : AIC=53.345, Time=0.03 sec
#  ARIMA(1,1,0)(0,0,0)[12] intercept   : AIC=52.479, Time=0.02 sec
#  ARIMA(1,1,2)(0,0,0)[12] intercept   : AIC=55.378, Time=0.04 sec
#  ARIMA(0,1,1)(0,0,0)[12]             : AIC=62.726, Time=0.01 sec
# 
# Best model:  ARIMA(0,1,1)(0,0,0)[12] intercept
# Total fit time: 0.830 seconds

model2 = pm.auto_arima(series2, max_p = 2, max_q = 2, d = 1, seasonal = False, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,1,2)(0,0,0)[0] intercept   : AIC=inf, Time=0.10 sec
#  ARIMA(0,1,0)(0,0,0)[0] intercept   : AIC=52.313, Time=0.01 sec
#  ARIMA(1,1,0)(0,0,0)[0] intercept   : AIC=52.479, Time=0.01 sec
#  ARIMA(0,1,1)(0,0,0)[0] intercept   : AIC=51.754, Time=0.01 sec
#  ARIMA(0,1,0)(0,0,0)[0]             : AIC=71.361, Time=0.01 sec
#  ARIMA(1,1,1)(0,0,0)[0] intercept   : AIC=53.400, Time=0.02 sec
#  ARIMA(0,1,2)(0,0,0)[0] intercept   : AIC=53.345, Time=0.02 sec
#  ARIMA(1,1,2)(0,0,0)[0] intercept   : AIC=55.378, Time=0.04 sec
#  ARIMA(0,1,1)(0,0,0)[0]             : AIC=62.726, Time=0.01 sec
# 
# Best model:  ARIMA(0,1,1)(0,0,0)[0] intercept
# Total fit time: 0.220 seconds


# %% 25 -
model2.summary()
# """
#                                SARIMAX Results                                
# ==============================================================================
# Dep. Variable:                      y   No. Observations:                   35
# Model:               SARIMAX(0, 1, 1)   Log Likelihood                 -22.877
# Date:                Thu, 11 Apr 2024   AIC                             51.754
# Time:                        22:46:51   BIC                             56.333
# Sample:                    02-28-2015   HQIC                            53.315
#                          - 12-31-2017                                         
# Covariance Type:                  opg                                         
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# intercept      0.4606      0.108      4.256      0.000       0.248       0.673
# ma.L1          0.3219      0.154      2.091      0.037       0.020       0.624
# sigma2         0.2242      0.055      4.096      0.000       0.117       0.331
# ===================================================================================
# Ljung-Box (L1) (Q):                   0.02   Jarque-Bera (JB):                 0.13
# Prob(Q):                              0.89   Prob(JB):                         0.94
# Heteroskedasticity (H):               3.94   Skew:                            -0.15
# Prob(H) (two-sided):                  0.03   Kurtosis:                         3.04
# ===================================================================================

# Warnings:
# [1] Covariance matrix calculated using the outer product of gradients (complex-step).
# """


# %% 26 -
model2.params()
# intercept    0.460616
# ma.L1        0.321906
# sigma2       0.224156
# dtype: float64


# %% 27 -
model2.aic()
# 51.75384285245132


# %% 28 -
resi2 = model2.resid()


# %% 28 -
acorr_ljungbox(resi2, lags = 1, boxpierce = True)
#     lb_stat  lb_pvalue   bp_stat  bp_pvalue
# 1  0.000342   0.985236  0.000315   0.985847

# COMMENT:
# fail to reject the null hypothesis that the residuals are a white noise
# process



# %% 29 -
model3 = pm.auto_arima(series3, max_p = 2, max_q = 2, d = 1, seasonal = False, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,1,2)(0,0,0)[0] intercept   : AIC=inf, Time=0.10 sec
#  ARIMA(0,1,0)(0,0,0)[0] intercept   : AIC=12.415, Time=0.01 sec
#  ARIMA(1,1,0)(0,0,0)[0] intercept   : AIC=10.305, Time=0.01 sec
#  ARIMA(0,1,1)(0,0,0)[0] intercept   : AIC=10.214, Time=0.01 sec
#  ARIMA(0,1,0)(0,0,0)[0]             : AIC=49.589, Time=0.01 sec
#  ARIMA(1,1,1)(0,0,0)[0] intercept   : AIC=11.947, Time=0.03 sec
#  ARIMA(0,1,2)(0,0,0)[0] intercept   : AIC=11.357, Time=0.02 sec
#  ARIMA(1,1,2)(0,0,0)[0] intercept   : AIC=11.688, Time=0.04 sec
#  ARIMA(0,1,1)(0,0,0)[0]             : AIC=33.438, Time=0.01 sec
# 
# Best model:  ARIMA(0,1,1)(0,0,0)[0] intercept
# Total fit time: 0.245 seconds


# %% 30 -
model3.summary()
# """
#                                SARIMAX Results                                
# ==============================================================================
# Dep. Variable:                      y   No. Observations:                   35
# Model:               SARIMAX(0, 1, 1)   Log Likelihood                  -2.107
# Date:                Thu, 11 Apr 2024   AIC                             10.214
# Time:                        22:49:01   BIC                             14.793
# Sample:                    02-28-2015   HQIC                            11.776
#                          - 12-31-2017                                         
# Covariance Type:                  opg                                         
# ==============================================================================
#                  coef    std err          z      P>|z|      [0.025      0.975]
# ------------------------------------------------------------------------------
# intercept      0.4006      0.064      6.224      0.000       0.274       0.527
# ma.L1          0.3323      0.189      1.758      0.079      -0.038       0.703
# sigma2         0.0660      0.022      3.069      0.002       0.024       0.108
# ===================================================================================
# Ljung-Box (L1) (Q):                   0.03   Jarque-Bera (JB):                 2.07
# Prob(Q):                              0.86   Prob(JB):                         0.36
# Heteroskedasticity (H):               0.58   Skew:                             0.54
# Prob(H) (two-sided):                  0.37   Kurtosis:                         2.45
# ===================================================================================

# Warnings:
# [1] Covariance matrix calculated using the outer product of gradients (complex-step).
# """


# %% 31 -
model3.params()
# intercept    0.400626
# ma.L1        0.332299
# sigma2       0.066045
# dtype: float64


# %% 32 -
model3.aic()
# 10.21395701201946


# %% 33 -
resi3 = model3.resid()


# %% 33 -
acorr_ljungbox(resi3, lags = 1, boxpierce = True)
#     lb_stat  lb_pvalue   bp_stat  bp_pvalue
# 1  0.000757   0.978052  0.000695   0.978961

# COMMENT:
# fail to reject the null hypothesis that the residuals are a white noise
# process



# %% 34 -
fig, axs = plt.subplots(3, 1, figsize = (16, 9))
axs[0].plot(resi1[1:], color = 'darkorange')
axs[1].plot(resi2[1:], color = 'darkorange')
axs[2].plot(resi3[1:], color = 'darkorange')
plt.show()






# COMMENT:
# to predict sales for each business unit for the first three months of 2018
# we use the predict function


# %% 35 -
# model1.forecast(3)

model1.predict(3)
# 2018-01-31    138.985907
# 2018-02-28    138.085907
# 2018-03-31    135.985907
# Freq: ME, dtype: float64


# %% 36 -
# model2.forecast(3)

model2.predict(3)
# 2018-01-31    131.717876
# 2018-02-28    132.178492
# 2018-03-31    132.639108
# Freq: ME, dtype: float64


# %% 37 -
# model3.forecast(3)

model3.predict(3)
# 2018-01-31    127.947080
# 2018-02-28    128.347705
# 2018-03-31    128.748331
# Freq: ME, dtype: float64
