
# BACKGROUND:
#
#   The Data for a Study of Risk Factors Associated with Low Infant Birth Weight.
#   Data were collected at Baystate Medical Center, Springfield, Massachusetts.
#
# Description of variables:
#
#   LOW   – Low Birth Weight (0 means Not low and 1 means low)
#   AGE   - Age of the Mother in Years
#   LWT   - Weight in Pounds at the Last Menstrual Period
#   RACE  - Race (1 = White, 2 = Black, 3 = Other)
#   SMOKE - Smoking Status During Pregnancy (1 = Yes, 0 = No)
#   PTL   - History of Premature Labor (0 = None, 1 = One, etc.)
#   HT    - History of Hypertension (1 = Yes, 0 = No)
#   UI    - Presence of Uterine Irritability (1 = Yes, 0 = No)
#   FTV   - Number of Physician Visits During the First Trimester (0 = None, 1 = One, 2 = Two, etc.)
#
# Consider LOW as dependent variable and remaining variables listed above as
# independent variables.


library(gmodels)
library(ROCR)






# 1 - Import BIRTH WEIGHT data.
data <- read.csv("../../../data/0404_advanced_predictive_modelling/assignment/BIRTH\ WEIGHT.csv", header = TRUE)

head(data)
#   SR.NO ID LOW AGE LWT RACE SMOKE PTL HT UI FTV
# 1     1 85   0  19 182    2     0   0  0  0   0
# 2     2 86   0  33 155    3     0   0  0  0   3
# 3     3 87   0  20 105    1     1   0  0  0   1
# 4     4 88   0  21 108    1     1   0  0  1   2
# 5     5 89   0  18 107    1     1   0  0  1   0
# 6     6 91   0  21 124    3     0   0  0  0   0

str(data)
# 'data.frame': 189 obs. of  11 variables:
# $ SR.NO: int  1 2 3 4 5 6 7 8 9 10 ...
# $ ID   : int  85 86 87 88 89 91 92 93 94 95 ...
# $ LOW  : int  0 0 0 0 0 0 0 0 0 0 ...
# $ AGE  : int  19 33 20 21 18 21 22 17 29 26 ...
# $ LWT  : int  182 155 105 108 107 124 118 103 123 113 ...
# $ RACE : int  2 3 1 1 1 3 1 3 1 1 ...
# $ SMOKE: int  0 0 1 1 1 0 0 0 1 1 ...
# $ PTL  : int  0 0 0 0 0 0 0 0 0 0 ...
# $ HT   : int  0 0 0 0 0 0 0 0 0 0 ...
# $ UI   : int  0 0 0 1 1 0 0 0 0 0 ...
# $ FTV  : int  0 3 1 2 0 0 1 1 1 0 ...

data$LOW   <- as.factor(data$LOW)
data$RACE  <- as.factor(data$RACE)
data$SMOKE <- as.factor(data$SMOKE)
data$HT    <- as.factor(data$HT)
data$UI    <- as.factor(data$UI)

str(data)
# 'data.frame':	189 obs. of  11 variables:
# $ SR.NO: int  1 2 3 4 5 6 7 8 9 10 ...
# $ ID   : int  85 86 87 88 89 91 92 93 94 95 ...
# $ LOW  : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
# $ AGE  : int  19 33 20 21 18 21 22 17 29 26 ...
# $ LWT  : int  182 155 105 108 107 124 118 103 123 113 ...
# $ RACE : Factor w/ 3 levels "1","2","3": 2 3 1 1 1 3 1 3 1 1 ...
# $ SMOKE: Factor w/ 2 levels "0","1": 1 1 2 2 2 1 1 1 2 2 ...
# $ PTL  : int  0 0 0 0 0 0 0 0 0 0 ...
# $ HT   : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
# $ UI   : Factor w/ 2 levels "0","1": 1 1 1 2 2 1 1 1 1 1 ...
# $ FTV  : int  0 3 1 2 0 0 1 1 1 0 ...






# 2 - Cross tabulate dependent variable with each independent variable.
#     (below I use the symbols '~=' to denote 'approximately equal to')

