

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
library(rpart)
library(randomForest)
library(neuralnet)
library(fastDummies)









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
# data$Success <- as.factor(data$Success)


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

model_rf   <- randomForest(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, ntree =100, importance = TRUE)
y_pred_rf  <- predict(model_rf, data, type = "prob")


pred_dt <- prediction(y_pred_dt[, 2], data$Success)
perf_dt <- performance(pred_dt, "tpr", "fpr")

pred_rf <- prediction(y_pred_rf[, 2], data$Success)
perf_rf <- performance(pred_rf, "tpr", "fpr")


plot(perf_dt)
abline(0, 1)

plot(perf_rf)
abline(0, 1)


auc_dt <- performance(pred_dt, "auc")
auc_rf <- performance(pred_rf, "auc")


paste("Decision Tree AUC: ", auc_dt@y.values)
paste("Random Forest AUC: ", auc_rf@y.values)
# Decision Tree AUC: 0.8337641
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


# y_class_rf <- predict(model_rf, data, type = "response")
# confusionMatrix(y_class_rf, data$Success, positive = "1")

accuracy_rf  <- cm_rf$overall["Accuracy"]
precision_rf <- cm_rf$byClass["Pos Pred Value"]
recall_rf    <- cm_rf$byClass["Sensitivity"]

paste(" Random Forest Accuracy:", accuracy_rf)
paste("Random Forest Precision:", precision_rf)
paste("   Random Forest Recall:", recall_rf)










# 3: Implement Neural Network Algorithm and obtain are under the ROC curve.

# data_dummies <- data.frame(dummy_cols(data, remove_selected_columns = TRUE))

# minMaxScaler <- function(x) { return((x - min(x)) / (max(x) - min(x))) }

# data_dummies$Recency_Service <- minMaxScaler(data_dummies$Recency_Service)
# data_dummies$Recency_Product <- minMaxScaler(data_dummies$Recency_Product)
# data_dummies$Bill_Service    <- minMaxScaler(data_dummies$Bill_Service)
# data_dummies$Bill_Product    <- minMaxScaler(data_dummies$Bill_Product)

# colnames(data_dummies)[9]  <- "AGE_30"
# colnames(data_dummies)[10] <- "AGE_45"
# colnames(data_dummies)[11] <- "AGE_55"

# head(data_dummies)

# model_nn  <- neuralnet(Success ~ Gender_Female + Gender_Male + AGE_30 + AGE_45 + AGE_55 + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data_dummies, hidden = 3, err.fct = "ce", linear.output = FALSE)
# y_pred_nn <- predict(model_nn, data_dummies)

# head(model_nn$covariate)
# head(model_nn$net.result[[1]])
# head(y_pred_nn)

# something <- data.frame(cbind(model_nn$covariate, model_nn$net.result[[1]]))
# colnames(something)[10] <- "predicted"
# head(something)

# pred_nn <- prediction(something$predicted, data_dummies$Success)
# perf_nn <- performance(pred_nn, "tpr", "fpr")


# plot(perf_nn)
# abline(0, 1)




