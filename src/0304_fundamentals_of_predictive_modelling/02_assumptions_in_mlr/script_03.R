
library(car)



data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)
head(data)


model <- lm(jpi ~ aptitude + tol + technical + general, data = data)
summary(model)


data$pred <- fitted(model)
data$resi <- residuals(model)


plot(data$pred, data$resi, col = "cadetblue")


qqnorm(data$resi, col = "cadetblue")
qqline(data$resi, col = "cadetblue")


shapiro.test(data$resi)
