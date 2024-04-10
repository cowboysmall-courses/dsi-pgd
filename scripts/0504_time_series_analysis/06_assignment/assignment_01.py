
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pmdarima as pm

from arch.unitroot import ADF
from pmdarima.arima.utils import ndiffs
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.statespace.tools import diff
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.stats.diagnostic import acorr_ljungbox


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
fig, axs = plt.subplots(3, 2, figsize = (16, 9))
axs[0, 0].plot(series1, color = 'red')
plot_acf(series1, ax = axs[0, 1])
axs[1, 0].plot(series2, color = 'red')
plot_acf(series2, ax = axs[1, 1])
axs[2, 0].plot(series3, color = 'red')
plot_acf(series3, ax = axs[2, 1])
plt.show()


# %% 5 - 
adf = ADF(series1, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                  1.683
# P-value                         0.978
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 6 - 
adf = ADF(series2, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                  5.295
# P-value                         1.000
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 7 - 
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


# %% 8 - 
ndiffs(series1)


# %% 9 - 
ndiffs(series2)


# %% 10 - 
ndiffs(series3)



# %% 11 - 
diff1 = diff(series1)
diff2 = diff(series2)
diff3 = diff(series3)


# %% 12 - 
fig, axs = plt.subplots(3, 2, figsize = (16, 9))
axs[0, 0].plot(diff1, color = 'red')
plot_acf(diff1, ax = axs[0, 1])
axs[1, 0].plot(diff2, color = 'red')
plot_acf(diff2, ax = axs[1, 1])
axs[2, 0].plot(diff3, color = 'red')
plot_acf(diff3, ax = axs[2, 1])
plt.show()


# %% 13 - 
adf = ADF(diff1, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -2.963
# P-value                         0.003
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.64 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 14 - 
adf = ADF(diff2, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -2.578
# P-value                         0.010
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.64 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 15 - 
adf = ADF(diff3, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -1.615
# P-value                         0.100
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.64 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 16 - 
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

# Best model:  ARIMA(0,1,1)(0,1,0)[12]          
# Total fit time: 0.898 seconds


# %% 17 - 
# model1 = ARIMA(series1, order = (0, 1, 1), seasonal_order = (0, 1, 0, 12)).fit()


# %% 17 - 
# model1.params
model1.params()
# ma.L1     0.716674
# sigma2    1.350645
# dtype: float64


# %% 18 - 
# model1.aic
model1.aic()
# 73.76709547666287


# %% 19 - 
resi1 = model1.resid
# resi1 = pd.Series(model1.resid(), series_rng)
resi1


# %% 20 - 
acorr_ljungbox(resi1, lags = None, boxpierce = True)
# acorr_ljungbox(resi1[1:], lags = None, boxpierce = True)
#     lb_stat  lb_pvalue   bp_stat  bp_pvalue
# 1  0.065811   0.797537  0.060327   0.805980
# 2  0.141720   0.931593  0.127801   0.938098
# 3  0.194773   0.978429  0.173486   0.981752
# 4  0.320527   0.988451  0.278281   0.991173
# 5  0.603002   0.987865  0.505831   0.991908
# 6  0.746240   0.993438  0.617238   0.996106


# %% 20 - 
model2 = pm.auto_arima(series2, max_p = 2, max_q = 2, d = 1, seasonal = True, m = 12, trace = True)
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

# Best model:  ARIMA(0,1,1)(0,0,0)[12] intercept
# Total fit time: 0.830 seconds


# %% 21 - 
# model2 = ARIMA(series2, order = (0, 1, 1), seasonal_order = (0, 0, 0, 12)).fit()


# %% 21 - 
# model2.params
model2.params()
# intercept    0.460616
# ma.L1        0.321906
# sigma2       0.224156
# dtype: float64


# %% 22 - 
# model2.aic
model2.aic()
# 51.75384285245132


# %% 23 - 
resi2 = model2.resid
# resi2 = pd.Series(model2.resid(), series_rng)
resi2


# %% 23 - 
acorr_ljungbox(resi2, lags = None, boxpierce = True)
# acorr_ljungbox(resi2[1:], lags = None, boxpierce = True)
#     lb_stat  lb_pvalue   bp_stat  bp_pvalue
# 1  0.019435   0.889125  0.017816   0.893817
# 2  0.347350   0.840570  0.309296   0.856717
# 3  0.442234   0.931386  0.391001   0.942095
# 4  1.196449   0.878683  1.019514   0.906823
# 5  1.284545   0.936514  1.090480   0.954943
# 6  1.361708   0.968146  1.150495   0.979259


# %% 24 - 
model3 = pm.auto_arima(series3, max_p = 2, max_q = 2, d = 1, seasonal = True, m = 12, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,1,2)(1,0,1)[12] intercept   : AIC=inf, Time=0.32 sec
#  ARIMA(0,1,0)(0,0,0)[12] intercept   : AIC=12.415, Time=0.01 sec
#  ARIMA(1,1,0)(1,0,0)[12] intercept   : AIC=12.285, Time=0.10 sec
#  ARIMA(0,1,1)(0,0,1)[12] intercept   : AIC=12.160, Time=0.05 sec
#  ARIMA(0,1,0)(0,0,0)[12]             : AIC=49.589, Time=0.01 sec
#  ARIMA(0,1,1)(0,0,0)[12] intercept   : AIC=10.214, Time=0.02 sec
#  ARIMA(0,1,1)(1,0,0)[12] intercept   : AIC=12.174, Time=0.07 sec
#  ARIMA(0,1,1)(1,0,1)[12] intercept   : AIC=inf, Time=0.22 sec
#  ARIMA(1,1,1)(0,0,0)[12] intercept   : AIC=11.947, Time=0.04 sec
#  ARIMA(0,1,2)(0,0,0)[12] intercept   : AIC=11.357, Time=0.03 sec
#  ARIMA(1,1,0)(0,0,0)[12] intercept   : AIC=10.305, Time=0.01 sec
#  ARIMA(1,1,2)(0,0,0)[12] intercept   : AIC=11.688, Time=0.04 sec
#  ARIMA(0,1,1)(0,0,0)[12]             : AIC=33.438, Time=0.01 sec

# Best model:  ARIMA(0,1,1)(0,0,0)[12] intercept
# Total fit time: 0.961 seconds


# %% 25 - 
model3 = ARIMA(series3, order = (0, 1, 1)).fit(trend = 'nc')


# %% 25 - 
model3.params
# model3.params()
# intercept    0.400626
# ma.L1        0.332299
# sigma2       0.066045
# dtype: float64


# %% 26 - 
model3.aic
# model3.aic()
# 10.21395701201946


# %% 27 - 
resi3 = model3.resid
# resi3 = pd.Series(model3.resid(), series_rng)
resi3


# %% 29 - 
acorr_ljungbox(resi3, lags = None, boxpierce = True)
# acorr_ljungbox(resi3[1:], lags = None, boxpierce = True)
#     lb_stat  lb_pvalue   bp_stat  bp_pvalue
# 1  0.034134   0.853421  0.031290   0.859595
# 2  0.074437   0.963465  0.067115   0.966999
# 3  2.704313   0.439495  2.331729   0.506470
# 4  2.782347   0.594884  2.396758   0.663213
# 5  3.929995   0.559538  3.321252   0.650590
# 6  6.315627   0.388778  5.176744   0.521353


# %% 29 - 
fig, axs = plt.subplots(3, 1, figsize = (16, 9))
axs[0].plot(resi1, color = 'darkorange')
axs[1].plot(resi2, color = 'darkorange')
axs[2].plot(resi3, color = 'darkorange')
# axs[0].plot(resi1[1:], color = 'darkorange')
# axs[1].plot(resi2[1:], color = 'darkorange')
# axs[2].plot(resi3[1:], color = 'darkorange')
plt.show()


# %% 29 - 
model1.forecast(3)


# %% 29 - 
model1.predict(3)
# 2018-01-31    138.985907
# 2018-02-28    138.085907
# 2018-03-31    135.985907
# Freq: ME, dtype: float64


# %% 29 - 
model2.forecast(3)


# %% 29 - 
model2.predict(3)
# 2018-01-31    131.717876
# 2018-02-28    132.178492
# 2018-03-31    132.639108
# Freq: ME, dtype: float64


# %% 29 - 
model3.forecast(3)


# %% 29 - 
model3.predict(3)
# 2018-01-31    127.947080
# 2018-02-28    128.347705
# 2018-03-31    128.748331
# Freq: ME, dtype: float64



