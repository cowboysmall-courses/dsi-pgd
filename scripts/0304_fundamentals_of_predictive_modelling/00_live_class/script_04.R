
library(car)
library(caret)
library(nortest)



data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_live_class/Vehicle\ Data.csv", header = TRUE)
head(data)
summary(data)


data <- na.omit(data)
summary(data)

set.seed(123)
index <- createDataPartition(data$selling_price, p = 0.8, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]


train_model <- lm(selling_price ~ km_driven + fuel + seller_type + transmission + owner + mileage + engine + max_power + seats, data = train)
summary(train_model)


vif(train_model)


train_model <- lm(selling_price ~ km_driven + seller_type + transmission + owner + mileage + max_power, data = train)
summary(train_model)


vif(train_model)



train$pred <- fitted(train_model)
train$resi <- residuals(train_model)
head(train)
dim(train)


plot(train$pred, train$resi, col = "cadetblue")
plot(train$selling_price, train$resi, col = "cadetblue")


qqnorm(train$resi, col = "cadetblue")
qqline(train$resi, col = "cadetblue", lwd = 2)


shapiro.test(sample(train$resi, size = 5000, replace = FALSE))
lillie.test(train$resi)


train_rmse <- sqrt(mean(train$resi ** 2))
train_rmse
# 464491


test$pred <- predict(train_model, test)
test$resi <- test$selling_price - test$pred
test_rmse <- sqrt(mean(test$resi ** 2))
test_rmse
# 478917.2

((test_rmse - train_rmse) / train_rmse) * 100
# 3.105801
