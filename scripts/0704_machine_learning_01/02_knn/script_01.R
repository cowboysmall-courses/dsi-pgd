
library(caret)
library(class)


data <- read.csv("./data/0704_machine_learning_01/02_knn/BANK LOAN KNN.csv", header = TRUE)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER
# 1  1   3     17      12     9.3    11.36    5.01         1
# 2  5   1      2       0    17.3     1.79    3.06         1
# 3  8   3     12      11     3.6     0.13    1.24         0
# 4  9   1      3       4    24.4     1.36    3.28         1
# 5 13   3     24      14    10.0     3.93    2.47         0
# 6 14   2      6       9    16.3     1.72    3.01         0


data_sub <- subset(data, select = c(-AGE, -SN, -DEFAULTER))
head(data_sub)
#   EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT
# 1     17      12     9.3    11.36    5.01
# 2      2       0    17.3     1.79    3.06
# 3     12      11     3.6     0.13    1.24
# 4      3       4    24.4     1.36    3.28
# 5     24      14    10.0     3.93    2.47
# 6      6       9    16.3     1.72    3.01


data_sub <- scale(data_sub)
head(data_sub)
#       EMPLOY    ADDRESS    DEBTINC      CREDDEBT     OTHDEBT
# 1  1.5656796  0.6216799 -0.2881684  3.8774339687  0.51519694
# 2 -0.8239988 -1.1852951  0.7889154  0.0289356115 -0.02571385
# 3  0.7691201  0.4710987 -1.0555906 -0.6386200074 -0.53056393
# 4 -0.6646869 -0.5829701  1.7448273 -0.1439854223  0.03531198
# 5  2.6808628  0.9228424 -0.1939235  0.8895193612 -0.18937404
# 6 -0.1867512  0.1699362  0.6542799  0.0007856758 -0.03958336


index <- createDataPartition(data$SN, p = 0.7, list = FALSE)
head(index)
#      Resample1
# [1,]         2
# [2,]         4
# [3,]         5
# [4,]         6
# [5,]         7
# [6,]        11


train <- data_sub[index, ]
test  <- data_sub[-index, ]


dim(train)
# 273   5
dim(test)
# 116   5


y_train <- data$DEFAULTER[index]
y_test  <- data$DEFAULTER[-index]


y_pred <- knn(train, test, k = 17, cl = y_train)


table(y_test, y_pred)
#       y_pred
# y_test  0  1
#      0 46 16
#      1 16 38


class(y_pred)
# "factor"
class(y_test)
# "integer"


y_test <- as.factor(y_test)


confusionMatrix(y_test, y_pred)
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction  0  1
#          0 46 16
#          1 16 38
# 
#                Accuracy : 0.7241         
#                  95% CI : (0.6334, 0.803)
#     No Information Rate : 0.5345         
#     P-Value [Acc > NIR] : 2.222e-05      
# 
#                   Kappa : 0.4456         
# 
#  Mcnemar's Test P-Value : 1              
# 
#             Sensitivity : 0.7419         
#             Specificity : 0.7037         
#          Pos Pred Value : 0.7419         
#          Neg Pred Value : 0.7037         
#              Prevalence : 0.5345         
#          Detection Rate : 0.3966         
#    Detection Prevalence : 0.5345         
#       Balanced Accuracy : 0.7228         
# 
#        'Positive' Class : 0   







