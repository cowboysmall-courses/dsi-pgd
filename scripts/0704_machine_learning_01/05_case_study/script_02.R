
library(dplyr)
library(caret)
library(ROCR)
library(e1071)
library(car)



data <- read.csv("./data/0704_machine_learning_01/05_case_study/Bank Churn.csv", header = TRUE)
head(data)
#   RowNumber CustomerId  Surname CreditScore Geography Gender Age Tenure
# 1         1   15634602 Hargrave         619    France Female  42      2
# 2         2   15647311     Hill         608     Spain Female  41      1
# 3         3   15619304     Onio         502    France Female  42      8
# 4         4   15701354     Boni         699    France Female  39      1
# 5         5   15737888 Mitchell         850     Spain Female  43      2
# 6         6   15574012      Chu         645     Spain   Male  44      8
#     Balance NumOfProducts HasCrCard IsActiveMember EstimatedSalary Exited
# 1      0.00             1         1              1       101348.88      1
# 2  83807.86             1         0              1       112542.58      0
# 3 159660.80             3         1              0       113931.57      1
# 4      0.00             2         0              0        93826.63      0
# 5 125510.82             1         1              1        79084.10      0
# 6 113755.78             2         1              0       149756.71      1


data <- data %>% mutate_at(vars(c("HasCrCard", "IsActiveMember", "Exited")), ~as.factor(.))


index <- createDataPartition(data$Exited, p = 0.7, list = F)
train <- data[index, ]
test  <- data[-index, ]


counts <- data.frame(table(data$Exited))
colnames(counts)[1] <- "Exited"
counts$Percent <- counts$Freq / sum(counts$Freq)
counts
#   Exited Freq Percent
# 1      0 7963  0.7963
# 2      1 2037  0.2037


threshold <- 0.2


model <- glm(Exited ~ CreditScore + Geography + Gender + Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, data = train, family = binomial)
summary(model)
# Call:
# glm(formula = Exited ~ CreditScore + Geography + Gender + Age + 
#     Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + 
#     EstimatedSalary, family = binomial, data = train)
# 
# Coefficients:
#                    Estimate Std. Error z value Pr(>|z|)    
# (Intercept)      -3.479e+00  2.945e-01 -11.814  < 2e-16 ***
# CreditScore      -6.811e-04  3.363e-04  -2.025   0.0429 *  
# GeographyGermany  7.100e-01  8.078e-02   8.790  < 2e-16 ***
# GeographySpain    9.067e-02  8.345e-02   1.087   0.2773    
# GenderMale       -4.913e-01  6.490e-02  -7.569 3.75e-14 ***
# Age               7.268e-02  3.069e-03  23.680  < 2e-16 ***
# Tenure           -9.687e-03  1.117e-02  -0.868   0.3857    
# Balance           3.176e-06  6.129e-07   5.182 2.20e-07 ***
# NumOfProducts    -1.027e-01  5.666e-02  -1.812   0.0700 .  
# HasCrCard1        5.564e-03  7.088e-02   0.078   0.9374    
# IsActiveMember1  -1.033e+00  6.845e-02 -15.093  < 2e-16 ***
# EstimatedSalary   1.802e-07  5.639e-07   0.320   0.7492    
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 7077.6  on 7000  degrees of freedom
# Residual deviance: 6029.9  on 6989  degrees of freedom
# AIC: 6053.9
# 
# Number of Fisher Scoring iterations: 5


vif(model)
#                     GVIF Df GVIF^(1/(2*Df))
# CreditScore     1.001614  1        1.000807
# Geography       1.201892  2        1.047047
# Gender          1.003743  1        1.001870
# Age             1.084290  1        1.041293
# Tenure          1.003679  1        1.001838
# Balance         1.284182  1        1.133218
# NumOfProducts   1.087972  1        1.043059
# HasCrCard       1.002213  1        1.001106
# IsActiveMember  1.081726  1        1.040060
# EstimatedSalary 1.000715  1        1.000358



