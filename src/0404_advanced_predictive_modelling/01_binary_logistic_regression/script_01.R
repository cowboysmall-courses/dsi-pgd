


data <- read.csv("./data/0404_advanced_predictive_modelling/live_class/BANK\ LOAN.csv", header = TRUE)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER
# 1  1   3     17      12     9.3    11.36    5.01         1
# 2  2   1     10       6    17.3     1.36    4.00         0
# 3  3   2     15      14     5.5     0.86    2.17         0
# 4  4   3     15      14     2.9     2.66    0.82         0
# 5  5   1      2       0    17.3     1.79    3.06         1
# 6  6   3      5       5    10.2     0.39    2.16         0



str(data)
# 'data.frame':	700 obs. of  8 variables:
# $ SN       : int  1 2 3 4 5 6 7 8 9 10 ...
# $ AGE      : int  3 1 2 3 1 3 2 3 1 2 ...
# $ EMPLOY   : int  17 10 15 15 2 5 20 12 3 0 ...
# $ ADDRESS  : int  12 6 14 14 0 5 9 11 4 13 ...
# $ DEBTINC  : num  9.3 17.3 5.5 2.9 17.3 10.2 30.6 3.6 24.4 19.7 ...
# $ CREDDEBT : num  11.36 1.36 0.86 2.66 1.79 ...
# $ OTHDEBT  : num  5.01 4 2.17 0.82 3.06 ...
# $ DEFAULTER: int  1 0 0 0 1 0 0 0 1 0 ...



data$AGE <- factor(data$AGE)
str(data)
# 'data.frame':	700 obs. of  8 variables:
# $ SN       : int  1 2 3 4 5 6 7 8 9 10 ...
# $ AGE      : Factor w/ 3 levels "1","2","3": 3 1 2 3 1 3 2 3 1 2 ...
# $ EMPLOY   : int  17 10 15 15 2 5 20 12 3 0 ...
# $ ADDRESS  : int  12 6 14 14 0 5 9 11 4 13 ...
# $ DEBTINC  : num  9.3 17.3 5.5 2.9 17.3 10.2 30.6 3.6 24.4 19.7 ...
# $ CREDDEBT : num  11.36 1.36 0.86 2.66 1.79 ...
# $ OTHDEBT  : num  5.01 4 2.17 0.82 3.06 ...
# $ DEFAULTER: int  1 0 0 0 1 0 0 0 1 0 ...



model <- glm(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data, family = "binomial")
summary(model)
# Call:
# glm(formula = DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + 
#     CREDDEBT + OTHDEBT, family = "binomial", data = data)
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



model <- glm(DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, data = data, family = "binomial")
summary(model)
# Call:
# glm(formula = DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, 
#     family = "binomial", data = data)
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


model_coef <- coef(model)
model_cint <- confint(model)
cbind(model_coef, odds_ratio = exp(model_coef), exp(model_cint))
#              model_coef odds_ratio     2.5 %    97.5 %
# (Intercept) -0.79107079  0.4533591 0.2756574 0.7400939
# EMPLOY      -0.24258492  0.7845971 0.7408645 0.8271278
# ADDRESS     -0.08122146  0.9219895 0.8863345 0.9572345
# DEBTINC      0.08826530  1.0922779 1.0536134 1.1332029
# CREDDEBT     0.57289682  1.7733968 1.5097676 2.1242860



data$predprob <- round(fitted(model), 2)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER predprob
# 1  1   3     17      12     9.3    11.36    5.01         1     0.81
# 2  2   1     10       6    17.3     1.36    4.00         0     0.20
# 3  3   2     15      14     5.5     0.86    2.17         0     0.01
# 4  4   3     15      14     2.9     2.66    0.82         0     0.02
# 5  5   1      2       0    17.3     1.79    3.06         1     0.78
# 6  6   3      5       5    10.2     0.39    2.16         0     0.22




ctable <- table(data$DEFAULTER, data$predprob > 0.5)
ctable
#   FALSE TRUE
# 0   479   38
# 1    91   92



sensitivity <- ctable[2, 2] / (ctable[2, 1] + ctable[2, 2]) * 100
sensitivity
# 50.27322


specificity <- ctable[1, 1] / (ctable[1, 1] + ctable[1, 2]) * 100
specificity
# 92.6499







ctable <- table(data$DEFAULTER, data$predprob > 0.3)
ctable
#   FALSE TRUE
# 0   415  102
# 1    46  137



sensitivity <- ctable[2, 2] / (ctable[2, 1] + ctable[2, 2]) * 100
sensitivity
# 74.86339


specificity <- ctable[1, 1] / (ctable[1, 1] + ctable[1, 2]) * 100
specificity
# 80.27079



