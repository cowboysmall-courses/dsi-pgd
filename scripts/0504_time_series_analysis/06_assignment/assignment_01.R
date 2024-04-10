
library(forecast)
library(urca)



data <- read.csv("./data/0504_time_series_analysis/06_assignment/USA\ FIRM\ SALES\ DATA.csv", header = TRUE)
head(data)
#   Year    Month   BU1   BU2   BU3
# 1 2015 February 125.1 115.5 113.8
# 2 2015    March 123.6 115.7 113.8
# 3 2015    April 123.1 116.5 114.0
# 4 2015      May 123.1 117.7 114.1
# 5 2015     June 123.4 118.3 114.7
# 6 2015     July 124.0 118.7 115.1


series1 <- ts(data$BU1, start = c(2015, 2), end = c(2017, 12), frequency = 12)
series2 <- ts(data$BU2, start = c(2015, 2), end = c(2017, 12), frequency = 12)
series3 <- ts(data$BU3, start = c(2015, 2), end = c(2017, 12), frequency = 12)


par(mfrow = c(3, 2))
plot(series1, col = "red")
acf(series1, col = "blue")
plot(series2, col = "red")
acf(series2, col = "blue")
plot(series3, col = "red")
acf(series3, col = "blue")


df1 <- ur.df(series1, lag = 0)
summary(df1)
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
# -2.5155 -0.9112 -0.0464  0.9743  3.3873 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)
# z.lag.1 0.003053   0.001813   1.683    0.102
# 
# Residual standard error: 1.393 on 33 degrees of freedom
# Multiple R-squared:  0.07908,   Adjusted R-squared:  0.05118 
# F-statistic: 2.834 on 1 and 33 DF,  p-value: 0.1017
# 
# 
# Value of test-statistic is: 1.6834 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61

df2 <- ur.df(series2, lag = 0)
summary(df2)
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
#      Min       1Q   Median       3Q      Max 
# -1.15497 -0.24878  0.00298  0.23616  1.13801 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 0.003696   0.000698   5.295 7.73e-06 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.5008 on 33 degrees of freedom
# Multiple R-squared:  0.4593,    Adjusted R-squared:  0.4429 
# F-statistic: 28.03 on 1 and 33 DF,  p-value: 7.73e-06
# 
# 
# Value of test-statistic is: 5.2948 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61

df3 <- ur.df(series3, lag = 0)
summary(df3)
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
#      Min       1Q   Median       3Q      Max 
# -0.41987 -0.19906 -0.01936  0.21336  0.61369 
# 
# Coefficients:
#          Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 0.0033563  0.0003955   8.486 8.33e-10 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.2772 on 33 degrees of freedom
# Multiple R-squared:  0.6858,    Adjusted R-squared:  0.6762 
# F-statistic: 72.01 on 1 and 33 DF,  p-value: 8.332e-10
# 
# 
# Value of test-statistic is: 8.4861 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61


ndiffs1 <- ndiffs(series1, test = "adf")
ndiffs1
# 1

ndiffs2 <- ndiffs(series2, test = "adf")
ndiffs2
# 1

ndiffs3 <- ndiffs(series3, test = "adf")
ndiffs3
# 1


diff1 <- diff(series1, differences = ndiffs1)
diff2 <- diff(series2, differences = ndiffs2)
diff3 <- diff(series3, differences = ndiffs3)


par(mfrow = c(3, 2))
plot(diff1, col = "red")
acf(diff1, col = "blue")
plot(diff2, col = "red")
acf(diff2, col = "blue")
plot(diff3, col = "red")
acf(diff3, col = "blue")



df4 <- ur.df(diff1, lag = 0)
summary(df4)
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
# -2.5074 -0.4044  0.3000  0.6940  2.9493 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)   
# z.lag.1  -0.4329     0.1461  -2.963  0.00571 **
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.195 on 32 degrees of freedom
# Multiple R-squared:  0.2153,    Adjusted R-squared:  0.1908 
# F-statistic: 8.779 on 1 and 32 DF,  p-value: 0.005709
# 
# 
# Value of test-statistic is: -2.9629 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61

df5 <- ur.df(diff2, lag = 0)
summary(df5)
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
#      Min       1Q   Median       3Q      Max 
# -0.94456 -0.08911  0.29430  0.52747  1.17203 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)  
# z.lag.1  -0.3886     0.1507  -2.578   0.0147 *
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.5614 on 32 degrees of freedom
# Multiple R-squared:  0.172,     Adjusted R-squared:  0.1461 
# F-statistic: 6.646 on 1 and 32 DF,  p-value: 0.01475
# 
# 
# Value of test-statistic is: -2.578 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61

