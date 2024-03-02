
test_data <- read.csv("./data/0204_statistical_inference/03_non_parametric_tests/Kruskal\ Wallis\ Test.csv", header = TRUE)

head(test_data)
summary(test_data)


# Kruskal Wallis test
kruskal.test(aptscore~Group, data = test_data)
# as p-value > 0.05, we fail to reject the null hypothesis
# i.e. aptitude score is the same for all groups of employees
