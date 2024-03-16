
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from arch.unitroot import ADF
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.statespace.tools import diff


# %% 1 -
plt.figure(figsize = (8, 6))
plt.style.use("ggplot")

sns.set_style("darkgrid")
sns.set_context("paper")


# %% 1 - import data and check the head
data = pd.read_csv("./data/0504_time_series_analysis/00_live_class/turnover_annual.csv")
data.head()


# %% 2 - 
sales_r = pd.date_range('1961-01-01', '2017-12-31', freq = 'YE')
sales_v = data.sales.values

sales_s = pd.Series(sales_v, sales_r)
sales_s.head()


# %% 3 - 
sales_s.plot(color = 'red', title = 'Sales Time Series (Simple Plot)')


# %% 4 - 
sales_2 = sales_s.loc['1990-12-31':'2016-12-31']
sales_2.plot(color = 'green', title = 'Sales Time Series (Subset)')


# %% 5 - 
plot_acf(sales_s, color = 'green')


# %% 6 - 
sales_d = diff(sales_s)
sales_d.plot(color = 'orange')


# %% 7 - 
plot_acf(sales_d, color = 'orange')


# %% 8 - 
sales_e = diff(sales_d)
sales_e.plot(color = 'cadetblue')


# %% 9 - 
plot_acf(sales_e, color = 'cadetblue')


# %% 10 - 
adf = ADF(sales_s, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	19.275
#        P-value	1.000
#           Lags	0
# 
# 
# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.


# %% 11 - 
adf = ADF(sales_d, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	0.257
#        P-value	0.763
#           Lags	0
# 
# 
# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.


# %% 12 - 
adf = ADF(sales_e, lags = 0, trend = 'n')
adf.summary()
# Augmented Dickey-Fuller Results
# Test Statistic	-11.908
#        P-value	0.000
#           Lags	0
# 
# 
# Trend: No Trend
# Critical Values: -2.61 (1%), -1.95 (5%), -1.61 (10%)
# Null Hypothesis: The process contains a unit root.
# Alternative Hypothesis: The process is weakly stationary.
