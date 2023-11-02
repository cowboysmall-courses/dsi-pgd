
library(e1071)
library(nortest)


test_data <- read.csv("../../../data/si/case_study/EMPLOYEE\ ENGAGEMENT\ DATA.csv", header = TRUE)

head(test_data)
summary(test_data)

# Test for normality
boxplot(test_data$EESCORE, col = "cadetblue", ylab = "Employee Engagement", main = "Employee Engagement")

skewness(test_data$EESCORE)
# 0.5585093


qqnorm(test_data$EESCORE, col = "cadetblue")

shapiro.test(test_data$EESCORE)
#         Shapiro-Wilk normality test
# 
# data:  test_data$EESCORE
# W = 0.9777, p-value = 0.143



t.test(test_data$EESCORE, alternative = "greater", mu = 50)
#         One Sample t-test
# 
# data:  test_data$EESCORE
# t = 1.2508, df = 85, p-value = 0.1072
# alternative hypothesis: true mean is greater than 50
# 95 percent confidence interval:
#   49.54929      Inf
# sample estimates:
#   mean of x 
# 51.36791 
