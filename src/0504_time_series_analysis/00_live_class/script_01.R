
library(forecast)
library(urca)



data <- read.csv("./data/0504_time_series_analysis/00_live_class/Sales\ Time\ Series\ Data.csv", header = TRUE)
head(data)
#   Year Month Sales
# 1 2014   Jan 223.0
# 2 2014   Feb 232.5
# 3 2014   Mar 233.8
# 4 2014   Apr 241.1
# 5 2014   May 240.0
# 6 2014   Jun 245.6


series <- ts(data$Sales, start = c(2014, 1), end = c(2015, 12), frequency = 12)
diff   <- diff(series, differences = 1)



par(mfrow = c(2, 2))
plot(series, col = "red")
acf(series, col = "blue")
plot(diff, col = "red")
acf(diff, col = "blue")


ndiffs(series)
#  1


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
#     Min      1Q  Median      3Q     Max 
# -3.1516 -1.4115 -0.9273  1.2374  7.6025 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)   
# z.lag.1 0.008509   0.002309   3.686  0.00129 **
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.817 on 22 degrees of freedom
# Multiple R-squared:  0.3817,    Adjusted R-squared:  0.3536 
# F-statistic: 13.58 on 1 and 22 DF,  p-value: 0.001294
# 
# 
# Value of test-statistic is: 3.6856 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.66 -1.95  -1.6


summary(ur.df(diff, lag = 0))
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
# -2.4364 -0.0190  0.9493  2.6075  7.0620 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1  -0.8169     0.1763  -4.635 0.000143 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.95 on 21 degrees of freedom
# Multiple R-squared:  0.5057,    Adjusted R-squared:  0.4821 
# F-statistic: 21.48 on 1 and 21 DF,  p-value: 0.0001425
# 
# 
# Value of test-statistic is: -4.6349 
# 
# Critical values for test statistics: 
#       1pct  5pct 10pct
# tau1 -2.66 -1.95  -1.6

