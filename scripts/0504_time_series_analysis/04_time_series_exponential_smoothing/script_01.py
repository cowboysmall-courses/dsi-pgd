
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import pmdarima as pm

from arch.unitroot import ADF
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.statespace.tools import diff
from statsmodels.tsa.holtwinters import SimpleExpSmoothing, ExponentialSmoothing
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
sales_r = pd.date_range('2013', '2016', freq = 'ME')
sales_v = data.Sales.values
series  = pd.Series(sales_v, sales_r)


# %% 3 - 
model = SimpleExpSmoothing(series)
fit1  = model.fit()


# %% 4 - 
fit1.predict()
# 2016-01-31    314.443013
# Freq: ME, dtype: float64


# %% 5 - 
fit1.summary()
# """
#                        SimpleExpSmoothing Model Results                       
# ==============================================================================
# Dep. Variable:                   None   No. Observations:                   36
# Model:             SimpleExpSmoothing   SSE                          10942.602
# Optimized:                       True   AIC                            209.808
# Trend:                           None   BIC                            212.975
# Seasonal:                        None   AICC                           211.099
# Seasonal Periods:                None   Date:                 Sat, 13 Apr 2024
# Box-Cox:                        False   Time:                         16:36:47
# Box-Cox Coeff.:                  None                                         
# ==============================================================================
#                        coeff                 code              optimized      
# ------------------------------------------------------------------------------
# smoothing_level            0.7547856                alpha                 True
# initial_level              123.00000                  l.0                False
# ------------------------------------------------------------------------------
# """


# %% 6 - 
model = ExponentialSmoothing(series, trend = 'add', seasonal = None)
fit2  = model.fit()


# %% 7 - 
fit2.predict()
# 2016-01-31    295.970234
# Freq: ME, dtype: float64


# %% 8 - 
fit2.summary()
# """
#                        ExponentialSmoothing Model Results                       
# ================================================================================
# Dep. Variable:                     None   No. Observations:                   36
# Model:             ExponentialSmoothing   SSE                           8649.636
# Optimized:                         True   AIC                            205.343
# Trend:                         Additive   BIC                            211.677
# Seasonal:                          None   AICC                           208.240
# Seasonal Periods:                  None   Date:                 Sat, 13 Apr 2024
# Box-Cox:                          False   Time:                         16:40:18
# Box-Cox Coeff.:                    None                                         
# ==============================================================================
#                        coeff                 code              optimized      
# ------------------------------------------------------------------------------
# smoothing_level            0.3039435                alpha                 True
# smoothing_trend            0.3039435                 beta                 True
# initial_level              127.50930                  l.0                 True
# initial_trend              11.565183                  b.0                 True
# ------------------------------------------------------------------------------
# """


# %% 9 - 
model = ExponentialSmoothing(series, seasonal_periods = 12, trend = 'add', seasonal = 'add')
fit3  = model.fit()


# %% 10 - 
fit3.predict()
# 2016-01-31    293.447781
# Freq: ME, dtype: float64


# %% 11 - 
fit3.summary()
# """
#                        ExponentialSmoothing Model Results                       
# ================================================================================
# Dep. Variable:                     None   No. Observations:                   36
# Model:             ExponentialSmoothing   SSE                            539.668
# Optimized:                         True   AIC                            129.468
# Trend:                         Additive   BIC                            154.804
# Seasonal:                      Additive   AICC                           169.703
# Seasonal Periods:                    12   Date:                 Sat, 13 Apr 2024
# Box-Cox:                          False   Time:                         16:43:20
# Box-Cox Coeff.:                    None                                         
# =================================================================================
#                           coeff                 code              optimized      
# ---------------------------------------------------------------------------------
# smoothing_level               1.0000000                alpha                 True
# smoothing_trend               0.3702992                 beta                 True
# smoothing_seasonal           1.5421e-08                gamma                 True
# initial_level                 121.18777                  l.0                 True
# initial_trend                 13.392646                  b.0                 True
# initial_seasons.0            -11.580381                  s.0                 True
# initial_seasons.1            -6.7219657                  s.1                 True
# initial_seasons.2            -4.9774468                  s.2                 True
# initial_seasons.3            -4.2801121                  s.3                 True
# initial_seasons.4            -5.3633839                  s.4                 True
# initial_seasons.5            -5.1939082                  s.5                 True
# initial_seasons.6            -7.6048752                  s.6                 True
# initial_seasons.7            -9.1965038                  s.7                 True
# initial_seasons.8            -12.235354                  s.8                 True
# initial_seasons.9            -15.088052                  s.9                 True
# initial_seasons.10           -16.787999                 s.10                 True
# initial_seasons.11            28.464812                 s.11                 True
# ---------------------------------------------------------------------------------
# """




