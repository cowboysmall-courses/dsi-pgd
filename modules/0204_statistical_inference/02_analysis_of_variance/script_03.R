
test_data <- read.csv("../../../data/si/analysis_of_variance/Two\ way\ anova.csv", header = TRUE)

head(test_data)
summary(test_data)


anova <- aov(satindex~dept+exp+dept*exp, data = test_data)
summary(anova)
# since p > 0.05 for all three, we fail to reject 
# the null hypothesis for all three tests
