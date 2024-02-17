
library(caret)



data <- read.csv("../../../data/0404_advanced_predictive_modelling/live_class/BANK\ LOAN.csv", header = TRUE)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER
# 1  1   3     17      12     9.3    11.36    5.01         1
# 2  2   1     10       6    17.3     1.36    4.00         0
# 3  3   2     15      14     5.5     0.86    2.17         0
# 4  4   3     15      14     2.9     2.66    0.82         0
# 5  5   1      2       0    17.3     1.79    3.06         1
# 6  6   3      5       5    10.2     0.39    2.16         0



index <- createDataPartition(data$DEFAULTER, p = 0.7, list = FALSE)
dim(index)



train <- data[index, ]
test  <- data[-index, ]


dim(train)
dim(test)



model <- glm(DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, data = train, family = "binomial")



train$predprob  <- predict(model, train, type = "response")
train$predY     <- ifelse(train$predprob > 0.30, 1, 0)
train$predY     <- factor(train$predY)
train$DEFAULTER <- factor(train$DEFAULTER)

confusionMatrix(train$predY, train$DEFAULTER, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 285  31
#          1  75  99
# 
#                Accuracy : 0.7837          
#                  95% CI : (0.7445, 0.8193)
#     No Information Rate : 0.7347          
#     P-Value [Acc > NIR] : 0.007196        
# 
#                   Kappa : 0.4992          
# 
#  Mcnemar's Test P-Value : 2.96e-05        
#                                           
#             Sensitivity : 0.7615          
#             Specificity : 0.7917          
#          Pos Pred Value : 0.5690          
#          Neg Pred Value : 0.9019          
#              Prevalence : 0.2653          
#          Detection Rate : 0.2020          
#    Detection Prevalence : 0.3551          
#       Balanced Accuracy : 0.7766          
#                                           
#        'Positive' Class : 1


test$predprob  <- predict(model, test, type = "response")
test$predY     <- ifelse(test$predprob > 0.30, 1, 0)
test$predY     <- factor(test$predY)
test$DEFAULTER <- factor(test$DEFAULTER)

confusionMatrix(test$predY, test$DEFAULTER, positive = "1")
# Confusion Matrix and Statistics
# 
#          Reference
# Prediction   0   1
#          0 120  10
#          1  37  43
# 
#                Accuracy : 0.7762          
#                  95% CI : (0.7137, 0.8307)
#     No Information Rate : 0.7476          
#     P-Value [Acc > NIR] : 0.1919683       
# 
#                   Kappa : 0.4925          
# 
#  Mcnemar's Test P-Value : 0.0001491       
#                                           
#             Sensitivity : 0.8113          
#             Specificity : 0.7643          
#          Pos Pred Value : 0.5375          
#          Neg Pred Value : 0.9231          
#              Prevalence : 0.2524          
#          Detection Rate : 0.2048          
#    Detection Prevalence : 0.3810          
#       Balanced Accuracy : 0.7878          
#                                           
#        'Positive' Class : 1    



kfolds <- trainControl(method = "cv", number = 4)

model <- train(as.factor(DEFAULTER) ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, data = data, method = "glm", family = binomial, trControl = kfolds)
model
# Generalized Linear Model 
# 
# 700 samples
#   4 predictor
#   2 classes: '0', '1' 
# 
# No pre-processing
# Resampling: Cross-Validated (4 fold) 
# Summary of sample sizes: 525, 524, 526, 525 
# Resampling results:
#   
#   Accuracy   Kappa    
#   0.8157192  0.4775696



data$pred      <- model$finalModel$fitted.values
data$predY     <- ifelse(data$pred > 0.3, 1, 0)
data$predY     <- factor(data$predY)
data$DEFAULTER <- factor(data$DEFAULTER)

confusionMatrix(data$predY, data$DEFAULTER, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 415  45
#          1 102 138
# 
#                Accuracy : 0.79            
#                  95% CI : (0.7579, 0.8196)
#     No Information Rate : 0.7386          
#     P-Value [Acc > NIR] : 0.0009121       
# 
#                   Kappa : 0.5059          
# 
#  Mcnemar's Test P-Value : 3.86e-06        
#                                           
#             Sensitivity : 0.7541          
#             Specificity : 0.8027          
#          Pos Pred Value : 0.5750          
#          Neg Pred Value : 0.9022          
#              Prevalence : 0.2614          
#          Detection Rate : 0.1971          
#    Detection Prevalence : 0.3429          
#       Balanced Accuracy : 0.7784          
#                                           
#        'Positive' Class : 1   




