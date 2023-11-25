
test_data <- read.csv("../../../data/si/live_class/Performance\ Appraisal\ Feedback.csv", header = TRUE)

head(test_data)
summary(test_data)

kruskal.test(Satscore ~ Function, data = test_data)
