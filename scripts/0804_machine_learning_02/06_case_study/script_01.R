
library(dplyr)
library(caret)
library(ROCR)
library(e1071)
library(car)
library(partykit)
library(randomForest)



data <- read.csv("./data/0804_machine_learning_02/06_case_study/Bank Churn.csv", header = TRUE)
head(data)
#   RowNumber CustomerId  Surname CreditScore Geography Gender Age Tenure   Balance NumOfProducts HasCrCard IsActiveMember EstimatedSalary Exited
# 1         1   15634602 Hargrave         619    France Female  42      2      0.00             1         1              1       101348.88      1
# 2         2   15647311     Hill         608     Spain Female  41      1  83807.86             1         0              1       112542.58      0
# 3         3   15619304     Onio         502    France Female  42      8 159660.80             3         1              0       113931.57      1
# 4         4   15701354     Boni         699    France Female  39      1      0.00             2         0              0        93826.63      0
# 5         5   15737888 Mitchell         850     Spain Female  43      2 125510.82             1         1              1        79084.10      0
# 6         6   15574012      Chu         645     Spain   Male  44      8 113755.78             2         1              0       149756.71      1


data <- data %>% mutate_at(vars(c("HasCrCard", "IsActiveMember", "Exited", "Geography", "Gender")), ~as.factor(.))


index <- createDataPartition(data$Exited, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]


counts <- data.frame(table(data$Exited))
colnames(counts)[1] <- "Exited"
counts$Percent <- counts$Freq / sum(counts$Freq)
counts
#   Exited Freq Percent
# 1      0 7963  0.7963
# 2      1 2037  0.2037


model_dt <- partykit::ctree(Exited ~ CreditScore + Geography + Gender + Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, data = train)
plot(model_dt, type = "simple")


pred_dt <- predict(model_dt, test, type = "prob")
pred    <- prediction(pred_dt[, 2], test$Exited)
perf    <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.7726933


test$predY <- predict(model_dt, test, type = "response")
confusionMatrix(test$predY, test$Exited, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 2273  408
#          1  115  203
# 
#                Accuracy : 0.8256         
#                  95% CI : (0.8115, 0.839)
#     No Information Rate : 0.7963         
#     P-Value [Acc > NIR] : 2.695e-05      
# 
#                   Kappa : 0.3458         
# 
#  Mcnemar's Test P-Value : < 2.2e-16      
# 
#             Sensitivity : 0.33224        
#             Specificity : 0.95184        
#          Pos Pred Value : 0.63836        
#          Neg Pred Value : 0.84782        
#              Prevalence : 0.20373        
#          Detection Rate : 0.06769        
#    Detection Prevalence : 0.10604        
#       Balanced Accuracy : 0.64204        
#
#        'Positive' Class : 1     



model_rf <- randomForest(Exited ~ CreditScore + Geography + Gender + Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, data = train, mtry = 3, ntree =100, importance = TRUE)
model_rf
# Call:
#  randomForest(formula = Exited ~ CreditScore + Geography + Gender +      Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember +      EstimatedSalary, data = train, mtry = 3, ntree = 100, importance = TRUE) 
#                Type of random forest: classification
#                      Number of trees: 100
# No. of variables tried at each split: 3
# 
#         OOB estimate of  error rate: 13.74%
# Confusion matrix:
#      0   1 class.error
# 0 5364 211  0.03784753
# 1  751 675  0.52664797


model_rf$importance
#                             0            1 MeanDecreaseAccuracy MeanDecreaseGini
# CreditScore      1.993849e-03 0.0033380024         2.255401e-03        295.87134
# Geography        1.151495e-03 0.0437234906         9.793972e-03         96.37106
# Gender           9.645670e-04 0.0029123545         1.361047e-03         40.56318
# Age              3.512301e-02 0.1160265442         5.152213e-02        508.13672
# Tenure           3.383143e-04 0.0031483009         9.064295e-04        171.86493
# Balance          1.177768e-02 0.0391874189         1.734273e-02        305.47159
# NumOfProducts    4.013819e-02 0.1086307582         5.401977e-02        313.82149
# HasCrCard        4.507029e-04 0.0012165810         6.009641e-04         36.61905
# IsActiveMember   1.662121e-02 0.0278382656         1.890684e-02         88.80577
# EstimatedSalary -4.474317e-05 0.0003549408         2.880274e-05        304.51476


varImpPlot(model_rf, col = "blue")


pred_rf <- predict(model_rf, test, type = "vote", norm.votes = TRUE)
pred    <- prediction(pred_rf[, 2], test$Exited)
perf    <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0,1)


auc <- performance(pred, "auc")
auc@y.values
# 0.8507002


test$predY <- predict(model_rf, test, type = "response")
confusionMatrix(test$predY, test$Exited, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 2300  322
#          1   88  289
# 
#                Accuracy : 0.8633          
#                  95% CI : (0.8505, 0.8754)
#     No Information Rate : 0.7963          
#     P-Value [Acc > NIR] : < 2.2e-16       
# 
#                   Kappa : 0.5086          
# 
#  Mcnemar's Test P-Value : < 2.2e-16       
# 
#             Sensitivity : 0.47300         
#             Specificity : 0.96315         
#          Pos Pred Value : 0.76658         
#          Neg Pred Value : 0.87719         
#              Prevalence : 0.20373         
#          Detection Rate : 0.09637         
#    Detection Prevalence : 0.12571         
#       Balanced Accuracy : 0.71807         
# 
#        'Positive' Class : 1       

