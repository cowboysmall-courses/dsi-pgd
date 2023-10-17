
# BACKGROUND:
#   A new marketing campaign was tested in 12 randomly 
#   selected stores of a large retail group. Usual campaign 
#   was run in another 12 randomly selected stores during 
#   the same month. The outcome variable is "Sales Growth". 



library(nortest)


# 0 - read the data and test for normality
campaign_data <- read.csv("./assignment_02.csv", header = TRUE)
head(campaign_data)

shapiro.test(campaign_data$Growth)

#         Shapiro-Wilk normality test
# 
# data:  campaign_data$Growth
# W = 0.92686, p-value = 0.08294

lillie.test(campaign_data$Growth)

#         Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  campaign_data$Growth
# D = 0.13332, p-value = 0.329

# in both tests the p-value > 0.05, and hence 
# the data looks to have been drawn from a
# normal distribution



# 1 - test the effect of campaign on growth
campaign_aov_1 <- aov(Growth ~ Campaign, data = campaign_data)
summary(campaign_aov_1)

#               Df Sum Sq Mean Sq F value Pr(>F)  
#   Campaign     1  17.68  17.682   7.769 0.0107 *
#   Residuals   22  50.07   2.276                 
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# as p-value < 0.05 we reject the null 
# hypothesis - there does seem to be a 
# significant difference between growth 
# across the different campaigns 



# 2 - test the effect of zone on growth
campaign_aov_2 <- aov(Growth ~ Zone, data = campaign_data)
summary(campaign_aov_2)

#             Df Sum Sq Mean Sq F value Pr(>F)
# Zone         2   7.74   3.868   1.353   0.28
# Residuals   21  60.02   2.858        

# as p-value > 0.05 we fail to reject 
# the null hypothesis - there does not 
# seem to be significant difference 
# between growth across the different 
# zones 

# zone alone does not appear to be significant, 
# but lets see if it is significant when combined 
# with campaign 



# 3 - test the effect of the interaction of campaign and zone on growth
campaign_aov_3 <- aov(Growth ~ Campaign*Zone, data = campaign_data)
summary(campaign_aov_3)

#               Df Sum Sq Mean Sq F value  Pr(>F)   
# Campaign       1  17.68  17.682   8.408 0.00955 **
# Zone           2   7.74   3.868   1.839 0.18759   
# Campaign:Zone  2   4.48   2.240   1.065 0.36537   
# Residuals     18  37.85   2.103                   
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# neither zone, nor the interaction effect 
# of zone with campaign appear to be 
# significant
