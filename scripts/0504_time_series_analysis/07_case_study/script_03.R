
library(forecast)
library(urca)


data <- read.csv("./data/0504_time_series_analysis/07_case_study/CROP\ DATA.csv", header = TRUE)
head(data)


series <- ts(data$CROPYIELD, start = 1947, end = 2024, frequency = 4)
series <- head(series, -1)


par(mfrow = c(2, 1))
plot(series, col = "red")
acf(series, col = "blue")


summary(ur.df(series, lag = 0))
# ############################################### 
# # Augmented Dickey-Fuller Test Unit Root Test # 
# ############################################### 
# 
# Test regression none 
# 
# 
# Call:
# lm(formula = z.diff ~ z.lag.1 - 1)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -1755.93   -21.13    11.85    49.04  1361.63 
# 
# Coefficients:
#          Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 0.0060586  0.0007327   8.268  4.2e-15 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 149 on 306 degrees of freedom
# Multiple R-squared:  0.1826,    Adjusted R-squared:  0.1799 
# F-statistic: 68.37 on 1 and 306 DF,  p-value: 4.195e-15
# 
# 
# Value of test-statistic is: 8.2684 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.58 -1.95 -1.62


ndiffs(series)
# 2

series_2 <- diff(series, differences = 2)
summary(ur.df(series_2, lag = 0))
# ############################################### 
# # Augmented Dickey-Fuller Test Unit Root Test # 
# ############################################### 
# 
# Test regression none 
# 
# 
# Call:
# lm(formula = z.diff ~ z.lag.1 - 1)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -1576.48   -42.34     0.32    40.23  2365.20 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 -1.55195    0.04784  -32.44   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 187.9 on 304 degrees of freedom
# Multiple R-squared:  0.7759,    Adjusted R-squared:  0.7751 
# F-statistic:  1052 on 1 and 304 DF,  p-value: < 2.2e-16
# 
# 
# Value of test-statistic is: -32.4383 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.58 -1.95 -1.62



par(mfrow = c(1, 2))
acf(series_2, col = "red")
pacf(series_2, col = "blue")



model <- auto.arima(series, d = 2, D = 1, max.p = 2, max.q = 2, max.P = 1, max.Q = 1, trace = TRUE, ic = "aic")
#  Fitting models using approximations to speed things up...
# 
#  ARIMA(2,2,2)(1,1,1)[4]                    : 3845.97
#  ARIMA(0,2,0)(0,1,0)[4]                    : 4292.328
#  ARIMA(1,2,0)(1,1,0)[4]                    : 4074.6
#  ARIMA(0,2,1)(0,1,1)[4]                    : 3861.55
#  ARIMA(2,2,2)(0,1,1)[4]                    : 3835.627
#  ARIMA(2,2,2)(0,1,0)[4]                    : Inf
#  ARIMA(2,2,2)(1,1,0)[4]                    : Inf
#  ARIMA(1,2,2)(0,1,1)[4]                    : Inf
#  ARIMA(2,2,1)(0,1,1)[4]                    : 3850.56
#  ARIMA(1,2,1)(0,1,1)[4]                    : 3846.207
# 
#  Now re-fitting the best model(s) without approximations...
# 
#  ARIMA(2,2,2)(0,1,1)[4]                    : Inf
#  ARIMA(2,2,2)(1,1,1)[4]                    : Inf
#  ARIMA(1,2,1)(0,1,1)[4]                    : Inf
#  ARIMA(2,2,1)(0,1,1)[4]                    : Inf
#  ARIMA(0,2,1)(0,1,1)[4]                    : Inf
#  ARIMA(1,2,0)(1,1,0)[4]                    : 4140.812
# 
#  Best model: ARIMA(1,2,0)(1,1,0)[4]                    
# 
# Warning message:
# In auto.arima(series, d = 2, D = 1, max.p = 2, max.q = 2, max.P = 1,  :
#   Having 3 or more differencing operations is not recommended. Please consider reducing the total number of differences.


model
# Series: series 
# ARIMA(1,2,0)(1,1,0)[4] 
# 
# Coefficients:
#           ar1     sar1
#       -0.5781  -0.5336
# s.e.   0.0469   0.0482
# 
# sigma^2 = 50442:  log likelihood = -2067.41
# AIC=4140.81   AICc=4140.89   BIC=4151.94


resi <- residuals(model)
Box.test(resi)
#         Box-Pierce test
# 
# data:  resi
# X-squared = 14.136, df = 1, p-value = 0.0001701


par(mfrow = c(1, 1))
plot(resi, col = "red")



series_3YR <- tail(model$residuals, 12)
series_3YR
#             Qtr1        Qtr2        Qtr3        Qtr4
# 2021  -468.30283   767.51707 -1253.99629  -107.68595
# 2022   207.19446   612.40142  -970.88399  -237.37904
# 2023   511.58104    27.59923   106.28718  -100.93536


Box.test(series_3YR)
#         Box-Pierce test
# 
# data:  series_3YR
# X-squared = 1.8791, df = 1, p-value = 0.1704




predict(model, n.ahead = 4)
# $pred
#          Qtr1     Qtr2     Qtr3     Qtr4
# 2024 22695.17 22696.14 22896.96 23034.10

# $se
#          Qtr1     Qtr2     Qtr3     Qtr4
# 2024 224.5940 390.4238 625.8742 877.8843



predict(model, n.ahead = 8)
# $pred
#          Qtr1     Qtr2     Qtr3     Qtr4
# 2024 22695.17 22696.14 22896.96 23034.10
# 2025 23103.56 23149.30 23373.57 23519.35

# $se
#           Qtr1      Qtr2      Qtr3      Qtr4
# 2024  224.5940  390.4238  625.8742  877.8843
# 2025 1237.2614 1624.7339 2066.9218 2540.5104


