
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import pmdarima as pm

from arch.unitroot import ADF
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.statespace.tools import diff
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf



# %% 1 - import data and check the head
data = pd.read_csv("./data/0504_time_series_analysis/03_time_series_modelling/Sales Data for 3 Years.csv")
data.head()
#    Year Month  Sales
# 0  2013   Jan  123.0
# 1  2013   Feb  142.0
# 2  2013   Mar  164.0
# 3  2013   Apr  173.0
# 4  2013   May  183.0


# %% 2 - 
sales_r = pd.date_range('01-01-2013', '31-12-2015', freq = 'ME')
sales_v = data.Sales.values
series  = pd.Series(sales_v, sales_r)


# %% 3 - 
series.plot()


# %% 4 - 
plot_acf(series)


# %% 5 - 
adf = ADF(series, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                  1.621
# P-value                         0.975
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 6 - 
series_d1 = diff(series)
(ADF(series_d1, lags = 0, trend = 'n')).summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 -6.891
# P-value                         0.000
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.63 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 7 - 
model = pm.auto_arima(series, d = 1, max_p = 2, max_q = 2, D = 1, max_P = 2, max_Q = 2, seasonal = True, m = 12, suppress_warnings = True, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,1,2)(1,1,1)[12]             : AIC=157.040, Time=0.19 sec
#  ARIMA(0,1,0)(0,1,0)[12]             : AIC=156.110, Time=0.01 sec
#  ARIMA(1,1,0)(1,1,0)[12]             : AIC=159.126, Time=0.05 sec
#  ARIMA(0,1,1)(0,1,1)[12]             : AIC=159.405, Time=0.05 sec
#  ARIMA(0,1,0)(1,1,0)[12]             : AIC=157.653, Time=0.03 sec
#  ARIMA(0,1,0)(0,1,1)[12]             : AIC=157.653, Time=0.03 sec
#  ARIMA(0,1,0)(1,1,1)[12]             : AIC=159.653, Time=0.03 sec
#  ARIMA(1,1,0)(0,1,0)[12]             : AIC=157.180, Time=0.01 sec
#  ARIMA(0,1,1)(0,1,0)[12]             : AIC=157.607, Time=0.02 sec
#  ARIMA(1,1,1)(0,1,0)[12]             : AIC=154.602, Time=0.03 sec
#  ARIMA(1,1,1)(1,1,0)[12]             : AIC=156.601, Time=0.11 sec
#  ARIMA(1,1,1)(0,1,1)[12]             : AIC=156.601, Time=0.08 sec
#  ARIMA(1,1,1)(1,1,1)[12]             : AIC=inf, Time=0.25 sec
#  ARIMA(2,1,1)(0,1,0)[12]             : AIC=152.557, Time=0.03 sec
#  ARIMA(2,1,1)(1,1,0)[12]             : AIC=153.101, Time=0.07 sec
#  ARIMA(2,1,1)(0,1,1)[12]             : AIC=inf, Time=0.23 sec
#  ARIMA(2,1,1)(1,1,1)[12]             : AIC=155.046, Time=0.21 sec
#  ARIMA(2,1,0)(0,1,0)[12]             : AIC=151.614, Time=0.02 sec
#  ARIMA(2,1,0)(1,1,0)[12]             : AIC=151.894, Time=0.05 sec
#  ARIMA(2,1,0)(0,1,1)[12]             : AIC=inf, Time=0.13 sec
#  ARIMA(2,1,0)(1,1,1)[12]             : AIC=153.862, Time=0.09 sec
#  ARIMA(2,1,0)(0,1,0)[12] intercept   : AIC=152.220, Time=0.03 sec

# Best model:  ARIMA(2,1,0)(0,1,0)[12]          
# Total fit time: 1.759 seconds

# model


# %% 8 - 
series = pd.to_numeric(series.astype(float))
model  = SARIMAX(series, order = (2, 1, 0), seasonal_order = (0, 1, 0, 12)).fit()


# %% 9 - 
model.params
# ar.L1      0.158289
# ar.L2      0.635230
# sigma2    31.166297
# dtype: float64


# %% 10 - 
model.aic
# 151.6144624358249


# %% 11 - 
resi = model.resid
resi.plot(color = "red")


# %% 12 - 
model.forecast(steps = 3)
# 2016-01-31    285.633155
# 2016-02-29    292.174297
# 2016-03-31    292.094559
# Freq: ME, Name: predicted_mean, dtype: float64
