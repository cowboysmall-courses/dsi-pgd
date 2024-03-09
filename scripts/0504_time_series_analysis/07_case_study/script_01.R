
library(forecast)
library(urca)


data <- read.csv("./data/0504_time_series_analysis/07_case_study/CROP\ DATA.csv", header = TRUE)
head(data)
#   Year Quarter CROPYIELD
# 1 1947       1  2182.681
# 2 1947       2  2176.892
# 3 1947       3  2172.432
# 4 1947       4  2206.452
# 5 1948       1  2239.682
# 6 1948       2  2276.690


nrow(data)
# 308


data_y <- aggregate(CROPYIELD ~ Year, data = data, FUN = sum)


series <- ts(data_y$CROPYIELD, start = 1947, end = 2023)


plot(series, col = "red")
acf(series, col = "blue")


df <- ur.df(series, lag = 0)
summary(df)

# ############################################### 
# # Augmented Dickey-Fuller Test Unit Root Test # 
# ############################################### 

# Test regression none 


# Call:
# lm(formula = z.diff ~ z.lag.1 - 1)

# Residuals:
#     Min      1Q  Median      3Q     Max 
# -3852.5  -220.7   192.8   568.3  2718.8 

# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 0.024411   0.002221   10.99   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 886.6 on 75 degrees of freedom
# Multiple R-squared:  0.617,     Adjusted R-squared:  0.6119 
# F-statistic: 120.8 on 1 and 75 DF,  p-value: < 2.2e-16


# Value of test-statistic is: 10.9911 

# Critical values for test statistics: 
#      1pct  5pct 10pct
# tau1 -2.6 -1.95 -1.61


ndiffs(series)
# 2


diff2 <- diff(series, differences = 2)


par(mfrow = c(1, 2))
acf_plot <- acf(diff2, main = "ACF Plot")
pacf_plot <- pacf(diff2, main = "PACF Plot")


par(mfrow = c(1, 1))


df2 <- ur.df(diff2, lag = 0)
summary(df2)

# ############################################### 
# # Augmented Dickey-Fuller Test Unit Root Test # 
# ############################################### 

# Test regression none 


# Call:
# lm(formula = z.diff ~ z.lag.1 - 1)

# Residuals:
#     Min      1Q  Median      3Q     Max 
# -3999.3  -439.3   122.1   478.0  4531.4 

# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 -1.52163    0.09994  -15.23   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 1062 on 73 degrees of freedom
# Multiple R-squared:  0.7605,    Adjusted R-squared:  0.7572 
# F-statistic: 231.8 on 1 and 73 DF,  p-value: < 2.2e-16


# Value of test-statistic is: -15.2256 

# Critical values for test statistics: 
#      1pct  5pct 10pct
# tau1 -2.6 -1.95 -1.61


model <- auto.arima(series, d = 2, max.p = 2, max.q = 2, trace = TRUE, ic = "aic")

#  ARIMA(2,2,2)                    : 1244.935
#  ARIMA(0,2,0)                    : 1281.959
#  ARIMA(1,2,0)                    : 1260.488
#  ARIMA(0,2,1)                    : 1239.208
#  ARIMA(1,2,1)                    : 1241.172
#  ARIMA(0,2,2)                    : 1241.173
#  ARIMA(1,2,2)                    : 1243.015

#  Best model: ARIMA(0,2,1)     


coef(model)
#        ma1 
# -0.8961226 


AIC(model)
# 1239.208


resi <- residuals(model)
Box.test(resi)

#         Box-Pierce test

# data:  resi
# X-squared = 0.30544, df = 1, p-value = 0.5805



plot(resi, col = "darkorange")


predict(model, n.ahead = 1)
# $pred
# Time Series:
# Start = 2024 
# End = 2024 
# Frequency = 1 
# [1] 91144.54

# $se
# Time Series:
# Start = 2024 
# End = 2024 
# Frequency = 1 
# [1] 908.3818






