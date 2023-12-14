
# BACKGROUND: 
#   The survey is conducted within a large organization to 
#   assess satisfaction level of employees in various 
#   functions. The satisfaction level is measured on 1-5 
#   scale where higher a number indicates more satisfaction.


library(nortest)
library(gmodels)




# 1 - Import EMPLOYEE SATISFACTION SURVEY data. Check for 
#     normality of the data.
ess_data <- read.csv("../../../data/0204_statistical_inference/assignment/EMPLOYEE\ SATISFACTION\ SURVEY.csv", header = TRUE)

head(ess_data)
summary(ess_data)

qqnorm(ess_data$satlevel, col = "cadetblue")

shapiro.test(ess_data$satlevel)

# Shapiro-Wilk normality test
# 
# data:  ess_data$satlevel
# W = 0.87548, p-value = 6.048e-05

# as p-value < 0.05, we reject the null hypothesis
# that the data was drawn from a normal distribution

lillie.test(ess_data$satlevel)

# Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  ess_data$satlevel
# D = 0.24072, p-value = 4.682e-08

# as p-value < 0.05, we reject the null hypothesis
# that the data was drawn from a normal distribution




# 2 - Find median satisfaction level for 'IT', 'Sales' and 
#     'Finance'. Test whether the satisfaction level among 
#     three roles differ significantly.
ess_data_I <- subset(ess_data, dept == "IT")
ess_data_S <- subset(ess_data, dept == "SALES")
ess_data_F <- subset(ess_data, dept == "FINANCE")

median(ess_data_I$satlevel)
# 3
median(ess_data_S$satlevel)
# 3
median(ess_data_F$satlevel)
# 4

CrossTable(ess_data$satlevel, ess_data$dept, chisq = TRUE)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  30.14967     d.f. =  6     p =  3.681483e-05 

# since p < 0.05 we reject the null hypothesis that there is 
# no association between satisfaction levels and department




# 3 - Is there any association between satisfaction level 
#     and experience level? Experience level is defined as 
#     midlevel (greater than 2 years) and Junior (less than 
#     or equal to 2 years). 
ess_data$explevel <- ifelse(ess_data$exp <= 2, "junior", "midlevel")

head(ess_data)

CrossTable(ess_data$satlevel, ess_data$explevel, chisq = TRUE)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  1.775779     d.f. =  3     p =  0.6202199 

# since p > 0.05 we fail to reject the null hypothesis that 
# there is no association between satisfaction levels and 
# experience level 




# 4 - Find number of employees with satisfaction score 
#     greater than 3 in each department
nrow(subset(ess_data_I, ess_data_I$satlevel > 3))
# 4
nrow(subset(ess_data_S, ess_data_S$satlevel > 3))
# 2
nrow(subset(ess_data_F, ess_data_F$satlevel > 3))
# 16

nrow(subset(ess_data, ess_data$satlevel > 3))
# 22 (4 + 2 + 16)
