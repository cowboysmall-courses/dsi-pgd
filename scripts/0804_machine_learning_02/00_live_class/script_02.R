
library(dplyr)
library(fastDummies)
library(neuralnet)
library(caret)
library(ROCR)


set.seed(20240612)


data <- read.csv("./data/0804_machine_learning_02/00_live_class/Bank Churn.csv")
head(data)
#   RowNumber CustomerId  Surname CreditScore Geography Gender Age Tenure   Balance NumOfProducts HasCrCard IsActiveMember EstimatedSalary Exited
# 1         1   15634602 Hargrave         619    France Female  42      2      0.00             1         1              1       101348.88      1
# 2         2   15647311     Hill         608     Spain Female  41      1  83807.86             1         0              1       112542.58      0
# 3         3   15619304     Onio         502    France Female  42      8 159660.80             3         1              0       113931.57      1
# 4         4   15701354     Boni         699    France Female  39      1      0.00             2         0              0        93826.63      0
# 5         5   15737888 Mitchell         850     Spain Female  43      2 125510.82             1         1              1        79084.10      0
# 6         6   15574012      Chu         645     Spain   Male  44      8 113755.78             2         1              0       149756.71      1


data <- dummy_cols(data, select_columns = c("Geography", "Gender"), remove_first_dummy = TRUE) 


normalize <- function(x) { return((x - min(x)) / (max(x) - min(x))) }

data$Age             <- normalize(data$Age) 
data$Tenure          <- normalize(data$Tenure) 
data$NumOfProducts   <- normalize(data$NumOfProducts) 
data$EstimatedSalary <- normalize(data$EstimatedSalary) 
data$CreditScore     <- normalize(data$CreditScore) 
data$Balance         <- normalize(data$Balance)


counts <- data.frame(table(data$Exited))
colnames(counts)[1] <- "Exited"
counts$Percent <- counts$Freq / sum(counts$Freq)
counts
#   Exited Freq Percent
# 1      0 7963  0.7963
# 2      1 2037  0.2037


index <- createDataPartition(data$Exited, p = 0.7, list = FALSE)

traindata <- data[index, ]
testdata  <- data[-index, ]


model <- neuralnet(Exited ~ CreditScore + Geography_Germany + Geography_Spain + Gender_Male + Age + Tenure + Balance + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary, data = traindata, hidden = 2, err.fct = "ce", linear.output = FALSE, stepmax = 10000000)


out_churn <- cbind(model$covariate, model$net.result[[1]])
head(out_churn)
#    CreditScore Geography_Germany Geography_Spain Gender_Male       Age Tenure   Balance NumOfProducts HasCrCard IsActiveMember EstimatedSalary           
# 5        1.000                 0               1           0 0.3378378    0.2 0.5002462     0.0000000         1              1       0.3954004 0.13379941
# 6        0.590                 0               1           1 0.3513514    0.8 0.4533944     0.3333333         1              0       0.7487972 0.18762400
# 7        0.944                 0               0           1 0.4324324    0.7 0.0000000     0.3333333         1              1       0.0502609 0.02255485
# 8        0.052                 1               0           0 0.1486486    0.4 0.4585397     1.0000000         1              0       0.5967335 0.99997441
# 9        0.302                 0               0           1 0.3513514    0.4 0.5661704     0.3333333         0              1       0.3746804 0.11233128
# 10       0.668                 0               0           1 0.1216216    0.2 0.5364883     0.0000000         1              1       0.3586050 0.03022403


dimnames(out_churn) <- list(NULL, c("CreditScore", "Geography_Germany", "Geography_Spain", "Gender_Male", "Age", "Tenure", "Balance", "NumOfProducts", "HasCrCard", "IsActiveMember", "EstimatedSalary", "nn_output")) 
head(out_churn)
#      CreditScore Geography_Germany Geography_Spain Gender_Male       Age Tenure   Balance NumOfProducts HasCrCard IsActiveMember EstimatedSalary  nn_output
# [1,]       1.000                 0               1           0 0.3378378    0.2 0.5002462     0.0000000         1              1       0.3954004 0.13379941
# [2,]       0.590                 0               1           1 0.3513514    0.8 0.4533944     0.3333333         1              0       0.7487972 0.18762400
# [3,]       0.944                 0               0           1 0.4324324    0.7 0.0000000     0.3333333         1              1       0.0502609 0.02255485
# [4,]       0.052                 1               0           0 0.1486486    0.4 0.4585397     1.0000000         1              0       0.5967335 0.99997441
# [5,]       0.302                 0               0           1 0.3513514    0.4 0.5661704     0.3333333         0              1       0.3746804 0.11233128
# [6,]       0.668                 0               0           1 0.1216216    0.2 0.5364883     0.0000000         1              1       0.3586050 0.03022403


plot(model, rep = "best")


outdf <- as.data.frame(out_churn) 
pred  <- prediction(outdf$nn_output, traindata$Exited) 
perf  <- performance(pred, "tpr", "fpr") 

plot(perf) 
abline(0, 1)


auc <- performance(pred, "auc") 
auc@y.values
# 0.8465933


traindata$predY <- as.factor(ifelse(outdf$nn_output > 0.5, 1, 0))
confusionMatrix(as.factor(traindata$predY), as.factor(traindata$Exited), positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 5326  839
#          1  249  586
# 
#                Accuracy : 0.8446         
#                  95% CI : (0.8359, 0.853)
#     No Information Rate : 0.7964         
#     P-Value [Acc > NIR] : < 2.2e-16      
# 
#                   Kappa : 0.4333         
# 
#  Mcnemar's Test P-Value : < 2.2e-16      
# 
#             Sensitivity : 0.41123        
#             Specificity : 0.95534        
#          Pos Pred Value : 0.70180        
#          Neg Pred Value : 0.86391        
#              Prevalence : 0.20357        
#          Detection Rate : 0.08371        
#    Detection Prevalence : 0.11929        
#       Balanced Accuracy : 0.68328        
# 
#        'Positive' Class : 1


prednn <- predict(model, testdata)
pred   <- prediction(prednn, testdata$Exited)
perf   <- performance(pred, "tpr", "fpr") 

plot(perf) 
abline(0, 1)


auc <- performance(pred, "auc") 
auc@y.values
# 0.8411468


testdata$predY <- as.factor(ifelse(prednn > 0.5, 1, 0)) 
confusionMatrix(as.factor(testdata$predY), as.factor(testdata$Exited), positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 2271  336
#          1  117  276
# 
#                Accuracy : 0.849           
#                  95% CI : (0.8357, 0.8616)
#     No Information Rate : 0.796           
#     P-Value [Acc > NIR] : 5.015e-14       
# 
#                   Kappa : 0.4637          
# 
#  Mcnemar's Test P-Value : < 2.2e-16       
# 
#             Sensitivity : 0.4510          
#             Specificity : 0.9510          
#          Pos Pred Value : 0.7023          
#          Neg Pred Value : 0.8711          
#              Prevalence : 0.2040          
#          Detection Rate : 0.0920          
#    Detection Prevalence : 0.1310          
#       Balanced Accuracy : 0.7010          
# 
#        'Positive' Class : 1