model <- glm(Exited ~ CreditScore + Geography + Gender + Age + Balance + NumOfProducts + IsActiveMember, data = train, family = binomial)
summary(model)
# Call:
# glm(formula = Exited ~ CreditScore + Geography + Gender + Age + 
#     Balance + NumOfProducts + IsActiveMember, family = binomial, 
#     data = train)
# 
# Coefficients:
#                    Estimate Std. Error z value Pr(>|z|)    
# (Intercept)      -3.508e+00  2.781e-01 -12.616  < 2e-16 ***
# CreditScore      -6.779e-04  3.362e-04  -2.016   0.0438 *  
# GeographyGermany  7.094e-01  8.076e-02   8.783  < 2e-16 ***
# GeographySpain    9.204e-02  8.341e-02   1.103   0.2699    
# GenderMale       -4.916e-01  6.489e-02  -7.577 3.55e-14 ***
# Age               7.268e-02  3.069e-03  23.685  < 2e-16 ***
# Balance           3.176e-06  6.126e-07   5.185 2.16e-07 ***
# NumOfProducts    -1.028e-01  5.664e-02  -1.815   0.0695 .  
# IsActiveMember1  -1.031e+00  6.839e-02 -15.078  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 7077.6  on 7000  degrees of freedom
# Residual deviance: 6030.8  on 6992  degrees of freedom
# AIC: 6048.8
# 
# Number of Fisher Scoring iterations: 5



train$predprob <- round(fitted(model), 2)
predtrain <- prediction(train$predprob, train$Exited)
perftrain <- performance(predtrain, "tpr", "fpr")

plot(perftrain)
abline(0, 1)


auc <- performance(predtrain, "auc")
auc@y.values
# 0.7635981


