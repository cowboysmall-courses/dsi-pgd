
library(car)
library(caret)




data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/cross_validation/Motor_Claims.csv", header = TRUE)
head(data)
#   vehage   CC Length Weight claimamt
# 1      4 1495   4250   1023  72000.0
# 2      2 1061   3495    875  72000.0
# 3      2 1405   3675    980  50400.0
# 4      7 1298   4090    930  39960.0
# 5      2 1495   4250   1023 106800.0
# 6      1 1086   3565    854  69592.8




kfolds <- trainControl(method = "cv", number = 4)
train(claimamt ~ Length + CC + vehage, data = data, method = "lm", trControl = kfolds)
# Linear Regression 
# 
# 1000 samples
#    3 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (4 fold) 
# Summary of sample sizes: 750, 751, 750, 749 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   11528.79  0.7289759  9051.445
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE




kfolds <- trainControl(method = "repeatedcv", number = 4, repeats = 5)
train(claimamt ~ Length + CC + vehage, data = data, method = "lm", trControl = kfolds)
# Linear Regression 
# 
# 1000 samples
#    3 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (4 fold, repeated 5 times) 
# Summary of sample sizes: 749, 752, 749, 750, 750, 750, ... 
# Resampling results:
#   
#   RMSE      Rsquared  MAE     
#   11517.02  0.732191  9034.696
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE




kfolds <- trainControl(method = "LOOCV")
train(claimamt ~ Length + CC + vehage, data = data, method = "lm", trControl = kfolds)
# Linear Regression 
# 
# 1000 samples
#    3 predictor
# 
# No pre-processing
# Resampling: Leave-One-Out Cross-Validation 
# Summary of sample sizes: 999, 999, 999, 999, 999, 999, ... 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   11515.85  0.7294088  9039.582
# 
# Tuning parameter 'intercept' was held constant at a value of TRU




kfolds <- trainControl(method = "boot")
train(claimamt ~ Length + CC + vehage, data = data, method = "lm", trControl = kfolds)
# Linear Regression 
# 
# 1000 samples
#    3 predictor
# 
# No pre-processing
# Resampling: Bootstrapped (25 reps) 
# Summary of sample sizes: 1000, 1000, 1000, 1000, 1000, 1000, ... 
# Resampling results:
#   
#   RMSE      Rsquared   MAE   
#   11559.46  0.7323465  9017.1
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE
