
library(nortest)


data <- read.csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/INDEPENDENT\ SAMPLES\ t\ TEST.csv", header = TRUE)

head(data)
summary(data)


qqnorm(data$time_g1, col = "cadetblue")
shapiro.test(data$time_g1)
lillie.test(data$time_g1)

qqnorm(data$time_g2, col = "cadetblue")
shapiro.test(data$time_g2)
lillie.test(data$time_g2)


t.test(data$time_g1, data$time_g2, alternative = 'two.sided', var.equal = TRUE)
