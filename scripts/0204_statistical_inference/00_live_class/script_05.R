
library(nortest)


data <- read.csv("./data/0204_statistical_inference/01_introduction_and_parametric_tests/Correlation\ test.csv", header = TRUE)

head(data)
summary(data)


qqnorm(data$aptitude, col = "cadetblue")
shapiro.test(data$aptitude)
lillie.test(data$aptitude)

qqnorm(data$job_prof, col = "cadetblue")
shapiro.test(data$job_prof)
lillie.test(data$job_prof)


cor.test(data$aptitude, data$job_prof, alternative = 'two.sided', var.equal = TRUE)

