
library(nortest)
library(gmodels)


cust_data <- read.csv("../../../data/si/non_parametric_tests/CUST_PROFILE.csv", header = TRUE)
head(cust_data)
dim(cust_data)
str(cust_data)
summary(cust_data)

length(unique(cust_data$CUSTID))
# [1] 15001

nps_data <- read.csv("../../../data/si/non_parametric_tests/NPSDATA.csv", header = TRUE)
head(nps_data)
dim(nps_data)
str(nps_data)
summary(nps_data)

length(unique(nps_data$CUSTID))
# [1] 107



merged_data <- merge(nps_data, cust_data, by = "CUSTID", all.x = TRUE)
head(merged_data)
dim(merged_data)
str(merged_data)
summary(merged_data)

length(unique(merged_data$CUSTID))
# [1] 107



mean(merged_data$NPS)
# [1] 6.196262

median(merged_data$NPS)
# [1] 6



boxplot(merged_data$NPS, main = "Box Plot", ylab = "Net Promoter Score", col = "cadetblue3")

qqnorm(merged_data$NPS, col = "cadetblue")

shapiro.test(merged_data$NPS)
#         Shapiro-Wilk normality test
# 
# data:  merged_data$NPS
# W = 0.94709, p-value = 0.000326

lillie.test(merged_data$NPS)
#         Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  merged_data$NPS
# D = 0.12501, p-value = 0.0002978

wilcox.test(merged_data$NPS, mu = 6, alternative = "greater")
#         Wilcoxon signed rank test with continuity correction
# 
# data:  merged_data$NPS
# V = 2166, p-value = 0.09809
# alternative hypothesis: true location is greater than 6



func <- function(x) {
  c(
    mean = round(mean(x), 2),
    median = median(x)
  )
}
aggregate(NPS ~ REGION, data = merged_data, FUN = func)
#   REGION NPS.mean NPS.median
# 1   East     6.25       6.00
# 2  North     6.21       6.00
# 3  South     6.06       6.00
# 4   West     6.32       7.00

kruskal.test(NPS ~ REGION, data = merged_data)
#         Kruskal-Wallis rank sum test
# 
# data:  NPS by REGION
# Kruskal-Wallis chi-squared = 0.52336, df = 3, p-value = 0.9137



agg_data <- aggregate(NPS ~ REGION, data = merged_data, FUN = median)
agg_data

barplot(
  agg_data$NPS, 
  main = "Net Promoter Score by Region", 
  names.arg = agg_data$REGION, 
  xlab = "Region", 
  ylab = "Net Promoter Score", 
  col = "darkorange"
)

boxplot(
  NPS ~ REGION, 
  data = merged_data, 
  main = "Box Plots", 
  xlab = "Region", 
  ylab = "Net Promoter Score", 
  col = c("orange", "green", "cadetblue", "yellow")
)



merged_data$DETRACTOR <- ifelse(merged_data$NPS <= 6, "Yes", "No")
head(merged_data)



table_data <- table(merged_data$DETRACTOR)
table_data
# No Yes 
# 48  59 

round(prop.table(table_data), 2)
#   No  Yes 
# 0.45 0.55

round(prop.table(table_data), 4) * 100
#    No   Yes 
# 44.86 55.14



prop.test(table_data["Yes"], sum(table_data), 0.4, alternative = "greater")
#         1-sample proportions test with continuity correction
# 
# data:  table_data["Yes"] out of sum(table_data), null probability 0.4
# X-squared = 9.5985, df = 1, p-value = 0.0009737
# alternative hypothesis: true p is greater than 0.4
# 95 percent confidence interval:
#   0.4673912 1.0000000
# sample estimates:
#         p 
# 0.5514019 



table(merged_data$DETRACTOR, merged_data$REGION)
#     East North South West
# No     7    11    15   15
# Yes   13    13    20   13

table(merged_data$REGION, merged_data$DETRACTOR)
#       No Yes
# East   7  13
# North 11  13
# South 15  20
# West  15  13

detractors <- subset(merged_data, DETRACTOR == 'Yes')
table(detractors$REGION)
# East North South  West 
#   13    13    20    13



CrossTable(merged_data$DETRACTOR, merged_data$REGION, chisq = TRUE)
#      Cell Contents
#   |-------------------------|
#   |                       N |
#   | Chi-square contribution |
#   |           N / Row Total |
#   |           N / Col Total |
#   |         N / Table Total |
#   |-------------------------|
#   
#   
#   Total Observations in Table:  107 
# 
# 
#                         | merged_data$REGION 
#   merged_data$DETRACTOR |      East |     North |     South |      West | Row Total | 
#   ----------------------|-----------|-----------|-----------|-----------|-----------|
#                      No |         7 |        11 |        15 |        15 |        48 | 
#                         |     0.433 |     0.005 |     0.031 |     0.474 |           | 
#                         |     0.146 |     0.229 |     0.312 |     0.312 |     0.449 | 
#                         |     0.350 |     0.458 |     0.429 |     0.536 |           | 
#                         |     0.065 |     0.103 |     0.140 |     0.140 |           | 
#   ----------------------|-----------|-----------|-----------|-----------|-----------|
#                     Yes |        13 |        13 |        20 |        13 |        59 | 
#                         |     0.353 |     0.004 |     0.025 |     0.385 |           | 
#                         |     0.220 |     0.220 |     0.339 |     0.220 |     0.551 | 
#                         |     0.650 |     0.542 |     0.571 |     0.464 |           | 
#                         |     0.121 |     0.121 |     0.187 |     0.121 |           | 
#   ----------------------|-----------|-----------|-----------|-----------|-----------|
#            Column Total |        20 |        24 |        35 |        28 |       107 | 
#                         |     0.187 |     0.224 |     0.327 |     0.262 |           | 
#   ----------------------|-----------|-----------|-----------|-----------|-----------|
#   
#   
#   Statistics for All Table Factors
# 
# 
#   Pearson's Chi-squared test 
#   ------------------------------------------------------------
#   Chi^2 =  1.711052     d.f. =  3     p =  0.6344795 
