
library(ROCR)
library(e1071)


data <- read.csv("./data/0704_machine_learning_01/01_naive_bayes/BANK LOAN.csv", header = TRUE)
str(data)
# 'data.frame':   700 obs. of  8 variables:
#  $ SN       : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ AGE      : int  3 1 2 3 1 3 2 3 1 2 ...
#  $ EMPLOY   : int  17 10 15 15 2 5 20 12 3 0 ...
#  $ ADDRESS  : int  12 6 14 14 0 5 9 11 4 13 ...
#  $ DEBTINC  : num  9.3 17.3 5.5 2.9 17.3 10.2 30.6 3.6 24.4 19.7 ...
#  $ CREDDEBT : num  11.36 1.36 0.86 2.66 1.79 ...
#  $ OTHDEBT  : num  5.01 4 2.17 0.82 3.06 ...
#  $ DEFAULTER: int  1 0 0 0 1 0 0 0 1 0 ...


data$AGE <- factor(data$AGE)


model_glm <- glm(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, family = binomial, data = data)
summary(model_glm)
# 
# Call:
# glm(formula = DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + 
#     CREDDEBT + OTHDEBT, family = binomial, data = data)
# 
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -0.78821    0.26407  -2.985  0.00284 ** 
# AGE2         0.25202    0.26651   0.946  0.34433    
# AGE3         0.62707    0.36056   1.739  0.08201 .  
# EMPLOY      -0.26172    0.03188  -8.211  < 2e-16 ***
# ADDRESS     -0.09964    0.02234  -4.459 8.22e-06 ***
# DEBTINC      0.08506    0.02212   3.845  0.00012 ***
# CREDDEBT     0.56336    0.08877   6.347 2.20e-10 ***
# OTHDEBT      0.02315    0.05709   0.405  0.68517    
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 804.36  on 699  degrees of freedom
# Residual deviance: 553.41  on 692  degrees of freedom
# AIC: 569.41
# 
# Number of Fisher Scoring iterations: 6


model_glm <- glm(DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, family = binomial, data = data)
summary(model_glm)
# 
# Call:
# glm(formula = DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, 
#     family = binomial, data = data)
# 
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -0.79107    0.25154  -3.145  0.00166 ** 
# EMPLOY      -0.24258    0.02806  -8.646  < 2e-16 ***
# ADDRESS     -0.08122    0.01960  -4.144 3.41e-05 ***
# DEBTINC      0.08827    0.01854   4.760 1.93e-06 ***
# CREDDEBT     0.57290    0.08725   6.566 5.17e-11 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 804.36  on 699  degrees of freedom
# Residual deviance: 556.74  on 695  degrees of freedom
# AIC: 566.74
# 
# Number of Fisher Scoring iterations: 6


pred_glm <- fitted(model_glm)

pred     <- prediction(pred_glm, data$DEFAULTER)
perf     <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.8556193


model_nb <- naiveBayes(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data)
model_nb
# 
# Naive Bayes Classifier for Discrete Predictors
# 
# Call:
# naiveBayes.default(x = X, y = Y, laplace = laplace)
# 
# A-priori probabilities:
# Y
#         0         1 
# 0.7385714 0.2614286 
# 
# Conditional probabilities:
#    AGE
# Y           1         2         3
#   0 0.3017408 0.4313346 0.2669246
#   1 0.4699454 0.3333333 0.1967213
# 
#    EMPLOY
# Y       [,1]     [,2]
#   0 9.508704 6.663741
#   1 5.224044 5.542946
# 
#    ADDRESS
# Y       [,1]     [,2]
#   0 8.945841 7.000621
#   1 6.393443 5.925208
# 
#    DEBTINC
# Y        [,1]     [,2]
#   0  8.679304 5.615197
#   1 14.727869 7.902798
# 
#    CREDDEBT
# Y       [,1]     [,2]
#   0 1.245397 1.422238
#   1 2.423770 3.232645
# 
#    OTHDEBT
# Y       [,1]     [,2]
#   0 2.773230 2.813970
#   1 3.863388 4.263394


pred_nb <- predict(model_nb, data, type = "raw")
head(pred_nb)
#                 0           1
# [1,] 4.269360e-08 0.999999957
# [2,] 7.182632e-01 0.281736806
# [3,] 9.930388e-01 0.006961177
# [4,] 9.885979e-01 0.011402100
# [5,] 4.889496e-01 0.511050425
# [6,] 9.177660e-01 0.082234006


pred <- prediction(pred_nb[, 2], data$DEFAULTER)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0,1)


auc <- performance(pred, "auc")
auc@y.values
# 0.794971







