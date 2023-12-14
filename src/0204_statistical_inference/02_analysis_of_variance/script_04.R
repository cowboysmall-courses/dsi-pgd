
test_data <- read.csv("../../../data/0204_statistical_inference/analysis_of_variance/Three\ Way\ Anova.csv", header = TRUE)

head(test_data)
summary(test_data)


anova <- aov(growth~campaign*region*size, data = test_data)
summary(anova)
# since p < 0.05 for campaign and region, we reject 
# the null hypothesis - there are significant 
# difference between campaigns and regions - and 
# there are significant interactions between 
# campaign*region and campaign*size 

par(mfrow = c(1, 3))
boxplot(growth~campaign, data = test_data, col = "cadetblue")
boxplot(growth~region, data = test_data, col = "cadetblue")
boxplot(growth~size, data = test_data, col = "cadetblue")


par(mfrow = c(1, 1))
interaction.plot(test_data$campaign, test_data$region, test_data$growth)
