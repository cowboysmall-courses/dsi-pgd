
library(nortest)
library(car)





# 

train_data1 <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_live_class/Performance\ Index.csv", header = TRUE)
head(train_data1)


model1 <- lm(jpi ~ aptitude + tol + technical + general, data = train_data1)
summary(model1)

X <- cbind(rep(1, nrow(train_data1)), as.matrix(train_data1[, c("aptitude", "tol", "technical", "general")]))
y <- as.matrix(train_data1[, "jpi"])
B <- solve(t(X) %*% X) %*% t(X) %*% y
round(B[, 1], 5)

vif(model1)

train_data1$pred <- fitted(model1)
train_data1$resi <- residuals(model1)
head(train_data1)



plot(train_data1$jpi, train_data1$resi, col = "cadetblue")

qqnorm(train_data1$resi, col = "cadetblue")
qqline(train_data1$resi, col = "cadetblue", lwd = 2)

shapiro.test(train_data1$resi)
lillie.test(train_data1$resi)





# 

train_data2 <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_live_class/Performance\ Index.csv", header = TRUE)
head(train_data2)

model2 <- lm(jpi ~ aptitude + technical + general, data = train_data2)
summary(model2)

X <- cbind(rep(1, nrow(train_data2)), as.matrix(train_data2[, c("aptitude", "technical", "general")]))
y <- as.matrix(train_data2[, "jpi"])
B <- solve(t(X) %*% X) %*% t(X) %*% y
round(B[, 1], 5)

vif(model2)

train_data2$pred <- fitted(model2)
train_data2$resi <- residuals(model2)
head(train_data2)



plot(train_data2$jpi, train_data2$resi, col = "cadetblue")

qqnorm(train_data2$resi, col = "cadetblue")
qqline(train_data2$resi, col = "cadetblue", lwd = 2)

shapiro.test(train_data2$resi)
lillie.test(train_data2$resi)





# 

test_data1 <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_live_class/Performance\ Index\ new.csv", header = TRUE)
head(test_data1)


test_data1$pred <- predict(model, test_data1)
test_data1$resi <- test_data1$jpi - test_data1$pred
head(test_data1)



plot(test_data1$jpi, test_data1$resi, col = "cadetblue")

qqnorm(test_data1$resi, col = "cadetblue")
qqline(test_data1$resi, col = "cadetblue", lwd = 2)

shapiro.test(test_data1$resi)
lillie.test(test_data1$resi)
