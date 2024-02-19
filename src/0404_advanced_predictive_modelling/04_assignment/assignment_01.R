
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


# we engineer some features - converting numerical and other data into
# categorical data with two levels - where the new value is 0 or 1 if
# below or above the  mean / median

summary(data$AGE)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 14.00   19.00   23.00   23.24   26.00   45.00

# construct a factor (0, 1) -> below / above median age
data$AGE_F <- as.factor(ifelse(data$AGE <= 23, 0, 1))


summary(data$LWT)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 80.0   110.0   121.0   129.8   140.0   250.0

# construct a factor (0, 1) -> below / above median LWT
data$LWT_F <- as.factor(ifelse(data$LWT <= 121.0, 0, 1))


summary(data$PTL)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 0.0000  0.0000  0.0000  0.1958  0.0000  3.0000

# construct a factor (0, 1) -> equal to / not equal to median PTL
data$PTL_F <- as.factor(ifelse(data$PTL == 0, 0, 1))


summary(data$FTV)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 0.0000  0.0000  0.0000  0.7937  1.0000  6.0000

# construct a factor (0, 1) -> equal to / not equal to median FTV
data$FTV_F <- as.factor(ifelse(data$FTV == 0, 0, 1))


summary(data$RACE)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   1.000   1.000   1.847   3.000   3.000

# construct a factor (0, 1) -> equal to / not equal to median RACE
data$RACE_F <- as.factor(ifelse(data$RACE == 1, 0, 1))



data$LOW   <- as.factor(data$LOW)
data$RACE  <- as.factor(data$RACE)
data$SMOKE <- as.factor(data$SMOKE)
data$HT    <- as.factor(data$HT)
data$UI    <- as.factor(data$UI)



str(data)
# 'data.frame':	189 obs. of  16 variables:
# $ SR.NO : int  1 2 3 4 5 6 7 8 9 10 ...
# $ ID    : int  85 86 87 88 89 91 92 93 94 95 ...
# $ LOW   : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
# $ AGE   : int  19 33 20 21 18 21 22 17 29 26 ...
# $ LWT   : int  182 155 105 108 107 124 118 103 123 113 ...
# $ RACE  : Factor w/ 3 levels "1","2","3": 2 3 1 1 1 3 1 3 1 1 ...
# $ SMOKE : Factor w/ 2 levels "0","1": 1 1 2 2 2 1 1 1 2 2 ...
# $ PTL   : int  0 0 0 0 0 0 0 0 0 0 ...
# $ HT    : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
# $ UI    : Factor w/ 2 levels "0","1": 1 1 1 2 2 1 1 1 1 1 ...
# $ FTV   : int  0 3 1 2 0 0 1 1 1 0 ...
# $ AGE_F : Factor w/ 2 levels "0","1": 1 2 1 1 1 1 1 1 2 2 ...
# $ LWT_F : Factor w/ 2 levels "0","1": 2 2 1 1 1 1 1 1 1 1 ...
# $ PTL_F : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
# $ FTV_F : Factor w/ 2 levels "0","1": 1 2 2 2 1 1 2 2 2 1 ...
# $ RACE_F: Factor w/ 2 levels "0","1": 2 2 1 1 1 2 1 2 1 1 ...



# 2 - Cross tabulate dependent variable with each independent variable.
#     (below I use the symbols '~=' to denote 'approximately equal to')

table(data$LOW, data$AGE)
#   14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 45
# 0  1  1  6  7  8 13 10  7 11  8  8  9  4  1  7  6  6  4  5  3  0  2  2  1
# 1  2  2  1  5  2  3  8  5  2  5  5  6  4  2  2  1  1  1  1  0  1  0  0  0

table(data$LOW, data$AGE_F)
#    0  1
# 0 72 58
# 1 35 24

