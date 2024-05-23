

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
#        "Success". Interpret sign of each significant variable in the model.
#     2: Compare performance of Binary Logistic Regression (significant
#        variables) and Naïve Bayes Method (all variables) using area under the
#        ROC curve.
#     3: Implement binary logistic regression and Support Vector Machines by
#        combining service and product variables. State area under the ROC curve
#        in each case.


library(car)
library(caret)
library(ROCR)
library(e1071)


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


str(data)
# 'data.frame':   683 obs. of  10 variables:
#  $ SN             : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ Gender         : Factor w/ 2 levels "Female","Male": 2 1 2 2 1 1 2 2 2 2 ...
#  $ AGE            : Factor w/ 3 levels "<=30","<=45",..: 2 1 1 2 1 1 1 2 2 1 ...
#  $ Recency_Service: int  12 6 1 2 0 1 11 16 14 8 ...
#  $ Recency_Product: int  11 0 9 14 11 2 8 9 8 4 ...
#  $ Bill_Service   : num  11.82 10.31 7.43 13.68 4.56 ...
#  $ Bill_Product   : num  2.68 1.32 0.49 1.85 1.01 ...
#  $ Success        : Factor w/ 2 levels "0","1": 1 1 1 1 2 2 1 1 2 1 ...










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


vif(model_glm)
# Recency_Service Recency_Product    Bill_Service    Bill_Product
#        1.737141        1.131628        1.320786        2.218089


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










# 2. Compare performance of Binary Logistic Regression (significant variables)
#    and Naïve Bayes Method (all variables) using area under the ROC curve.


#   My approach is as follows:
#     1. split the data into train and test data sets
#     2. train a model for each classifier (glm and naive bayes)
#     3. evaluate the models with both train and test sets - to
#        ensure that each of the models are consistent and perform
#        well
#     4. compare the results of each model's performance for the
#        test data set


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
# 0.8526238


