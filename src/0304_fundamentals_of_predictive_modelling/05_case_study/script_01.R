
library(reshape2)
library(ggplot2)
library(caret)
library(car)
library(nortest)



# 1 - import data and check the head
data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/case_study/Housing\ Prices.csv", header = TRUE)
head(data)
#      CRIM ZN INDUS CHAS   NOX    RM  AGE    DIS RAD TAX PTRATIO LSTAT MEDV
# 1 0.00632 18  2.31    0 0.538 6.575 65.2 4.0900   1 296    15.3  4.98 24.0
# 2 0.02731  0  7.07    0 0.469 6.421 78.9 4.9671   2 242    17.8  9.14 21.6
# 3 0.02729  0  7.07    0 0.469 7.185 61.1 4.9671   2 242    17.8  4.03 34.7
# 4 0.03237  0  2.18    0 0.458 6.998 45.8 6.0622   3 222    18.7  2.94 33.4
# 5 0.06905  0  2.18    0 0.458 7.147 54.2 6.0622   3 222    18.7  5.33 36.2
# 6 0.02985  0  2.18    0 0.458 6.430 58.7 6.0622   3 222    18.7  5.21 28.7



# 2 - construct a heatmap of correlations
cormat <- round(cor(data), 2)
melted_cormat <- melt(cormat)

ggplot(data = melted_cormat, aes(x = Var1, y = Var2, fill = value)) + 
  geom_tile() +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  scale_fill_gradient2(low = "red", mid = "white" ,high = "blue")



# 3 - split into train and test data
index <- createDataPartition(data$MEDV, p = 0.8, list = FALSE)
train <- data[index, ]
test <- data[-index, ]



# 4 - build the model
model <- lm(MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + LSTAT, data = train)
summary(model)
# Call:
# lm(formula = MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + 
#     DIS + RAD + TAX + PTRATIO + LSTAT, data = train)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -14.6325  -2.7175  -0.6113   1.8679  27.2893 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  42.701296   5.316058   8.033 1.12e-14 ***
# CRIM         -0.105070   0.038807  -2.708 0.007074 ** 
# ZN            0.053577   0.014683   3.649 0.000299 ***
# INDUS         0.019683   0.066020   0.298 0.765754    
# CHAS          3.113000   0.910480   3.419 0.000694 ***
# NOX         -21.809889   4.123753  -5.289 2.05e-07 ***
# RM            3.770041   0.463242   8.138 5.30e-15 ***
# AGE          -0.002293   0.014133  -0.162 0.871173    
# DIS          -1.659567   0.215448  -7.703 1.09e-13 ***
# RAD           0.253963   0.071571   3.548 0.000434 ***
# TAX          -0.011872   0.004031  -2.945 0.003421 ** 
# PTRATIO      -0.938334   0.139328  -6.735 5.83e-11 ***
# LSTAT        -0.491053   0.055941  -8.778  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 4.631 on 394 degrees of freedom
# Multiple R-squared:  0.7494,	Adjusted R-squared:  0.7418 
# F-statistic:  98.2 on 12 and 394 DF,  p-value: < 2.2e-16



# 5 - test for multicollinearity
vif(model)
#     CRIM       ZN    INDUS     CHAS      NOX       RM      AGE      DIS      RAD      TAX  PTRATIO    LSTAT 
# 1.872416 2.327431 3.866056 1.074323 4.361276 2.034520 3.068716 4.019971 7.187934 8.608008 1.739792 3.186220



# 6 - rebuild the model
model <- lm(MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + PTRATIO + LSTAT, data = train)
summary(model)
# Call:
# lm(formula = MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + 
#     DIS + RAD + PTRATIO + LSTAT, data = train)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -15.1020  -2.9354  -0.5403   1.7805  27.4215 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  41.358498   5.347666   7.734 8.76e-14 ***
# CRIM         -0.104955   0.039182  -2.679  0.00770 ** 
# ZN            0.045567   0.014568   3.128  0.00189 ** 
# INDUS        -0.064170   0.060140  -1.067  0.28662    
# CHAS          3.449420   0.912017   3.782  0.00018 ***
# NOX         -23.114325   4.139528  -5.584 4.38e-08 ***
# RM            3.866785   0.466543   8.288 1.82e-15 ***
# AGE          -0.003414   0.014264  -0.239  0.81098    
# DIS          -1.694886   0.217193  -7.804 5.44e-14 ***
# RAD           0.088462   0.044750   1.977  0.04876 *  
# PTRATIO      -0.974163   0.140137  -6.951 1.50e-11 ***
# LSTAT        -0.485406   0.056448  -8.599  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 4.675 on 395 degrees of freedom
# Multiple R-squared:  0.7439,	Adjusted R-squared:  0.7368 
# F-statistic: 104.3 on 11 and 395 DF,  p-value: < 2.2e-16



