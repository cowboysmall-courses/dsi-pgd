
library(car)



data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)
head(data)


model <- lm(jpi ~ aptitude + technical + general, data = data)
summary(model)


vif(model)
