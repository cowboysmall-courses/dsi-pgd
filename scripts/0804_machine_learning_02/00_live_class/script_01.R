
library(partykit)


data <- read.csv("./data/0804_machine_learning_02/00_live_class/BANK LOAN.csv", header = TRUE)
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER
# 1  1   3     17      12     9.3    11.36    5.01         1
# 2  2   1     10       6    17.3     1.36    4.00         0
# 3  3   2     15      14     5.5     0.86    2.17         0
# 4  4   3     15      14     2.9     2.66    0.82         0
# 5  5   1      2       0    17.3     1.79    3.06         1
# 6  6   3      5       5    10.2     0.39    2.16         0


str(data)
# 'data.frame':   700 obs. of  8 variables:
#  $ SN       : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ AGE      : int  3 1 2 3 1 3 2 3 1 2 ...
#  $ EMPLOY   : int  17 10 15 15 2 5 20 12 3 0 ...
#  $ ADDRESS  : int  12 6 14 14 0 5 9 11 4 13 ...
#  $ DEBTINC  : num  9.3 17.3 5.5 2.9 17.3 10.2 30.6 3.6 24.4 19.7 ...
#  $ CREDDEBT : num  11.36 1.36 0.86 2.66 1.79 ...
#  $ OTHDEBT  : num  5.01 4 2.17 0.82 3.06 ...
#  $ DEFAULTER: int  1 0 0 0 1 0 0 0 1 0 ...


data$AGE <- as.factor(data$AGE)
data$DEFAULTER <- as.factor(data$DEFAULTER)


tree <- partykit::ctree(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = data)


plot(tree, type = "simple", gp = gpar(cex = 0.7))


model    <- glm(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, family = binomial, data = data)
summary(model)
# 
# Call:
# glm(formula = DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + 
#     CREDDEBT + OTHDEBT, family = binomial, data = data)
# 
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -1.10181    0.33280  -3.311 0.000930 ***
# AGE          0.30508    0.17796   1.714 0.086468 .  
# EMPLOY      -0.26285    0.03163  -8.311  < 2e-16 ***
# ADDRESS     -0.10004    0.02231  -4.483 7.35e-06 ***
# DEBTINC      0.08462    0.02206   3.836 0.000125 ***
# CREDDEBT     0.56559    0.08839   6.399 1.56e-10 ***
# OTHDEBT      0.02409    0.05697   0.423 0.672432    
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 804.36  on 699  degrees of freedom
# Residual deviance: 553.48  on 693  degrees of freedom
# AIC: 567.48
# 
# Number of Fisher Scoring iterations: 6
