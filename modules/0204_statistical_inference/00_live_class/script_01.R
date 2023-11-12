
library(nortest)


data <- read.csv("../../../data/si/intro_and_parametric_tests/ONE\ SAMPLE\ t\ TEST.csv", header = TRUE)

head(data)
summary(data)

# Test for normality
boxplot(data$Time, col = "cadetblue", ylab = "Time", main = "Boxplot of Time")
qqnorm(data$Time, col = "cadetblue")

shapiro.test(data$Time)
lillie.test(data$Time)

# one sample t-test
t.test(data$Time, alternative = "greater", mu = 90)
# as p-value < 0.05, we reject the null hypothesis
