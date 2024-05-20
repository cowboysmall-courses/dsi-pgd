
library(car)
library(caret)
library(ROCR)
library(e1071)


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
#     1: Import Email Campaign data. Perform binary logistic regression to model
#        "Success. Interpret sign of each significant variable in the model.
#     2: Compare performance of Binary Logistic Regression (significant
#        variables) and Naïve Bayes Method (all variables) using area under the
#        ROC curve.
#     3: Implement binary logistic regression and Support Vector Machines by
#        combining service and product variables. State area under the ROC curve
#        in each case.





data <- read.csv("./data/0704_machine_learning_01/04_assignment/Email Campaign.csv", header = TRUE)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success
# 1  1      1 <=45              12              11        11.82         2.68       0
# 2  2      2 <=30               6               0        10.31         1.32       0
# 3  3      1 <=30               1               9         7.43         0.49       0
# 4  4      1 <=45               2              14        13.68         1.85       0
# 5  5      2 <=30               0              11         4.56         1.01       1
# 6  6      2 <=30               1               2        18.99         0.44       1


sum(is.na(data))
# 0

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
data$Success <- as.factor(data$Success)


summary(data)
#        SN           Gender      AGE      Recency_Service  Recency_Product   Bill_Service     Bill_Product    Success
#  Min.   :  1.0   Female:372   <=30:238   Min.   : 0.000   Min.   : 0.000   Min.   : 0.450   Min.   : 0.050   0:503
#  1st Qu.:171.5   Male  :311   <=45:277   1st Qu.: 3.000   1st Qu.: 3.000   1st Qu.: 5.705   1st Qu.: 0.860   1:180
#  Median :342.0                <=55:168   Median : 7.000   Median : 7.000   Median : 9.280   Median : 1.450
#  Mean   :342.0                           Mean   : 8.471   Mean   : 8.376   Mean   :10.796   Mean   : 2.065
#  3rd Qu.:512.5                           3rd Qu.:12.500   3rd Qu.:12.000   3rd Qu.:14.835   3rd Qu.: 2.460
#  Max.   :683.0                           Max.   :32.000   Max.   :35.000   Max.   :41.550   Max.   :20.690


counts <- data.frame(table(data$Success))
colnames(counts)[1] <- "Success"
counts$Percent <- counts$Freq / sum(counts$Freq)
counts
#   Success Freq   Percent
# 1       0  503 0.7364568
# 2       1  180 0.2635432


# threshold <- 0.74
threshold <- 0.5





# 1. Import Email Campaign data. Perform binary logistic regression to model
#    "Success". Interpret sign of each significant variable in the model.

model_glm <- glm(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, family = binomial)
summary(model_glm)
# Call:
# glm(formula = Success ~ Gender + AGE + Recency_Service + Recency_Product +
#     Bill_Service + Bill_Product, family = binomial, data = data)
#
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)
# (Intercept)     -1.25849    0.27115  -4.641 3.46e-06 ***
# GenderMale       0.23697    0.21414   1.107    0.268
# AGE<=45          0.15725    0.26726   0.588    0.556
# AGE<=55          0.67267    0.36588   1.839    0.066 .
# Recency_Service -0.24592    0.02944  -8.352  < 2e-16 ***
# Recency_Product -0.09087    0.02207  -4.117 3.84e-05 ***
# Bill_Service     0.09293    0.01854   5.013 5.36e-07 ***
# Bill_Product     0.51966    0.08103   6.413 1.43e-10 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 787.81  on 682  degrees of freedom
# Residual deviance: 545.98  on 675  degrees of freedom
# AIC: 561.98
#
# Number of Fisher Scoring iterations: 6


vif(model_glm)
#                     GVIF Df GVIF^(1/(2*Df))
# Gender          1.008713  1        1.004347
# AGE             1.638617  2        1.131408
# Recency_Service 2.019479  1        1.421084
# Recency_Product 1.484285  1        1.218312
# Bill_Service    1.322204  1        1.149871
# Bill_Product    2.241463  1        1.497152


