
# BACKGROUND: 
#   In a randomized control trial, 32 patients were divided 
#   into two groups: A and B. Group A received test drug 
#   whereas group B received placebo. The variable of 
#   interest was Numerical Pain Rating Scale (NPRS) before 
#   treatment and after 3 days of treatment. (Higher number 
#   indicates more pain)


library(ggplot2)





# 1 - Import NPRS DATA and name it as pain_nprs. Find 
#     median NPRS before and after treatment.
pain_nprs <- read.csv("../../../data/0204_statistical_inference/assignment/NPRS\ DATA.csv", header = TRUE)

head(pain_nprs)
summary(pain_nprs)

median(pain_nprs$NPRS_before)
# 7
median(pain_nprs$NPRS_after)
# 5




# 2 - Is post treatment NPRS score significantly less 
#     as compared to 'before treatment' NPRS score for 
#     Group A?
pain_nprs_A <- subset(pain_nprs, Group == "A")
head(pain_nprs_A)

wilcox.test(pain_nprs_A$NPRS_before, pain_nprs_A$NPRS_after, paired = TRUE, alternative = "greater")
# alternative is "greater" because if pain is less 
# after treatment then difference will be greater 
# than zero

#         Wilcoxon signed rank test with continuity correction
# 
# data:  pain_nprs_A$NPRS_before and pain_nprs_A$NPRS_after
# V = 105, p-value = 0.0004507
# alternative hypothesis: true location shift is greater than 0

# as the p-value < 0.05 we reject the null hypothesis 
# that post treatment NPRS score is the same as before
# treatment NPRS score for Group A




# 3 - Is post treatment NPRS score significantly less 
#     as compared to 'before treatment' NPRS score for 
#     Group B?
pain_nprs_B <- subset(pain_nprs, Group == "B")
head(pain_nprs_B)

wilcox.test(pain_nprs_B$NPRS_before, pain_nprs_B$NPRS_after, paired = TRUE, alternative = "greater")
# alternative is "greater" because if pain is less 
# after treatment then difference will be greater 
# than zero

#         Wilcoxon signed rank test with continuity correction
# 
# data:  pain_nprs_B$NPRS_before and pain_nprs_B$NPRS_after
# V = 120, p-value = 0.0003079
# alternative hypothesis: true location shift is greater than 0

# as the p-value < 0.05 we reject the null hypothesis 
# that post treatment NPRS score is the same as before
# treatment NPRS score for Group B




# 4 - Is the change in NPRS for Group A significantly 
#     different than Group B?
pain_nprs$Delta <- pain_nprs$NPRS_before - pain_nprs$NPRS_after
head(pain_nprs)

wilcox.test(Delta ~ Group, data = pain_nprs)

#         Wilcoxon rank sum test with continuity correction
# 
# data:  Delta by Group
# W = 105, p-value = 0.378
# alternative hypothesis: true location shift is not equal to 0

# as the p-value > 0.05 we fail to reject the null 
# hypothesis that the difference in NPRS score is 
# the same across Groups




# 5 - Present change in NPRS for each group using 
#     box-whisker plot.
ggplot(pain_nprs, aes(x = Group, y = Delta)) + 
  geom_boxplot(fill = "darkorange", outlier.color = "midnightblue", outlier.size = 2.5) +
  labs(x = "Group", y = "Change in NPRS", title = "Box Plot")
