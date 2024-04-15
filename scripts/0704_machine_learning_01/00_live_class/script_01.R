
library(caret)
library(class)


# data <- read.csv("./data/0704_machine_learning_01/00_live_class/BANK\ LOAN.csv", header = TRUE)
data <- read.csv("./data/0704_machine_learning_01/00_live_class/BANK\ LOAN\ KNN.csv", header = TRUE)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER
# 1  1   3     17      12     9.3    11.36    5.01         1
# 2  5   1      2       0    17.3     1.79    3.06         1
# 3  8   3     12      11     3.6     0.13    1.24         0
# 4  9   1      3       4    24.4     1.36    3.28         1
# 5 13   3     24      14    10.0     3.93    2.47         0
# 6 14   2      6       9    16.3     1.72    3.01         0


data2 <- subset(data, select = c(-AGE, -SN, -DEFAULTER))


data2 <- scale(data2)


index <- createDataPartition(data$SN, p = 0.7, list = FALSE)
train <- data2[index, ]
test  <- data2[-index, ]


y_train <- data$DEFAULTER[index]
y_test  <- data$DEFAULTER[-index]


y_test_pred <- knn(train, test, k = 17, cl = y_train)


table(y_test, y_test_pred)
#       y_test_pred
# y_test  0  1
#      0 44 13
#      1 15 44

