
train_data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)
head(train_data)


model <- lm(jpi ~ aptitude + tol + technical + general, data = train_data)
summary(model)


model <- lm(jpi ~ aptitude + technical + general, data = train_data)
summary(model)


train_data$pred <- fitted(model)
train_data$resi <- residuals(model)
head(train_data)


test_data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index\ new.csv", header = TRUE)
head(test_data)


test_data$pred <- predict(model, test_data)
test_data$resi <- test_data$jpi - test_data$pred
head(test_data)