train$predY <- as.factor(ifelse(train$predprob > threshold, 1, 0))
confusionMatrix(train$predY, train$Exited, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 3964  452
#          1 1611  974
# 
#                Accuracy : 0.7053         
#                  95% CI : (0.6945, 0.716)
#     No Information Rate : 0.7963         
#     P-Value [Acc > NIR] : 1              
# 
#                   Kappa : 0.3026         
# 
#  Mcnemar's Test P-Value : <2e-16         
# 
#             Sensitivity : 0.6830         
#             Specificity : 0.7110         
#          Pos Pred Value : 0.3768         
#          Neg Pred Value : 0.8976         
#              Prevalence : 0.2037         
#          Detection Rate : 0.1391         
#    Detection Prevalence : 0.3692         
#       Balanced Accuracy : 0.6970         
# 
#        'Positive' Class : 1       


test$predprob <- predict(model, test, type = "response")
pred <- prediction(test$predprob, test$Exited)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.7769662


test$predY <- as.factor(ifelse(test$predprob > threshold, 1, 0))
confusionMatrix(test$predY, test$Exited, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 1632  163
#          1  756  448
# 
#                Accuracy : 0.6936        
#                  95% CI : (0.6767, 0.71)
#     No Information Rate : 0.7963        
#     P-Value [Acc > NIR] : 1             
# 
#                   Kappa : 0.3061        
# 
#  Mcnemar's Test P-Value : <2e-16        
# 
#             Sensitivity : 0.7332        
#             Specificity : 0.6834        
#          Pos Pred Value : 0.3721        
#          Neg Pred Value : 0.9092        
#              Prevalence : 0.2037        
#          Detection Rate : 0.1494        
#    Detection Prevalence : 0.4015        
#       Balanced Accuracy : 0.7083        
# 
#        'Positive' Class : 1          



model_nb <- naiveBayes(Exited ~ CreditScore + Geography + Gender + Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, data = train)
model_nb


prednb <- predict(model_nb, train, type = "raw")
pred <- prediction(prednb[, 2], train$Exited)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.8007316


train$predY <- as.factor(ifelse(prednb[, 2] > threshold, 1, 0))
confusionMatrix(train$predY, train$Exited, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction    0    1
#          0 4157  418
#          1 1418 1008
#
#                Accuracy : 0.7378         
#                  95% CI : (0.7273, 0.748)
#     No Information Rate : 0.7963         
#     P-Value [Acc > NIR] : 1              
#
#                   Kappa : 0.3589         
#
#  Mcnemar's Test P-Value : <2e-16         
#
#             Sensitivity : 0.7069         
#             Specificity : 0.7457         
#          Pos Pred Value : 0.4155         
#          Neg Pred Value : 0.9086         
#              Prevalence : 0.2037         
#          Detection Rate : 0.1440         
#    Detection Prevalence : 0.3465         
#       Balanced Accuracy : 0.7263         
#
#        'Positive' Class : 1        


prednb <- predict(model_nb, test, type = "raw")
pred <- prediction(prednb[, 2], test$Exited)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.8112823


test$predY <- as.factor(ifelse(prednb[, 2] > threshold, 1, 0))
confusionMatrix(test$predY, test$Exited, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction    0    1
#          0 1769  155
#          1  619  456
#
#                Accuracy : 0.7419          
#                  95% CI : (0.7259, 0.7575)
#     No Information Rate : 0.7963          
#     P-Value [Acc > NIR] : 1               
#
#                   Kappa : 0.3798          
#
#  Mcnemar's Test P-Value : <2e-16          
#
#             Sensitivity : 0.7463          
#             Specificity : 0.7408          
#          Pos Pred Value : 0.4242          
#          Neg Pred Value : 0.9194          
#              Prevalence : 0.2037          
#          Detection Rate : 0.1521          
#    Detection Prevalence : 0.3585          
#       Balanced Accuracy : 0.7436          
#
#        'Positive' Class : 1 



model_svm <- svm(Exited ~ CreditScore + Geography + Gender + Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, data = train, type = "C", probability = TRUE, kernel = "linear")
model_svm
# Call:
# svm(formula = Exited ~ CreditScore + Geography + Gender + Age + Tenure + 
#     Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, 
#     data = train, type = "C", probability = TRUE, kernel = "linear")
#
#
# Parameters:
#    SVM-Type:  C-classification 
#  SVM-Kernel:  linear 
#        cost:  1 
#
# Number of Support Vectors:  3052


pred1 <- predict(model_svm, train, probability = TRUE)
pred2 <- attr(pred1, "probabilities")[, 1]

pred <- prediction(pred2, train$Exited)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.6558406

train$predY <- as.factor(ifelse(pred2 > threshold, 1, 0))
confusionMatrix(train$predY, train$Exited, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction    0    1
#          0 3466  541
#          1 2109  885
#
#                Accuracy : 0.6215        
#                  95% CI : (0.61, 0.6329)
#     No Information Rate : 0.7963        
#     P-Value [Acc > NIR] : 1             
#
#                   Kappa : 0.172         
#
#  Mcnemar's Test P-Value : <2e-16        
#
#             Sensitivity : 0.6206        
#             Specificity : 0.6217        
#          Pos Pred Value : 0.2956        
#          Neg Pred Value : 0.8650        
#              Prevalence : 0.2037        
#          Detection Rate : 0.1264        
#    Detection Prevalence : 0.4277        
#       Balanced Accuracy : 0.6212        
#
#        'Positive' Class : 1             


pred1 <- predict(model_svm, test, probability = TRUE)
pred2 <- attr(pred1, "probabilities")[, 1]

pred <- prediction(pred2, test$Exited)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.6830662

test$predY <- as.factor(ifelse(pred2 > threshold, 1, 0))
confusionMatrix(test$predY, test$Exited, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction    0    1
#          0 1445  203
#          1  943  408
#
#                Accuracy : 0.6179          
#                  95% CI : (0.6002, 0.6353)
#     No Information Rate : 0.7963          
#     P-Value [Acc > NIR] : 1               
#
#                   Kappa : 0.1881          
#
#  Mcnemar's Test P-Value : <2e-16          
#
#             Sensitivity : 0.6678          
#             Specificity : 0.6051          
#          Pos Pred Value : 0.3020          
#          Neg Pred Value : 0.8768          
#              Prevalence : 0.2037          
#          Detection Rate : 0.1360          
#    Detection Prevalence : 0.4505          
#       Balanced Accuracy : 0.6364          
#
#        'Positive' Class : 1               

