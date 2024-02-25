
library(nortest)


data <- read.csv("./data/0204_statistical_inference/intro_and_parametric_tests/PAIRED\ t\ TEST.csv", header = TRUE)

head(data)
summary(data)


t.test(data$time_before, data$time_after, alternative = 'greater', paired = TRUE)
