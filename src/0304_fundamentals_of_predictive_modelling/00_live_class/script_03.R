
library(nortest)
library(car)
library(GGally)
library(caret)



# 1 - Load the data...
data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_live_class/Motor_Claims.csv", header = TRUE)
head(data)



# 2 - Model generation...
model <- lm(claimamt ~ Length + CC + vehage + Weight, data = data)
summary(model)
# Call:
# lm(formula = claimamt ~ Length + CC + vehage + Weight, data = data)
# 
# Residuals:
#    Min     1Q Median     3Q    Max 
# -45577  -8007     39   7852  40561 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -54765.128   5569.375  -9.833  < 2e-16 ***
# Length          35.461      1.990  17.824  < 2e-16 ***
# CC              15.413      2.114   7.292 6.23e-13 ***
# vehage       -6637.213    154.098 -43.071  < 2e-16 ***
# Weight         -16.255      3.678  -4.420 1.10e-05 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 11360 on 995 degrees of freedom
# Multiple R-squared:  0.7379,	Adjusted R-squared:  0.7368 
# F-statistic: 700.3 on 4 and 995 DF,  p-value: < 2.2e-16

vif(model)
#   Length       CC   vehage   Weight
# 3.396171 5.881428 1.038357 6.552811

model <- lm(claimamt ~ Length + CC + vehage, data = data)
summary(model)
# Call:
# lm(formula = claimamt ~ Length + CC + vehage, data = data)
# 
# Residuals:
#    Min     1Q Median     3Q    Max 
# -47069  -7673    -14   7783  40447 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -49195.196   5475.151  -8.985  < 2e-16 ***
# Length          32.065      1.852  17.312  < 2e-16 ***
# CC               8.689      1.481   5.867 6.02e-09 ***
# vehage       -6638.076    155.525 -42.682  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 11470 on 996 degrees of freedom
# Multiple R-squared:  0.7327,	Adjusted R-squared:  0.7319 
# F-statistic: 910.3 on 3 and 996 DF,  p-value: < 2.2e-16

vif(model)
#   Length       CC   vehage 
# 2.889718 2.833931 1.038355



# 3 - RMSE calculation for the generated model...
resi <- residuals(model)
sqrt(mean(resi ** 2))
# [1] 11444.51



# 4 - Hold Back Cross Validation - Train / Test Split 
set.seed(12345)

index <- createDataPartition(data$claimamt, p = 0.8, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]

dim(train)
dim(test)

train_model <- lm(claimamt ~ Length + CC + vehage, data = train)
train$resi  <- residuals(train_model)
head(train)
sqrt(mean(train$resi ** 2))
# [1] 11198.8

test$pred <- predict(train_model, test)
test$resi <- test$claimamt - test$pred
sqrt(mean(test$resi ** 2))
# [1] 12463.06



# 5 - K-Fold Cross Validation for K = 4

set.seed(12345)

kfolds <- trainControl(method = "cv", number = 4)
train(claimamt ~ Length + CC + vehage, data = data, method = "lm", trControl = kfolds)
# Linear Regression 
# 
# 1000 samples
#    3 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (4 fold) 
# Summary of sample sizes: 751, 749, 750, 750 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   11500.13  0.7306014  9043.211
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE



# 6 - K-Fold Cross Validation for K = 5

set.seed(12345)

kfolds <- trainControl(method = "cv", number = 5)
train(claimamt ~ Length + CC + vehage, data = data, method = "lm", trControl = kfolds)
# Linear Regression 
# 
# 1000 samples
#    3 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 800, 800, 800, 800, 800 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   11520.49  0.7333074  9058.269
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE
