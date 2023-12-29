
library(car)



data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)
head(data)
#   empid   jpi aptitude   tol technical general
# 1     1 45.52    43.83 55.92     51.82   43.58
# 2     2 40.10    32.71 32.56     51.49   51.03
# 3     3 50.61    56.64 54.84     52.29   52.47
# 4     4 38.97    51.53 59.69     47.48   47.69
# 5     5 41.87    51.35 51.50     47.59   45.77
# 6     6 38.71    39.60 43.63     48.34   42.06



model <- lm(jpi ~ aptitude + technical + general, data = data)
summary(model)
# Call:
# lm(formula = jpi ~ aptitude + technical + general, data = data)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -7.4909 -2.7215  0.5793  2.9169  5.5226 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -54.40644    7.28964  -7.464 3.17e-08 ***
# aptitude      0.33335    0.06361   5.241 1.30e-05 ***
# technical     1.11663    0.17329   6.444 4.75e-07 ***
# general       0.54316    0.15569   3.489  0.00157 ** 
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 3.501 on 29 degrees of freedom
# Multiple R-squared:  0.8758,	Adjusted R-squared:  0.863 
# F-statistic: 68.18 on 3 and 29 DF,  p-value: 3.026e-13



vif(model)
# aptitude technical   general 
# 1.067857  1.945283  2.010262 
