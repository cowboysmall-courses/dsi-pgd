
library(car)



data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)
head(data)


model <- lm(jpi ~ aptitude + tol + technical + general, data = data)
summary(model)


influ <- influence.measures(model)
influ


influencePlot(model, id.method = "identify", main = "Influence Plot", sub = "Circle size is proportioal to Cook's Distance")
