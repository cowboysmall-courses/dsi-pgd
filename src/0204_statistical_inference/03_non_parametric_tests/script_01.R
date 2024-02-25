
test_data <- read.csv("./data/0204_statistical_inference/non_parametric_tests/Mann\ Whitney\ test.csv", header = TRUE)

head(test_data)
summary(test_data)


# the Mann-Whitney test
wilcox.test(aptscore~Group, data = test_data)
# as p-value > 0.05 we fail to reject the null hypothesis
# i.e. samples come from the same population
