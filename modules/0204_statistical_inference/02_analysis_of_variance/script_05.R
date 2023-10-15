
test_data <- read.csv("../../../data/si/analysis_of_variance/Post\ Hoc\ Tests-Anova.csv", header = TRUE)

head(test_data)
summary(test_data)


# post-hoc testing - ANOVA
anova <- aov(aptscore~group, data = test_data)
summary(anova)
# as p < 0.05 we reject the null hypothesis that 
# there is no significant difference between the 
# mean aptitude scores of each group of employees


# pairwise t-tests
pairwise.t.test(test_data$aptscore, test_data$group, p.adj = "none")
# significant difference between GrI and GrIII, 
# and between GrII and GrIII


# pairwise t-tests - with Bonferroni adjustment
pairwise.t.test(test_data$aptscore, test_data$group, p.adj = "bonf")
# signiificant difference between GrII and GrIII


TukeyHSD(anova, "group")