predY_glm <- as.factor(ifelse(predprob_glm > 0.5, 1, 0))
confusionMatrix(predY_glm, train$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 328  62
#          1  25  64
# 
#                Accuracy : 0.8184
#                  95% CI : (0.7809, 0.8519)
#     No Information Rate : 0.737           
#     P-Value [Acc > NIR] : 1.714e-05
# 
#                   Kappa : 0.4827
# 
#  Mcnemar's Test P-Value : 0.0001136
# 
#             Sensitivity : 0.5079
#             Specificity : 0.9292
#          Pos Pred Value : 0.7191
#          Neg Pred Value : 0.8410
#              Prevalence : 0.2630          
#          Detection Rate : 0.1336
#    Detection Prevalence : 0.1858
#       Balanced Accuracy : 0.7186
# 
#        'Positive' Class : 1


predprob_glm <- predict(model_glm, test, type = "response")
pred_glm     <- prediction(predprob_glm, test$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8503704


predY_glm <- as.factor(ifelse(predprob_glm > 0.5, 1, 0))
confusionMatrix(predY_glm, test$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 145  32
#          1   5  22
# 
#                Accuracy : 0.8186
#                  95% CI : (0.7588, 0.869)
#     No Information Rate : 0.7353
#     P-Value [Acc > NIR] : 0.003397
# 
#                   Kappa : 0.4453
# 
#  Mcnemar's Test P-Value : 1.917e-05
# 
#             Sensitivity : 0.4074
#             Specificity : 0.9667
#          Pos Pred Value : 0.8148
#          Neg Pred Value : 0.8192
#              Prevalence : 0.2647
#          Detection Rate : 0.1078
#    Detection Prevalence : 0.1324
#       Balanced Accuracy : 0.6870
# 
#        'Positive' Class : 1


# The glm model performs consistently well





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
#   0 0.5694051 0.4305949
#   1 0.5238095 0.4761905
# 
#    AGE
# Y        <=30      <=45      <=55
#   0 0.3172805 0.4192635 0.2634561
#   1 0.4920635 0.3095238 0.1984127
# 
#    Recency_Service
# Y       [,1]     [,2]
#   0 9.501416 6.710374
#   1 5.182540 5.733272
# 
#    Recency_Product
# Y       [,1]     [,2]
#   0 8.830028 7.162045
#   1 6.920635 6.460468
# 
#    Bill_Service
# Y        [,1]     [,2]
#   0  9.285524 5.621474
#   1 15.592063 8.206811
# 
#    Bill_Product
# Y       [,1]     [,2]
#   0 1.746969 1.491369
#   1 3.090873 3.485516


predprob_nb <- predict(model_nb, train, type = "raw")
pred_nb     <- prediction(predprob_nb[, 2], train$Success)
perf_nb     <- performance(pred_nb, "tpr", "fpr")

plot(perf_nb)
abline(0, 1)


auc <- performance(pred_nb, "auc")
auc@y.values
# 0.8150546


predY_nb <- as.factor(ifelse(predprob_nb[, 2] > 0.5, 1, 0))
confusionMatrix(predY_nb, train$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 324  76
#          1  29  50
# 
#                Accuracy : 0.7808
#                  95% CI : (0.741, 0.8171)
#     No Information Rate : 0.737
#     P-Value [Acc > NIR] : 0.01541
# 
#                   Kappa : 0.3576
# 
#  Mcnemar's Test P-Value : 7.151e-06
# 
#             Sensitivity : 0.3968
#             Specificity : 0.9178
#          Pos Pred Value : 0.6329
#          Neg Pred Value : 0.8100
#              Prevalence : 0.2630
#          Detection Rate : 0.1044
#    Detection Prevalence : 0.1649
#       Balanced Accuracy : 0.6573
# 
#        'Positive' Class : 1


predprob_nb <- predict(model_nb, test, type = "raw")
pred_nb     <- prediction(predprob_nb[, 2], test$Success)
perf_nb     <- performance(pred_nb, "tpr", "fpr")

plot(perf_nb)
abline(0, 1)


auc <- performance(pred_nb, "auc")
auc@y.values
# 0.8080247


predY_nb <- as.factor(ifelse(predprob_nb[, 2] > 0.5, 1, 0))
confusionMatrix(predY_nb, test$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 142  40
#          1   8  14
# 
#                Accuracy : 0.7647
#                  95% CI : (0.7004, 0.8211)
#     No Information Rate : 0.7353          
#     P-Value [Acc > NIR] : 0.1922
# 
#                   Kappa : 0.2541
# 
#  Mcnemar's Test P-Value : 7.66e-06
# 
#             Sensitivity : 0.25926
#             Specificity : 0.94667
#          Pos Pred Value : 0.63636
#          Neg Pred Value : 0.78022
#              Prevalence : 0.26471
#          Detection Rate : 0.06863
#    Detection Prevalence : 0.10784
#       Balanced Accuracy : 0.60296
# 
#        'Positive' Class : 1


# The naive bayes model performs consistently well


# According to the above analysis, the glm model outperforms the naive bayes
# model significantly - looking at AUC for the train and test data for each
# model in turn:
#
# Training Data:
#       GLM AUC: 0.8526238
#        NB AUC: 0.8150546
#
#     Test Data:
#       GLM AUC: 0.8503704
#        NB AUC: 0.8080247











# 3. Implement binary logistic regression and Support Vector Machines by
#    combining service and product variables. State area under the ROC curve
#    in each case.


# For this exercise I have decided on the following ways of combining the data:
#     1.  Bill_Total = Bill_Service + Bill_Product
#     2. Recency_Max = max(Recency_Service, Recency_Product)
# I was considering adding both Recency values to get an indication of the
# magnitude of both Recency values, but in the end went with the max value of
# each.


data$Recency_Max <- pmax(data$Recency_Service, data$Recency_Product)
data$Bill_Total  <- data$Bill_Service + data$Bill_Product
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success Recency_Max Bill_Total
# 1  1   Male <=45              12              11        11.82         2.68       0          12      14.50
# 2  2 Female <=30               6               0        10.31         1.32       0           6      11.63
# 3  3   Male <=30               1               9         7.43         0.49       0           9       7.92
# 4  4   Male <=45               2              14        13.68         1.85       0          14      15.53
# 5  5 Female <=30               0              11         4.56         1.01       1          11       5.57
# 6  6 Female <=30               1               2        18.99         0.44       1           2      19.43


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
# (Intercept) -1.51016    0.27129  -5.567 2.60e-08 ***
# Recency_Max -0.14170    0.02145  -6.606 3.94e-11 ***
# Bill_Total   0.13504    0.01643   8.218  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 552.02  on 478  degrees of freedom
# Residual deviance: 433.14  on 476  degrees of freedom
# AIC: 439.14
# 
# Number of Fisher Scoring iterations: 5


predprob_glm <- round(fitted(model_glm), 2)
pred_glm     <- prediction(predprob_glm, train$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8079837


predY_glm <- as.factor(ifelse(predprob_glm > 0.5, 1, 0))
confusionMatrix(predY_glm, train$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 327  83
#          1  26  43
# 
#                Accuracy : 0.7724
#                  95% CI : (0.7322, 0.8093)
#     No Information Rate : 0.737           
#     P-Value [Acc > NIR] : 0.04186
# 
#                   Kappa : 0.3132
# 
#  Mcnemar's Test P-Value : 8.148e-08
# 
#             Sensitivity : 0.34127
#             Specificity : 0.92635
#          Pos Pred Value : 0.62319
#          Neg Pred Value : 0.79756
#              Prevalence : 0.26305
#          Detection Rate : 0.08977
#    Detection Prevalence : 0.14405
#       Balanced Accuracy : 0.63381
# 
#        'Positive' Class : 1


predprob_glm <- predict(model_glm, test, type = "response")
pred_glm     <- prediction(predprob_glm, test$Success)
perf_glm     <- performance(pred_glm, "tpr", "fpr")

plot(perf_glm)
abline(0, 1)


auc <- performance(pred_glm, "auc")
auc@y.values
# 0.8390123


predY_glm <- as.factor(ifelse(predprob_glm > 0.5, 1, 0))
confusionMatrix(predY_glm, test$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 145  32
#          1   5  22
# 
#                Accuracy : 0.8186
#                  95% CI : (0.7588, 0.869)
#     No Information Rate : 0.7353
#     P-Value [Acc > NIR] : 0.003397
# 
#                   Kappa : 0.4453
# 
#  Mcnemar's Test P-Value : 1.917e-05
# 
#             Sensitivity : 0.4074
#             Specificity : 0.9667
#          Pos Pred Value : 0.8148
#          Neg Pred Value : 0.8192
#              Prevalence : 0.2647
#          Detection Rate : 0.1078
#    Detection Prevalence : 0.1324
#       Balanced Accuracy : 0.6870
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
# Number of Support Vectors:  241


pred1 <- predict(model_svm, train, probability = TRUE)
pred2 <- attr(pred1, "probabilities")[, 2]

pred_svm <- prediction(pred2, train$Success)
perf_svm <- performance(pred_svm, "tpr", "fpr")

plot(perf_svm)
abline(0, 1)


auc <- performance(pred_svm, "auc")
auc@y.values
# 0.8083097

predY_svm <- as.factor(ifelse(pred2 > 0.5, 1, 0))
confusionMatrix(predY_svm, train$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 325  79
#          1  28  47
# 
#                Accuracy : 0.7766
#                  95% CI : (0.7366, 0.8132)
#     No Information Rate : 0.737           
#     P-Value [Acc > NIR] : 0.02595
# 
#                   Kappa : 0.3376
# 
#  Mcnemar's Test P-Value : 1.34e-06
# 
#             Sensitivity : 0.37302
#             Specificity : 0.92068
#          Pos Pred Value : 0.62667
#          Neg Pred Value : 0.80446
#              Prevalence : 0.26305
#          Detection Rate : 0.09812
#    Detection Prevalence : 0.15658
#       Balanced Accuracy : 0.64685
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
# 0.8385185

predY_svm <- as.factor(ifelse(pred2 > 0.5, 1, 0))
confusionMatrix(predY_svm, test$Success, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 146  32
#          1   4  22
# 
#                Accuracy : 0.8235
#                  95% CI : (0.7642, 0.8732)
#     No Information Rate : 0.7353          
#     P-Value [Acc > NIR] : 0.001991
# 
#                   Kappa : 0.4565
# 
#  Mcnemar's Test P-Value : 6.795e-06
# 
#             Sensitivity : 0.4074
#             Specificity : 0.9733
#          Pos Pred Value : 0.8462
#          Neg Pred Value : 0.8202
#              Prevalence : 0.2647
#          Detection Rate : 0.1078
#    Detection Prevalence : 0.1275
#       Balanced Accuracy : 0.6904
# 
#        'Positive' Class : 1


# According to the above analysis, the glm model and the svm model perform
# almost identically - looking at AUC for the train and test data for each
# model in turn:
# 
# Training Data:
#       GLM AUC: 0.8079837
#       SVM AUC: 0.8083097
# 
#     Test Data:
#       GLM AUC: 0.8390123
#       SVM AUC: 0.8385185

