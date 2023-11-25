
test_data <- read.csv("../../../data/0204_statistical_inference/intro_and_parametric_tests/Correlation\ test.csv", header = TRUE)

head(test_data)
summary(test_data)


# t-test for correlation
cor.test(test_data$aptitude, test_data$job_prof, alternative = "two.sided", method = "pearson")
# as p-value < 0.05, we reject the null hypothesis
# as the confidence interval does not contain 0, we 
# therefore reject the null hypothesis
