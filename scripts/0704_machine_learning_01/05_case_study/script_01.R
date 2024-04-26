
library(dplyr)
library(ggplot2)
library(caret)
library(ROCR)
library(e1071)
library(car)



data <- read.csv("./data/0704_machine_learning_01/05_case_study/Hospital Readmissions.csv", header = TRUE)
head(data)
#   id     age time_in_hospital n_lab_procedures n_procedures n_medications n_outpatient n_inpatient n_emergency   diagnosis glucose_test A1Ctest change
# 1  1 [70-80)                8               72            1            18            2           0           0 Circulatory           no      no     no
# 2  2 [70-80)                3               34            2            13            0           0           0       Other           no      no     no
# 3  3 [50-60)                5               45            0            18            0           0           0 Circulatory           no      no    yes
# 4  4 [70-80)                2               36            0            12            1           0           0 Circulatory           no      no    yes
# 5  5 [60-70)                1               42            0             7            0           0           0       Other           no      no     no
# 6  6 [40-50)                2               51            0            10            0           0           0       Other           no      no     no
#   diabetes_med readmitted
# 1          yes          0
# 2          yes          0
# 3          yes          1
# 4          yes          1
# 5          yes          0
# 6           no          1



data$readmitted <- as.factor(ifelse(data$readmitted == "no", 0, 1)) 


data <- data %>% mutate_at(vars(c("age", "diagnosis", "glucose_test", "A1Ctest", "change", "diabetes_med")), ~as.factor(.))


index <- createDataPartition(data$readmitted, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]



threshold <- 0.45



model <- glm(readmitted ~ age + time_in_hospital + n_lab_procedures + n_procedures +n_medications + n_outpatient + n_inpatient + n_emergency + diagnosis + glucose_test + A1Ctest + change + diabetes_med, data = train, family = binomial)
summary(model)
# Call:
# glm(formula = readmitted ~ age + time_in_hospital + n_lab_procedures + 
#     n_procedures + n_medications + n_outpatient + n_inpatient + 
#     n_emergency + diagnosis + glucose_test + A1Ctest + change + 
#     diabetes_med, family = binomial, data = train)
# 
# Coefficients:
#                            Estimate Std. Error z value Pr(>|z|)    
# (Intercept)              -0.6926958  0.1302972  -5.316 1.06e-07 ***
# age[50-60)               -0.0178369  0.0631498  -0.282 0.777595    
# age[60-70)                0.1013013  0.0604493   1.676 0.093776 .  
# age[70-80)                0.2126161  0.0595748   3.569 0.000358 ***
# age[80-90)                0.2063537  0.0633339   3.258 0.001121 ** 
# age[90-100)              -0.0913107  0.1054700  -0.866 0.386627    
# time_in_hospital          0.0107928  0.0061865   1.745 0.081060 .  
# n_lab_procedures          0.0014193  0.0009005   1.576 0.115025    
# n_procedures             -0.0398293  0.0104788  -3.801 0.000144 ***
# n_medications             0.0025673  0.0024644   1.042 0.297534    
# n_outpatient              0.1185318  0.0156786   7.560 4.03e-14 ***
# n_inpatient               0.3785044  0.0172813  21.903  < 2e-16 ***
# n_emergency               0.2239309  0.0305938   7.319 2.49e-13 ***
# diagnosisDiabetes         0.0936614  0.0678165   1.381 0.167248    
# diagnosisDigestive       -0.0861760  0.0586905  -1.468 0.142019    
# diagnosisInjury          -0.1940297  0.0673127  -2.883 0.003945 ** 
# diagnosisMissing          0.2856505  1.4147999   0.202 0.839994    
# diagnosisMusculoskeletal -0.2993270  0.0781051  -3.832 0.000127 ***
# diagnosisOther           -0.2055883  0.0432806  -4.750 2.03e-06 ***
# diagnosisRespiratory     -0.0710725  0.0511142  -1.390 0.164388    
# glucose_testno           -0.0283246  0.0980562  -0.289 0.772687    
# glucose_testnormal       -0.0076523  0.1347913  -0.057 0.954727    
# A1Ctestno                -0.0067960  0.0520082  -0.131 0.896034    
# A1Ctestnormal            -0.2036319  0.0846858  -2.405 0.016192 *  
# changeyes                 0.0332421  0.0372702   0.892 0.372436    
# diabetes_medyes           0.2404255  0.0433856   5.542 3.00e-08 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 24199  on 17500  degrees of freedom
# Residual deviance: 23025  on 17475  degrees of freedom
# AIC: 23077
# 
# Number of Fisher Scoring iterations: 4



