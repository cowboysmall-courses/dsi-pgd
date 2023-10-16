
# BACKGROUND:
#   In a randomized control trial, 32 patients were divided into
#   two groups: A and B. Group A received test drug whereas group
#   B received placebo. The variable of interest was ‘Change in
#   pain level’ measured by visual analogue scale (VAS)’ before
#   treatment and after 3 days of treatment.


library(nortest)
library(ggplot2)





# 1 - Import VAS DATA and name it as pain_vas. Check for normality of the data.
pain_vas <- read.csv("../../../data/si/assignment/VAS\ DATA.csv", header = TRUE)

head(pain_vas)
summary(pain_vas)
dim(pain_vas)

# Subset the data in groups A and B
pain_vas_A = subset(pain_vas, Group == "A")
head(pain_vas_A)

pain_vas_B = subset(pain_vas, Group == "B")
head(pain_vas_B)


# Check group A for normality
qqnorm(pain_vas_A$VAS_before, col = "cadetblue")
# the Q-Q plot looks linear, and hence would indicate
# the data is drawn from a normal distribution

shapiro.test(pain_vas_A$VAS_before)

# Shapiro-Wilk normality test
#
# data:  pain_vas_A$VAS_before
# W = 0.95239, p-value = 0.5284

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution

lillie.test(pain_vas_A$VAS_before)

# Lilliefors (Kolmogorov-Smirnov) normality test
#
# data:  pain_vas_A$VAS_before
# D = 0.13899, p-value = 0.5609

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution


qqnorm(pain_vas_A$VAS_after, col = "cadetblue")
# the Q-Q plot does not look perfectly linear, and hence
# would indicate the data is not drawn from a normal
# distribution

shapiro.test(pain_vas_A$VAS_after)

# Shapiro-Wilk normality test
#
# data:  pain_vas_A$VAS_after
# W = 0.87669, p-value = 0.03448

# as p-value < 0.05, we reject the null hypothesis
# that the data was drawn from a normal distribution

lillie.test(pain_vas_A$VAS_after)

# Lilliefors (Kolmogorov-Smirnov) normality test
#
# data:  pain_vas_A$VAS_after
# D = 0.20398, p-value = 0.07391

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution


# there is some ambiguity - the Shapiro-Wilk test and the
# Kolmogorov-Smirnov do not agree - the latter is usually
# appropriate for large samples so I would tend to believe
# that the former result is more reliable. Does this mean 
# that we should not proceed?



# Check group B for normality
qqnorm(pain_vas_B$VAS_before, col = "cadetblue")
# the Q-Q plot looks linear, and hence would indicate
# the data is drawn from a normal distribution

shapiro.test(pain_vas_B$VAS_before)

# Shapiro-Wilk normality test
# 
# data:  pain_vas_B$VAS_before
# W = 0.98225, p-value = 0.9789

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution

lillie.test(pain_vas_B$VAS_before)

# Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  pain_vas_B$VAS_before
# D = 0.084017, p-value = 0.9921

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution


qqnorm(pain_vas_B$VAS_after, col = "cadetblue")
# the Q-Q plot does not look perfectly  linear, and hence
# would indicate the data is not drawn from a normal
# distribution

shapiro.test(pain_vas_B$VAS_after)

# Shapiro-Wilk normality test
# 
# data:  pain_vas_B$VAS_after
# W = 0.968, p-value = 0.8053

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution

lillie.test(pain_vas_B$VAS_after)

# Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  pain_vas_B$VAS_after
# D = 0.10563, p-value = 0.904

# as p-value > 0.05, we fail to reject the null hypothesis
# that the data was drawn from a normal distribution

# there is some ambiguity - the Shapiro-Wilk test and the
# Kolmogorov-Smirnov do not agree - the latter





# 2 - Is post treatment VAS score significantly less as
#     compared to ‘before treatment’ VAS score for Group A?
t.test(pain_vas_A$VAS_before, pain_vas_A$VAS_after, alternative = "greater", paired = TRUE)
# t.test(pain_vas_A$VAS_after, pain_vas_A$VAS_before, alternative = "less", paired = TRUE)

# Paired t-test
# 
# data:  pain_vas_A$VAS_before and pain_vas_A$VAS_after
# t = 12.021, df = 15, p-value = 2.111e-09
# alternative hypothesis: true mean difference is greater than 0
# 95 percent confidence interval:
#   28.61447      Inf
# sample estimates:
#   mean difference 
#          33.5 

# as p-value < 0.05, we reject the null hypothesis
# that, for group A, the VAS scores are the same
# before and after treatment





# 3 - Is post treatment VAS score significantly less as
#     compared to ‘before treatment’ VAS score for Group B?
t.test(pain_vas_B$VAS_before, pain_vas_B$VAS_after, alternative = "greater", paired = TRUE)
# t.test(pain_vas_B$VAS_after, pain_vas_B$VAS_before, alternative = "less", paired = TRUE)

# Paired t-test
# 
# data:  pain_vas_B$VAS_before and pain_vas_B$VAS_after
# t = 2.4252, df = 15, p-value = 0.01419
# alternative hypothesis: true mean difference is greater than 0
# 95 percent confidence interval:
#   0.4503799       Inf
# sample estimates:
#   mean difference 
#          1.625 

# as p-value < 0.05, we reject the null hypothesis 
# that, for group B, the VAS scores are the same 
# before and after treatment (in this case a placebo)





# 4 - Is the average change in pain level for group 
#     ‘A’ significantly more than group ‘B’? 
pain_vas$Delta <- pain_vas$VAS_before - pain_vas$VAS_after
head(pain_vas)

pain_delta_A = subset(pain_vas, Group == "A")
head(pain_delta_A)
mean(pain_delta_A$Delta)

pain_delta_B = subset(pain_vas, Group == "B")
head(pain_delta_B)
mean(pain_delta_B$Delta)

t.test(pain_delta_A$Delta, pain_delta_B$Delta, alternative = "greater")

# Welch Two Sample t-test
# 
# data:  pain_delta_A$Delta and pain_delta_B$Delta
# t = 11.121, df = 16.728, p-value = 1.903e-09
# alternative hypothesis: true difference in means is greater than 0
# 95 percent confidence interval:
#   26.88412      Inf
# sample estimates:
#   mean of x mean of y 
# 33.500     1.625 

# as p-value < 0.05, we reject the null hypothesis 
# that the average change in pain scores are the same 
# across the groups





# 5 - Present change in pain level for each group 
#     using box-whisker plot.
ggplot(pain_vas, aes(x = Group, y = Delta)) + 
  geom_boxplot(fill = "darkorange", outlier.color = "midnightblue", outlier.size = 2.5) + 
  labs(x = "Group", y = "Change in Pain Level", title = "Box Plot")








# 4 (Alternative) 
# the above original approach is preferred because 
# it provides an easier structure for the boxplot

# Delta_A <- pain_vas_A$VAS_before - pain_vas_A$VAS_after
# Delta_B <- pain_vas_B$VAS_before - pain_vas_B$VAS_after
# 
# mean(Delta_A)
# mean(Delta_B)
# 
# t.test(Delta_A, Delta_B, alternative = "greater")

# Welch Two Sample t-test
# 
# data:  Delta_A and Delta_B
# t = 11.121, df = 16.728, p-value = 1.903e-09
# alternative hypothesis: true difference in means is greater than 0
# 95 percent confidence interval:
#   26.88412      Inf
# sample estimates:
#   mean of x mean of y 
# 33.500     1.625 
