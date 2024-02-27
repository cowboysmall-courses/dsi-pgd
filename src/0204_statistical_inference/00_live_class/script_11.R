
test_data <- read.csv("./data/0204_statistical_inference/00_live_class/Performance\ Appraisal\ Feedback.csv", header = TRUE)

head(test_data)
summary(test_data)

kruskal.test(Satscore ~ Function, data = test_data)
