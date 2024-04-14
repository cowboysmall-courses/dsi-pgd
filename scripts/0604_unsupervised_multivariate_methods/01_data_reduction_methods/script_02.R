
library(car)
library(pls)


data <- read.csv("./data/0604_unsupervised_multivariate_methods/00_live_class/pcrdata.csv", header = TRUE)
head(data)
#   SRNO SALES   AD PRO SALEXP ADPRE PROPRE
# 1    1 20.11 1.98 0.9   0.31  2.02    0.0
# 2    2 15.10 1.94 0.0   0.30  1.99    1.0
# 3    3 18.68 2.20 0.8   0.35  1.93    0.0
# 4    4 16.05 2.00 0.0   0.35  2.20    0.8
# 5    5 21.30 1.69 1.3   0.30  2.00    0.0
# 6    6 17.85 1.74 0.3   0.32  1.69    1.3


lmmodel <- lm(SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE, data = data)
summary(lmmodel)
# Call:
# lm(formula = SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE, data = data)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -2.0693 -1.0521 -0.1369  0.8975  2.8016 
# 
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -10.8147     6.5314  -1.656  0.10005    
# AD            4.6762     1.4100   3.316  0.00117 ** 
# PRO           7.7886     1.2628   6.168  7.3e-09 ***
# SALEXP       22.4089     0.7704  29.089  < 2e-16 ***
# ADPRE         3.1856     1.2442   2.560  0.01154 *  
# PROPRE        3.4970     1.3697   2.553  0.01177 *  
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 1.201 on 137 degrees of freedom
# Multiple R-squared:  0.9089,    Adjusted R-squared:  0.9055 
# F-statistic: 273.2 on 5 and 137 DF,  p-value: < 2.2e-16


vif(lmmodel)
#        AD       PRO    SALEXP     ADPRE    PROPRE 
# 36.159771 31.846727  1.076284 24.781948 42.346468


data_pca <- subset(data, select = c(-SRNO, -SALES))


pc <- princomp(formula = ~., data = data_pca, cor = TRUE)
summary(pc)
# Importance of components:
#                           Comp.1    Comp.2    Comp.3    Comp.4      Comp.5
# Standard deviation     1.3015565 1.1318477 1.0705353 0.9334328 0.086769725
# Proportion of Variance 0.3388099 0.2562159 0.2292091 0.1742593 0.001505797
# Cumulative Proportion  0.3388099 0.5950257 0.8242349 0.9984942 1.000000000


pcmodel <- pcr(SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE, ncomp = 3, data = data, scale = TRUE)


data$pred_pcr <- predict(pcmodel, data, ncomp = 3)
head(data)
#   SRNO SALES   AD PRO SALEXP ADPRE PROPRE pred_pcr
# 1    1 20.11 1.98 0.9   0.31  2.02    0.0 21.29053
# 2    2 15.10 1.94 0.0   0.30  1.99    1.0 18.16976
# 3    3 18.68 2.20 0.8   0.35  1.93    0.0 21.27149
# 4    4 16.05 2.00 0.0   0.35  2.20    0.8 17.62114
# 5    5 21.30 1.69 1.3   0.30  2.00    0.0 22.97930
# 6    6 17.85 1.74 0.3   0.32  1.69    1.3 20.57217


data_test <- read.csv("./data/0604_unsupervised_multivariate_methods/00_live_class/pcrdata_test.csv", header = TRUE)
head(data_test)
#   SRNO SALES   AD  PRO SALEXP ADPRE PROPRE
# 1    1 28.93 2.75 1.00   0.72  1.97   0.02
# 2    2 25.96 1.73 1.06   0.89  2.77   0.02
# 3    3 31.25 2.19 1.26   0.79  1.22   0.42
# 4    4 25.05 1.82 1.45   0.83  2.23   0.15
# 5    5 27.32 2.38 1.01   0.74  1.01   0.07
# 6    6 23.23 2.97 0.46   0.96  2.36   0.12


data_test$lmpredict <- predict(lmmodel, data_test)
data_test$lmres     <- (data_test$SALES - data_test$lmpredict)
RMSE_lm <- sqrt(mean(data_test$lmres ** 2))


data_test$pcrpredict <- predict(pcmodel, data_test, ncomp = 3)
data_test$pcrres     <- (data_test$SALES - data_test$pcrpredict)
RMSE_pcr <- sqrt(mean(data_test$pcrres ** 2))


head(data_test)
#   SRNO SALES   AD  PRO SALEXP ADPRE PROPRE lmpredict       lmres pcrpredict
# 1    1 28.93 2.75 1.00   0.72  1.97   0.02  32.31368  -3.3836776   23.23291
# 2    2 25.96 1.73 1.06   0.89  2.77   0.02  34.36925  -8.4092464   22.26693
# 3    3 31.25 2.19 1.26   0.79  1.22   0.42  32.29821  -1.0482117   27.61578
# 4    4 25.05 1.82 1.45   0.83  2.23   0.15  35.21751 -10.1675083   25.21307
# 5    5 27.32 2.38 1.01   0.74  1.01   0.07  28.22616  -0.9061594   27.05439
# 6    6 23.23 2.97 0.46   0.96  2.36   0.12  36.10681 -12.8768143   20.92296
#       pcrres
# 1  5.6970943
# 2  3.6930660
# 3  3.6342207
# 4 -0.1630736
# 5  0.2656139
# 6  2.3070370


RMSE_lm
# 9.111682

RMSE_pcr
# 2.851245