df6 <- ur.df(diff3, lag = 0)
summary(df6)
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
#      Min       1Q   Median       3Q      Max 
# -0.53971 -0.09314  0.03562  0.23562  0.67124 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)
# z.lag.1  -0.1781     0.1103  -1.615    0.116
# 
# Residual standard error: 0.3036 on 32 degrees of freedom
# Multiple R-squared:  0.07537,   Adjusted R-squared:  0.04648 
# F-statistic: 2.608 on 1 and 32 DF,  p-value: 0.1161
# 
# 
# Value of test-statistic is: -1.6151 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.62 -1.95 -1.61




model1 <- auto.arima(series1, d = 1, max.p = 2, max.q = 2, trace = TRUE, ic = "aic")
# 
#  ARIMA(2,1,2)(0,1,0)[12]                    : Inf
#  ARIMA(0,1,0)(0,1,0)[12]                    : 78.21463
#  ARIMA(1,1,0)(0,1,0)[12]                    : 76.95402
#  ARIMA(0,1,1)(0,1,0)[12]                    : 73.7662
#  ARIMA(1,1,1)(0,1,0)[12]                    : Inf
#  ARIMA(0,1,2)(0,1,0)[12]                    : Inf
#  ARIMA(1,1,2)(0,1,0)[12]                    : Inf
# 
#  Best model: ARIMA(0,1,1)(0,1,0)[12] 

coef(model1)
#       ma1 
# 0.7168853 

AIC(model1)
# 73.7662

resi1 <- residuals(model1)
resi1

Box.test(resi1)
# 
#         Box-Pierce test
# 
# data:  resi1
# X-squared = 0.36574, df = 1, p-value = 0.5453



model2 <- auto.arima(series2, d = 1, max.p = 2, max.q = 2, trace = TRUE, ic = "aic")
# 
#  ARIMA(2,1,2)            with drift         : Inf
#  ARIMA(0,1,0)            with drift         : 52.31335
#  ARIMA(1,1,0)            with drift         : 52.47872
#  ARIMA(0,1,1)            with drift         : 51.75392
#  ARIMA(0,1,0)                               : 71.36077
#  ARIMA(1,1,1)            with drift         : 53.39991
#  ARIMA(0,1,2)            with drift         : 53.34526
#  ARIMA(1,1,2)            with drift         : Inf
#  ARIMA(0,1,1)                               : 62.72611
# 
#  Best model: ARIMA(0,1,1)            with drift 

coef(model2)
#       ma1     drift 
# 0.3219106 0.4606218 

AIC(model2)
# 51.75392

resi2 <- residuals(model2)
resi2

Box.test(resi2)
# 
#         Box-Pierce test
# 
# data:  resi2
# X-squared = 0.023036, df = 1, p-value = 0.8794





model3 <- auto.arima(series3, d = 1, max.p = 2, max.q = 2, trace = TRUE, ic = "aic")
# 
#  ARIMA(2,1,2)            with drift         : Inf
#  ARIMA(0,1,0)            with drift         : 12.41481
#  ARIMA(1,1,0)            with drift         : 10.30528
#  ARIMA(0,1,1)            with drift         : 10.21436
#  ARIMA(0,1,0)                               : 49.58878
#  ARIMA(1,1,1)            with drift         : 11.94784
#  ARIMA(0,1,2)            with drift         : 11.35799
#  ARIMA(1,1,2)            with drift         : 11.68784
#  ARIMA(0,1,1)                               : 33.43813
# 
#  Best model: ARIMA(0,1,1)            with drift   

coef(model3)
#       ma1     drift 
# 0.3322898 0.4006291

AIC(model3)
# 10.21436

resi3 <- residuals(model3)
resi3

Box.test(resi3)

#         Box-Pierce test

# data:  resi3
# X-squared = 0.0041724, df = 1, p-value = 0.9485


par(mfrow = c(3, 1))
plot(resi1, col = "darkorange")
plot(resi2, col = "darkorange")
plot(resi3, col = "darkorange")


predict(model1, n.ahead = 3)
# $pred
#           Jan      Feb      Mar
# 2018 138.9859 138.0859 135.9859
# 
# $se
#           Jan      Feb      Mar
# 2018 1.193145 2.370636 3.133087

forecast(model1, h = 3)
#          Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95
# Jan 2018       138.9859 137.4568 140.5150 136.6474 141.3244
# Feb 2018       138.0859 135.0478 141.1240 133.4395 142.7322
# Mar 2018       135.9859 131.9707 140.0011 129.8451 142.1266

forecast(model2, h = 3)
#          Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95
# Jan 2018       131.7179 131.0919 132.3439 130.7605 132.6752
# Feb 2018       132.1785 131.1409 133.2161 130.5917 133.7653
# Mar 2018       132.6391 131.3120 133.9663 130.6094 134.6688

forecast(model3, h = 3)
#          Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95
# Jan 2018       127.9471 127.6066 128.2875 127.4264 128.4678
# Feb 2018       128.3477 127.7806 128.9149 127.4803 129.2151
# Mar 2018       128.7483 128.0221 129.4746 127.6377 129.8590
