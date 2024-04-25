
library(dplyr)
library(ggplot2)
library(caret)
library(ROCR)
library(e1071)
library(car)



data <- read.csv("./data/0704_machine_learning_01/05_case_study/Hospital Readmissions.csv", header = TRUE)
head(data)


data$readmitted <- ifelse(data$readmitted == "no", 0, 1)
data$readmitted <- as.factor(data$readmitted) 


data <- data %>% mutate_at(vars(c("age", "diagnosis", "glucose_test", "A1Ctest", "change", "diabetes_med")), ~as.factor(.))


index <- createDataPartition(data$readmitted, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]



threshold <- 0.45



model <- glm(readmitted ~ age + time_in_hospital + n_lab_procedures + n_procedures +n_medications + n_outpatient + n_inpatient + n_emergency + diagnosis + glucose_test + A1Ctest + change + diabetes_med, data = train, family = binomial)
summary(model)

vif(model)



model <- glm(readmitted ~ age + time_in_hospital + n_procedures + n_outpatient + n_inpatient + n_emergency + diagnosis + diabetes_med, data = train, family = binomial)
summary(model)

vif(model)


train$predprob <- round(fitted(model), 2)

predtrain <- prediction(train$predprob, train$readmitted)
perftrain <- performance(predtrain, "tpr", "fpr")

plot(perftrain)
abline(0, 1)


auc <- performance(predtrain, "auc")
auc@y.values



train$predY <- as.factor(ifelse(train$predprob > threshold, 1, 0))
confusionMatrix(train$predY, as.factor(train$readmitted), positive = "1")




testdata$predprob <- predict(model, test, type = "response")
pred <- prediction(test$predprob, test$readmitted)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0,1)


auc <- performance(pred, "auc")
auc@y.values


test$predY <- as.factor(ifelse(test$predprob > threshold, 1, 0))
confusionMatrix(test$predY, as.factor(test$readmitted), positive = "1")




model_nb <- naiveBayes(readmitted ~ age + time_in_hospital + n_lab_procedures + n_procedures + n_medications + n_outpatient + n_inpatient + n_emergency + diagnosis + glucose_test + A1Ctest + change + diabetes_med, data = train)
summary(model_nb)


prednb <- predict(model_nb, train, type = "raw")
pred <- prediction(prednb[, 2], train$readmitted)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)



auc <- performance(pred, "auc")
auc@y.values


train$predY <- as.factor(ifelse(prednb[, 2] > threshold, 1, 0))
confusionMatrix(train$predY, train$readmitted, positive = "1")



prednb <- predict(model_nb, test, type = "raw")
pred <- prediction(prednb[, 2], test$readmitted)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)



auc <- performance(pred, "auc")
auc@y.values


test$predY <- as.factor(ifelse(prednb[, 2] > threshold, 1, 0))
confusionMatrix(test$predY, test$readmitted, positive = "1")






