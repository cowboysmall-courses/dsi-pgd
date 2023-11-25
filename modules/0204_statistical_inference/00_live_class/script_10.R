
test_data <- read.csv("../../../data/0204_statistical_inference/live_class/Pain\ Level\ Assessment.csv", header = TRUE)

head(test_data)
summary(test_data)

wilcox.test(test_data$pain_before, test_data$pain_after, paired = TRUE, alternative = "greater")
