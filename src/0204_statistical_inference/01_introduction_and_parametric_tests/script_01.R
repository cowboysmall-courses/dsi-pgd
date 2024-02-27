
library(nortest)


test_data <- read.csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/Normality\ Testing\ Data.csv", header = TRUE)

head(test_data)
summary(test_data)


# linear => normal
qqnorm(test_data$csi, col = "cadetblue")

# non-linear => non-normal
qqnorm(test_data$billamt, col = "cadetblue")



# Shapiro-Wilks Test
#
# null hypothesis -> sample drawn from normal population
shapiro.test(test_data$csi)
# as p-value > 0.05, we fail to reject the null hypothesis

# null hypothesis -> sample drawn from normal population
shapiro.test(test_data$billamt)
# as p-value < 0.05, we reject the null hypothesis



# Kolmogorov-Smirnov Test
#
# null hypothesis -> sample drawn from normal population
lillie.test(test_data$csi)
# as p-value > 0.05, we fail to reject the null hypothesis

# null hypothesis -> sample drawn from normal population
lillie.test(test_data$billamt)
# as p-value < 0.05, we reject the null hypothesis
