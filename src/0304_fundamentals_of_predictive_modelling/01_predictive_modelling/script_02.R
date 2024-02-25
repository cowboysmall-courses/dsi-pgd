
library(lm.beta)


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
model
# Call:
# lm(formula = jpi ~ aptitude + tol + technical + general, data = data)
# 
# Coefficients:
# (Intercept)     aptitude          tol    technical      general  
#   -54.28225      0.32356      0.03337      1.09547      0.53683

summary(model)
# Call:
# lm(formula = jpi ~ aptitude + tol + technical + general, data = data)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -7.2891 -2.7692  0.4562  2.8508  5.6068 
# 
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
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


model <- lm(jpi ~ aptitude + technical + general, data = data)
model
# Call:
# lm(formula = jpi ~ aptitude + technical + general, data = data)
# 
# Coefficients:
# (Intercept)     aptitude    technical      general  
#    -54.4064       0.3333       1.1166       0.5432

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


data$pred <- fitted(model)
data$resi <- residuals(model)

head(data)
#   empid   jpi aptitude   tol technical general     pred      resi
# 1     1 45.52    43.83 55.92     51.82   43.58 41.73850  3.781497
# 2     2 40.10    32.71 32.56     51.49   51.03 41.70973 -1.609731
# 3     3 50.61    56.64 54.84     52.29   52.47 51.36215 -0.752151
# 4     4 38.97    51.53 59.69     47.48   47.69 41.69149 -2.721486
# 5     5 41.87    51.35 51.50     47.59   45.77 40.71145  1.158549
# 6     6 38.71    39.60 43.63     48.34   42.06 35.61699  3.093010


test_data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index\ new.csv", header = TRUE)
test_data$pred <- predict(model, test_data)

head(test_data)
#   empid   jpi   tol technical general aptitude     pred
# 1    34 66.35 59.20     57.18   54.98    66.74 61.55258
# 2    35 56.10 64.92     52.51   55.78    55.45 53.00898
# 3    36 48.95 63.59     57.76   52.08    51.73 55.62154
# 4    37 43.25 64.90     50.13   42.75    45.09 39.82060
# 5    38 41.20 51.50     47.89   45.77    50.85 40.87977
# 6    39 50.24 55.77     51.13   47.98    53.86 46.70139


predict(model, test_data, interval = "confidence")
#        fit      lwr      upr
# 1 61.55258 59.00956 64.09559
# 2 53.00898 50.67792 55.34004
# 3 55.62154 53.65401 57.58906
# 4 39.82060 37.73390 41.90730
# 5 40.87977 39.23364 42.52590
# 6 46.70139 45.41627 47.98650


lm.beta(model)
# Call:
# lm(formula = jpi ~ aptitude + technical + general, data = data)
# 
# Standardized Coefficients::
# (Intercept)    aptitude   technical     general 
#          NA   0.3543742   0.5880966   0.3236793 
