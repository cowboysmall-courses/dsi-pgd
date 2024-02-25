
library(car)



data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)
head(data)
#   empid   jpi aptitude   tol technical general
# 1     1 45.52    43.83 55.92     51.82   43.58
# 2     2 40.10    32.71 32.56     51.49   51.03
# 3     3 50.61    56.64 54.84     52.29   52.47
# 4     4 38.97    51.53 59.69     47.48   47.69
# 5     5 41.87    51.35 51.50     47.59   45.77
# 6     6 38.71    39.60 43.63     48.34   42.06



model <- lm(jpi ~ aptitude + tol + technical + general, data = data)
summary(model)
# Call:
# lm(formula = jpi ~ aptitude + tol + technical + general, data = data)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -7.2891 -2.7692  0.4562  2.8508  5.6068 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -54.28225    7.39453  -7.341 5.41e-08 ***
# aptitude      0.32356    0.06778   4.774 5.15e-05 ***
# tol           0.03337    0.07124   0.468   0.6431    
# technical     1.09547    0.18138   6.039 1.65e-06 ***
# general       0.53683    0.15840   3.389   0.0021 ** 
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 3.549 on 28 degrees of freedom
# Multiple R-squared:  0.8768,	Adjusted R-squared:  0.8592 
# F-statistic: 49.81 on 4 and 28 DF,  p-value: 2.467e-12



data$pred <- fitted(model)
data$resi <- residuals(model)


plot(data$pred, data$resi, col = "cadetblue")


qqnorm(data$resi, col = "cadetblue")
qqline(data$resi, col = "cadetblue")


shapiro.test(data$resi)
# Shapiro-Wilk normality test
# 
# data:  data$resi
# W = 0.94986, p-value = 0.1318
