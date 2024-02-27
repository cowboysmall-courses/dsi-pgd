
library(nortest)
library(car)
library(GGally)



data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/00_live_class/car\ price\ data.csv", header = TRUE)
head(data)

ggpairs(
  data[, c("RESALE.PRICE", "ENGINE.SIZE", "HORSE.POWER", "WEIGHT", "YEARS")],
  title = "Scatter Plot Matrix",
  columnLabels = c("Resale Price", "Engine Sie", "Horse Power", "Weight", "Years")
)





# 

model <- lm(RESALE.PRICE ~ ENGINE.SIZE + HORSE.POWER + WEIGHT + YEARS, data = data)
summary(model)

vif(model)





# 

model <- lm(RESALE.PRICE ~ HORSE.POWER + WEIGHT + YEARS, data = data)
summary(model)

vif(model)





# 

model <- lm(RESALE.PRICE ~ HORSE.POWER + WEIGHT, data = data)
summary(model)

vif(model)






# 

data$pred <- fitted(model)
data$resi <- residuals(model)
head(data)



plot(data$RESALE.PRICE, data$resi, col = "cadetblue")

qqnorm(data$resi, col = "cadetblue")
qqline(data$resi, col = "cadetblue", lwd = 2)

shapiro.test(data$resi)
lillie.test(data$resi)



