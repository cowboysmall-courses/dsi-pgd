# Jerry Kiely
# Data Science Institute
# Descriptive Statistics in R 
# EDA T4 Assignment

# 1
# Premiums <- read.csv("./Premiums.csv", header = TRUE)
Premiums <- read.csv("../../../data/exploratory_data_analysis_assignment/Premiums.csv", header = TRUE)
head(Premiums)


# 2
t <- table(Premiums$ZONE_NAME)
m <- max(t)
# the zone (name) with the greatest frequency - South
names(t)[t == m]


# 3
boxplot(Premiums$Vintage_Period, data = Premiums, main = "Box and Whisker plot (Vintage Period)", ylab = "Vintage Period", col = "green")


# 4
library(car)
# By default, the function Boxplot returns a vector of the 10 most extreme outliers - 5 smallest and 5 largest
outliers <-sort(Boxplot(Premiums$Vintage_Period, main = "Box and Whisker plot (Vintage Period)", ylab = "Vintage Period"))
# the 5 smallest outliers
outliers[1:5]
# the 5 largest outliers
outliers[6:10]


# 5
library(e1071)
# create a function to calculate both skewness and kurtosis
sk <- function(x) c(skew = skewness(x, type = 2), kurt = kurtosis(x, type = 2))
# apply the above function to premium amount partitioned by zone (name)
aggregate(Premium ~ ZONE_NAME, data = Premiums, FUN = sk)


# 6
plot(Premiums$Premium, Premiums$Vintage_Period, col = "red")


# 7
cor(Premiums$Premium, Premiums$Vintage_Period)
# The Correlation Coefficient of 0.3641487 is greater than zero, and hence implies a 
# positive correlation, but the value is low, and hence would imply a low correlation.



