
library(car)
library(GGally)




data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/03_cross_validation/Motor_Claims.csv", header = TRUE)
head(data)
#   vehage   CC Length Weight claimamt
# 1      4 1495   4250   1023  72000.0
# 2      2 1061   3495    875  72000.0
# 3      2 1405   3675    980  50400.0
# 4      7 1298   4090    930  39960.0
# 5      2 1495   4250   1023 106800.0
# 6      1 1086   3565    854  69592.8




ggpairs(
  data[, c("vehage", "CC", "Length", "Weight", "claimamt")],
  title = "Scatter Plot Matrix",
  columnLabels = c("vehage", "CC", "Length", "Weight", "claimamt")
)




model <- lm(claimamt ~ Length + CC + vehage + Weight, data = data)
summary(model)
# Call:
# lm(formula = claimamt ~ Length + CC + vehage + Weight, data = data)
# 
# Residuals:
#    Min     1Q Median     3Q    Max 
# -45577  -8007     39   7852  40561 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -54765.128   5569.375  -9.833  < 2e-16 ***
# Length          35.461      1.990  17.824  < 2e-16 ***
# CC              15.413      2.114   7.292 6.23e-13 ***
# vehage       -6637.213    154.098 -43.071  < 2e-16 ***
# Weight         -16.255      3.678  -4.420 1.10e-05 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 11360 on 995 degrees of freedom
# Multiple R-squared:  0.7379,	Adjusted R-squared:  0.7368 
# F-statistic: 700.3 on 4 and 995 DF,  p-value: < 2.2e-16




vif(model)
#   Length       CC   vehage   Weight
# 3.396171 5.881428 1.038357 6.552811




model <- lm(claimamt ~ Length + CC + vehage, data = data)
summary(model)
# Call:
# lm(formula = claimamt ~ Length + CC + vehage, data = data)
# 
# Residuals:
#    Min     1Q Median     3Q    Max 
# -47069  -7673    -14   7783  40447 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -49195.196   5475.151  -8.985  < 2e-16 ***
# Length          32.065      1.852  17.312  < 2e-16 ***
# CC               8.689      1.481   5.867 6.02e-09 ***
# vehage       -6638.076    155.525 -42.682  < 2e-16 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 11470 on 996 degrees of freedom
# Multiple R-squared:  0.7327,	Adjusted R-squared:  0.7319 
# F-statistic: 910.3 on 3 and 996 DF,  p-value: < 2.2e-16




vif(model)
#   Length       CC   vehage 
# 2.889718 2.833931 1.038355




data$resi <- residuals(model)
sqrt(mean(data$resi ** 2))
# [1] 11444.51
