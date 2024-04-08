
library(car)
library(pls)


data <- read.csv("./data/0604_unsupervised_multivariate_methods/00_live_class/pcrdata.csv", header = TRUE)
head(data)


model <- lm(SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE, data = data)
summary(model)
# Call:
# lm(formula = SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE, data = data)

# Residuals:
#     Min      1Q  Median      3Q     Max 
# -2.0693 -1.0521 -0.1369  0.8975  2.8016 

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

# Residual standard error: 1.201 on 137 degrees of freedom
# Multiple R-squared:  0.9089,    Adjusted R-squared:  0.9055 
# F-statistic: 273.2 on 5 and 137 DF,  p-value: < 2.2e-16


vif(model)
#        AD       PRO    SALEXP     ADPRE    PROPRE 
# 36.159771 31.846727  1.076284 24.781948 42.346468 


data_pca <- subset(data, select = c(-SRNO, -SALES))
pc <- princomp(~., data = data_pca, cor = TRUE)
summary(pc)
# Importance of components:
#                           Comp.1    Comp.2    Comp.3    Comp.4      Comp.5
# Standard deviation     1.3015565 1.1318477 1.0705353 0.9334328 0.086769725
# Proportion of Variance 0.3388099 0.2562159 0.2292091 0.1742593 0.001505797
# Cumulative Proportion  0.3388099 0.5950257 0.8242349 0.9984942 1.000000000


model_pc <- pcr(SALES ~ AD + PRO + SALEXP + ADPRE + PROPRE, ncomp = 3, data = data, scale = TRUE)
data$pred_pcr <- predict(model_pc, data, ncomp = 3)
head(data)


test <- read.csv("./data/0604_unsupervised_multivariate_methods/00_live_class/pcrdata_test.csv", header = TRUE)

test$lmpredict <- predict(model, test)
test$lmres <- (test$SALES - test$lmpredict)
RMSE_lm <- sqrt(mean(test$lmres ** 2))

test$pcrpredict <- predict(model_pc, test, ncomp = 3)
test$pcrres <- (test$SALES - test$pcrpredict)
RMSE_pcr <- sqrt(mean(test$pcrres ** 2))

head(test)
RMSE_lm
RMSE_pcr