model_glm <- glm(Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, family = binomial)
summary(model_glm)
# Call:
# glm(formula = Success ~ Recency_Service + Recency_Product + Bill_Service +
#     Bill_Product, family = binomial, data = data)
#
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)
# (Intercept)     -1.15780    0.24777  -4.673 2.97e-06 ***
# Recency_Service -0.22984    0.02728  -8.426  < 2e-16 ***
# Recency_Product -0.07389    0.01932  -3.825 0.000131 ***
# Bill_Service     0.09183    0.01846   4.974 6.55e-07 ***
# Bill_Product     0.51852    0.08083   6.415 1.41e-10 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 787.81  on 682  degrees of freedom
# Residual deviance: 550.87  on 678  degrees of freedom
# AIC: 560.87
#
# Number of Fisher Scoring iterations: 6


# - one unit increase in the Recency_Service estimator will result in a -0.22984
#   change in the log odds of the email being successfully opened
# - one unit increase in the Recency_Product estimator will result in a -0.07389
#   change in the log odds of the email being successfully opened

# - one unit increase in the Bill_Service estimator will result in a 0.09183
#   change in the log odds of the email being successfully opened
# - one unit increase in the Bill_Product estimator will result in a 0.51852
#   change in the log odds of the email being successfully opened

# - Both the estimates of Recency_Service and Recency_Product negatively affect
#   the outcome - the greater the value of each estimator, the less is the
#   likelihood a successful outcome

# - Both the estimates of Bill_Service and Bill_Product positively affect the
#   outcome - the greater the value of each estimator, the more is the
#   likelihood a successful outcome


vif(model_glm)
# Recency_Service Recency_Product    Bill_Service    Bill_Product
#        1.737141        1.131628        1.320786        2.218089





# 2. Compare performance of Binary Logistic Regression (significant variables)
#    and Naïve Bayes Method (all variables) using area under the ROC curve.

index <- createDataPartition(data$Success, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]


model_glm <- glm(Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = train, family = binomial)


