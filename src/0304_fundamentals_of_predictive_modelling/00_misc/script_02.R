
library(gmodels)
library(nortest)


data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/misc/basic_recovery_data.csv", header = TRUE)

head(data)
#   Gender Resting.HR X2.mins X4.mins X6.mins X8.mins X10.mins
# 1   Male         65      90      83      80      70       65
# 2   Male         80     120     110     100      90       80
# 3   Male         62      90      86      79      69       62
# 4   Male         65      90      84      77      73       65
# 5   Male         75      99      90      85      84       75
# 6   Male         80     120     110     103      90       80


qqnorm(data$Resting.HR, col = "cadetblue")
qqline(data$Resting.HR, col = "cadetblue", lwd = 2)

qqnorm(data$X2.mins, col = "cadetblue")
qqline(data$X2.mins, col = "cadetblue", lwd = 2)

qqnorm(data$X4.mins, col = "cadetblue")
qqline(data$X4.mins, col = "cadetblue", lwd = 2)

qqnorm(data$X6.mins, col = "cadetblue")
qqline(data$X6.mins, col = "cadetblue", lwd = 2)

qqnorm(data$X8.mins, col = "cadetblue")
qqline(data$X8.mins, col = "cadetblue", lwd = 2)

qqnorm(data$X10.mins, col = "cadetblue")
qqline(data$X10.mins, col = "cadetblue", lwd = 2)


for(i in 2:ncol(data)) {
  sw <- shapiro.test(data[, i])$p.value
  ks <- lillie.test(data[, i])[2]

  cat(paste("Column:", colnames(data)[i], "->", ifelse(sw > 0.05 || ks > 0.05, "Parametric", "Non Parametric")))
  cat("\n")
  cat(paste("      Shapiro-Wilk Test: p-value = ", sw))
  cat("\n")
  cat(paste("Kolmogorov-Smirnov Test: p-value = ", ks))
  cat("\n")
  cat("\n")
}
# Column: Resting.HR -> Parametric
#       Shapiro-Wilk Test: p-value =  0.0998919611990975
# Kolmogorov-Smirnov Test: p-value =  0.337871893926727
# 
# Column: X2.mins -> Non Parametric
#       Shapiro-Wilk Test: p-value =  0.000366064013384196
# Kolmogorov-Smirnov Test: p-value =  0.00446600858855119
# 
# Column: X4.mins -> Parametric
#       Shapiro-Wilk Test: p-value =  0.0884995679060479
# Kolmogorov-Smirnov Test: p-value =  0.0904961925238923
# 
# Column: X6.mins -> Non Parametric
#       Shapiro-Wilk Test: p-value =  7.26073310316771e-15
# Kolmogorov-Smirnov Test: p-value =  3.13938959106298e-27
# 
# Column: X8.mins -> Parametric
#       Shapiro-Wilk Test: p-value =  0.00166993421847086
# Kolmogorov-Smirnov Test: p-value =  0.129392381959864
# 
# Column: X10.mins -> Non Parametric
#       Shapiro-Wilk Test: p-value =  0.00313867459794711
# Kolmogorov-Smirnov Test: p-value =  0.0017666898393127



# Parametric Tests

var.test(Resting.HR ~ Gender, data = data, alternative = "two.sided")
#         F test to compare two variances
# 
# data:  Resting.HR by Gender
# F = 1.2408, num df = 28, denom df = 20, p-value = 0.6249
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#  0.5245028 2.7699780
# sample estimates:
# ratio of variances 
#           1.240801 

t.test(Resting.HR ~ Gender, data = data, var.equal = TRUE)
#         Two Sample t-test
# 
# data:  Resting.HR by Gender
# t = 1.8135, df = 48, p-value = 0.07601
# alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
# 95 percent confidence interval:
#   -0.6325382 12.2680062
# sample estimates:
# mean in group Female   mean in group Male 
#             81.10345             75.28571


var.test(X4.mins ~ Gender, data = data, alternative = "two.sided")
#         F test to compare two variances
# 
# data:  X4.mins by Gender
# F = 2.2936, num df = 28, denom df = 20, p-value = 0.05849
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#  0.969532 5.120244
# sample estimates:
#   ratio of variances 
#             2.293594

t.test(X4.mins ~ Gender, data = data, var.equal = TRUE)
#         Two Sample t-test
# 
# data:  X4.mins by Gender
# t = 1.5494, df = 48, p-value = 0.1279
# alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
# 95 percent confidence interval:
#  -2.511116 19.381395
# sample estimates:
# mean in group Female   mean in group Male 
#             110.4828             102.0476


var.test(X8.mins ~ Gender, data = data, alternative = "two.sided")
#         F test to compare two variances
# 
# data:  X8.mins by Gender
# F = 2.6092, num df = 28, denom df = 20, p-value = 0.02977
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#  1.102944 5.824814
# sample estimates:
# ratio of variances 
#           2.609204 

t.test(X8.mins ~ Gender, data = data)
#         Welch Two Sample t-test
# 
# data:  X8.mins by Gender
# t = 2.1285, df = 47.036, p-value = 0.03856
# alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
# 95 percent confidence interval:
#   0.6237106 22.1086375
# sample estimates:
# mean in group Female   mean in group Male 
#             97.41379             86.04762



# Non Parametric Tests

wilcox.test(X2.mins ~ Gender, data = data)
#         Wilcoxon rank sum test with continuity correction
# 
# data:  X2.mins by Gender
# W = 406, p-value = 0.04655
# alternative hypothesis: true location shift is not equal to 0


wilcox.test(X6.mins ~ Gender, data = data)
#         Wilcoxon rank sum test with continuity correction
# 
# data:  X6.mins by Gender
# W = 393.5, p-value = 0.08152
# alternative hypothesis: true location shift is not equal to 0


wilcox.test(X10.mins ~ Gender, data = data)
#         Wilcoxon rank sum test with continuity correction
# 
# data:  X10.mins by Gender
# W = 439.5, p-value = 0.008147
# alternative hypothesis: true location shift is not equal to 0
