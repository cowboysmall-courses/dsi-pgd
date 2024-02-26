
library(pec)
library(survival)


bankloan <- read.csv("./data/0404_advanced_predictive_modelling/poisson_and_cox_regression/BANK\ LOAN\ (COX).csv", header = TRUE)
head(bankloan)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT STATUS TIME
# 1  1   3     17      12     9.3    11.36    5.01      1   12
# 2  2   1     10       6    17.3     1.36    4.00      0   36
# 3  3   2     15      14     5.5     0.86    2.17      0   36
# 4  4   3     15      14     2.9     2.66    0.82      0   36
# 5  5   1      2       0    17.3     1.79    3.06      1   14
# 6  6   3      5       5    10.2     0.39    2.16      0   36


bankloan$AGE <- as.factor(bankloan$AGE)


surv <- Surv(bankloan$TIME, bankloan$STATUS)


timemodel <- coxph(surv ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = bankloan, x = TRUE)
summary(timemodel)
# Call:
# coxph(formula = surv ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + 
#     OTHDEBT, data = bankloan, x = TRUE)

#   n= 700, number of events= 183 

#              coef exp(coef) se(coef)       z Pr(>|z|)    
# AGE2      0.30668   1.35891  0.18701   1.640   0.1010    
# AGE3      0.54006   1.71611  0.25293   2.135   0.0327 *  
# EMPLOY   -0.24177   0.78524  0.02238 -10.803  < 2e-16 ***
# ADDRESS  -0.09825   0.90643  0.01634  -6.011 1.84e-09 ***
# DEBTINC   0.05859   1.06034  0.01308   4.478 7.53e-06 ***
# CREDDEBT  0.58482   1.79468  0.05020  11.649  < 2e-16 ***
# OTHDEBT   0.06465   1.06679  0.03166   2.042   0.0411 *  
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

#          exp(coef) exp(-coef) lower .95 upper .95
# AGE2        1.3589     0.7359    0.9419    1.9605
# AGE3        1.7161     0.5827    1.0453    2.8173
# EMPLOY      0.7852     1.2735    0.7515    0.8204
# ADDRESS     0.9064     1.1032    0.8779    0.9359
# DEBTINC     1.0603     0.9431    1.0335    1.0879
# CREDDEBT    1.7947     0.5572    1.6265    1.9802
# OTHDEBT     1.0668     0.9374    1.0026    1.1351

# Concordance= 0.833  (se = 0.014 )
# Likelihood ratio test= 336.9  on 7 df,   p=<2e-16
# Wald test            = 282.4  on 7 df,   p=<2e-16
# Score (logrank) test = 322  on 7 df,   p=<2e-16


bankloantest <- read.csv("./data/0404_advanced_predictive_modelling/poisson_and_cox_regression/BANK\ LOAN\ (COX)\ TEST.csv", header = TRUE)
head(bankloantest)
#    SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT
# 1 701   3     17      12     9.4    11.38    5.01
# 2 702   2     10       6    17.3     1.36    4.00
# 3 703   3     15      13     5.5     0.86    2.17
# 4 704   2     15      14     2.9     2.66    0.82
# 5 705   1      2       0    17.6     1.79    3.06
# 6 706   1      5       5    10.2     0.35    2.16


bankloantest$AGE <- as.factor(bankloantest$AGE)


bankloantest$prob24 <- predictSurvProb(timemodel, bankloantest, times = 24)
head(bankloantest)
#    SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT    prob24
# 1 701   3     17      12     9.4    11.38    5.01 0.1262493
# 2 702   2     10       6    17.3     1.36    4.00 0.9341567
# 3 703   3     15      13     5.5     0.86    2.17 0.9957209
# 4 704   2     15      14     2.9     2.66    0.82 0.9930838
# 5 705   1      2       0    17.6     1.79    3.06 0.4630305
# 6 706   1      5       5    10.2     0.35    2.16 0.9416758