CrossTable(data$LOW, data$AGE_F, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
#    Cell Contents
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
#              | data$AGE_F
#     data$LOW |         0 |         1 | Row Total |
# -------------|-----------|-----------|-----------|
#            0 |        72 |        58 |       130 |
#              |     0.035 |     0.045 |           |
#              |     0.381 |     0.307 |           |
# -------------|-----------|-----------|-----------|
#            1 |        35 |        24 |        59 |
#              |     0.076 |     0.100 |           |
#              |     0.185 |     0.127 |           |
# -------------|-----------|-----------|-----------|
# Column Total |       107 |        82 |       189 |
# -------------|-----------|-----------|-----------|
#
#
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  0.2561431     d.f. =  1     p =  0.6127824
#
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  0.1209219     d.f. =  1     p =  0.7280367

# p-value ~= 0.61
# fail to reject the null hypothesis that LOW and AGE_F are not associated



table(data$LOW, data$LWT_F)
#    0  1
# 0 61 69
# 1 35 24

CrossTable(data$LOW, data$LWT_F, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
#    Cell Contents
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
#              | data$LWT_F
#     data$LOW |         0 |         1 | Row Total |
# -------------|-----------|-----------|-----------|
#            0 |        61 |        69 |       130 |
#              |     0.383 |     0.396 |           |
#              |     0.323 |     0.365 |           |
# -------------|-----------|-----------|-----------|
#            1 |        35 |        24 |        59 |
#              |     0.845 |     0.872 |           |
#              |     0.185 |     0.127 |           |
# -------------|-----------|-----------|-----------|
# Column Total |        96 |        93 |       189 |
# -------------|-----------|-----------|-----------|
# 
# 
# Statistics for All Table Factors
# 
# 
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  2.496165     d.f. =  1     p =  0.1141239
# 
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  2.024729     d.f. =  1     p =  0.1547565

# p-value ~= 0.11
# fail to reject the null hypothesis that LOW and LWT_F are not associated



table(data$LOW, data$PTL)
#     0   1   2   3
# 0 118   8   3   1
# 1  41  16   2   0

table(data$LOW, data$PTL_F)
#     0   1
# 0 118  12
# 1  41  18

CrossTable(data$LOW, data$PTL_F, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
#    Cell Contents
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
#              | data$PTL_F
#     data$LOW |         0 |         1 | Row Total |
# -------------|-----------|-----------|-----------|
#            0 |       118 |        12 |       130 |
#              |     0.682 |     3.613 |           |
#              |     0.624 |     0.063 |           |
# -------------|-----------|-----------|-----------|
#            1 |        41 |        18 |        59 |
#              |     1.502 |     7.962 |           |
#              |     0.217 |     0.095 |           |
# -------------|-----------|-----------|-----------|
# Column Total |       159 |        30 |       189 |
# -------------|-----------|-----------|-----------|
#
#
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  13.75905     d.f. =  1     p =  0.0002078175
#
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  12.21176     d.f. =  1     p =  0.0004748918

# p-value ~= 0.0002
# reject the null hypothesis that LOW and PTL_F are not associated




table(data$LOW, data$FTV)
#    0  1  2  3  4  6
# 0 64 36 23  3  3  1
# 1 36 11  7  4  1  0

table(data$LOW, data$FTV_F)
#    0  1
# 0 64 66
# 1 36 23

CrossTable(data$LOW, data$FTV_F, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
#   Cell Contents
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
#              | data$FTV_F
#     data$LOW |         0 |         1 | Row Total |
# -------------|-----------|-----------|-----------|
#            0 |        64 |        66 |       130 |
#              |     0.333 |     0.374 |           |
#              |     0.339 |     0.349 |           |
# -------------|-----------|-----------|-----------|
#            1 |        36 |        23 |        59 |
#              |     0.733 |     0.823 |           |
#              |     0.190 |     0.122 |           |
# -------------|-----------|-----------|-----------|
# Column Total |       100 |        89 |       189 |
# -------------|-----------|-----------|-----------|
#
#
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  2.262629     d.f. =  1     p =  0.1325289
#
# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  1.814304     d.f. =  1     p =  0.1779927

# p-value ~= 0.13
# fail to reject the null hypothesis that LOW and FTV_F are not associated




table(data$LOW, data$RACE)
#    1  2  3
# 0 73 15 42
# 1 23 11 25

table(data$LOW, data$RACE_F)
#    0  1
# 0 73 57
# 1 23 36

CrossTable(data$LOW, data$RACE_F, chisq = TRUE, prop.r = FALSE, prop.c = FALSE)
#    Cell Contents
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
#              | data$RACE_F
#     data$LOW |         0 |         1 | Row Total |
# -------------|-----------|-----------|-----------|
#            0 |        73 |        57 |       130 |
#              |     0.735 |     0.759 |           |
#              |     0.386 |     0.302 |           |
# -------------|-----------|-----------|-----------|
#            1 |        23 |        36 |        59 |
#              |     1.620 |     1.673 |           |
#              |     0.122 |     0.190 |           |
# -------------|-----------|-----------|-----------|
# Column Total |        96 |        93 |       189 |
# -------------|-----------|-----------|-----------|
#
#
# Statistics for All Table Factors
#
#
# Pearson's Chi-squared test
# ------------------------------------------------------------
# Chi^2 =  4.787225     d.f. =  1     p =  0.02867159

# Pearson's Chi-squared test with Yates' continuity correction
# ------------------------------------------------------------
# Chi^2 =  4.124867     d.f. =  1     p =  0.04225733


# p-value ~= 0.03
# reject the null hypothesis that LOW and RACE_F are not associated




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
# - RACE_F
# - PTL_F
# - HT
# - UI






# 3 - Develop a model to predict if birth weight is low or not using the given
#     variables.
model <- glm(LOW ~ AGE + AGE_F + LWT + LWT_F + RACE + SMOKE + PTL + PTL_F + HT + UI + FTV + FTV_F, data = data, family = "binomial")
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


model <- glm(LOW ~ LWT + RACE + SMOKE + PTL_F + HT + UI, data = data, family = "binomial")
summary(model)



# from looking at the model summary, it appears that the independent 
# variables / features of significance are:
# - LWT
# - RACE
# - SMOKE
# - HT
# - UI (at the 0.1 level of significance)
#
# the independent variables AGE and LWT negatively influence the outcome,
# while all other independent variables positively influence the outcome

# rebuilding the model, omitting the insignificant features:

model <- glm(LOW ~ LWT + RACE + SMOKE + HT + UI, data = data, family = "binomial")
summary(model)
# Call:
# glm(formula = LOW ~ LWT + RACE + SMOKE + HT + UI, family = "binomial",
#     data = data)
#
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)
# (Intercept)  0.001967   0.939760   0.002  0.99833
# LWT         -0.016334   0.006805  -2.400  0.01638 *
# RACE2        1.351239   0.522848   2.584  0.00976 **
# RACE3        0.923378   0.430433   2.145  0.03193 *
# SMOKE1       1.025284   0.392803   2.610  0.00905 **
# HT1          1.861851   0.689137   2.702  0.00690 **
# UI1          0.970088   0.455893   2.128  0.03335 *
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 234.67  on 188  degrees of freedom
# Residual deviance: 203.77  on 182  degrees of freedom
# AIC: 217.77
#
# Number of Fisher Scoring iterations: 4


# from looking at the improved model summary, it appears that all the
# independent variables / features are significant.
# - LWT
# - RACE
# - SMOKE
# - HT
# - UI
#
# the independent variable LWT continues to negatively influence the outcome,
# while all other independent variables positively influence the outcome






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
#     0 110  34
#     1  20  25
table2
# pred2  0  1
#     0 88 18
#     1 42 41
table3
# pred3   0   1
#     0 120  41
#     1  10  18






# 5 - Calculate sensitivity,specificity and mis-classification rate for all
#     three tables above. What is the recommended cut-off value?
sensitivity1 <- (table1[2, 2] / (table1[2, 1] + table1[2, 2])) * 100
specificity1 <- (table1[1, 1] / (table1[1, 1] + table1[1, 2])) * 100
accuracy1    <- ((table1[1, 1] + table1[2, 2]) / nrow(data)) * 100
misclass1    <- ((table1[1, 2] + table1[2, 1]) / nrow(data)) * 100
falsepos1    <- (table1[1, 2] / (table1[1, 2] + table1[2, 2])) * 100

paste("Sensitivity for cut-off 0.4 is :", round(sensitivity1, 2))
# "Sensitivity for cut-off 0.4 is : 55.56"
paste("Specificity for cut-off 0.4 is :", round(specificity1, 2))
# "Specificity for cut-off 0.4 is : 76.39"
paste("Accuracy for cut-off 0.4 is :", round(accuracy1, 2))
# "Accuracy for cut-off 0.4 is : 71.43"
paste("Mis-Classification for cut-off 0.4 is :", round(misclass1, 2))
# "Mis-Classification for cut-off 0.4 is : 28.57"
paste("The sum of Sensitivity and Specificity for cut-off 0.4 is :", round(sensitivity1 + specificity1, 2))
# "The sum of Sensitivity and Specificity for cut-off 0.4 is : 131.94"
paste("The difference of Sensitivity and Specificity for cut-off 0.4 is :", abs(round(sensitivity1 - specificity1, 2)))
# "The difference of Sensitivity and Specificity for cut-off 0.4 is : 20.83"
paste("False Positive Rate for cut-off 0.4 is :", round(falsepos1, 2))
# "False Positive Rate for cut-off 0.4 is : 57.63"



sensitivity2 <- (table2[2, 2] / (table2[2, 1] + table2[2, 2])) * 100
specificity2 <- (table2[1, 1] / (table2[1, 1] + table2[1, 2])) * 100
accuracy2    <- ((table2[1, 1] + table2[2, 2]) / nrow(data)) * 100
misclass2    <- ((table2[1, 2] + table2[2, 1]) / nrow(data)) * 100
falsepos2    <- (table2[1, 2] / (table2[1, 2] + table2[2, 2])) * 100

paste("Sensitivity for cut-off 0.3 is :", round(sensitivity2, 2))
# "Sensitivity for cut-off 0.3 is : 49.4"
paste("Specificity for cut-off 0.3 is :", round(specificity2, 2))
# "Specificity for cut-off 0.3 is : 83.02"
paste("Accuracy for cut-off 0.3 is :", round(accuracy2, 2))
# "Accuracy for cut-off 0.3 is : 68.25"
paste("Mis-Classification for cut-off 0.3 is :", round(misclass2, 2))
# "Mis-Classification for cut-off 0.3 is : 31.75"
paste("The sum of Sensitivity and Specificity for cut-off 0.3 is :", round(sensitivity2 + specificity2, 2))
# "The sum of Sensitivity and Specificity for cut-off 0.3 is : 132.42"
paste("The difference of Sensitivity and Specificity for cut-off 0.3 is :", abs(round(sensitivity2 - specificity2, 2)))
# "The difference of Sensitivity and Specificity for cut-off 0.3 is : 33.62"
paste("False Positive Rate for cut-off 0.3 is :", round(falsepos2, 2))
# "False Positive Rate for cut-off 0.3 is : 30.51"



sensitivity3 <- (table3[2, 2] / (table3[2, 1] + table3[2, 2])) * 100
specificity3 <- (table3[1, 1] / (table3[1, 1] + table3[1, 2])) * 100
accuracy3    <- ((table3[1, 1] + table3[2, 2]) / nrow(data)) * 100
misclass3    <- ((table3[1, 2] + table3[2, 1]) / nrow(data)) * 100
falsepos3    <- (table3[1, 2] / (table3[1, 2] + table3[2, 2])) * 100

paste("Sensitivity for cut-off 0.55 is :", round(sensitivity3, 2))
# "Sensitivity for cut-off 0.55 is : 64.29"
paste("Specificity for cut-off 0.55 is :", round(specificity3, 2))
# "Specificity for cut-off 0.55 is : 74.53"
paste("Accuracy for cut-off 0.55 is :", round(accuracy3, 2))
# "Accuracy for cut-off 0.55 is : 73.02"
paste("Mis-Classification for cut-off 0.55 is :", round(misclass3, 2))
# "Mis-Classification for cut-off 0.55 is : 26.98"
paste("The sum of Sensitivity and Specificity for cut-off 0.55 is :", round(sensitivity3 + specificity3, 2))
# "The sum of Sensitivity and Specificity for cut-off 0.55 is : 138.82"
paste("The difference of Sensitivity and Specificity for cut-off 0.55 is :", abs(round(sensitivity3 - specificity3, 2)))
# "The difference of Sensitivity and Specificity for cut-off 0.55 is : 10.25"
paste("False Positive Rate for cut-off 0.55 is :", round(falsepos3, 2))
# "False Positive Rate for cut-off 0.55 is : 69.49"



# of the three cut-off values above, and based on the criteria of maximizing
# both sensitivity and specificity, it looks as if the cut-off value of 0.55
# is the best choice. But we can be more precise by using the below approach
# to calculate the optimal cut-off value:

prediction1 <- prediction(data$pred_prob, data$LOW)


perf1       <- performance(prediction1, "sens", "spec")
perf1
# A performance instance
#   'Specificity' vs. 'Sensitivity' (alpha: 'Cutoff')
#   with 148 data points

threshold   <- perf1@alpha.values[[1]][which.max(perf1@x.values[[1]] + perf1@y.values[[1]])]
threshold   <- round(threshold, 2)
paste("Best Threshold maximizing sensitivity and specificity is :", threshold)
# "Best Threshold maximizing sensitivity and specificity is : 0.3"

plot(perf1@alpha.values[[1]], perf1@x.values[[1]], xlab = "Cut-off", ylab = "", type = "n")
lines(perf1@alpha.values[[1]], perf1@x.values[[1]], type = "l", col = "red")
lines(perf1@alpha.values[[1]], perf1@y.values[[1]], type = "l", col = "blue")
legend("right", legend = c("Sensitivity", "Specificity"), col = c("red", "blue"), lty = 1)


pred4       <- ifelse(data$pred_prob <= threshold, 0, 1)
table4      <- table(pred4, data$LOW)
table4
# pred4  0  1
#     0 88 18
#     1 42 41

sensitivity4 <- (table4[2, 2] / (table4[2, 1] + table4[2, 2])) * 100
specificity4 <- (table4[1, 1] / (table4[1, 1] + table4[1, 2])) * 100
accuracy4    <- ((table4[1, 1] + table4[2, 2]) / nrow(data)) * 100
misclass4    <- ((table4[1, 2] + table4[2, 1]) / nrow(data)) * 100
falsepos4    <- (table4[1, 2] / (table4[1, 2] + table4[2, 2])) * 100

paste("Sensitivity for cut-off", threshold, "is :", round(sensitivity4, 2))
# "Sensitivity for cut-off 0.3 is : 49.4"
paste("Specificity for cut-off", threshold, "is :", round(specificity4, 2))
# "Specificity for cut-off 0.3 is : 83.02"
paste("Accuracy for cut-off", threshold, "is :", round(accuracy4, 2))
# "Accuracy for cut-off 0.3 is : 68.25"
paste("Mis-Classification for cut-off", threshold, "is :", round(misclass4, 2))
# "Mis-Classification for cut-off 0.3 is : 31.75"
paste("The sum of Sensitivity and Specificity for cut-off", threshold, "is :", round(sensitivity4 + specificity4, 2))
# "The sum of Sensitivity and Specificity for cut-off 0.3 is : 132.42"
paste("The difference of Sensitivity and Specificity for cut-off", threshold, "is :", abs(round(sensitivity4 - specificity4, 2)))
# "The difference of Sensitivity and Specificity for cut-off 0.3 is : 33.62"
paste("False Positive Rate for cut-off", threshold, "is :", round(falsepos4, 2))
# "False Positive Rate for cut-off 0.3 is : 30.51"





# 6 - Obtain ROC curve and report area under curve.
perf2 <- performance(prediction1, "tpr", "fpr")
perf2
# A performance instance
#   'False positive rate' vs. 'True positive rate' (alpha: 'Cutoff')
#   with 148 data points

plot(perf2)
abline(0, 1)

perf3 <- performance(prediction1, "auc")
perf3
# A performance instance
#   'Area under the ROC curve'

paste("Area under the curve is :", perf3@y.values)
# "Area under the curve is : 0.73754889178618"