predprob_glm <- round(fitted(model_glm), 2)
pred_glm     <- prediction(predprob_glm, train$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8346823


predY_glm <- as.factor(ifelse(predprob_glm > threshold, 1, 0))
confusionMatrix(predY_glm, train$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 332  61
#          1  21  65
#
#                Accuracy : 0.8288
#                  95% CI : (0.792, 0.8615)
#     No Information Rate : 0.737
#     P-Value [Acc > NIR] : 1.235e-06
#
#                   Kappa : 0.5083
#
#  Mcnemar's Test P-Value : 1.656e-05
#
#             Sensitivity : 0.5159
#             Specificity : 0.9405
#          Pos Pred Value : 0.7558
#          Neg Pred Value : 0.8448
#              Prevalence : 0.2630
#          Detection Rate : 0.1357
#    Detection Prevalence : 0.1795
#       Balanced Accuracy : 0.7282
#
#        'Positive' Class : 1


predprob_glm <- predict(model_glm, test, type = "response")
pred_glm     <- prediction(predprob_glm, test$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8407407


predY_glm <- as.factor(ifelse(predprob_glm > threshold, 1, 0))
confusionMatrix(predY_glm, test$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 137  30
#          1  13  24
#
#                Accuracy : 0.7892
#                  95% CI : (0.7268, 0.8431)
#     No Information Rate : 0.7353
#     P-Value [Acc > NIR] : 0.04537
#
#                   Kappa : 0.3979
#
#  Mcnemar's Test P-Value : 0.01469
#
#             Sensitivity : 0.4444
#             Specificity : 0.9133
#          Pos Pred Value : 0.6486
#          Neg Pred Value : 0.8204
#              Prevalence : 0.2647
#          Detection Rate : 0.1176
#    Detection Prevalence : 0.1814
#       Balanced Accuracy : 0.6789
#
#        'Positive' Class : 1



model_nb <- naiveBayes(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = train)
model_nb
# Naive Bayes Classifier for Discrete Predictors
#
# Call:
# naiveBayes.default(x = X, y = Y, laplace = laplace)
#
# A-priori probabilities:
# Y
#        0        1
# 0.736952 0.263048
#
# Conditional probabilities:
#    Gender
# Y      Female      Male
#   0 0.5637394 0.4362606
#   1 0.5317460 0.4682540
#
#    AGE
# Y        <=30      <=45      <=55
#   0 0.2889518 0.4645892 0.2464589
#   1 0.4920635 0.3253968 0.1825397
#
#    Recency_Service
# Y       [,1]     [,2]
#   0 9.521246 6.643967
#   1 5.182540 5.467578
#
#    Recency_Product
# Y       [,1]     [,2]
#   0 8.849858 6.867050
#   1 6.460317 6.579545
#
#    Bill_Service
# Y        [,1]     [,2]
#   0  9.229377 5.896293
#   1 15.624921 7.899061
#
#    Bill_Product
# Y       [,1]     [,2]
#   0 1.730510 1.399769
#   1 2.953968 3.265132


predprob_nb <- predict(model_nb, train, type = "raw")
pred_nb     <- prediction(predprob_nb[, 2], train$Success)
perf_nb     <- performance(pred_nb, "tpr", "fpr")

plot(perf_nb)
abline(0, 1)


auc <- performance(pred_nb, "auc")
auc@y.values
# 0.8109402


predY_nb <- as.factor(ifelse(predprob_nb[, 2] > threshold, 1, 0))
confusionMatrix(predY_nb, train$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 326  78
#          1  27  48
#
#                Accuracy : 0.7808
#                  95% CI : (0.741, 0.8171)
#     No Information Rate : 0.737
#     P-Value [Acc > NIR] : 0.01541
#
#                   Kappa : 0.35
#
#  Mcnemar's Test P-Value : 1.064e-06
#
#             Sensitivity : 0.3810
#             Specificity : 0.9235
#          Pos Pred Value : 0.6400
#          Neg Pred Value : 0.8069
#              Prevalence : 0.2630
#          Detection Rate : 0.1002
#    Detection Prevalence : 0.1566
#       Balanced Accuracy : 0.6522
#
#        'Positive' Class : 1


predprob_nb <- predict(model_nb, test, type = "raw")
pred_nb     <- prediction(predprob_nb[, 2], test$Success)
perf_nb     <- performance(pred_nb, "tpr", "fpr")

plot(perf_nb)
abline(0, 1)


auc <- performance(pred_nb, "auc")
auc@y.values
# 0.8108642


predY_nb <- as.factor(ifelse(predprob_nb[, 2] > threshold, 1, 0))
confusionMatrix(predY_nb, test$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 140  32
#          1  10  22
#
#                Accuracy : 0.7941
#                  95% CI : (0.7321, 0.8474)
#     No Information Rate : 0.7353
#     P-Value [Acc > NIR] : 0.031561
#
#                   Kappa : 0.3918
#
#  Mcnemar's Test P-Value : 0.001194
#
#             Sensitivity : 0.4074
#             Specificity : 0.9333
#          Pos Pred Value : 0.6875
#          Neg Pred Value : 0.8140
#              Prevalence : 0.2647
#          Detection Rate : 0.1078
#    Detection Prevalence : 0.1569
#       Balanced Accuracy : 0.6704
#
#        'Positive' Class : 1




# 3. Implement binary logistic regression and Support Vector Machines by
#    combining service and product variables. State area under the ROC curve
#    in each case.

data$Recency_Max <- pmax(data$Recency_Service, data$Recency_Product)
data$Bill_Total  <- data$Bill_Service + data$Bill_Product

head(data)

index <- createDataPartition(data$Success, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]


model_glm <- glm(Success ~ Recency_Max + Bill_Total, data = train, family = binomial)
summary(model_glm)
# Call:
# glm(formula = Success ~ Recency_Max + Bill_Total, family = binomial,
#     data = train)
#
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)
# (Intercept) -1.27801    0.26615  -4.802 1.57e-06 ***
# Recency_Max -0.15432    0.02235  -6.906 4.99e-12 ***
# Bill_Total   0.12818    0.01605   7.988 1.37e-15 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 552.02  on 478  degrees of freedom
# Residual deviance: 433.44  on 476  degrees of freedom
# AIC: 439.44
#
# Number of Fisher Scoring iterations: 5


predprob_glm <- round(fitted(model_glm), 2)
pred_glm     <- prediction(predprob_glm, train$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8202595



threshold <- 0.5
predY_glm <- as.factor(ifelse(predprob_glm > threshold, 1, 0))
confusionMatrix(predY_glm, train$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 335  78
#          1  18  48
#
#                Accuracy : 0.7996
#                  95% CI : (0.7609, 0.8345)
#     No Information Rate : 0.737
#     P-Value [Acc > NIR] : 0.0008436
#
#                   Kappa : 0.3896
#
#  Mcnemar's Test P-Value : 1.726e-09
#
#             Sensitivity : 0.3810
#             Specificity : 0.9490
#          Pos Pred Value : 0.7273
#          Neg Pred Value : 0.8111
#              Prevalence : 0.2630
#          Detection Rate : 0.1002
#    Detection Prevalence : 0.1378
#       Balanced Accuracy : 0.6650
#
#        'Positive' Class : 1


predprob_glm <- predict(model_glm, test, type = "response")
pred_glm     <- prediction(predprob_glm, test$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8132099


predY_glm <- as.factor(ifelse(predprob_glm > threshold, 1, 0))
confusionMatrix(predY_glm, test$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 139  31
#          1  11  23
#
#                Accuracy : 0.7941
#                  95% CI : (0.7321, 0.8474)
#     No Information Rate : 0.7353
#     P-Value [Acc > NIR] : 0.03156
#
#                   Kappa : 0.4
#
#  Mcnemar's Test P-Value : 0.00337
#
#             Sensitivity : 0.4259
#             Specificity : 0.9267
#          Pos Pred Value : 0.6765
#          Neg Pred Value : 0.8176
#              Prevalence : 0.2647
#          Detection Rate : 0.1127
#    Detection Prevalence : 0.1667
#       Balanced Accuracy : 0.6763
#
#        'Positive' Class : 1



model_svm <- svm(Success ~ Recency_Max + Bill_Total, data = train, type = "C", probability = TRUE, kernel = "linear")
model_svm
# Call:
# svm(formula = Success ~ Recency_Max + Bill_Total, data = train, type = "C", probability = TRUE, kernel = "linear")
#
#
# Parameters:
#    SVM-Type:  C-classification
#  SVM-Kernel:  linear
#        cost:  1
#
# Number of Support Vectors:  237


pred1 <- predict(model_svm, train, probability = TRUE)
pred2 <- attr(pred1, "probabilities")[, 2]

pred_svm <- prediction(pred2, train$Success)
perf_svm <- performance(pred_svm, "tpr", "fpr")

plot(perf_svm)
abline(0, 1)


auc <- performance(pred_svm, "auc")
auc@y.values
# 0.8185732

predY_svm <- as.factor(ifelse(pred2 > threshold, 1, 0))
confusionMatrix(predY_svm, train$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 462 108
#          1  41  72
#
#                Accuracy : 0.7818
#                  95% CI : (0.749, 0.8123)
#     No Information Rate : 0.7365
#     P-Value [Acc > NIR] : 0.003523
#
#                   Kappa : 0.3617
#
#  Mcnemar's Test P-Value : 6.411e-08
#
#             Sensitivity : 0.4000
#             Specificity : 0.9185
#          Pos Pred Value : 0.6372
#          Neg Pred Value : 0.8105
#              Prevalence : 0.2635
#          Detection Rate : 0.1054
#    Detection Prevalence : 0.1654
#       Balanced Accuracy : 0.6592
#
#        'Positive' Class : 1




pred1 <- predict(model_svm, test, probability = TRUE)
pred2 <- attr(pred1, "probabilities")[, 2]

pred_svm <- prediction(pred2, test$Success)
perf_svm <- performance(pred_svm, "tpr", "fpr")

plot(perf_svm)
abline(0, 1)


auc <- performance(pred_svm, "auc")
auc@y.values
# 0.8116049

predY_svm <- as.factor(ifelse(pred2 > threshold, 1, 0))
confusionMatrix(predY_svm, test$Success, positive = "1")
# Confusion Matrix and Statistics
#
#           Reference
# Prediction   0   1
#          0 135  34
#          1  15  20
#
#                Accuracy : 0.7598
#                  95% CI : (0.6952, 0.8167)
#     No Information Rate : 0.7353
#     P-Value [Acc > NIR] : 0.23951
#
#                   Kappa : 0.3047
#
#  Mcnemar's Test P-Value : 0.01013
#
#             Sensitivity : 0.37037
#             Specificity : 0.90000
#          Pos Pred Value : 0.57143
#          Neg Pred Value : 0.79882
#              Prevalence : 0.26471
#          Detection Rate : 0.09804
#    Detection Prevalence : 0.17157
#       Balanced Accuracy : 0.63519
#
#        'Positive' Class : 1






