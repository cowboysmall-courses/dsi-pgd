

# BACKGROUND:
#
#     The data is a marketing campaign data of a skin care clinic associated
#     with its success.
#
#     Description of variables:
#
#         Success:         Response to marketing campaign of Skin Care Clinic
#                          which offers both products and services. (1: email
#                          Opened, 0: email not opened)
#         AGE:             Age Group of Customer
#         Recency_Service: Number of days since last service purchase
#         Recency_Product: Number of days since last product purchase
#         Bill_Service:    Total bill amount for service in last 3 months
#         Bill_Product:    Total bill amount for products in last 3 months
#         Gender:          (1: Male, 2: Female)
#
#     Note: Answer following questions using entire data and do not create test
#           data.
#
# QUESTIONS
# 
#     1: Import Email Campaign data. Obtain decision tree to classify cases as
#        success=0 or 1. Obtain Sensitivity/Recall using cut-off value as 0.50
#        for estimated probabilities.
#     2: Compare performance of Decision Tree and Random Forest Method using
#        area under the ROC curve.
#     3: Implement Neural Network Algorithm and obtain are under the ROC curve.


library(caret)
library(ROCR)
library(fastDummies)
library(rpart)
library(randomForest)
library(neuralnet)









# 1: Import Email Campaign data. Obtain decision tree to classify cases as
#    success = 0 or 1. Obtain Sensitivity/Recall using cut-off value as 0.50
#    for estimated probabilities.

data <- read.csv("./data/0804_machine_learning_02/05_assignment/Email Campaign.csv", header = TRUE)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success
# 1  1      1 <=45              12              11        11.82         2.68       0
# 2  2      2 <=30               6               0        10.31         1.32       0
# 3  3      1 <=30               1               9         7.43         0.49       0
# 4  4      1 <=45               2              14        13.68         1.85       0
# 5  5      2 <=30               0              11         4.56         1.01       1
# 6  6      2 <=30               1               2        18.99         0.44       1


str(data)
# 'data.frame':   683 obs. of  8 variables:
#  $ SN             : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ Gender         : int  1 2 1 1 2 2 1 1 1 1 ...
#  $ AGE            : chr  "<=45" "<=30" "<=30" "<=45" ...
#  $ Recency_Service: int  12 6 1 2 0 1 11 16 14 8 ...
#  $ Recency_Product: int  11 0 9 14 11 2 8 9 8 4 ...
#  $ Bill_Service   : num  11.82 10.31 7.43 13.68 4.56 ...
#  $ Bill_Product   : num  2.68 1.32 0.49 1.85 1.01 ...
#  $ Success        : int  0 0 0 0 1 1 0 0 1 0 ...


data$Gender  <- as.factor(ifelse(data$Gender == 1, "Male", "Female"))
data$AGE     <- as.factor(data$AGE)
data$Success <- as.factor(data$Success)


str(data)
# 'data.frame':   683 obs. of  8 variables:
#  $ SN             : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ Gender         : Factor w/ 2 levels "Female","Male": 2 1 2 2 1 1 2 2 2 2 ...
#  $ AGE            : Factor w/ 3 levels "<=30","<=45",..: 2 1 1 2 1 1 1 2 2 1 ...
#  $ Recency_Service: int  12 6 1 2 0 1 11 16 14 8 ...
#  $ Recency_Product: int  11 0 9 14 11 2 8 9 8 4 ...
#  $ Bill_Service   : num  11.82 10.31 7.43 13.68 4.56 ...
#  $ Bill_Product   : num  2.68 1.32 0.49 1.85 1.01 ...
#  $ Success        : Factor w/ 2 levels "0","1": 1 1 1 1 2 2 1 1 2 1 ...


# model_dt  <- partykit::ctree(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data)
model_dt  <- rpart(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, method = "class")
y_pred_dt <- predict(model_dt, data, type = "prob")


y_class_dt <- as.factor(ifelse(y_pred_dt[, 2] > 0.5, 1, 0))
cm_dt      <- confusionMatrix(y_class_dt, factor(data$Success), positive = "1")
cm_dt
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 475  84
#          1  28  96
# 
#                Accuracy : 0.836          
#                  95% CI : (0.8061, 0.863)
#     No Information Rate : 0.7365         
#     P-Value [Acc > NIR] : 3.862e-10      
# 
#                   Kappa : 0.5307         
# 
#  Mcnemar's Test P-Value : 2.025e-07      
# 
#             Sensitivity : 0.5333         
#             Specificity : 0.9443         
#          Pos Pred Value : 0.7742         
#          Neg Pred Value : 0.8497         
#              Prevalence : 0.2635         
#          Detection Rate : 0.1406         
#    Detection Prevalence : 0.1816         
#       Balanced Accuracy : 0.7388         
# 
#        'Positive' Class : 1


