
library(nortest)


test_data <- read.csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/ONE\ SAMPLE\ t\ TEST.csv", header = TRUE)

head(test_data)
summary(test_data)

# Test for normality
qqnorm(test_data$Time, col = "cadetblue")
shapiro.test(test_data$Time)
lillie.test(test_data$Time)

# one sample t-test
t.test(test_data$Time, alternative = "greater", mu = 90)
# as p-value < 0.05, we reject the null hypothesis
