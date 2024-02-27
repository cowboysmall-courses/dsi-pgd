
house_data <- read.csv("./data/0104_exploratory_data_analysis/00_live_class/Housing_Prices.csv", header = TRUE)

head(house_data)
summary(house_data)
dim(house_data)


# CRIM -> Per Capita Crime Rate by town
# NOX  -> Nitric Oxides concentration
# MEDV -> Median Value of owner-occupied homes in $1000's


library(GGally)

ggpairs(house_data, title = "Scatter Plot Matrix")

cor(house_data$MEDV, house_data$CRIM)
cor(house_data$MEDV, house_data$NOX)



# Simple Linear Regression: MEDV vs CRIM
model1 <- lm(MEDV ~ CRIM, data = house_data)
summary(model1)

house_data$pred1 <- fitted(model1)
house_data$resi1 <- residuals(model1)
head(house_data)



# Simple Linear Regression: MEDV vs NOX
model2 <- lm(MEDV ~ NOX, data = house_data)
summary(model2)

house_data$pred2 <- fitted(model2)
house_data$resi2 <- residuals(model2)
head(house_data)



# Multiple Linear Regression: MEDV vs NOX
model3 <- lm(MEDV ~ CRIM + NOX, data = house_data)
summary(model3)

house_data$pred3 <- fitted(model3)
house_data$resi3 <- residuals(model3)
head(house_data)