accuracy_dt  <- cm_dt$overall["Accuracy"]
precision_dt <- cm_dt$byClass["Pos Pred Value"]
recall_dt    <- cm_dt$byClass["Sensitivity"]

paste(" Decision Tree Accuracy: ", accuracy_dt)
paste("Decision Tree Precision: ", precision_dt)
paste("   Decision Tree Recall: ", recall_dt)

#  Decision Tree Accuracy:  0.83601756954612
# Decision Tree Precision:  0.774193548387097
#    Decision Tree Recall:  0.533333333333333






# 2: Compare performance of Decision Tree and Random Forest Method using
#    area under the ROC curve.

model_rf  <- randomForest(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, ntree =100, importance = TRUE)
y_pred_rf <- predict(model_rf, data, type = "prob")


pred_dt <- ROCR::prediction(y_pred_dt[, 2], data$Success)
perf_dt <- ROCR::performance(pred_dt, "tpr", "fpr")

pred_rf <- ROCR::prediction(y_pred_rf[, 2], data$Success)
perf_rf <- ROCR::performance(pred_rf, "tpr", "fpr")


plot(perf_dt)
abline(0, 1)

plot(perf_rf)
abline(0, 1)


auc_dt <- ROCR::performance(pred_dt, "auc")
auc_rf <- ROCR::performance(pred_rf, "auc")


paste("Decision Tree AUC: ", auc_dt@y.values)
paste("Random Forest AUC: ", auc_rf@y.values)
# Decision Tree AUC: 0.819637729180473
# Random Forest AUC: 1


y_class_rf <- as.factor(ifelse(y_pred_rf[, 2] > 0.5, 1, 0))
cm_rf      <- confusionMatrix(y_class_rf, data$Success, positive = "1")
cm_rf
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 503   0
#          1   0 180
# 
#                Accuracy : 1          
#                  95% CI : (0.9946, 1)
#     No Information Rate : 0.7365     
#     P-Value [Acc > NIR] : < 2.2e-16  
# 
#                   Kappa : 1          
# 
#  Mcnemar's Test P-Value : NA         
# 
#             Sensitivity : 1.0000     
#             Specificity : 1.0000     
#          Pos Pred Value : 1.0000     
#          Neg Pred Value : 1.0000     
#              Prevalence : 0.2635     
#          Detection Rate : 0.2635     
#    Detection Prevalence : 0.2635     
#       Balanced Accuracy : 1.0000     
# 
#        'Positive' Class : 1


accuracy_rf  <- cm_rf$overall["Accuracy"]
precision_rf <- cm_rf$byClass["Pos Pred Value"]
recall_rf    <- cm_rf$byClass["Sensitivity"]

paste(" Random Forest Accuracy:", accuracy_rf)
paste("Random Forest Precision:", precision_rf)
paste("   Random Forest Recall:", recall_rf)

#  Random Forest Accuracy: 1
# Random Forest Precision: 1
#    Random Forest Recall: 1









# 3: Implement Neural Network Algorithm and obtain area under the ROC curve.

data_dummies <- dummy_cols(data, select_columns = c("Gender", "AGE"), remove_first_dummy = TRUE)

colnames(data_dummies)[10] <- "AGE_45"
colnames(data_dummies)[11] <- "AGE_55"


minMaxScaler <- function(x) { return((x - min(x)) / (max(x) - min(x))) }

data_dummies$Recency_Service <- minMaxScaler(data_dummies$Recency_Service)
data_dummies$Recency_Product <- minMaxScaler(data_dummies$Recency_Product)
data_dummies$Bill_Service    <- minMaxScaler(data_dummies$Bill_Service)
data_dummies$Bill_Product    <- minMaxScaler(data_dummies$Bill_Product)


model_nn  <- neuralnet(Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product + Gender_Male + AGE_45 + AGE_55, data = data_dummies, hidden = 3, err.fct = "ce", linear.output = FALSE)
y_pred_nn <- predict(model_nn, data_dummies)


