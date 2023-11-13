
test_data <- read.csv("../../../data/si/non_parametric_tests/Pain\ Level\ Assessment.csv", header = TRUE)

head(test_data)
summary(test_data)

wilcox.test(test_data$pain_before, test_data$pain_after, paired = TRUE, alternative = "greater")
