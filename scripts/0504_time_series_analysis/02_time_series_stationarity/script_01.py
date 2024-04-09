
# %% 0 - 
import pandas as pd
import matplotlib.pyplot as plt

from arch.unitroot import ADF

from statsmodels.tsa.statespace.tools import diff
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf


# %% 1 - 
data = pd.read_csv("./data/0504_time_series_analysis/02_time_series_stationarity/turnover_annual.csv")
data.head()
# 	Year	 sales
# 0	1961	224786
# 1	1962	230034
# 2	1963	236562
# 3	1964	250960
# 4	1965	261615


# %% 2 -
rng = pd.date_range('01-01-1961', '31-12-2017', freq = 'YE')
sales = data.sales.values
series = pd.Series(sales, rng)
series.plot(color = 'red', title = "Sales Time Series (Simple Plot)")

# %% 3 -
plot_acf(series)


# %% 4 -
diff1 = diff(series)
diff1.plot()


# %% 5 -
plot_acf(diff1)


# %% 6 -
diff2 = diff(diff1)
diff2.plot(color = 'red')


# %% 7 -
plot_acf(diff2)


# %% 8 -
plot_pacf(diff2)


# %% 9 -
adf = ADF(series, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                 19.275
# P-value                         1.000
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


# %% 10 -
adf = ADF(diff2, lags = 0, trend = 'n')
adf.summary()
# """
#    Augmented Dickey-Fuller Results   
# =====================================
# Test Statistic                -11.908
# P-value                         0.000
# Lags                                0
# -------------------------------------

# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
# """


