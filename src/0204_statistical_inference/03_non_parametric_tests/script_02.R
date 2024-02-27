
test_data <- read.csv("./data/0204_statistical_inference/03_non_parametric_tests/Wilcoxon\ Signed\ Rank\ test\ for\ paired\ data.csv", header = TRUE)

head(test_data)
summary(test_data)


# Wilcoxon signed rank test for paired data
wilcox.test(test_data$Before, test_data$After, data = test_data, paired = TRUE, alternative = "less")
# as p-value < 0.05 we reject the null hypothesis
# i.e. the score after training is greater than 
# the score before
