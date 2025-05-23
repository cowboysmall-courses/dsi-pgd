
library(MASS)



data <- read.csv("./data/0404_advanced_predictive_modelling/05_case_study/Brand\ Preference\ Study.csv", header = TRUE)
head(data)
# id Preference Gender Location   Age
# 1  1          3   MALE     CITY  <=25
# 2  2          2   MALE     CITY 25-40
# 3  3          1   MALE     CITY 40-55
# 4  4          2 FEMALE     CITY 25-40
# 5  5          2 FEMALE     CITY 40-55
# 6  6          1 FEMALE     CITY 25-40



round(mean(data[data$Gender == 'MALE', ]$Preference), 2)
# 2.07
round(mean(data[data$Gender == 'FEMALE', ]$Preference), 2)
# 1.51


round(mean(data[data$Location == 'CITY', ]$Preference), 2)
# 2.05
round(mean(data[data$Location == 'SUBURBS', ]$Preference), 2)
# 1.27


round(mean(data[data$Age == '<=25', ]$Preference), 2)
# 1.72
round(mean(data[data$Age == '25-40', ]$Preference), 2)
# 1.62
round(mean(data[data$Age == '40-55', ]$Preference), 2)
# 1.48



data$Preference <- as.ordered(data$Preference)



model <- polr(Preference ~ Gender + Location + Age, data = data, Hess = TRUE)
effect <- summary(model)
effect
# Call:
# polr(formula = Preference ~ Gender + Location + Age, data = data, 
#     Hess = TRUE)
# 
# Coefficients:
#                   Value Std. Error t value
# GenderMALE       1.1872     0.3420  3.4710
# LocationSUBURBS -2.3863     0.2962 -8.0560
# Age25-40        -0.2174     0.3141 -0.6923
# Age40-55        -0.7511     0.3531 -2.1268
# 
# Intercepts:
#     Value   Std. Error t value
# 1|2 -1.4568  0.3135    -4.6468
# 2|3  1.1904  0.3063     3.8859
# 
# Residual Deviance: 397.5779 
# AIC: 409.5779 




ptable <- data.frame(effect$coefficients)
ptable
#                      Value Std..Error    t.value
# GenderMALE       1.1871541  0.3420191  3.4710171
# LocationSUBURBS -2.3862520  0.2962095 -8.0559606
# Age25-40        -0.2174104  0.3140560 -0.6922664
# Age40-55        -0.7510563  0.3531452 -2.1267637
# 1|2             -1.4567802  0.3135024 -4.6467910
# 2|3              1.1903988  0.3063378  3.8859027




ptable$pvalue <- 1 - pchisq(ptable$t.value ^ 2, df = 1)
ptable$pvalue <- round(ptable$pvalue, 4)
ptable
#                      Value Std..Error    t.value pvalue
# GenderMALE       1.1871541  0.3420191  3.4710171 0.0005
# LocationSUBURBS -2.3862520  0.2962095 -8.0559606 0.0000
# Age25-40        -0.2174104  0.3140560 -0.6922664 0.4888
# Age40-55        -0.7510563  0.3531452 -2.1267637 0.0334
# 1|2             -1.4567802  0.3135024 -4.6467910 0.0000
# 2|3              1.1903988  0.3063378  3.8859027 0.0001



data$predprob <- round(fitted(model), 2)
head(data)
#   id Preference Gender Location   Age predprob.1 predprob.2 predprob.3
# 1  1          3   MALE     CITY  <=25       0.07       0.43       0.50
# 2  2          2   MALE     CITY 25-40       0.08       0.47       0.45
# 3  3          1   MALE     CITY 40-55       0.13       0.55       0.32
# 4  4          2 FEMALE     CITY 25-40       0.22       0.58       0.20
# 5  5          2 FEMALE     CITY 40-55       0.33       0.54       0.13
# 6  6          1 FEMALE     CITY 25-40       0.22       0.58       0.20



expected <- predict(model, data, type = "class")
head(expected)
# 3 2 2 2 2 2
# Levels: 1 2 3



ctable <- table(data$Preference, expected)
ctable
#  expected
#     1   2   3
# 1 108  24   1
# 2  34  56   4
# 3   2  24   6



round((ctable[1, 1] + ctable[2, 2] + ctable[3, 3]) /  sum(colSums(ctable)), 2) * 100
# 66
