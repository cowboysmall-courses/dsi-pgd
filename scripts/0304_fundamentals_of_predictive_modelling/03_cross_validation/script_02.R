
library(car)
library(caret)




data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/03_cross_validation/Motor_Claims.csv", header = TRUE)
head(data)
#   vehage   CC Length Weight claimamt
# 1      4 1495   4250   1023  72000.0
# 2      2 1061   3495    875  72000.0
# 3      2 1405   3675    980  50400.0
# 4      7 1298   4090    930  39960.0
# 5      2 1495   4250   1023 106800.0
# 6      1 1086   3565    854  69592.8




index <- createDataPartition(data$claimamt, p = 0.8, list = FALSE)
head(index)
#      Resample1
# [1,]         1
# [2,]         2
# [3,]         3
# [4,]         4
# [5,]         5
# [6,]         6
dim(index)
# [1] 800   1




train <- data[index, ]
test  <- data[-index, ]
dim(train)
# [1] 800   5
dim(test)
# [1] 200   5




train_model <- lm(claimamt ~ Length + CC + vehage, data = train)
train$resi  <- residuals(train_model)
head(train)
#   vehage   CC Length Weight claimamt       resi
# 1      4 1495   4250   1023  72000.0  -1348.050
# 2      2 1061   3495    875  72000.0  13503.225
# 3      2 1405   3675    980  50400.0 -17041.134
# 4      7 1298   4090    930  39960.0  -6271.298
# 5      2 1495   4250   1023 106800.0  20011.402
# 6      1 1086   3565    854  69592.8   1892.001




sqrt(mean(train$resi ** 2))
# [1] 11165.62




test$pred <- predict(train_model, test)
test$resi <- test$claimamt - test$pred
head(test)
#    vehage   CC Length Weight claimamt     pred       resi
# 19      2 1396   3675    980  57216.0 67358.84 -10142.842
# 20      2 1405   3675    980  60561.6 67441.13  -6879.534
# 21      4 2609   4325   1880  81240.0 85950.17  -4710.175
# 27      3 1405   3675    980  60240.0 60720.86   -480.860
# 34      2  796   3335    665  42240.0 50919.09  -8679.086
# 39      1 1405   3675    980  96242.9 74161.41  22081.496




sqrt(mean(test$resi ** 2))
# [1] 12530.66
