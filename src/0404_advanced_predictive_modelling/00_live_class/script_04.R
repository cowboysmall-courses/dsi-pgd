
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
# 490   1


train <- data[index, ]
test  <- data[-index, ]


dim(train)
# 490   8

dim(test)
# 210   8


model <- glm(DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, data = train, family = "binomial")

train$predprob  <- predict(model, train, type = "response")
train$pred      <- ifelse(train$predprob > 0.30, 1, 0)
train$pred      <- factor(train$pred)
train$DEFAULTER <- factor(train$DEFAULTER)
confusionMatrix(train$pred, train$DEFAULTER, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 302  29
#          1  72  87
# 
#                Accuracy : 0.7939          
#                  95% CI : (0.7553, 0.8289)
#     No Information Rate : 0.7633          
#     P-Value [Acc > NIR] : 0.05998         
# 
#                   Kappa : 0.4943          
# 
#  Mcnemar's Test P-Value : 2.926e-05       
#                                           
#             Sensitivity : 0.7500          
#             Specificity : 0.8075          
#          Pos Pred Value : 0.5472          
#          Neg Pred Value : 0.9124          
#              Prevalence : 0.2367          
#          Detection Rate : 0.1776          
#    Detection Prevalence : 0.3245          
#       Balanced Accuracy : 0.7787          
#                                           
#        'Positive' Class : 1      


test$predprob  <- predict(model, test, type = "response")
test$pred      <- ifelse(test$predprob > 0.3, 1, 0)
test$pred      <- factor(test$pred)
test$DEFAULTER <- factor(test$DEFAULTER)
confusionMatrix(test$pred, test$DEFAULTER, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 114  22
#          1  29  45
# 
#                Accuracy : 0.7571          
#                  95% CI : (0.6934, 0.8135)
#     No Information Rate : 0.681           
#     P-Value [Acc > NIR] : 0.009648        
# 
#                   Kappa : 0.4562          
# 
#  Mcnemar's Test P-Value : 0.400814        
#                                           
#             Sensitivity : 0.6716          
#             Specificity : 0.7972          
#          Pos Pred Value : 0.6081          
#          Neg Pred Value : 0.8382          
#              Prevalence : 0.3190          
#          Detection Rate : 0.2143          
#    Detection Prevalence : 0.3524          
#       Balanced Accuracy : 0.7344          
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
# Summary of sample sizes: 525, 525, 525, 525 
# Resampling results:
#   
#   Accuracy   Kappa    
#   0.8128571  0.4670574



data$predprob  <- model$finalModel$fitted.values
data$pred      <- ifelse(data$predprob > 0.3, 1, 0)
data$pred      <- factor(data$pred)
data$DEFAULTER <- factor(data$DEFAULTER)
confusionMatrix(data$pred, data$DEFAULTER, positive = "1")
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

