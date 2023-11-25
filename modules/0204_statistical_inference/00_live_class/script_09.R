
test_data <- read.csv("../../../data/si/live_class/Mobile\ Consumer\ Behaviour.csv", header = TRUE)

head(test_data)
summary(test_data)

wilcox.test(Color ~ Gender, data = test_data)
