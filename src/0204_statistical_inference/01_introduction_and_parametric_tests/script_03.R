
test_data <- read.csv("./data/0204_statistical_inference/intro_and_parametric_tests/INDEPENDENT\ SAMPLES\ t\ TEST.csv", header = TRUE)

head(test_data)
summary(test_data)


# Test for normality
qqnorm(test_data$time_g1, col = "cadetblue")
shapiro.test(test_data$time_g1)
lillie.test(test_data$time_g1)

qqnorm(test_data$time_g2, col = "cadetblue")
shapiro.test(test_data$time_g2)
lillie.test(test_data$time_g2)


# two sample t-test - equal variances
t.test(test_data$time_g1, test_data$time_g2, alternative = "two.sided", var.equal = TRUE)
# as p-value > 0.05, we fail to reject the null hypothesis
# as the confidence interval contains 0, we therefore fail 
# to reject the null hypothesis



# two sample t-test - unequal variances
t.test(test_data$time_g1, test_data$time_g2, alternative = "two.sided", var.equal = FALSE)
# as p-value > 0.05, we fail to reject the null hypothesis
# as the confidence interval contains 0, we therefore fail 
# to reject the null hypothesis
