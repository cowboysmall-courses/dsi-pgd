
library(ggplot2)
library(dplyr)
library(ROCR)
library(car)
library(caret)


data <- read.csv("../../../data/0404_advanced_predictive_modelling/case_study/ICU\ Mortality.csv", header = TRUE)
head(data)
#   SR.NO ID STA AGE SEX RACE SER CAN CRN INF CPR SYS HRA PRE TYP FRA PO2 PH PCO BIC CRE LOC
# 1     1  8   0  27   1    1   0   0   0   1   0 142  88   0   1   0   0  0   0   0   0   0
# 2     2 12   0  59   0    1   0   0   0   0   0 112  80   1   1   0   0  0   0   0   0   0
# 3     3 14   0  77   0    1   1   0   0   0   0 100  70   0   0   0   0  0   0   0   0   0
# 4     4 28   0  54   0    1   0   0   0   1   0 142 103   0   1   1   0  0   0   0   0   0
# 5     5 32   0  87   1    1   1   0   0   1   0 110 154   1   1   0   0  0   0   0   0   0
# 6     6 38   0  69   0    1   0   0   0   1   0 110 132   0   1   0   1  0   0   1   0   0



data$STA           <- as.factor(data$STA)
STA                <- data.frame(table(data$STA))
names(STA)         <- c("Vital Status", "N")
STA$Percentage     <- round((STA$N / sum(STA$N)) * 100, 2)
STA$`Vital Status` <- ifelse(STA$`Vital Status` == 1, "Died", "Lived")
STA
#   Vital Status   N Percentage
# 1        Lived 160         80
# 2         Died  40         20


ggplot(data, aes(x = STA, y = AGE, fill = STA)) +
  ggtitle("Boxplot of Age by Vital Status") +
  geom_boxplot() +
  theme_classic()

ggplot(data, aes(x = STA, y = SYS, fill = STA)) +
  ggtitle("Boxplot of Systolic Blood Pressure by Vital Status") +
  geom_boxplot() +
  theme_classic()

ggplot(data, aes(x = STA, y = HRA, fill = STA)) +
  ggtitle("Boxplot of Heart Rate by Vital Status") +
  geom_boxplot() +
  theme_classic()


gender              <- as.data.frame.matrix(table(data$SEX, data$STA))
names(gender)       <- c("Lived", "Died")
gender$N            <- gender$Lived + gender$Died
gender$Gender       <- ifelse(row.names(gender) == 0, "Male", "Female")
gender$`Death Rate` <- round((gender$Died / gender$N) * 100, 2)
gender              <- gender %>% select(Gender, N, `Death Rate`)
gender
#   Gender   N Death Rate
# 0   Male 124      19.35
# 1 Female  76      21.05



toa                  <- as.data.frame.matrix(table(data$TYP, data$STA))
names(toa)           <- c("Lived", "Died")
toa$N                <- toa$Lived + toa$Died
toa$`Admission Type` <- ifelse(row.names(toa) == 0, "Elective", "Emergency")
toa$`Death Rate`     <- round((toa$Died / toa$N) * 100, 2)
toa                  <- toa %>% select(`Admission Type`, N, `Death Rate`)
toa
#   Admission Type   N Death Rate
# 0       Elective  53       3.77
# 1      Emergency 147      25.85




loc                          <- as.data.frame.matrix(table(data$LOC, data$STA))
names(loc)                   <- c("Lived", "Died")
loc$N                        <- loc$Lived + loc$Died
loc$`Level of Consciousness` <- ifelse(row.names(loc) == 0, "No Coma or Stupor", ifelse(row.names(loc) == 1, "Deep Stupor", "Coma"))
loc$`Death Rate`             <- round((loc$Died / loc$N) * 100, 2)
loc                          <- loc %>% select(`Level of Consciousness`, N, `Death Rate`)
loc
#   Level of Consciousness   N Death Rate
# 0      No Coma or Stupor 185      14.59
# 1            Deep Stupor   5     100.00
# 2                   Coma  10      80.00




