
library(pscl)


data <- read.csv("./data/0404_advanced_predictive_modelling/03_poisson_and_cox_regression/Complaints.csv",header=TRUE)
head(data)
#   custid region     tier   age ncomp
# 1      1      N platinum less2     0
# 2      2      W     gold more2     3
# 3      3      W   silver less2     9
# 4      4      S   silver less2     6
# 5      5      E   silver less2     7
# 6      6      N   silver less2     5


model  <- glm(ncomp ~ region + tier + age, data = data, family = "poisson")
smodel <- summary(model)
smodel
# Call:
# glm(formula = ncomp ~ region + tier + age, family = "poisson", 
#     data = data)

# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)    
# (Intercept)    1.2919     0.1389   9.302  < 2e-16 ***
# regionN       -0.1096     0.1420  -0.772 0.439968    
# regionS       -0.2286     0.1489  -1.535 0.124786    
# regionW       -0.4498     0.1613  -2.789 0.005290 ** 
# tierplatinum  -0.6883     0.1754  -3.925 8.69e-05 ***
# tiersilver     0.4410     0.1137   3.878 0.000105 ***
# agemore2       0.1767     0.1077   1.641 0.100785    
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# (Dispersion parameter for poisson family taken to be 1)

#     Null deviance: 186.08  on 112  degrees of freedom
# Residual deviance: 116.01  on 106  degrees of freedom
# AIC: 456.86

# Number of Fisher Scoring iterations: 5


1 - pchisq(smodel$deviance, smodel$df.residual)
# 0.2380154


data$ncomppred <- round(predict(model, data, type = "response"))
head(data)
#   custid region     tier   age ncomp ncomppred
# 1      1      N platinum less2     0         2
# 2      2      W     gold more2     3         3
# 3      3      W   silver less2     9         4
# 4      4      S   silver less2     6         5
# 5      5      E   silver less2     7         6
# 6      6      N   silver less2     5         5


zip_model <- zeroinfl(ncomp ~ region + tier + age, data = data)
summary(zip_model)
