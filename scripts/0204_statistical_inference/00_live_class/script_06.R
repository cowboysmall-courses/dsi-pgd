
library(nortest)


data <- read.csv("./data/0204_statistical_inference/02_analysis_of_variance/One\ way\ anova.csv", header = TRUE)

head(data)
summary(data)


qqnorm(data$satindex, col = "cadetblue")
shapiro.test(data$satindex)
lillie.test(data$satindex)


summary(aov(satindex ~ dept, data = data))