# 7 - test again for multicollinearity
vif(model)
#     CRIM       ZN    INDUS     CHAS      NOX       RM      AGE      DIS      RAD  PTRATIO    LSTAT 
# 1.872414 2.247560 3.146984 1.057412 4.310962 2.024289 3.066493 4.007515 2.756502 1.726527 3.182476



# 8 - predicted and residual values
train$pred <- fitted(model)
train$resi <- residuals(model)



# 9 - residual analysis
plot(train$pred, train$resi)

qqnorm(train$resi)
qqline(train$resi, lwd = 2)


shapiro.test(train$resi)
#         Shapiro-Wilk normality test
# 
# data:  train$resi
# W = 0.92006, p-value = 6.879e-14


lillie.test(train$resi)
#         Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  train$resi
# D = 0.10857, p-value = 1.757e-12



# 10 - rebuild the model
model <- lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = train)
summary(model)
# Call:
# lm(formula = MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + 
#     PTRATIO + LSTAT, data = train)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -15.1768  -2.9953  -0.6303   1.7651  27.2216 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  41.64056    5.32139   7.825 4.64e-14 ***
# CRIM         -0.10204    0.03905  -2.613 0.009318 ** 
# ZN            0.04620    0.01449   3.189 0.001543 ** 
# CHAS          3.39006    0.90948   3.727 0.000222 ***
# NOX         -24.87408    3.73423  -6.661 9.09e-11 ***
# RM            3.90270    0.45305   8.614  < 2e-16 ***
# DIS          -1.63255    0.20267  -8.055 9.36e-15 ***
# RAD           0.08266    0.04399   1.879 0.060949 .  
# PTRATIO      -1.00260    0.13731  -7.302 1.56e-12 ***
# LSTAT        -0.49662    0.05277  -9.412  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 4.671 on 397 degrees of freedom
# Multiple R-squared:  0.7431,	Adjusted R-squared:  0.7373 
# F-statistic: 127.6 on 9 and 397 DF,  p-value: < 2.2e-16



# 11 - test again for multicollinearity
vif(model)
#     CRIM       ZN     CHAS      NOX       RM      DIS      RAD  PTRATIO    LSTAT 
# 1.863808 2.227534 1.053661 3.515177 1.912751 3.496360 2.668532 1.660783 2.786358



# 12 - model validation
train$pred <- fitted(model)
train$resi <- residuals(model)

sqrt(mean(train$resi ** 2))
# 4.612932

test$pred <- predict(model, test)
test$resi <- test$MEDV - test$pred

sqrt(mean(test$resi ** 2))
# 5.575676



# 13 - k-fold cross validation
kfolds <- trainControl(method = "cv", number = 4)
kmodel <- train(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = data, method = "lm", trControl = kfolds)
kmodel
# Linear Regression 
# 
# 506 samples
#   9 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (4 fold) 
# Summary of sample sizes: 379, 379, 380, 380 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   5.027415  0.7015474  3.568052
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE


kfolds <- trainControl(method = "cv", number = 5)
kmodel <- train(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = data, method = "lm", trControl = kfolds)
kmodel
# Linear Regression 
# 
# 506 samples
#   9 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 405, 404, 405, 406, 404 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   4.887044  0.7229968  3.487032
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE



# 14 - final model validation
model <- lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = data)
summary(model)
# Call:
# lm(formula = MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + 
#     PTRATIO + LSTAT, data = data)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -15.8550  -2.9880  -0.5477   1.8770  26.4105 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  39.98405    4.94523   8.085 4.78e-15 ***
# CRIM         -0.11854    0.03330  -3.559 0.000407 ***
# ZN            0.03658    0.01357   2.695 0.007279 ** 
# CHAS          3.13944    0.86975   3.610 0.000338 ***
# NOX         -21.37566    3.50093  -6.106 2.07e-09 ***
# RM            3.85056    0.41105   9.368  < 2e-16 ***
# DIS          -1.45079    0.18905  -7.674 8.92e-14 ***
# RAD           0.10457    0.04071   2.569 0.010495 *  
# PTRATIO      -1.00175    0.13049  -7.677 8.74e-14 ***
# LSTAT        -0.55346    0.04797 -11.537  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 4.847 on 496 degrees of freedom
# Multiple R-squared:  0.7273,	Adjusted R-squared:  0.7223 
# F-statistic: 146.9 on 9 and 496 DF,  p-value: < 2.2e-16

vif(model)
#     CRIM       ZN     CHAS      NOX       RM      DIS      RAD  PTRATIO    LSTAT 
# 1.764257 2.154051 1.049185 3.538215 1.793239 3.407113 2.701027 1.715836 2.523246

data$pred <- predict(model, data)
data$resi <- data$MEDV - data$pred

sqrt(mean(data$resi ** 2))
# 4.79846
