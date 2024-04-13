
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pmdarima as pm

from arch.unitroot import ADF
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tsa.statespace.tools import diff
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf



# %% 1 - import data and check the head
data = pd.read_csv("./data/0504_time_series_analysis/03_time_series_modelling/turnover_annual.csv")
data.head()
#    Year   sales
# 0  1961  224786
# 1  1962  230034
# 2  1963  236562
# 3  1964  250960
# 4  1965  261615


# %% 2 - 
sales_r = pd.date_range('01-01-1961', '31-12-2017', freq = 'YE')
# sales_r = pd.date_range('1961-01-01', '2017-12-31', freq = 'YE')
sales_v = data.sales.values
series  = pd.Series(sales_v, sales_r)


# %% 3 - 
series.plot(color = 'red', title = 'Sales Time Series (Simple Plot)')


# %% 4 - 
plot_acf(series)


# %% 5 - 
series_d1 = diff(series)
series_d1.plot()


# %% 6 - 
series_d2 = diff(series_d1)
series_d2.plot(color = 'red')


# %% 7 - 
plot_acf(series_d2)


# %% 7 - 
adf = ADF(series, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 19.275
# P-value                         1.000
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 8 - 
adf = ADF(series_d2, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                -11.908
# P-value                         0.000
# Lags                                0
# -------------------------------------
# 
# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 9 - 
model = ARIMA(series, order = (2, 2, 2)).fit()


# %% 10 - 
model.params
# ar.L1    -6.732785e-01
# ar.L2    -2.369390e-01
# ma.L1     3.545751e-01
# ma.L2     3.514057e-02
# sigma2    7.970162e+08
# dtype: float64


# %% 10 - 
model.aic
# 1293.8912617376557


# %% 11 - 
model = pm.auto_arima(series, max_p = 2, max_q = 2, d = 2, seasonal = False, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,2,2)(0,0,0)[0] intercept   : AIC=1294.586, Time=0.03 sec
#  ARIMA(0,2,0)(0,0,0)[0] intercept   : AIC=1295.387, Time=0.01 sec
#  ARIMA(1,2,0)(0,0,0)[0] intercept   : AIC=1291.568, Time=0.01 sec
#  ARIMA(0,2,1)(0,0,0)[0] intercept   : AIC=1292.152, Time=0.01 sec
#  ARIMA(0,2,0)(0,0,0)[0]             : AIC=1294.532, Time=0.00 sec
#  ARIMA(2,2,0)(0,0,0)[0] intercept   : AIC=1291.358, Time=0.01 sec
#  ARIMA(2,2,1)(0,0,0)[0] intercept   : AIC=1292.717, Time=0.02 sec
#  ARIMA(1,2,1)(0,0,0)[0] intercept   : AIC=1293.092, Time=0.02 sec
#  ARIMA(2,2,0)(0,0,0)[0]             : AIC=1290.274, Time=0.01 sec
#  ARIMA(1,2,0)(0,0,0)[0]             : AIC=1290.280, Time=0.01 sec
#  ARIMA(2,2,1)(0,0,0)[0]             : AIC=1292.003, Time=0.03 sec
#  ARIMA(1,2,1)(0,0,0)[0]             : AIC=1290.670, Time=0.01 sec
# 
# Best model:  ARIMA(2,2,0)(0,0,0)[0]          
# Total fit time: 0.182 seconds


# %% 12 - 
model = ARIMA(series, order = (2, 2, 0)).fit()


# %% 13 - 
model.params
# ar.L1    -3.379791e-01
# ar.L2    -1.282427e-01
# sigma2    7.602909e+08
# dtype: float64


# %% 14 - 
model.aic
# 1290.274116014659


# %% 15 - 
resi = model.resid
resi.plot()


# %% 16 - 
model.forecast(steps = 3)
# 2018-12-31    3.075934e+06
# 2019-12-31    3.305379e+06
# 2020-12-31    3.536293e+06
# Freq: YE-DEC, Name: predicted_mean, dtype: float64
