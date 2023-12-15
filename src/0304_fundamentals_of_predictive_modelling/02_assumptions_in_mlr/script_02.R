
library(GGally)
library(car)



data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/ridge\ regression\ data.csv", header = TRUE)
head(data)


ggpairs(
    ridgedata[, c("RESALE.PRICE", "ENGINE.SIZE", "HORSE.POWER", "YEARS")],
    title = "Scatter Plot Matrix",
    columnLabels = c("RESALE.PRICE", "ENGINE.SIZE", "HORSE.POWER", "YEARS")
)


model <- lm(RESALE.PRICE ~ ENGINE.SIZE + HORSE.POWER + WEIGHT + YEARS, data = data)
summary(model)


vif(model)