pred_nn <- ROCR::prediction(y_pred_nn[, 2], data_dummies$Success)
perf_nn <- ROCR::performance(pred_nn, "tpr", "fpr")

plot(perf_nn)
abline(0, 1)

auc_nn <- ROCR::performance(pred_nn, "auc")
paste("Neural Network AUC: ", auc_nn@y.values)
# Neural Network AUC:  0.869229070024296


y_class_nn <- as.factor(ifelse(y_pred_nn[, 2] > 0.5, 1, 0))
cm_nn      <- confusionMatrix(y_class_nn, data_dummies$Success, positive = "1")
cm_nn
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 470  80
#          1  33 100
# 
#                Accuracy : 0.8346          
#                  95% CI : (0.8045, 0.8617)
#     No Information Rate : 0.7365          
#     P-Value [Acc > NIR] : 7.070e-10       
# 
#                   Kappa : 0.5348          
# 
#  Mcnemar's Test P-Value : 1.509e-05       
# 
#             Sensitivity : 0.5556          
#             Specificity : 0.9344          
#          Pos Pred Value : 0.7519          
#          Neg Pred Value : 0.8545          
#              Prevalence : 0.2635          
#          Detection Rate : 0.1464          
#    Detection Prevalence : 0.1947          
#       Balanced Accuracy : 0.7450          
# 
#        'Positive' Class : 1


accuracy_nn  <- cm_nn$overall["Accuracy"]
precision_nn <- cm_nn$byClass["Pos Pred Value"]
recall_nn    <- cm_nn$byClass["Sensitivity"]

paste(" Neural Network Accuracy: ", accuracy_nn)
paste("Neural Network Precision: ", precision_nn)
paste("   Neural Network Recall: ", recall_nn)

#  Neural Network Accuracy:  0.834553440702782
# Neural Network Precision:  0.75187969924812
#    Neural Network Recall:  0.555555555555556










# 4. Addendum - look at the Random Forest classifier performance - using cross
#    validation to get a more acurate indication of the performance of the 
#    classifier

kfolds <- trainControl(method = "cv", number = 4)


model_rf_cv  <- train(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, method = "rf", ntree =100, importance = TRUE, trControl = kfolds)
y_pred_rf_cv <- predict(model_rf_cv, data, type = "prob")


pred_rf_cv <- ROCR::prediction(y_pred_rf_cv[, 2], data$Success)
perf_rf_cv <- ROCR::performance(pred_rf_cv, "tpr", "fpr")

plot(perf_rf_cv)
abline(0, 1)


auc_rf_cv <- ROCR::performance(pred_rf_cv, "auc")
paste("Random Forest (CV) AUC: ", auc_rf_cv@y.values)
# Random Forest (CV) AUC:  1


y_class_rf_cv <- as.factor(ifelse(y_pred_rf_cv[, 2] > 0.5, 1, 0))
cm_rf_cv      <- confusionMatrix(y_class_rf_cv, data$Success, positive = "1")
cm_rf_cv
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 503   1
#          1   0 179
# 
#                Accuracy : 0.9985     
#                  95% CI : (0.9919, 1)
#     No Information Rate : 0.7365     
#     P-Value [Acc > NIR] : <2e-16     
# 
#                   Kappa : 0.9962     
# 
#  Mcnemar's Test P-Value : 1          
# 
#             Sensitivity : 0.9944     
#             Specificity : 1.0000     
#          Pos Pred Value : 1.0000     
#          Neg Pred Value : 0.9980     
#              Prevalence : 0.2635     
#          Detection Rate : 0.2621     
#    Detection Prevalence : 0.2621     
#       Balanced Accuracy : 0.9972     
# 
#        'Positive' Class : 1


accuracy_rf_cv  <- cm_rf_cv$overall["Accuracy"]
precision_rf_cv <- cm_rf_cv$byClass["Pos Pred Value"]
recall_rf_cv    <- cm_rf_cv$byClass["Sensitivity"]

paste(" Random Forest Accuracy:", accuracy_rf_cv)
paste("Random Forest Precision:", precision_rf_cv)
paste("   Random Forest Recall:", recall_rf_cv)

#  Random Forest Accuracy: 0.998535871156662
# Random Forest Precision: 1
#    Random Forest Recall: 0.994444444444444