vif(model)
#                      GVIF Df GVIF^(1/(2*Df))
# age              1.096003  5        1.009209
# time_in_hospital 1.408401  1        1.186761
# n_lab_procedures 1.295103  1        1.138026
# n_procedures     1.316149  1        1.147236
# n_medications    1.638959  1        1.280218
# n_outpatient     1.031245  1        1.015502
# n_inpatient      1.063650  1        1.031334
# n_emergency      1.053159  1        1.026235
# diagnosis        1.250800  7        1.016113
# glucose_test     1.065559  2        1.016002
# A1Ctest          1.120106  2        1.028762
# change           1.408818  1        1.186936
# diabetes_med     1.354423  1        1.163797



model <- glm(readmitted ~ age + time_in_hospital + n_procedures + n_outpatient + n_inpatient + n_emergency + diagnosis + diabetes_med, data = train, family = binomial)
summary(model)
# Call:
# glm(formula = readmitted ~ age + time_in_hospital + n_procedures + 
#     n_outpatient + n_inpatient + n_emergency + diagnosis + diabetes_med, 
#     family = binomial, data = train)
# 
# Coefficients:
#                           Estimate Std. Error z value Pr(>|z|)    
# (Intercept)              -0.671879   0.069153  -9.716  < 2e-16 ***
# age[50-60)               -0.017044   0.063066  -0.270 0.786960    
# age[60-70)                0.104485   0.060298   1.733 0.083127 .  
# age[70-80)                0.212812   0.059360   3.585 0.000337 ***
# age[80-90)                0.204119   0.063049   3.237 0.001206 ** 
# age[90-100)              -0.091561   0.105142  -0.871 0.383848    
# time_in_hospital          0.016326   0.005421   3.012 0.002599 ** 
# n_procedures             -0.036112   0.009890  -3.651 0.000261 ***
# n_outpatient              0.120629   0.015596   7.735 1.04e-14 ***
# n_inpatient               0.381458   0.017207  22.169  < 2e-16 ***
# n_emergency               0.225779   0.030611   7.376 1.64e-13 ***
# diagnosisDiabetes         0.093648   0.067501   1.387 0.165332    
# diagnosisDigestive       -0.086790   0.058472  -1.484 0.137733    
# diagnosisInjury          -0.195723   0.067096  -2.917 0.003533 ** 
# diagnosisMissing          0.266708   1.414710   0.189 0.850465    
# diagnosisMusculoskeletal -0.301168   0.076853  -3.919 8.90e-05 ***
# diagnosisOther           -0.210874   0.043015  -4.902 9.47e-07 ***
# diagnosisRespiratory     -0.065227   0.050992  -1.279 0.200837    
# diabetes_medyes           0.269769   0.037538   7.186 6.65e-13 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 24199  on 17500  degrees of freedom
# Residual deviance: 23037  on 17482  degrees of freedom
# AIC: 23075
# 
# Number of Fisher Scoring iterations: 4



vif(model)
#                      GVIF Df GVIF^(1/(2*Df))
# age              1.072170  5        1.006993
# time_in_hospital 1.081961  1        1.040174
# n_procedures     1.173166  1        1.083128
# n_outpatient     1.021797  1        1.010840
# n_inpatient      1.053154  1        1.026233
# n_emergency      1.049960  1        1.024675
# diagnosis        1.154377  7        1.010307
# diabetes_med     1.014821  1        1.007383



train$predprob <- round(fitted(model), 2)
predtrain <- prediction(train$predprob, train$readmitted)
perftrain <- performance(predtrain, "tpr", "fpr")

plot(perftrain)
abline(0, 1)



auc <- performance(predtrain, "auc")
auc@y.values
# 0.6456167



