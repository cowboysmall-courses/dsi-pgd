
test_data <- read.csv("../../../data/si/live_class/EMPLOYEE\ ENGAGEMENT\ DATA.csv", header = TRUE)

head(test_data)
summary(test_data)


wilcox.test(FEEDBACK ~ GENDER, data = test_data)
# Wilcoxon rank sum test with continuity correction
# 
# data:  FEEDBACK by GENDER
# W = 831, p-value = 0.8405
# alternative hypothesis: true location shift is not equal to 0



kruskal.test(FEEDBACK ~ DEPT, data = test_data)
# Kruskal-Wallis rank sum test
# 
# data:  FEEDBACK by DEPT
# Kruskal-Wallis chi-squared = 1.3292, df = 2, p-value = 0.5145
