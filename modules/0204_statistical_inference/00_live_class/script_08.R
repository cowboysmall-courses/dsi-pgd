
library(e1071)
library(nortest)
library(dplyr)
library(ggplot2)


test_data <- read.csv("../../../data/0204_statistical_inference/live_class/EMPLOYEE\ ENGAGEMENT\ DATA.csv", header = TRUE)

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





# boxplot(
#   test_data$EESCORE ~ test_data$DEPT,
#   col = c("cadetblue", "darkorange", "lightyellow"),
#   xlab = "Department",
#   ylab = "Employee Engagement",
#   main = "Employee Engagement by Department"
# )

boxplot(
  EESCORE ~ DEPT,
  data = test_data,
  col = c("cadetblue", "darkorange", "lightyellow"),
  xlab = "Department",
  ylab = "Employee Engagement",
  main = "Employee Engagement by Department"
)

test_data %>%
  group_by(DEPT) %>%
  summarise(Count = length(EESCORE), Mean = round(mean(EESCORE), 2), SD = round(sd(EESCORE), 2), Min = min(EESCORE), MAX = max(EESCORE)) %>%
  as.data.frame()
#      DEPT Count  Mean    SD   Min   MAX
# 1 FINANCE    28 50.09 11.02 29.63 74.63
# 2      IT    32 51.11 10.29 32.13 87.13
# 3   SALES    26 53.07  9.07 37.25 70.38

test_data %>%
  ggplot(aes(sample = EESCORE)) + geom_qq() + geom_qq_line() + facet_wrap(~DEPT, scales = 'free_y')

aggregate(
  EESCORE ~ DEPT,
  data = test_data,
  FUN = function(x) {
    y <- shapiro.test(x)
    c(y$p.value)
  }
)

summary(aov(EESCORE ~ DEPT, data = test_data))
#             Df Sum Sq Mean Sq F value Pr(>F)
# DEPT         2    123   61.47   0.592  0.556
# Residuals   83   8619  103.85







boxplot(
  EESCORE ~ GENDER,
  data = test_data,
  col = c("cadetblue", "darkorange"),
  xlab = "Gender",
  ylab = "Employee Engagement",
  main = "Employee Engagement by Gender"
)

test_data %>%
  group_by(GENDER) %>%
  summarise(Count = length(EESCORE), Mean = round(mean(EESCORE), 2), SD = round(sd(EESCORE), 2), Min = min(EESCORE), MAX = max(EESCORE)) %>%
  as.data.frame()
#   GENDER Count  Mean   SD   Min   MAX
# 1 Female    55 55.07 9.44 37.25 87.13
# 2   Male    31 44.81 7.83 29.63 64.00

test_data %>%
  ggplot(aes(sample = EESCORE)) + geom_qq() + geom_qq_line() + facet_wrap(~GENDER, scales = 'free_y')

aggregate(
  EESCORE ~ GENDER,
  data = test_data,
  FUN = function(x) {
    y <- shapiro.test(x)
    c(y$p.value)
  }
)

t.test(EESCORE ~ GENDER, data = test_data, alternative = 'two.sided', var.equal = TRUE)
#        Two Sample t-test
#
# data:  EESCORE by GENDER
# t = 5.1332, df = 84, p-value = 1.812e-06
# alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
# 95 percent confidence interval:
#   6.285999 14.236487
# sample estimates:
#   mean in group Female   mean in group Male
# 55.06673             44.80548




summary(aov(EESCORE ~ DEPT*GENDER, data = test_data))
#             Df Sum Sq Mean Sq F value   Pr(>F)
# DEPT         2    123    61.5   0.797   0.4543
# GENDER       1   2002  2002.3  25.957 2.28e-06 ***
# DEPT:GENDER  2    446   223.0   2.891   0.0614 .
# Residuals   80   6171    77.1
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

summary(aov(EESCORE ~ GENDER*DEPT, data = test_data))
