
library(reshape2)
library(ggplot2)
library(caret)
library(car)
library(nortest)


data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/case_study/Housing\ Prices.csv", header = TRUE)
head(data)
#      CRIM ZN INDUS CHAS   NOX    RM  AGE    DIS RAD TAX PTRATIO LSTAT MEDV
# 1 0.00632 18  2.31    0 0.538 6.575 65.2 4.0900   1 296    15.3  4.98 24.0
# 2 0.02731  0  7.07    0 0.469 6.421 78.9 4.9671   2 242    17.8  9.14 21.6
# 3 0.02729  0  7.07    0 0.469 7.185 61.1 4.9671   2 242    17.8  4.03 34.7
# 4 0.03237  0  2.18    0 0.458 6.998 45.8 6.0622   3 222    18.7  2.94 33.4
# 5 0.06905  0  2.18    0 0.458 7.147 54.2 6.0622   3 222    18.7  5.33 36.2
# 6 0.02985  0  2.18    0 0.458 6.430 58.7 6.0622   3 222    18.7  5.21 28.7


cormat <- round(cor(data), 2)
melted_cormat <- melt(cormat)


ggplot(data = melted_cormat, aes(x = Var1, y = Var2, fill = value)) + 
  geom_tile() +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  scale_fill_gradient2(low = "red", mid = "white" ,high = "blue")


index <- createDataPartition(data$MEDV, p = 0.8, list = FALSE)

train <- data[index, ]
test <- data[-index, ]


model <- lm(MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + LSTAT, data = train)
summary(model)


vif(model)
#     CRIM       ZN    INDUS     CHAS      NOX       RM      AGE      DIS      RAD      TAX  PTRATIO    LSTAT 
# 1.759777 2.248001 3.844934 1.065356 4.495863 1.911102 2.937110 4.036277 6.898243 8.333691 1.786470 2.887064


model <- lm(MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + PTRATIO + LSTAT, data = train)
summary(model)


vif(model)
#     CRIM       ZN    INDUS     CHAS      NOX       RM      AGE      DIS      RAD  PTRATIO    LSTAT 
# 1.759600 2.151873 3.139832 1.044515 4.463431 1.905748 2.935402 4.034723 2.773612 1.768220 2.886730 


train$pred <- fitted(model)
train$resi <- residuals(model)

plot(train$pred, train$resi)

qqnorm(train$resi)
qqline(train$resi, lwd = 2)


shapiro.test(train$resi)
#         Shapiro-Wilk normality test
# 
# data:  train$resi
# W = 0.91971, p-value = 6.365e-14


lillie.test(train$resi)
#         Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  train$resi
# D = 0.10384, p-value = 2.315e-11


model <- lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = train)
summary(model)


vif(model)
#     CRIM       ZN     CHAS      NOX       RM      DIS      RAD  PTRATIO    LSTAT 
# 1.753613 2.134953 1.038914 3.727619 1.817442 3.505424 2.720901 1.685204 2.575827


train$pred <- fitted(model)
train$resi <- residuals(model)

sqrt(mean(train$resi ** 2))
# 4.741551



test$pred <- predict(model, test)
test$resi <- test$MEDV - test$pred

sqrt(mean(test$resi ** 2))
# 5.127582



kfolds <- trainControl(method = "cv", number = 4)
kmodel <- train(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = data, method = "lm", trControl = kfolds)
kmodel
# Linear Regression 
# 
# 506 samples
#   9 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (4 fold) 
# Summary of sample sizes: 380, 379, 380, 379 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   5.187681  0.7047988  3.626889
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE


kfolds <- trainControl(method = "cv", number = 5)
kmodel <- train(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = data, method = "lm", trControl = kfolds)
kmodel
# Linear Regression 
# 
# 506 samples
#   9 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 406, 403, 405, 404, 406 
# Resampling results:
#   
#   RMSE      Rsquared   MAE     
#   4.995484  0.7062227  3.520038
# 
# Tuning parameter 'intercept' was held constant at a value of TRUE





model <- lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + RAD + PTRATIO + LSTAT, data = data)
summary(model)


vif(model)
#     CRIM       ZN     CHAS      NOX       RM      DIS      RAD  PTRATIO    LSTAT 
# 1.764257 2.154051 1.049185 3.538215 1.793239 3.407113 2.701027 1.715836 2.523246


data$pred <- predict(model, data)
data$resi <- data$MEDV - data$pred

sqrt(mean(data$resi ** 2))
# 4.79846



