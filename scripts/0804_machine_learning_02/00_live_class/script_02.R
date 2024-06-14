
library(dplyr)
library(fastDummies)
library(neuralnet)
library(caret)
library(ROCR)


set.seed(20240612)


data <- read.csv("./data/0804_machine_learning_02/00_live_class/Bank Churn.csv")
head(data)


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


dimnames(out_churn) <- list(NULL, c("CreditScore", "Geography_Germany", "Geography_Spain", "Gender_Male", "Age", "Tenure", "Balance", "NumOfProducts", "HasCrCard", "IsActiveMember", "EstimatedSalary", "nn_output")) 
head(out_churn)


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
