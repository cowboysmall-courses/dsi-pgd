
test_data <- read.csv("../../../data/si/analysis_of_variance/One\ way\ anova.csv", header = TRUE)

head(test_data)
summary(test_data)


anova <- aov(satindex~dept, data = test_data)
summary(anova)
# since p > 0.05, we fail to reject the null hypothesis
