
library(dplyr)
library(nortest)
library(gmodels)





# 1 - import data and check first 5 rows
data <- read.csv("./data/0204_statistical_inference/live_class/Food\ Delivery\ App\ Survey\ Data.csv", header = TRUE)
head(data, 5)





# 2 - find median rating for each parameter for AGE
data %>% group_by(AGE) %>% summarise(across(Q1:Q3, median))

aggregate(cbind(Q1, Q2, Q3) ~ AGE, data = data, FUN = median)





# 3 - calculate total score as sum of the 3 parameter ratings
data$TOTAL_SCORE <- data$Q1 + data$Q2 + data$Q3
head(data)





# 4 - obtain box-whisker plot for total score
boxplot(data$TOTAL_SCORE, main = "Box Plot", ylab = "Total Score", col = "cadetblue3")





# 5 - can total score be assumed to be normal? use statistical test
qqnorm(data$TOTAL_SCORE, col = "cadetblue")

shapiro.test(data$TOTAL_SCORE)
# Shapiro-Wilk normality test
#
# data:  data$TOTAL_SCORE
# W = 0.97408, p-value = 0.239

lillie.test(data$TOTAL_SCORE)
# Lilliefors (Kolmogorov-Smirnov) normality test
#
# data:  data$TOTAL_SCORE
# D = 0.095339, p-value = 0.2013





# 6 - compare the total score for three age groups using statistical tests
aggregate(
  TOTAL_SCORE ~ AGE,
  data = data,
  FUN = function(x) {
    y <- shapiro.test(x)
    c(y$p.value)
  }
)
#     AGE TOTAL_SCORE
# 1  <=30   0.4045214
# 2   >50   0.7464921
# 3 30-50   0.7791045

aggregate(
  TOTAL_SCORE ~ AGE,
  data = data,
  FUN = function(x) {
    y <- lillie.test(x)
    c(y$p.value)
  }
)
#     AGE TOTAL_SCORE
# 1  <=30   0.2910144
# 2   >50   0.6361052
# 3 30-50   0.0955906

summary(aov(TOTAL_SCORE ~ AGE, data = data))
#             Df Sum Sq Mean Sq F value Pr(>F)
# AGE          2    2.1   1.038   0.079  0.924
# Residuals   56  739.1  13.198





# 7 - compare the total score for male and female using statistical tests
aggregate(
  TOTAL_SCORE ~ GENDER,
  data = data,
  FUN = function(x) {
    y <- shapiro.test(x)
    c(y$p.value)
  }
)
#   GENDER TOTAL_SCORE
# 1 Female   0.5002397
# 2   Male   0.1736490

aggregate(
  TOTAL_SCORE ~ GENDER,
  data = data,
  FUN = function(x) {
    y <- lillie.test(x)
    c(y$p.value)
  }
)
#   GENDER TOTAL_SCORE
# 1 Female   0.3931352
# 2   Male   0.6241096

t.test(TOTAL_SCORE ~ GENDER, data = data, var.equal = TRUE)
#         Two Sample t-test
#
# data:  TOTAL_SCORE by GENDER
# t = -3.2193, df = 57, p-value = 0.002123
# alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
# 95 percent confidence interval:
#   -4.526246 -1.054773
# sample estimates:
#   mean in group Female   mean in group Male
#               16.46875             19.25926

summary(aov(TOTAL_SCORE ~ GENDER, data = data))
#             Df Sum Sq Mean Sq F value  Pr(>F)
# GENDER       1  114.0     114   10.36 0.00212 **
# Residuals   57  627.2      11
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1





# 8 - analyze the effect of age group and gender with interaction on total score
summary(aov(TOTAL_SCORE ~ AGE*GENDER, data = data))
#             Df Sum Sq Mean Sq F value  Pr(>F)
# AGE          2    2.1    1.04   0.090 0.91429
# GENDER       1  122.5  122.48  10.590 0.00198 **
# AGE:GENDER   2    3.7    1.83   0.158 0.85385
# Residuals   53  613.0   11.57
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1





# 9 - create indicator variable as satisfied "Yes" if total score > 20, "No" otherwise
data$SATISFIED <- ifelse(data$TOTAL_SCORE > 20, "Yes", "No")
head(data)





# 10 - find the proportion of satisfied customers
prop.table(table(data$SATISFIED))
#        No       Yes
# 0.7457627 0.2542373

round(prop.table(table(data$SATISFIED)) * 100, 2)
#    No   Yes
# 74.58 25.42
