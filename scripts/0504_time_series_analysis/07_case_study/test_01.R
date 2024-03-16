
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


str(data)
# 'data.frame':   308 obs. of  3 variables:
#  $ Year     : int  1947 1947 1947 1947 1948 1948 1948 1948 1949 1949 ...
#  $ Quarter  : int  1 2 3 4 1 2 3 4 1 2 ...
#  $ CROPYIELD: num  2183 2177 2172 2206 2240 ...


nrow(data)
# 308


data_y <- aggregate(CROPYIELD ~ Year, data = data, FUN = sum)


index <- data$Year < 2020
head(index)


train <- data_y[(data_y$Year < 2020), ]
test  <- data_y[(data_y$Year >= 2020), ]


series <- ts(train$CROPYIELD, start = 1947, end = 2019)


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
# -3434.2  -192.6   162.1   557.6  1435.8 

# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1 0.025396   0.001978   12.84   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 716 on 71 degrees of freedom
# Multiple R-squared:  0.6989,    Adjusted R-squared:  0.6947 
# F-statistic: 164.8 on 1 and 71 DF,  p-value: < 2.2e-16


# Value of test-statistic is: 12.8379 

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
# -2173.5  -359.3   104.2   429.4  2956.8 

# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1  -1.2964     0.1149  -11.28   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 783.1 on 69 degrees of freedom
# Multiple R-squared:  0.6485,    Adjusted R-squared:  0.6434 
# F-statistic: 127.3 on 1 and 69 DF,  p-value: < 2.2e-16


# Value of test-statistic is: -11.2834 

# Critical values for test statistics: 
#      1pct  5pct 10pct
# tau1 -2.6 -1.95 -1.61


model <- auto.arima(series, d = 2, max.p = 2, max.q = 2, trace = TRUE, ic = "aic")

#  ARIMA(2,2,2)                    : Inf
#  ARIMA(0,2,0)                    : 1154.445
#  ARIMA(1,2,0)                    : 1149.998
#  ARIMA(0,2,1)                    : 1140.78
#  ARIMA(1,2,1)                    : 1136.349
#  ARIMA(2,2,1)                    : 1138.058
#  ARIMA(1,2,2)                    : 1138.173
#  ARIMA(0,2,2)                    : 1136.536
#  ARIMA(2,2,0)                    : 1149.041

#  Best model: ARIMA(1,2,1)


coef(model)
#        ar1        ma1 
#  0.3273661 -0.9089416 


AIC(model)
# 1136.349


resi <- residuals(model)
Box.test(resi)

#         Box-Pierce test

# data:  resi
# X-squared = 0.022152, df = 1, p-value = 0.8817



plot(resi, col = "darkorange")


predict(model, n.ahead = 4)
# $pred
# Time Series:
# Start = 2020 
# End = 2023 
# Frequency = 1 
# [1] 84466.09 86067.25 87636.80 89195.99

# $se
# Time Series:
# Start = 2020 
# End = 2023 
# Frequency = 1 
# [1]  697.4354 1210.3929 1668.4259 2093.0883


test
#    Year CROPYIELD
# 74 2020  80936.30
# 75 2021  85630.77
# 76 2022  87288.15
# 77 2023  89497.36