# Note: cross tables for LOW vs. all factor variables - I omit the numeric 
#       variables (AGE, LWT, PTL, and FTV)

table(data$LOW, data$RACE)
#    1  2  3
# 0 73 15 42
# 1 23 11 25

CrossTable(data$LOW, data$RACE, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
# Cell Contents
# |-------------------------|
# |                       N |
# | Chi-square contribution |
# |           N / Row Total |
# |         N / Table Total |
# |-------------------------|
# 
# 
# Total Observations in Table:  189
# 
# 
#              | data$RACE 
#     data$LOW |         1 |         2 |         3 | Row Total | 
# -------------|-----------|-----------|-----------|-----------|
#            0 |        73 |        15 |        42 |       130 | 
#              |     0.735 |     0.465 |     0.362 |           | 
#              |     0.386 |     0.079 |     0.222 |           | 
# -------------|-----------|-----------|-----------|-----------|
#            1 |        23 |        11 |        25 |        59 | 
#              |     1.620 |     1.024 |     0.798 |           | 
#              |     0.122 |     0.058 |     0.132 |           | 
# -------------|-----------|-----------|-----------|-----------|
# Column Total |        96 |        26 |        67 |       189 | 
# -------------|-----------|-----------|-----------|-----------|
# 
# 
# Statistics for All Table Factors
# 
# 
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  5.004813     d.f. =  2     p =  0.0818877


# p-value ~= 0.08
# fail to reject the null hypothesis that LOW and RACE are not associated



table(data$LOW, data$SMOKE)
#    0  1
# 0 86 44
# 1 29 30

CrossTable(data$LOW, data$SMOKE, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
# Cell Contents
# |-------------------------|
# |                       N |
# | Chi-square contribution |
# |         N / Table Total |
# |-------------------------|
#   
#   
# Total Observations in Table:  189 
# 
# 
#              | data$SMOKE 
#     data$LOW |         0 |         1 | Row Total | 
# -------------|-----------|-----------|-----------|
#            0 |        86 |        44 |       130 | 
#              |     0.602 |     0.935 |           | 
#              |     0.455 |     0.233 |           | 
# -------------|-----------|-----------|-----------|
#            1 |        29 |        30 |        59 | 
#              |     1.326 |     2.061 |           | 
#              |     0.153 |     0.159 |           | 
# -------------|-----------|-----------|-----------|
# Column Total |       115 |        74 |       189 | 
# -------------|-----------|-----------|-----------|
#   
#   
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  4.923705     d.f. =  1     p =  0.02649064
#
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  4.235929     d.f. =  1     p =  0.03957697


# p-value ~= 0.03
# reject the null hypothesis that LOW and SMOKE are not associated



table(data$LOW, data$HT)
#     0   1
# 0 125   5
# 1  52   7

CrossTable(data$LOW, data$HT, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
# Cell Contents
# |-------------------------|
# |                       N |
# | Chi-square contribution |
# |         N / Table Total |
# |-------------------------|
#   
#   
# Total Observations in Table:  189 
# 
# 
#              | data$HT 
#     data$LOW |         0 |         1 | Row Total | 
# -------------|-----------|-----------|-----------|
#            0 |       125 |         5 |       130 | 
#              |     0.087 |     1.283 |           | 
#              |     0.661 |     0.026 |           | 
# -------------|-----------|-----------|-----------|
#            1 |        52 |         7 |        59 | 
#              |     0.192 |     2.827 |           | 
#              |     0.275 |     0.037 |           | 
# -------------|-----------|-----------|-----------|
# Column Total |       177 |        12 |       189 | 
# -------------|-----------|-----------|-----------|
#   
#   
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  4.387955     d.f. =  1     p =  0.0361937
#
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  3.143065     d.f. =  1     p =  0.07625038


# p-value ~= 0.04
# reject the null hypothesis that LOW and HT are not associated



table(data$LOW, data$UI)
#     0   1
# 0 117  13
# 1  45  14

CrossTable(data$LOW, data$UI, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
# Cell Contents
# |-------------------------|
# |                       N |
# | Chi-square contribution |
# |         N / Table Total |
# |-------------------------|
#   
#   
# Total Observations in Table:  189 
# 
# 
#              | data$UI 
#     data$LOW |         0 |         1 | Row Total | 
# -------------|-----------|-----------|-----------|
#            0 |       117 |        13 |       130 | 
#              |     0.279 |     1.671 |           | 
#              |     0.619 |     0.069 |           | 
# -------------|-----------|-----------|-----------|
#            1 |        45 |        14 |        59 | 
#              |     0.614 |     3.683 |           | 
#              |     0.238 |     0.074 |           | 
# -------------|-----------|-----------|-----------|
# Column Total |       162 |        27 |       189 | 
# -------------|-----------|-----------|-----------|
#   
#   
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  6.24661     d.f. =  1     p =  0.01244312
#
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  5.175733     d.f. =  1     p =  0.0229045


# p-value ~= 0.01
# reject the null hypothesis that LOW and UI are not associated



# from looking at the results of the Chi-squared tests, it appears that the
# factor variables / features with an association with LOW are:
# - SMOKE
# - HT
# - UI






# 3 - Develop a model to predict if birth weight is low or not using the given
#     variables.
model <- glm(LOW ~ AGE + LWT + RACE + SMOKE + PTL + HT + UI + FTV, data = data, family = "binomial")
summary(model)
# Call:
# glm(formula = LOW ~ AGE + LWT + RACE + SMOKE + PTL + HT + UI + 
#     FTV, family = "binomial", data = data)
# 
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)   
# (Intercept)  0.442841   1.198347   0.370  0.71172   
# AGE         -0.029786   0.037041  -0.804  0.42133   
# LWT         -0.015083   0.006924  -2.178  0.02938 * 
# RACE2        1.293517   0.528366   2.448  0.01436 * 
# RACE3        0.876593   0.440997   1.988  0.04684 * 
# SMOKE1       0.930404   0.402357   2.312  0.02076 * 
# PTL          0.535460   0.345628   1.549  0.12133   
# HT1          1.854814   0.695627   2.666  0.00767 **
# UI1          0.830951   0.466893   1.780  0.07512 . 
# FTV          0.062039   0.172417   0.360  0.71898   
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 234.67  on 188  degrees of freedom
# Residual deviance: 200.91  on 179  degrees of freedom
# AIC: 220.91
# 
# Number of Fisher Scoring iterations: 4


# from looking at the model summary, it appears that the independent 
# variables / features of significance are:
# - LWT
# - RACE
# - SMOKE
# - HT
# - UI (at the 0.1 level of significance)






# 4 - Generate three classification tables with cut-off values 0.4, 0.3 and 0.55.
data$pred_prob <- fitted(model)

pred1  <- ifelse(data$pred_prob <= 0.4,  0, 1)
pred2  <- ifelse(data$pred_prob <= 0.3,  0, 1)
pred3  <- ifelse(data$pred_prob <= 0.55, 0, 1)

table1 <- table(pred1, data$LOW)
table2 <- table(pred2, data$LOW)
table3 <- table(pred3, data$LOW)

table1
# pred1   0   1
#     0 107  31
#     1  23  28
table2
# pred2  0  1
#     0 87 19
#     1 43 40
table3
# pred3   0   1
#     0 120  42
#     1  10  17






# 5 - Calculate sensitivity,specificity and misclassification rate for all 
#     three tables above. What is the recommended cut-off value?
sensitivity1 <- (table1[2, 2] / (table1[2, 1] + table1[2, 2])) * 100
specificity1 <- (table1[1, 1] / (table1[1, 1] + table1[1, 2])) * 100
accuracy1    <- ((table1[1, 1] + table1[2, 2]) / nrow(data)) * 100
misclass1    <- ((table1[1, 2] + table1[2, 1]) / nrow(data)) * 100

paste("Sensitivity for cut-off 0.4 is :", round(sensitivity1, 2))
# "Sensitivity for cut-off 0.4 is : 54.9"
paste("Specificity for cut-off 0.4 is :", round(specificity1, 2))
# "Specificity for cut-off 0.4 is : 77.54"
paste("Accuracy for cut-off 0.4 is :", round(accuracy1, 2))
# "Accuracy for cut-off 0.4 is : 71.43"
paste("Mis-Classification for cut-off 0.4 is :", round(misclass1, 2))
# "Mis-Classification for cut-off 0.4 is : 28.57"



sensitivity2 <- (table2[2, 2] / (table2[2, 1] + table2[2, 2])) * 100
specificity2 <- (table2[1, 1] / (table2[1, 1] + table2[1, 2])) * 100
accuracy2    <- ((table2[1, 1] + table2[2, 2]) / nrow(data)) * 100
misclass2    <- ((table2[1, 2] + table2[2, 1]) / nrow(data)) * 100

paste("Sensitivity for cut-off 0.3 is :", round(sensitivity2, 2))
# "Sensitivity for cut-off 0.3 is : 48.19"
paste("Specificity for cut-off 0.3 is :", round(specificity2, 2))
# "Specificity for cut-off 0.3 is : 82.08"
paste("Accuracy for cut-off 0.3 is :", round(accuracy2, 2))
# "Accuracy for cut-off 0.3 is : 67.2"
paste("Mis-Classification for cut-off 0.3 is :", round(misclass2, 2))
# "Mis-Classification for cut-off 0.3 is : 32.8"



sensitivity3 <- (table3[2, 2] / (table3[2, 1] + table3[2, 2])) * 100
specificity3 <- (table3[1, 1] / (table3[1, 1] + table3[1, 2])) * 100
accuracy3    <- ((table3[1, 1] + table3[2, 2]) / nrow(data)) * 100
misclass3    <- ((table3[1, 2] + table3[2, 1]) / nrow(data)) * 100

paste("Sensitivity for cut-off 0.55 is :", round(sensitivity3, 2))
# "Sensitivity for cut-off 0.55 is : 62.96"
paste("Specificity for cut-off 0.55 is :", round(specificity3, 2))
# "Specificity for cut-off 0.55 is : 74.07"
paste("Accuracy for cut-off 0.55 is :", round(accuracy3, 2))
# "Accuracy for cut-off 0.55 is : 72.49"
paste("Mis-Classification for cut-off 0.55 is :", round(misclass3, 2))
# "Mis-Classification for cut-off 0.55 is : 27.51"


prediction1 <- prediction(data$pred_prob, data$LOW)


perf1       <- performance(prediction1, "sens", "spec")
threshold   <- perf1@alpha.values[[1]][which.max(perf1@x.values[[1]] + perf1@y.values[[1]])]
threshold   <- round(threshold, 2)
paste("Best Threshold maximizing sensitivity and specificity is :", threshold)
# "Best Threshold maximizing sensitivity and specificity is : 0.31"

pred4       <- ifelse(data$pred_prob <= threshold, 0, 1)
table4      <- table(pred4, data$LOW)
table4
# pred4  0  1
#     0 93 19
#     1 37 40

sensitivity4 <- (table4[2, 2] / (table4[2, 1] + table4[2, 2])) * 100
specificity4 <- (table4[1, 1] / (table4[1, 1] + table4[1, 2])) * 100
accuracy4    <- ((table4[1, 1] + table4[2, 2]) / nrow(data)) * 100
misclass4    <- ((table4[1, 2] + table4[2, 1]) / nrow(data)) * 100

paste("Sensitivity for cut-off", threshold, "is :", round(sensitivity4, 2))
# "Sensitivity for cut-off 0.31 is : 51.95"
paste("Specificity for cut-off", threshold, "is :", round(specificity4, 2))
# "Specificity for cut-off 0.31 is : 83.04"
paste("Accuracy for cut-off", threshold, "is :", round(accuracy4, 2))
# "Accuracy for cut-off 0.31 is : 70.37"
paste("Mis-Classification for cut-off", threshold, "is :", round(misclass4, 2))
# "Mis-Classification for cut-off 0.31 is : 29.63"






# 6 - Obtain ROC curve and report area under curve.
perf2 <- performance(prediction1, "tpr", "fpr")
plot(perf2)
abline(0, 1)

perf3 <- performance(prediction1, "auc")
paste("AOC is :", perf3@y.values)
# "Area under the curve is : 0.749022164276402"
