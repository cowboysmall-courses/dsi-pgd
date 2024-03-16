
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
# 0	1947	      1	 2182.681
# 1	1947	      2	 2176.892
# 2	1947	      3	 2172.432
# 3	1947	      4	 2206.452
# 4	1948	      1	 2239.682


# %% 3 - 
data.CROPYIELD.mean()
# 9968.193418831168


# %% 4 - 
quarterly_r = pd.date_range('1947', '2024', freq = 'QE')
quarterly_v = data.CROPYIELD.values

quarterly_s = pd.Series(quarterly_v, quarterly_r)
quarterly_s.head()
# 1947-03-31    2182.681
# 1947-06-30    2176.892
# 1947-09-30    2172.432
# 1947-12-31    2206.452
# 1948-03-31    2239.682
# Freq: QE-DEC, dtype: float64


# %% 5 - 
quarterly_s.plot(color = 'green', title = 'Crop Yield over Time')


# %% 6 - 
plot_acf(quarterly_s, color = 'green')


# %% 7 - 
adf = ADF(quarterly_s, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	8.268
#        P-value	1.000
#           Lags	0
# 
# 
# Trend: No Trend
# Critical Values: -2.57 (1%), -1.94 (5%), -1.62 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.


# %% 8 - 
diffs = ndiffs(quarterly_s)
print(f"Number of differences needed: {diffs}")
# Number of differences needed: 2


# %% 9 - 
quarterly_2 = diff(diff(quarterly_s))


# %% 10 - 
quarterly_2.plot(color = 'red')


# %% 11 - 
plot_acf(quarterly_2, color = 'green')


# %% 12 - 
adf = ADF(quarterly_2, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	-32.438
#        P-value	0.000
#           Lags	0
# 
# 
# Trend: No Trend
# Critical Values: -2.57 (1%), -1.94 (5%), -1.62 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.


# %% 13 - 
fig, axes = plt.subplots(1, 2, figsize = (12, 4))

plot_acf(quarterly_2, ax = axes[0], color = 'cadetblue')
axes[0].set_title('Autocorrelation Function')

plot_pacf(quarterly_2, ax = axes[1], color = 'cadetblue')
axes[1].set_title('Partial Autocorrelation Function')

plt.show()


# %% 14 - 
model = pm.auto_arima(quarterly_s, max_p = 2, max_q = 2, d = 2, max_P = 1, max_Q = 1, D = 1, m = 4, trace = True)
# Performing stepwise search to minimize aic
#  ARIMA(2,2,2)(1,1,1)[4]             : AIC=inf, Time=0.28 sec
#  ARIMA(0,2,0)(0,1,0)[4]             : AIC=4353.841, Time=0.02 sec
#  ARIMA(1,2,0)(1,1,0)[4]             : AIC=4132.999, Time=0.05 sec
#  ARIMA(0,2,1)(0,1,1)[4]             : AIC=inf, Time=0.12 sec
#  ARIMA(1,2,0)(0,1,0)[4]             : AIC=4232.919, Time=0.02 sec
#  ARIMA(1,2,0)(1,1,1)[4]             : AIC=inf, Time=0.12 sec
#  ARIMA(1,2,0)(0,1,1)[4]             : AIC=inf, Time=0.10 sec
#  ARIMA(0,2,0)(1,1,0)[4]             : AIC=4253.783, Time=0.02 sec
#  ARIMA(2,2,0)(1,1,0)[4]             : AIC=4091.198, Time=0.08 sec
#  ARIMA(2,2,0)(0,1,0)[4]             : AIC=4180.307, Time=0.03 sec
#  ARIMA(2,2,0)(1,1,1)[4]             : AIC=inf, Time=0.16 sec
#  ARIMA(2,2,0)(0,1,1)[4]             : AIC=inf, Time=0.14 sec
#  ARIMA(2,2,1)(1,1,0)[4]             : AIC=inf, Time=0.21 sec
#  ARIMA(1,2,1)(1,1,0)[4]             : AIC=inf, Time=0.15 sec
#  ARIMA(2,2,0)(1,1,0)[4] intercept   : AIC=4093.198, Time=0.15 sec
# 
# Best model:  ARIMA(2,2,0)(1,1,0)[4]          
# Total fit time: 1.655 seconds


# %% 15 - 
model.params()
# ar.L1         -0.789224
# ar.L2         -0.366854
# ar.S.L4       -0.511277
# sigma2     43268.147700
# dtype: float64


# %% 16 - 
model.aic()
# 4091.1979398649596


# %% 17 - 
resi = pd.Series(model.resid(), quarterly_r)
acorr_ljungbox(resi, lags = None, boxpierce = True)

#         lb_stat	   lb_pvalue	  bp_stat	   bp_pvalue
#  1	11.270807	7.873548e-04	11.161735	8.350180e-04
#  2	15.114026	5.224335e-04	14.955363	5.655671e-04
#  3	19.980335	1.713427e-04	19.743184	1.918660e-04
#  4	32.732989	1.354671e-06	32.249013	1.701508e-06
#  5	40.140976	1.398733e-07	39.489722	1.892422e-07
#  6	40.871313	3.069692e-07	40.201212	4.158646e-07
#  7	41.783907	5.722634e-07	41.087311	7.789389e-07
#  8	57.590129	1.381153e-09	56.383655	2.374862e-09
#  9	57.999235	3.251354e-09	56.778245	5.572369e-09
# 10	59.412935	4.679848e-09	58.137220	8.145345e-09



# %% 18 - 
resi.plot(color = 'red')


# %% 19 - 
resi_21_23 = pd.Series(model.resid(), quarterly_r)
resi_21_23 = resi_21_23[resi_21_23.index.year.isin(range(2021, 2024))]
acorr_ljungbox(resi_21_23, lags = None, boxpierce = True)
#    lb_stat	lb_pvalue	 bp_stat	bp_pvalue
# 1	0.687737	 0.406935	0.540365	 0.462282
# 2	1.583294	 0.453098	1.180048	 0.554314


# %% 20 - 
model.predict(4)
# 2024-03-31    22689.402541
# 2024-06-30    22739.440206
# 2024-09-30    22923.423768
# 2024-12-31    23087.972540
# Freq: QE-DEC, dtype: float64
