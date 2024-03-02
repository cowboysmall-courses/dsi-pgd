
test_data <- read.csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/PAIRED\ t\ TEST.csv", header = TRUE)

head(test_data)
summary(test_data)


# Test for normality
qqnorm(test_data$time_before, col = "cadetblue")
shapiro.test(test_data$time_before)
lillie.test(test_data$time_before)

qqnorm(test_data$time_after, col = "cadetblue")
shapiro.test(test_data$time_after)
lillie.test(test_data$time_after)



# paired sample t-test
t.test(test_data$time_before, test_data$time_after, alternative = "greater", paired = TRUE)
# as p-value < 0.05, we reject the null hypothesis
# as the confidence interval does not contain 0, we 
# therefore reject the null hypothesis
