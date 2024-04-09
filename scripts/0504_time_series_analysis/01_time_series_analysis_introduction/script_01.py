
# %% 0 - 
import pandas as pd


# %% 1 - 
data = pd.read_csv("./data/0504_time_series_analysis/01_time_series_analysis_introduction/turnover_annual.csv")
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
sub_series = series.loc['1990-12-31':'2016-12-31']
sub_series.plot(color = 'red', title = "Sales Time Series (Subset)")


# %% 4 -



