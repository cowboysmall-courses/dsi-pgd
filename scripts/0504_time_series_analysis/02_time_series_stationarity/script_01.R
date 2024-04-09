
library(forecast)
library(urca)

data <- read.csv("./data/0504_time_series_analysis/02_time_series_stationarity/turnover_annual.csv", header = TRUE)
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
acf(series, col = "blue")

diff1 <- diff(series, difference = 1)
plot(diff1, main = "Sales Differenced Time Series")
acf(diff1, col = "blue")


ndiffs(series)
# 2


diff2 <- diff(series, difference = 2)
plot(diff2, col = "red")
acf(diff2, col = "blue")


df <- ur.df(series, lag = 0)
summary(df)
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
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
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


df <- ur.df(diff2, lag = 0)
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
# -69843  -8676   7079  22229  84580 
# 
# Coefficients:
#         Estimate Std. Error t value Pr(>|t|)    
# z.lag.1  -1.4639     0.1229  -11.91   <2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 27740 on 53 degrees of freedom
# Multiple R-squared:  0.7279,    Adjusted R-squared:  0.7228 
# F-statistic: 141.8 on 1 and 53 DF,  p-value: < 2.2e-16
# 
# 
# Value of test-statistic is: -11.9083 
# 
# Critical values for test statistics: 
#      1pct  5pct 10pct
# tau1 -2.6 -1.95 -1.61