data$LOC <- ifelse(data$LOC > 0, 1, 0)



model <- glm(STA ~ . - SR.NO - ID - RACE, data = data, family = binomial)
summary(model)
# Call:
# glm(formula = STA ~ . - SR.NO - ID - RACE, family = binomial, 
#     data = data)
# 
# Coefficients:
#               Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -3.791e+00  1.858e+00  -2.040  0.04137 *  
# AGE          4.373e-02  1.599e-02   2.735  0.00624 ** 
# SEX         -3.125e-01  4.815e-01  -0.649  0.51629    
# SER         -4.591e-01  5.707e-01  -0.805  0.42108    
# CAN         -1.459e+01  1.495e+03  -0.010  0.99221    
# CRN          1.712e-02  7.702e-01   0.022  0.98227    
# INF         -8.294e-03  5.342e-01  -0.016  0.98761    
# CPR          1.017e+00  9.321e-01   1.092  0.27501    
# SYS         -1.407e-02  7.769e-03  -1.811  0.07019 .  
# HRA         -3.117e-03  9.210e-03  -0.338  0.73504    
# PRE          6.321e-01  6.068e-01   1.042  0.29754    
# TYP          1.932e+00  9.565e-01   2.020  0.04341 *  
# FRA          8.281e-01  9.879e-01   0.838  0.40192    
# PO2          2.138e-01  7.763e-01   0.275  0.78298    
# PH           2.064e+00  1.085e+00   1.901  0.05724 .  
# PCO         -2.421e+00  1.180e+00  -2.051  0.04028 *  
# BIC         -8.013e-01  8.563e-01  -0.936  0.34942    
# CRE          5.011e-01  9.330e-01   0.537  0.59120    
# LOC          4.306e+00  1.081e+00   3.984 6.78e-05 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 200.16  on 199  degrees of freedom
# Residual deviance: 130.40  on 181  degrees of freedom
# AIC: 168.4
# 
# Number of Fisher Scoring iterations: 17




vif(model)
# AGE      SEX      SER      CAN      CRN      INF      CPR      SYS      HRA      PRE      TYP      FRA      PO2       PH      PCO      BIC      CRE 
# 1.490876 1.123196 1.563270 1.000000 1.329164 1.442442 1.195532 1.399281 1.327056 1.180287 1.277596 1.294443 1.353238 2.047266 2.280889 1.582621 1.264426 
# LOC 
# 1.514423 



data$predprob <- fitted(model)
pred <- prediction(data$predprob, data$STA)
perf <- performance(pred, "tpr", "fpr")
plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.8560937



ss <- performance(pred, "sens", "spec")
best_threshold <- ss@alpha.values[[1]][which.max(ss@x.values[[1]] + ss@y.values[[1]])]
paste("Best Threshold is :", round(best_threshold, 2))
# "Best Threshold is : 0.28"



data$predY <- as.factor(ifelse(data$predprob > best_threshold, 1, 0))
confusionMatrix(data$predY, data$STA, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction   0   1
#          0 143  14
#          1  17  26
# 
#                Accuracy : 0.845           
#                  95% CI : (0.7873, 0.8922)
#     No Information Rate : 0.8             
#     P-Value [Acc > NIR] : 0.06324         
# 
#                   Kappa : 0.5289          
# 
#  Mcnemar's Test P-Value : 0.71944         
#                                           
#             Sensitivity : 0.6500          
#             Specificity : 0.8938          
#          Pos Pred Value : 0.6047          
#          Neg Pred Value : 0.9108          
#              Prevalence : 0.2000          
#          Detection Rate : 0.1300          
#    Detection Prevalence : 0.2150          
#       Balanced Accuracy : 0.7719          
#                                           
#        'Positive' Class : 1      
