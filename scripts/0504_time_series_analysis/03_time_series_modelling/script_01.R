
library(forecast)
library(urca)

data <- read.csv("./data/0504_time_series_analysis/03_time_series_modelling/turnover_annual.csv", header = TRUE)
head(data)
#   Year  sales
# 1 1961 224786
# 2 1962 230034
# 3 1963 236562
# 4 1964 250960
# 5 1965 261615
# 6 1966 268316

series <- ts(data$sales, start = 1961, end = 2017)
plot(series, col = "red", main = "Sales Time Series (Simple Plot)")

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
#    Min     1Q Median     3Q    Max 
# -73514 -19075  -8490   3412  76065 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 0.064334   0.003338   19.27   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 25950 on 55 degrees of freedom
# Multiple R-squared:  0.871,     Adjusted R-squared:  0.8687 
# F-statistic: 371.5 on 1 and 55 DF,  p-value: < 2.2e-16
# 
# 
# Value of test-statistic is: 19.2745 
# 
# Critical values for test statistics: 
#      1pct  5pct 10pct
# tau1 -2.6 -1.95 -1.61

ndiffs(series)
# 2

diff2 <- diff(series, differences = 2)
plot(diff2, col = "red")
acf(diff2, col = "blue")

model <- arima(series, order = c(2, 2, 2))

coef(model)
#        ar1        ar2        ma1        ma2 
# -1.2355735 -0.6701038  0.7851143  0.3295140 

AIC(model)
# 1285.984

auto.arima(series, d = 2, max.p = 2, max.q = 2, trace = TRUE, ic = "aic")
# 
#  ARIMA(2,2,2)                    : 1285.984
#  ARIMA(0,2,0)                    : 1294.497
#  ARIMA(1,2,0)                    : 1283.644
#  ARIMA(0,2,1)                    : 1285.212
#  ARIMA(2,2,0)                    : 1285.114
#  ARIMA(1,2,1)                    : 1285.361
#  ARIMA(2,2,1)                    : 1283.568
#  ARIMA(1,2,2)                    : 1286.479
# 
#  Best model: ARIMA(2,2,1)                    
# 
# Series: series 
# ARIMA(2,2,1) 
# 
# Coefficients:
#           ar1      ar2     ma1
#       -1.3949  -0.5100  0.9727
# s.e.   0.1171   0.1168  0.1019
# 
# sigma^2 = 714703485:  log likelihood = -637.78
# AIC=1283.57   AICc=1284.37   BIC=1291.6

model <- arima(series, order = c(2, 2, 1))

coef(model)
#        ar1        ar2        ma1 
# -1.3948728 -0.5100167  0.9726748 

AIC(model)
# 1283.568

resi <- residuals(model)

Box.test(resi)
# 
#         Box-Pierce test
# 
# data:  resi
# X-squared = 0.17544, df = 1, p-value = 0.6753

plot(resi, col = "red")

predict(model, n.ahead = 3)
# $pred
# Time Series:
# Start = 2018 
# End = 2020 
# Frequency = 1 
# [1] 3072045 3308799 3537673

# $se
# Time Series:
# Start = 2018 
# End = 2020 
# Frequency = 1 
# [1] 26017.21 48562.55 75729.34



