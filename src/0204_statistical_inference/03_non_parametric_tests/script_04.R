
library(gmodels)

test_data <- read.csv("../../../data/0204_statistical_inference/non_parametric_tests/chi\ square\ test\ of\ association.csv", header = TRUE)

head(test_data)
summary(test_data)


# Chi-square test of association
CrossTable(test_data$performance, test_data$source, chisq = TRUE)
# as p-value < 0.05, we reject the null hypothesis
# i.e. recruitment source and employee performance 
# are associated 
