
library(randomForest)

empdata <- read.csv("./data/0804_machine_learning_02/02_random_forest/EMPLOYEE CHURN DATA.csv", header = TRUE)
head(empdata)
#   sn status function.         exp gender   source
# 1  1      1        CS          <3      M external
# 2  2      1        CS          <3      M external
# 3  3      1        CS >=3 and <=5      M internal
# 4  4      1        CS >=3 and <=5      F internal
# 5  5      1        CS          <3      M internal
# 6  6      1        CS          >5      M external

empdata$status <- as.factor(empdata$status)

churn_rf <- randomForest(status ~ function. + exp + gender + source, data = empdata, mtry = 2, ntree = 100, importance = TRUE, cutoff = c(0.6, 0.4))
churn_rf
# Call:
#  randomForest(formula = status ~ function. + exp + gender + source,      data = empdata, mtry = 2, ntree = 100, importance = TRUE,      cutoff = c(0.6, 0.4)) 
#                Type of random forest: classification
#                      Number of trees: 100
# No. of variables tried at each split: 2
# 
#         OOB estimate of  error rate: 30.12%
# Confusion matrix:
#    0  1 class.error
# 0 36 14   0.2800000
# 1 11 22   0.3333333

plot(churn_rf)

empdata$pred <- predict(churn_rf, empdata)
head(empdata)
#   sn status function.         exp gender   source pred
# 1  1      1        CS          <3      M external    1
# 2  2      1        CS          <3      M external    1
# 3  3      1        CS >=3 and <=5      M internal    0
# 4  4      1        CS >=3 and <=5      F internal    0
# 5  5      1        CS          <3      M internal    1
# 6  6      1        CS          >5      M external    1

churn_rf$importance
#                     0           1 MeanDecreaseAccuracy MeanDecreaseGini
# function. 0.067664069  0.04675604           0.05897277         7.532204
# exp       0.128453211  0.11093105           0.11912368        12.343537
# gender    0.001094959 -0.03558078          -0.01323896         2.161723
# source    0.031951914 -0.01063450           0.01431554         2.771580

varImpPlot(churn_rf, col = "blue")


