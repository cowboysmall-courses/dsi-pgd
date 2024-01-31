
library(dplyr)
library(ggplot2)
library(gmodels)
library(ROCR)


data <- read.csv("../../../data/0404_advanced_predictive_modelling/live_class/BANK\ LOAN.csv", header = TRUE)
head(data)


model <- glm(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data, family = "binomial")
summary(model)



model <- glm(DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, data = data, family = "binomial")
summary(model)


data$pred_prob <- round(fitted(model), 2)
head(data)


data$pred <- ifelse(data$pred_prob <= 0.5, 0, 1)
head(data)


table <- table(data$DEFAULTER, data$pred)
table
#     0   1
# 0 479  38
# 1  91  92

sensitivity <- (table[2, 2] / (table[2, 1] + table[2, 2])) * 100
sensitivity

specificity <- (table[1, 1] / (table[1, 1] + table[1, 2])) * 100
specificity


round(prop.table(table(data$DEFAULTER, data$pred)) * 100, 2)
#       0     1
# 0 68.43  5.43
# 1 13.00 13.14

round((sum(data$pred == data$DEFAULTER) / nrow(data)) * 100, 2)
# 81.57

round((sum(data$pred != data$DEFAULTER) / nrow(data)) * 100, 2)
# 18.43
