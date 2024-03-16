
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import pmdarima as pm

from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from arch.unitroot import ADF 
from statsmodels.tsa.statespace.tools import diff
from pmdarima.arima.utils import ndiffs

from statsmodels.stats.diagnostic import acorr_ljungbox


# %% 1 -
plt.style.use("ggplot")


# %% 2 - import data and check the head
data = pd.read_csv("./data/0504_time_series_analysis/07_case_study/CROP DATA.csv")
data.head()
# 	Year	Quarter	CROPYIELD
# 0	1947	1	2182.681
# 1	1947	2	2176.892
# 2	1947	3	2172.432
# 3	1947	4	2206.452
# 4	1948	1	2239.682


# %% 3 - 
yearly = data.groupby('Year')['CROPYIELD'].sum().reset_index()
yearly.head()
# Year	CROPYIELD
# 0	1947	8738.457
# 1	1948	9098.506
# 2	1949	9047.711
# 3	1950	9834.127
# 4	1951	10625.280


# %% 4 - 
yearly_r = pd.date_range('1947', '2024', freq = 'YE')
yearly_v = yearly.CROPYIELD.values

yearly_s = pd.Series(yearly_v, yearly_r)
yearly_s.head()
# 1947-12-31     8738.457
# 1948-12-31     9098.506
# 1949-12-31     9047.711
# 1950-12-31     9834.127
# 1951-12-31    10625.280
# Freq: YE-DEC, dtype: float64


# %% 5 - 
yearly_s.plot(color = 'red', title = 'Crop Yield over Time')


# %% 6 - 
plot_acf(yearly_s, color = 'green')



# %% 7 - 
adf = ADF(yearly_s, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	10.991
#        P-value	1.000
#           Lags	0


# Trend: No Trend
# Critical Values: -2.60 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.


# %% 8 - 
diffs = ndiffs(yearly_s)
print(f"Number of differences needed: {diffs}")
# Number of differences needed: 2


# %% 9 - 
yearly_2 = diff(diff(yearly_s))
yearly_2.plot(color = 'red')


# %% 10 - 
fig, axes = plt.subplots(1, 2, figsize = (12, 4))

plot_acf(yearly_2, ax = axes[0], color = 'cadetblue')
axes[0].set_title('Autocorrelation Function')

plot_pacf(yearly_2, ax = axes[1], color = 'cadetblue')
axes[1].set_title('Partial Autocorrelation Function')

plt.show()


# %% 11 - 
adf = ADF(yearly_2, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	-15.226
#        P-value	0.000
#           Lags	0


# Trend: No Trend
# Critical Values: -2.60 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.


# %% 12 - 
model = pm.auto_arima(yearly_s, max_p = 2, max_q = 2, d = 2, seasonal = False, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,2,2)(0,0,0)[0] intercept   : AIC=inf, Time=0.13 sec
#  ARIMA(0,2,0)(0,0,0)[0] intercept   : AIC=1283.929, Time=0.01 sec
#  ARIMA(1,2,0)(0,0,0)[0] intercept   : AIC=1267.411, Time=0.01 sec
#  ARIMA(0,2,1)(0,0,0)[0] intercept   : AIC=inf, Time=0.04 sec
#  ARIMA(0,2,0)(0,0,0)[0]             : AIC=1281.960, Time=0.01 sec
#  ARIMA(2,2,0)(0,0,0)[0] intercept   : AIC=1261.666, Time=0.04 sec
#  ARIMA(2,2,1)(0,0,0)[0] intercept   : AIC=inf, Time=0.10 sec
#  ARIMA(1,2,1)(0,0,0)[0] intercept   : AIC=inf, Time=0.06 sec
#  ARIMA(2,2,0)(0,0,0)[0]             : AIC=1259.699, Time=0.01 sec
#  ARIMA(1,2,0)(0,0,0)[0]             : AIC=1265.363, Time=0.01 sec
#  ARIMA(2,2,1)(0,0,0)[0]             : AIC=1247.884, Time=0.05 sec
#  ARIMA(1,2,1)(0,0,0)[0]             : AIC=1245.917, Time=0.03 sec
#  ARIMA(0,2,1)(0,0,0)[0]             : AIC=1244.431, Time=0.02 sec
#  ARIMA(0,2,2)(0,0,0)[0]             : AIC=1245.903, Time=0.04 sec
#  ARIMA(1,2,2)(0,0,0)[0]             : AIC=1248.282, Time=0.04 sec

# Best model:  ARIMA(0,2,1)(0,0,0)[0]          
# Total fit time: 0.595 seconds

# %% 13 - 
model.params()
# ma.L1         -0.898574
# sigma2    822606.104304
# dtype: float64


# %% 14 - 
model.aic()
# 1244.4313001285661


# %% 15 - 
resi = pd.Series(model.resid(), yearly_r)
acorr_ljungbox(resi, lags = None, boxpierce = True)
#        lb_stat   lb_pvalue     bp_stat   bp_pvalue
#  1	1.952447	0.162323	1.878304	0.170527
#  2	2.544453	0.280207	2.440334	0.295181
#  3	2.661401	0.446827	2.549881	0.466344
#  4	2.666522	0.615085	2.554613	0.634884
#  5	2.748128	0.738748	2.628988	0.756956
#  6	2.749660	0.839547	2.630365	0.853602
#  7	2.796396	0.903177	2.671776	0.913617
#  8	2.892010	0.940950	2.755288	0.948764
#  9	3.064983	0.961663	2.904175	0.967973
# 10	3.319378	0.972878	3.119928	0.978459



# %% 16 - 
resi.plot(color = 'red')


# %% 17 - 
model.predict(1)
# 2024-12-31    91138.301863
# Freq: YE-DEC, dtype: float64
