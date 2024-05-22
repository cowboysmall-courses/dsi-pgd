
library(e1071)
library(ROCR)

data <- read.csv("./data/0704_machine_learning_01/03_support_vector_machines/BANK LOAN.csv", header = TRUE)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER
# 1  1   3     17      12     9.3    11.36    5.01         1
# 2  2   1     10       6    17.3     1.36    4.00         0
# 3  3   2     15      14     5.5     0.86    2.17         0
# 4  4   3     15      14     2.9     2.66    0.82         0
# 5  5   1      2       0    17.3     1.79    3.06         1
# 6  6   3      5       5    10.2     0.39    2.16         0


data$AGE <- as.factor(data$AGE)
str(data)
# 'data.frame':   700 obs. of  8 variables:
#  $ SN       : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ AGE      : Factor w/ 3 levels "1","2","3": 3 1 2 3 1 3 2 3 1 2 ...
#  $ EMPLOY   : int  17 10 15 15 2 5 20 12 3 0 ...
#  $ ADDRESS  : int  12 6 14 14 0 5 9 11 4 13 ...
#  $ DEBTINC  : num  9.3 17.3 5.5 2.9 17.3 10.2 30.6 3.6 24.4 19.7 ...
#  $ CREDDEBT : num  11.36 1.36 0.86 2.66 1.79 ...
#  $ OTHDEBT  : num  5.01 4 2.17 0.82 3.06 ...
#  $ DEFAULTER: int  1 0 0 0 1 0 0 0 1 0 ...


model <- svm(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data, type = "C", probability = TRUE, kernel = "linear")
model
# Call:
# svm(formula = DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data, type = "C", probability = TRUE, kernel = "linear")
# 
# 
# Parameters:
#    SVM-Type:  C-classification 
#  SVM-Kernel:  linear 
#        cost:  1 
# 
# Number of Support Vectors:  312


pred1 <- predict(model, data, probability = TRUE)
pred2 <- attr(pred1, "probabilities")[, 1]
pred3 <- prediction(pred2, data$DEFAULTER)

perf  <- performance(pred3, "tpr", "fpr")
plot(perf)
abline(0, 1)


auc   <- performance(pred3, "auc")
auc@y.values
# 0.855577
