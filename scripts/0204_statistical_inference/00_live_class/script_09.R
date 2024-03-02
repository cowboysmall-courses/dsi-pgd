
test_data <- read.csv("./data/0204_statistical_inference/00_live_class/Mobile\ Consumer\ Behaviour.csv", header = TRUE)

head(test_data)
summary(test_data)

wilcox.test(Color ~ Gender, data = test_data)
