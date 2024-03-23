
library(forecast)
library(urca)
library(car)
library(lmtest)



data <- read.csv("./data/0504_time_series_analysis/07_case_study/mktmix.csv", header = TRUE)
head(data)



model <- lm(Sales ~ Base_Price + Radio + InStore + TV, data = data)
summary(model)
# Call:
# lm(formula = Sales ~ Base_Price + Radio + InStore + TV, data = data)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -2657.07  -476.97    83.55   555.52  2387.42 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 47572.675   3019.360  15.756  < 2e-16 ***
# Base_Price  -1952.594    191.249 -10.210  < 2e-16 ***
# Radio           1.193      1.109   1.076  0.28467    
# InStore        35.053      7.323   4.787 6.22e-06 ***
# TV              7.444      2.217   3.357  0.00113 ** 
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 957.5 on 95 degrees of freedom
#   (4 observations deleted due to missingness)
# Multiple R-squared:  0.6476,    Adjusted R-squared:  0.6328 
# F-statistic: 43.65 on 4 and 95 DF,  p-value: < 2.2e-16



durbinWatsonTest(model)
#  lag Autocorrelation D-W Statistic p-value
#    1       0.5505479     0.8981617       0
#  Alternative hypothesis: rho != 0



sales <- ts(data$Sales, start = 1, frequency = 52)
xvar  <- subset(data, select = c("Base_Price", "Radio", "InStore", "TV"))
model <- arima(sales, order = c(1, 0, 0), xreg = xvar)

coef(model)
#       ar1     intercept    Base_Price         Radio       InStore 
# 0.6492747 50153.4051044 -2073.0137482    -0.5594487    43.8800372 
#        TV 
# 3.2752311 

coeftest(model)
#               Estimate  Std. Error z value Pr(>|z|)    
# ar1         6.4928e-01  7.7874e-02  8.3375  < 2e-16 ***
# intercept   5.0153e+04  3.3307e+03 15.0580  < 2e-16 ***
# Base_Price -2.0730e+03  2.1284e+02 -9.7397  < 2e-16 ***
# Radio      -5.5945e-01  1.2979e+00 -0.4310  0.66643    
# InStore     4.3880e+01  4.7573e+00  9.2237  < 2e-16 ***
# TV          3.2752e+00  1.7340e+00  1.8888  0.05891 .  
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1



Base_Price <- c(15.64, 15.49)
Radio      <- c(279, 259)
InStore    <- c(41.50, 20.40)
TV         <- c(103.44, 128.40)

xvarnew <- data.frame(Base_Price, Radio, InStore, TV)

predict(model, n.ahead = 2, newxreg = xvarnew)
# $pred
# Time Series:
# Start = c(3, 1) 
# End = c(3, 2) 
# Frequency = 52 
# [1] 19723.55 19205.66

# $se
# Time Series:
# Start = c(3, 1) 
# End = c(3, 2) 
# Frequency = 52 
# [1] 960.8988 964.6413
