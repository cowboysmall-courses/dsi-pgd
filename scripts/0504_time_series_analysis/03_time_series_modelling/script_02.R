
library(forecast)
library(urca)

data <- read.csv("./data/0504_time_series_analysis/03_time_series_modelling/Sales\ Data\ for\ 3\ Years.csv", header = TRUE)
head(data)

series <- ts(data$Sales, start = c(2013, 1), end = c(2015, 12), frequency = 12)

plot(series, col = "red", main = "Sales Time Series (Simple Plot)")

acf(series, col = "blue")

ndiffs(series)
# 1

df <- ur.df(series, lag = 0)
summary(df)
# 
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
#     Min      1Q  Median      3Q     Max 
# -49.216  -4.668  -1.959   3.965  49.363 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)
# z.lag.1  0.02065    0.01274   1.621    0.114
# 
# Residual standard error: 17.82 on 34 degrees of freedom
# Multiple R-squared:  0.07176,   Adjusted R-squared:  0.04446 
# F-statistic: 2.628 on 1 and 34 DF,  p-value: 0.1142
# 
# 
# Value of test-statistic is: 1.6212 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61


diff1 <- diff(series, differences = 1)
summary(ur.df(diff1, lags = 0))
# 
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
#     Min      1Q  Median      3Q     Max 
# -26.753   1.097   2.598   7.343  55.287 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1  -1.3186     0.1913  -6.891 7.18e-08 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 17.75 on 33 degrees of freedom
# Multiple R-squared:   0.59,     Adjusted R-squared:  0.5776 
# F-statistic: 47.49 on 1 and 33 DF,  p-value: 7.184e-08
# 
# 
# Value of test-statistic is: -6.8914 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61

auto.arima(series, d = 1, D = 1, max.p = 2, max.q = 2, max.P = 2, max.Q = 2, trace = TRUE, ic = "aic")
# 
#  ARIMA(2,1,2)(1,1,1)[12]                    : 157.0397
#  ARIMA(0,1,0)(0,1,0)[12]                    : 156.1096
#  ARIMA(1,1,0)(1,1,0)[12]                    : 159.1271
#  ARIMA(0,1,1)(0,1,1)[12]                    : 159.4057
#  ARIMA(0,1,0)(1,1,0)[12]                    : 157.6536
#  ARIMA(0,1,0)(0,1,1)[12]                    : 157.6536
#  ARIMA(0,1,0)(1,1,1)[12]                    : 159.6536
#  ARIMA(1,1,0)(0,1,0)[12]                    : 157.1806
#  ARIMA(0,1,1)(0,1,0)[12]                    : 157.6069
#  ARIMA(1,1,1)(0,1,0)[12]                    : 154.6016
#  ARIMA(1,1,1)(1,1,0)[12]                    : 161.3531
#  ARIMA(1,1,1)(0,1,1)[12]                    : 156.6
#  ARIMA(1,1,1)(1,1,1)[12]                    : Inf
#  ARIMA(2,1,1)(0,1,0)[12]                    : 152.5563
#  ARIMA(2,1,1)(1,1,0)[12]                    : 153.1015
#  ARIMA(2,1,1)(0,1,1)[12]                    : Inf
#  ARIMA(2,1,1)(1,1,1)[12]                    : 155.0459
#  ARIMA(2,1,0)(0,1,0)[12]                    : 151.6156
#  ARIMA(2,1,0)(1,1,0)[12]                    : 151.8961
#  ARIMA(2,1,0)(0,1,1)[12]                    : Inf
#  ARIMA(2,1,0)(1,1,1)[12]                    : 153.864
# 
#  Best model: ARIMA(2,1,0)(0,1,0)[12]                    
# 
# Series: series 
# ARIMA(2,1,0)(0,1,0)[12] 
# 
# Coefficients:
#          ar1     ar2
#       0.1583  0.6353
# s.e.  0.1545  0.1856
# 
# sigma^2 = 34.14:  log likelihood = -72.81
# AIC=151.62   AICc=152.88   BIC=155.02

model <- arima(series, order = c(2, 1, 0), seasonal = list(order = c(0, 1, 0), period = 12))
coef(model)
#       ar1       ar2 
# 0.1583488 0.6352769 

resi <- residuals(model)
Box.test(resi)
# 
#         Box-Pierce test
# 
# data:  resi
# X-squared = 0.78552, df = 1, p-value = 0.3755

plot(resi, col = "red")

predict(model, n.ahead = 3)
# $pred
#           Jan      Feb      Mar
# 2016 285.6334 292.1748 292.0954
# 
# $se
#            Jan       Feb       Mar
# 2016  5.582376  8.542626 13.268502


