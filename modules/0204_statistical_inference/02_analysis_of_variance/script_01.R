
test_data <- read.csv("../../../data/0204_statistical_inference/analysis_of_variance/F\ test\ for\ 2\ variances.csv", header = TRUE)

head(test_data)
summary(test_data)


# F-test for equality of variances
var.test(test_data$time_g1, test_data$time_g2, alternative = "two.sided")
# as p-value > 0.05, we fail to reject the null hypothesis
# as the confidence interval contains 1, we therefore fail 
# to reject the null hypothesis
