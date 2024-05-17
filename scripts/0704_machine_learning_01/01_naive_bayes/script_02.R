
library(ROCR)
library(e1071)


data1 <- read.csv("./data/0704_machine_learning_01/01_naive_bayes/Data for Laplace Smoothing.csv", header = TRUE)

data1$X1 <- factor(data1$X1)

head(data1)
#   Y X1 X2 X3
# 1 0  1  M  A
# 2 0  2  M  A
# 3 0  2  M  A
# 4 0  1  M  A
# 5 0  2  F  A
# 6 1  2  F  A


model <- naiveBayes(Y ~ X1 + X2 + X3, data = data1)
model
# 
# Naive Bayes Classifier for Discrete Predictors
# 
# Call:
# naiveBayes.default(x = X, y = Y, laplace = laplace)
# 
# A-priori probabilities:
# Y
#         0         1 
# 0.3571429 0.6428571 
# 
# Conditional probabilities:
#    X1
# Y     1   2
#   0 0.5 0.5
#   1 0.0 1.0
# 
#    X2
# Y           F         M
#   0 0.5000000 0.5000000
#   1 0.3333333 0.6666667
# 
#    X3
# Y           A         B
#   0 0.8000000 0.2000000
#   1 0.2777778 0.7222222


laplace <- naiveBayes(Y ~ X1 + X2 + X3, data = data1, laplace = 2)
laplace
# 
# Naive Bayes Classifier for Discrete Predictors
# 
# Call:
# naiveBayes.default(x = X, y = Y, laplace = laplace)
# 
# A-priori probabilities:
# Y
#         0         1 
# 0.3571429 0.6428571 
# 
# Conditional probabilities:
#    X1
# Y            1          2
#   0 0.50000000 0.50000000
#   1 0.09090909 0.90909091
# 
#    X2
# Y           F         M
#   0 0.7000000 0.7000000
#   1 0.4444444 0.7777778
# 
#    X3
# Y           A         B
#   0 1.0000000 0.4000000
#   1 0.3888889 0.8333333



data2 <- read.csv("./data/0704_machine_learning_01/01_naive_bayes/New Data for Laplace Predictions.csv", header = TRUE)
head(data2)
#   Y X1 X2 X3
# 1 1  1  M  A
# 2 0  2  M  A
# 3 0  2  M  A
# 4 1  1  M  A


data2$X1 <- factor(data2$X1)


pred1 <- predict(laplace, data2, type = "raw")
pred1
#              0         1
# [1,] 0.8761062 0.1238938
# [2,] 0.4142259 0.5857741
# [3,] 0.4142259 0.5857741
# [4,] 0.8761062 0.1238938


pred2 <- predict(laplace, data2, type = "raw", threshold = 0.1, eps = 0.1)
pred2
#              0         1
# [1,] 0.8653846 0.1346154
# [2,] 0.4142259 0.5857741
# [3,] 0.4142259 0.5857741
# [4,] 0.8653846 0.1346154

