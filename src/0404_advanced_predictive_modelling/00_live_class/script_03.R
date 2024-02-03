
library(dplyr)
library(ggplot2)
library(gmodels)
library(ROCR)
library(car)
library(caret)
library(nortest)


p_data_1 <- read.csv("../../../data/0404_advanced_predictive_modelling/live_class/Purchase\ Data\ 1.csv", header = TRUE)
p_data_2 <- read.csv("../../../data/0404_advanced_predictive_modelling/live_class/Purchase\ Data\ 2.csv", header = TRUE)
r_data_1 <- read.csv("../../../data/0404_advanced_predictive_modelling/live_class/Response\ Data.csv", header = TRUE)

head(p_data_1)
head(p_data_2)
head(r_data_1)

data<-Reduce(function(data1, data2) merge(data1, data2, by = "Custid", all.x = TRUE), list(r_data_1, p_data_1, p_data_2))

data$Age <- as.factor(data$Age)
data$Gender <- as.factor(data$Gender)
data$MS <- as.factor(data$MS)
data$Pre_Month <- as.factor(data$Pre_Month)
data$Response <- as.factor(data$Response)

head(data)



table <- table(data$Response)
table

round(prop.table(table), 3)

CrossTable(data$Response)



func <- function(x) {
  c(
    n = length(x),
    mean = mean(x),
    median = median(x),
    sd = sd(x)
  )
}

aggregate(BillAmt_1 ~ Response, data = data, FUN = func)

aggregate(BillAmt_2 ~ Response, data = data, FUN = func)

aggregate(BillAmt_3 ~ Response, data = data, FUN = func)

data %>% 
  group_by(Response) %>%
  summarise(
    n = length(BillAmt_1),
    mean = mean(BillAmt_1),
    median = median(BillAmt_1),
    sd = sd(BillAmt_1)
  ) %>%
  as.data.frame()

data %>% 
  group_by(Response) %>%
  summarise(
    n = length(BillAmt_2),
    mean = mean(BillAmt_2),
    median = median(BillAmt_2),
    sd = sd(BillAmt_2)
  ) %>%
  as.data.frame()

data %>% 
  group_by(Response) %>%
  summarise(
    n = length(BillAmt_3),
    mean = mean(BillAmt_3),
    median = median(BillAmt_3),
    sd = sd(BillAmt_3)
  ) %>%
  as.data.frame()



boxplot(N_Products ~ Response, data = data, col = "cadetblue")

boxplot(N_Service ~ Response, data = data, col = "cadetblue")



ggplot(data, aes(x = factor(Response), y = N_Products)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot of Number of Products by Response", y = "Bill_Service")

ggplot(data, aes(x = factor(Response), y = N_Service)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot of Number of Services by Response", y = "Bill_Product")



CrossTable(data$Gender, data$Response, prop.r = TRUE, prop.c = FALSE)



index <- createDataPartition(data$Response, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]


model <- glm(Response ~ Age + Gender + MS + Pre_Month + N_Products + N_Service + BillAmt_1 + BillAmt_2 + BillAmt_3, data = train, family = "binomial")
summary(model)

model <- glm(Response ~ Age + N_Products + N_Service + BillAmt_1 + BillAmt_2, data = train, family = "binomial")
summary(model)



vif(model)
#                GVIF Df GVIF^(1/(2*Df))
# Age        1.002690  2        1.000672
# N_Products 1.347988  1        1.161029
# N_Service  1.068767  1        1.033812
# BillAmt_1  1.331180  1        1.153768
# BillAmt_2  1.738026  1        1.318342



train$predprob <- fitted(model)
predtrain      <- prediction(train$predprob, train$Response)
perftrain      <- performance(predtrain, "tpr", "fpr")
plot(perftrain)
abline(0, 1)

test$predprob <- predict(model, test, type = "response")
predtest      <- prediction(test$predprob, test$Response)
perftest      <- performance(predtest, "tpr", "fpr")
plot(perftest)
abline(0, 1)


auctrain <- performance(predtrain, "auc")
auctrain@y.values 

auctest <- performance(predtest, "auc")
auctest@y.values 


sstrain <- performance(predtrain, "sens", "spec")
best_threshold <- sstrain@alpha.values[[1]][which.max(sstrain@x.values[[1]]+sstrain@y.values[[1]])]
best_threshold


train$Response <- as.factor(train$Response)
train$predY <- as.factor(ifelse(train$predprob > best_threshold, 1, 0))
confusionMatrix(train$predY, train$Response, positive = "1")


test$Response <- as.factor(test$Response)
test$predY <- as.factor(ifelse(test$predprob > best_threshold, 1, 0))
confusionMatrix(test$predY, test$Response, positive = "1")