train$predY <- as.factor(ifelse(train$predprob > threshold, 1, 0))
confusionMatrix(train$predY, as.factor(train$readmitted), positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 6207 3760
#          1 3066 4468
# 
#                Accuracy : 0.61            
#                  95% CI : (0.6027, 0.6172)
#     No Information Rate : 0.5299          
#     P-Value [Acc > NIR] : < 2.2e-16       
# 
#                   Kappa : 0.2134          
# 
#  Mcnemar's Test P-Value : < 2.2e-16       
#                                           
#             Sensitivity : 0.5430          
#             Specificity : 0.6694          
#          Pos Pred Value : 0.5930          
#          Neg Pred Value : 0.6228          
#              Prevalence : 0.4701          
#          Detection Rate : 0.2553          
#    Detection Prevalence : 0.4305          
#       Balanced Accuracy : 0.6062          
#                                           
#        'Positive' Class : 1   



test$predprob <- predict(model, test, type = "response")
pred <- prediction(test$predprob, test$readmitted)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0,1)



auc <- performance(pred, "auc")
auc@y.values
# 0.6477391



test$predY <- as.factor(ifelse(test$predprob > threshold, 1, 0))
confusionMatrix(test$predY, as.factor(test$readmitted), positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 2601 1504
#          1 1372 2022
# 
#                Accuracy : 0.6165          
#                  95% CI : (0.6054, 0.6275)
#     No Information Rate : 0.5298          
#     P-Value [Acc > NIR] : < 2e-16         
# 
#                   Kappa : 0.2286          
# 
#  Mcnemar's Test P-Value : 0.01458         
#                                           
#             Sensitivity : 0.5735          
#             Specificity : 0.6547          
#          Pos Pred Value : 0.5958          
#          Neg Pred Value : 0.6336          
#              Prevalence : 0.4702          
#          Detection Rate : 0.2696          
#    Detection Prevalence : 0.4526          
#       Balanced Accuracy : 0.6141          
#                                           
#        'Positive' Class : 1        



model_nb <- naiveBayes(readmitted ~ age + time_in_hospital + n_lab_procedures + n_procedures + n_medications + n_outpatient + n_inpatient + n_emergency + diagnosis + glucose_test + A1Ctest + change + diabetes_med, data = train)
summary(model_nb)
#           Length Class  Mode     
# apriori    2     table  numeric  
# tables    13     -none- list     
# levels     2     -none- character
# isnumeric 13     -none- logical  
# call       4     -none- call   



prednb <- predict(model_nb, train, type = "raw")
pred <- prediction(prednb[, 2], train$readmitted)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)



auc <- performance(pred, "auc")
auc@y.values
# 0.6418633



train$predY <- as.factor(ifelse(prednb[, 2] > threshold, 1, 0))
confusionMatrix(train$predY, train$readmitted, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 7999 5875
#          1 1274 2353
# 
#                Accuracy : 0.5915          
#                  95% CI : (0.5842, 0.5988)
#     No Information Rate : 0.5299          
#     P-Value [Acc > NIR] : < 2.2e-16       
# 
#                   Kappa : 0.1534          
# 
#  Mcnemar's Test P-Value : < 2.2e-16       
#                                           
#             Sensitivity : 0.2860          
#             Specificity : 0.8626          
#          Pos Pred Value : 0.6487          
#          Neg Pred Value : 0.5765          
#              Prevalence : 0.4701          
#          Detection Rate : 0.1344          
#    Detection Prevalence : 0.2072          
#       Balanced Accuracy : 0.5743          
#                                           
#        'Positive' Class : 1   



prednb <- predict(model_nb, test, type = "raw")
pred <- prediction(prednb[, 2], test$readmitted)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)



auc <- performance(pred, "auc")
auc@y.values
# 0.6435321



test$predY <- as.factor(ifelse(prednb[, 2] > threshold, 1, 0))
confusionMatrix(test$predY, test$readmitted, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 3461 2487
#          1  512 1039
# 
#                Accuracy : 0.6001          
#                  95% CI : (0.5889, 0.6112)
#     No Information Rate : 0.5298          
#     P-Value [Acc > NIR] : < 2.2e-16       
# 
#                   Kappa : 0.1712          
# 
#  Mcnemar's Test P-Value : < 2.2e-16       
#                                           
#             Sensitivity : 0.2947          
#             Specificity : 0.8711          
#          Pos Pred Value : 0.6699          
#          Neg Pred Value : 0.5819          
#              Prevalence : 0.4702          
#          Detection Rate : 0.1386          
#    Detection Prevalence : 0.2068          
#       Balanced Accuracy : 0.5829          
#                                           
#        'Positive' Class : 1               
