
library(car)
library(pls)
library(caret)


# set.seed(123)


# 1 - import the data
data <- read.csv("./data/0604_unsupervised_multivariate_methods/04_case_study/Diabetes\ Data.csv", header = TRUE)
head(data)
#   AGE  BMI  BP  S1    S2 S3 S4     S5 S6   Y
# 1  59 32.1 101 157  93.2 38  4 4.8598 87 151
# 2  48 21.6  87 183 103.2 70  3 3.8918 69  75
# 3  72 30.5  93 156  93.6 41  4 4.6728 85 141
# 4  24 25.3  84 198 131.4 40  5 4.8903 89 206
# 5  50 23.0 101 192 125.4 52  4 4.2905 80 135
# 6  23 22.6  89 139  64.8 61  2 4.1897 68  97

# 2 - check the data dimensions
dim(data)
# 442  10

# 3 - create a model with Y as dependent variable
model <- lm(Y ~ AGE + BMI + BP + S1 + S2 + S3 + S4 + S5 + S6, data = data)

# 4 - check summary, and comment on R
summary(model)
# 
# Call:
# lm(formula = Y ~ AGE + BMI + BP + S1 + S2 + S3 + S4 + S5 + S6, 
#     data = data)
# 
# Residuals:
#      Min       1Q   Median       3Q      Max 
# -147.044  -39.028   -4.167   38.202  152.402 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -363.8987    68.1416  -5.340 1.50e-07 ***
# AGE           -0.1205     0.2195  -0.549   0.5833    
# BMI            6.0041     0.7214   8.322 1.14e-15 ***
# BP             0.9505     0.2248   4.227 2.89e-05 ***
# S1            -0.9808     0.5821  -1.685   0.0927 .  
# S2             0.6585     0.5391   1.221   0.2226    
# S3             0.5136     0.7945   0.646   0.5183    
# S4             4.6599     6.0372   0.772   0.4406    
# S5            68.9473    15.9273   4.329 1.86e-05 ***
# S6             0.2026     0.2771   0.731   0.4650    
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 55.05 on 432 degrees of freedom
# Multiple R-squared:  0.5006,    Adjusted R-squared:  0.4902 
# F-statistic: 48.11 on 9 and 432 DF,  p-value: < 2.2e-16

# R-squared is around 50% - which is no better than a a coin toss.

# 5 - check VIF
vif(model)
#       AGE       BMI        BP        S1        S2        S3        S4        S5 
#  1.205380  1.478660  1.407578 59.062508 39.123245 15.369272  8.833675 10.075391 
#        S6 
#  1.476845 


index <- createDataPartition(data$Y, p = 0.8, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]

dim(train)
# 355  10
dim(test)
# 87 10


train_model <- lm(Y ~ AGE + BMI + BP + S1 + S2 + S3 + S4 + S5 + S6, data = train)

train_resi <- residuals(train_model)
train_rmse <- sqrt(mean(train_resi ** 2))
train_rmse
# 54.76055

test_pred <- predict(train_model, test)
test_resi <- test$Y - test_pred
test_rmse <- sqrt(mean(test_resi ** 2))
test_rmse
# 53.4079


data_pca <- subset(data, select = c(-Y))
pc <- princomp(~., data = data_pca, cor = TRUE)
summary(pc)
# Importance of components:
#                           Comp.1    Comp.2    Comp.3     Comp.4    Comp.5
# Standard deviation     1.9788912 1.1803160 1.0954142 0.86171293 0.7767701
# Proportion of Variance 0.4351123 0.1547940 0.1333258 0.08250546 0.0670413
# Cumulative Proportion  0.4351123 0.5899063 0.7232321 0.80573752 0.8727788
#                            Comp.6     Comp.7      Comp.8       Comp.9
# Standard deviation     0.73688897 0.71769845 0.279862592 0.0925801681
# Proportion of Variance 0.06033393 0.05723234 0.008702563 0.0009523431
# Cumulative Proportion  0.93311275 0.99034509 0.999047657 1.0000000000


train_model_pcr <- pcr(Y ~ AGE + BMI + BP + S1 + S2 + S3 + S4 + S5 + S6, ncomp = 4, data = train, scale = TRUE)
summary(train_model_pcr)
# Data:   X dimension: 355 9 
#         Y dimension: 355 1
# Fit method: svdpc
# Number of components considered: 4
# TRAINING: % variance explained
#    1 comps  2 comps  3 comps  4 comps
# X    43.71    59.02    72.14    80.61
# Y    32.23    41.69    42.67    45.50

train_resi_pcr <- residuals(train_model_pcr)
train_pcr_rmse <- sqrt(mean(train_resi_pcr ** 2))
train_pcr_rmse
# 58.64549

test_pred_pcr <- predict(train_model_pcr, test, ncomp = 4)
test_resi_pcr <- (test$Y - test_pred_pcr)
test_rmse_pcr <- sqrt(mean(test_resi_pcr ** 2))
test_rmse_pcr
# 55.90645


