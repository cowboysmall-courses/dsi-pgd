
library(e1071)


data <- read.csv("../../../data/0104_exploratory_data_analysis/live_class/Normality_Assessment_Data.csv", header = TRUE)


boxplot(data$csi, col = "cadetblue")
boxplot(data$billamt, col = "cadetblue")


skewness(data$csi)
skewness(data$billamt)


qqnorm(data$csi, col = "cadetblue")
qqnorm(data$billamt, col = "cadetblue")




