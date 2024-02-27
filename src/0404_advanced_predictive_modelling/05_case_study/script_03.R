
library(ggplot2)
library(caret)
library(gmodels)
library(car)
library(ROCR)



data <- read.csv("./data/0404_advanced_predictive_modelling/05_case_study/Hospital\ Readmissions.csv", header = TRUE)
head(data)
# id     age time_in_hospital n_lab_procedures n_procedures n_medications n_outpatient n_inpatient n_emergency   diagnosis glucose_test A1Ctest change
# 1  1 [70-80)                8               72            1            18            2           0           0 Circulatory           no      no     no
# 2  2 [70-80)                3               34            2            13            0           0           0       Other           no      no     no
# 3  3 [50-60)                5               45            0            18            0           0           0 Circulatory           no      no    yes
# 4  4 [70-80)                2               36            0            12            1           0           0 Circulatory           no      no    yes
# 5  5 [60-70)                1               42            0             7            0           0           0       Other           no      no     no
# 6  6 [40-50)                2               51            0            10            0           0           0       Other           no      no     no
# diabetes_med readmitted
# 1          yes         no
# 2          yes         no
# 3          yes        yes
# 4          yes        yes
# 5          yes         no
# 6           no        yes



str(data)
# 'data.frame':	25000 obs. of  15 variables:
# $ id              : int  1 2 3 4 5 6 7 8 9 10 ...
# $ age             : chr  "[70-80)" "[70-80)" "[50-60)" "[70-80)" ...
# $ time_in_hospital: int  8 3 5 2 1 2 4 1 4 8 ...
# $ n_lab_procedures: int  72 34 45 36 42 51 44 19 67 37 ...
# $ n_procedures    : int  1 2 0 0 0 0 2 6 3 1 ...
# $ n_medications   : int  18 13 18 12 7 10 21 16 13 18 ...
# $ n_outpatient    : int  2 0 0 1 0 0 0 0 0 0 ...
# $ n_inpatient     : int  0 0 0 0 0 0 0 0 0 0 ...
# $ n_emergency     : int  0 0 0 0 0 0 0 1 0 0 ...
# $ diagnosis       : chr  "Circulatory" "Other" "Circulatory" "Circulatory" ...
# $ glucose_test    : chr  "no" "no" "no" "no" ...
# $ A1Ctest         : chr  "no" "no" "no" "no" ...
# $ change          : chr  "no" "no" "yes" "yes" ...
# $ diabetes_med    : chr  "yes" "yes" "yes" "yes" ...
# $ readmitted      : chr  "no" "no" "yes" "yes" ...



table(data$readmitted)
#    no   yes 
# 13246 11754 



table(data$diagnosis)
# Circulatory        Diabetes       Digestive          Injury         Missing Musculoskeletal           Other     Respiratory 
#        7824            1747            2329            1666               4            1252            6498            3680 

table(data$diagnosis, data$readmitted)
#                   no  yes
# Circulatory     4074 3750
# Diabetes         810  937
# Digestive       1224 1105
# Injury           939  727
# Missing            2    2
# Musculoskeletal  757  495
# Other           3566 2932
# Respiratory     1874 1806



table(data$glucose_test)
# high     no normal 
#  686  23625    689 

table(data$glucose_test, data$readmitted)
#           no   yes
# high     329   357
# no     12561 11064
# normal   356   333



table(data$A1Ctest)
# high     no normal 
# 2827  20938   1235 

table(data$A1Ctest, data$readmitted)
#           no   yes
# high    1528  1299
# no     11003  9935
# normal   715   520



table(data$change)
#    no   yes 
# 13497 11503 

table(data$change, data$readmitted)
#       no  yes
# no  7420 6077
# yes 5826 5677



table(data$diabetes_med)
#   no   yes 
# 5772 19228 

table(data$diabetes_med, data$readmitted)
#       no  yes
# no  3385 2387
# yes 9861 9367



data$age          <- as.factor(data$age)
data$diagnosis    <- as.factor(data$diagnosis)
data$glucose_test <- as.factor(data$glucose_test)
data$A1Ctest      <- as.factor(data$A1Ctest)
data$change       <- as.factor(data$change)
data$diabetes_med <- as.factor(data$diabetes_med)

data$readmitted <- as.factor(ifelse(data$readmitted == "yes", 1, 0))



str(data)
# 'data.frame':	25000 obs. of  15 variables:
# $ id              : int  1 2 3 4 5 6 7 8 9 10 ...
# $ age             : Factor w/ 6 levels "[40-50)","[50-60)",..: 4 4 2 4 3 1 2 3 5 4 ...
# $ time_in_hospital: int  8 3 5 2 1 2 4 1 4 8 ...
# $ n_lab_procedures: int  72 34 45 36 42 51 44 19 67 37 ...
# $ n_procedures    : int  1 2 0 0 0 0 2 6 3 1 ...
# $ n_medications   : int  18 13 18 12 7 10 21 16 13 18 ...
# $ n_outpatient    : int  2 0 0 1 0 0 0 0 0 0 ...
# $ n_inpatient     : int  0 0 0 0 0 0 0 0 0 0 ...
# $ n_emergency     : int  0 0 0 0 0 0 0 1 0 0 ...
# $ diagnosis       : Factor w/ 8 levels "Circulatory",..: 1 7 1 1 7 7 4 1 3 8 ...
# $ glucose_test    : Factor w/ 3 levels "high","no","normal": 2 2 2 2 2 2 2 2 2 2 ...
# $ A1Ctest         : Factor w/ 3 levels "high","no","normal": 2 2 2 2 2 2 3 2 2 2 ...
# $ change          : Factor w/ 2 levels "no","yes": 1 1 2 2 1 1 2 1 1 2 ...
# $ diabetes_med    : Factor w/ 2 levels "no","yes": 2 2 2 2 2 1 2 2 1 2 ...
# $ readmitted      : Factor w/ 2 levels "0","1": 1 1 2 2 1 2 1 2 2 1 ...



boxplot(time_in_hospital ~ readmitted, data = data, col = "cadetblue")
boxplot(n_lab_procedures ~ readmitted, data = data, col = "cadetblue")
boxplot(n_procedures ~ readmitted, data = data, col = "cadetblue")
boxplot(n_medications ~ readmitted, data = data, col = "cadetblue")
boxplot(n_outpatient ~ readmitted, data = data, col = "cadetblue")
boxplot(n_inpatient ~ readmitted, data = data, col = "cadetblue")
boxplot(n_emergency ~ readmitted, data = data, col = "cadetblue")




index <- createDataPartition(data$readmitted, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]

dim(train)
# 17501    15

dim(test)
# 7499   15



head(train)
# id     age time_in_hospital n_lab_procedures n_procedures n_medications n_outpatient n_inpatient n_emergency   diagnosis glucose_test A1Ctest change
# 1  1 [70-80)                8               72            1            18            2           0           0 Circulatory           no      no     no
# 2  2 [70-80)                3               34            2            13            0           0           0       Other           no      no     no
# 3  3 [50-60)                5               45            0            18            0           0           0 Circulatory           no      no    yes
# 4  4 [70-80)                2               36            0            12            1           0           0 Circulatory           no      no    yes
# 5  5 [60-70)                1               42            0             7            0           0           0       Other           no      no     no
# 6  6 [40-50)                2               51            0            10            0           0           0       Other           no      no     no
# diabetes_med readmitted
# 1          yes          0
# 2          yes          0
# 3          yes          1
# 4          yes          1
# 5          yes          0
# 6           no          1



str(train)
# 'data.frame':	17501 obs. of  15 variables:
# $ id              : int  1 2 3 4 5 6 8 13 15 16 ...
# $ age             : Factor w/ 6 levels "[40-50)","[50-60)",..: 4 4 2 4 3 1 3 4 5 5 ...
# $ time_in_hospital: int  8 3 5 2 1 2 1 8 2 8 ...
# $ n_lab_procedures: int  72 34 45 36 42 51 19 67 73 52 ...
# $ n_procedures    : int  1 2 0 0 0 0 6 0 1 0 ...
# $ n_medications   : int  18 13 18 12 7 10 16 21 26 20 ...
# $ n_outpatient    : int  2 0 0 1 0 0 0 0 0 0 ...
# $ n_inpatient     : int  0 0 0 0 0 0 0 0 0 0 ...
# $ n_emergency     : int  0 0 0 0 0 0 1 0 0 0 ...
# $ diagnosis       : Factor w/ 8 levels "Circulatory",..: 1 7 1 1 7 7 1 2 1 7 ...
# $ glucose_test    : Factor w/ 3 levels "high","no","normal": 2 2 2 2 2 2 2 2 2 2 ...
# $ A1Ctest         : Factor w/ 3 levels "high","no","normal": 2 2 2 2 2 2 2 3 2 2 ...
# $ change          : Factor w/ 2 levels "no","yes": 1 1 2 2 1 1 1 1 1 2 ...
# $ diabetes_med    : Factor w/ 2 levels "no","yes": 2 2 2 2 2 1 2 2 2 2 ...
# $ readmitted      : Factor w/ 2 levels "0","1": 1 1 2 2 1 2 2 1 1 2 ...



model <- glm(readmitted ~ age + time_in_hospital + n_lab_procedures + n_procedures + n_medications + n_outpatient + n_inpatient + n_emergency + diagnosis + glucose_test + A1Ctest + change + diabetes_med, data = train, family = "binomial")
summary(model)
# Call:
# glm(formula = readmitted ~ age + time_in_hospital + n_lab_procedures + 
#     n_procedures + n_medications + n_outpatient + n_inpatient + 
#     n_emergency + diagnosis + glucose_test + A1Ctest + change + 
#     diabetes_med, family = "binomial", data = train)
# 
# Coefficients:
#                            Estimate Std. Error z value Pr(>|z|)    
# (Intercept)              -0.7407173  0.1304023  -5.680 1.34e-08 ***
# age[50-60)                0.0493064  0.0630958   0.781 0.434536    
# age[60-70)                0.1652208  0.0606127   2.726 0.006414 ** 
# age[70-80)                0.2627059  0.0595281   4.413 1.02e-05 ***
# age[80-90)                0.2710950  0.0636877   4.257 2.08e-05 ***
# age[90-100)              -0.0787575  0.1036029  -0.760 0.447143    
# time_in_hospital          0.0183501  0.0062067   2.957 0.003111 ** 
# n_lab_procedures          0.0009264  0.0009098   1.018 0.308535    
# n_procedures             -0.0351072  0.0104884  -3.347 0.000816 ***
# n_medications             0.0009853  0.0024818   0.397 0.691360    
# n_outpatient              0.1372364  0.0163762   8.380  < 2e-16 ***
# n_inpatient               0.3834460  0.0172438  22.237  < 2e-16 ***
# n_emergency               0.2029828  0.0293374   6.919 4.55e-12 ***
# diagnosisDiabetes         0.1219798  0.0681738   1.789 0.073575 .  
# diagnosisDigestive       -0.0777738  0.0589399  -1.320 0.186987    
# diagnosisInjury          -0.2330951  0.0672925  -3.464 0.000532 ***
# diagnosisMissing          0.0337000  1.0127914   0.033 0.973456    
# diagnosisMusculoskeletal -0.2821996  0.0772349  -3.654 0.000258 ***
# diagnosisOther           -0.2048424  0.0431979  -4.742 2.12e-06 ***
# diagnosisRespiratory     -0.0439953  0.0512141  -0.859 0.390315    
# glucose_testno           -0.0723678  0.0977466  -0.740 0.459080    
# glucose_testnormal       -0.0451765  0.1332820  -0.339 0.734644    
# A1Ctestno                 0.0095498  0.0517708   0.184 0.853651    
# A1Ctestnormal            -0.0958295  0.0851226  -1.126 0.260257    
# changeyes                 0.0361982  0.0372012   0.973 0.330535    
# diabetes_medyes           0.2593382  0.0435802   5.951 2.67e-09 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 24199  on 17500  degrees of freedom
# Residual deviance: 22983  on 17475  degrees of freedom
# AIC: 23035
# 
# Number of Fisher Scoring iterations: 4


vif(model)
#                      GVIF Df GVIF^(1/(2*Df))
# age              1.096852  5        1.009287
# time_in_hospital 1.405978  1        1.185740
# n_lab_procedures 1.312725  1        1.145742
# n_procedures     1.324157  1        1.150720
# n_medications    1.671632  1        1.292916
# n_outpatient     1.031347  1        1.015552
# n_inpatient      1.060442  1        1.029778
# n_emergency      1.050444  1        1.024911
# diagnosis        1.249420  7        1.016033
# glucose_test     1.068469  2        1.016695
# A1Ctest          1.121460  2        1.029072
# change           1.400069  1        1.183245
# diabetes_med     1.344146  1        1.159373



model <- glm(readmitted ~ age + time_in_hospital + n_procedures + n_outpatient + n_inpatient + n_emergency + diagnosis + diabetes_med, data = train, family = "binomial")
summary(model)
# Call:
# glm(formula = readmitted ~ age + time_in_hospital + n_procedures + 
#     n_outpatient + n_inpatient + n_emergency + diagnosis + diabetes_med,
#     family = "binomial", data = train)
#
# Coefficients:
#                           Estimate Std. Error z value Pr(>|z|)
# (Intercept)              -0.771355   0.069313 -11.129  < 2e-16 ***
# age[50-60)                0.048279   0.063024   0.766 0.443653
# age[60-70)                0.166811   0.060451   2.759 0.005790 **
# age[70-80)                0.262715   0.059325   4.428 9.49e-06 ***
# age[80-90)                0.269990   0.063432   4.256 2.08e-05 ***
# age[90-100)              -0.076887   0.103311  -0.744 0.456736
# time_in_hospital          0.021641   0.005451   3.970 7.18e-05 ***
# n_procedures             -0.033729   0.009848  -3.425 0.000615 ***
# n_outpatient              0.138917   0.016302   8.521  < 2e-16 ***
# n_inpatient               0.384792   0.017173  22.407  < 2e-16 ***
# n_emergency               0.204835   0.029342   6.981 2.93e-12 ***
# diagnosisDiabetes         0.124270   0.067834   1.832 0.066954 .
# diagnosisDigestive       -0.077619   0.058732  -1.322 0.186312
# diagnosisInjury          -0.234668   0.067117  -3.496 0.000472 ***
# diagnosisMissing          0.017625   1.014106   0.017 0.986133
# diagnosisMusculoskeletal -0.285480   0.075946  -3.759 0.000171 ***
# diagnosisOther           -0.207569   0.042941  -4.834 1.34e-06 ***
# diagnosisRespiratory     -0.039886   0.051117  -0.780 0.435226
# diabetes_medyes           0.283935   0.037875   7.497 6.55e-14 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 24199  on 17500  degrees of freedom
# Residual deviance: 22988  on 17482  degrees of freedom
# AIC: 23026
# 
# Number of Fisher Scoring iterations: 4


train$predprob <- fitted(model)
predtrain      <- prediction(train$predprob, train$readmitted)
perftrain      <- performance(predtrain, "tpr", "fpr")
plot(perftrain)
abline(0, 1)

test$predprob <- predict(model, test, type = "response")
predtest      <- prediction(test$predprob, test$readmitted)
perftest      <- performance(predtest, "tpr", "fpr")
plot(perftest)
abline(0, 1)


auctrain <- performance(predtrain, "auc")
auctrain@y.values 
# 0.6471285

auctest  <- performance(predtest, "auc")
auctest@y.values 
# 0.6442581



train$predY    <- as.factor(ifelse(train$predprob > 0.5, 1, 0))
confusionMatrix(train$predY, train$readmitted, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 7362 4919
#          1 1911 3309
# 
#                Accuracy : 0.6097         
#                  95% CI : (0.6025, 0.617)
#     No Information Rate : 0.5299         
#     P-Value [Acc > NIR] : < 2.2e-16      
# 
#                   Kappa : 0.2002         
# 
#  Mcnemar's Test P-Value : < 2.2e-16      
#                                          
#             Sensitivity : 0.4022         
#             Specificity : 0.7939         
#          Pos Pred Value : 0.6339         
#          Neg Pred Value : 0.5995         
#              Prevalence : 0.4701         
#          Detection Rate : 0.1891         
#    Detection Prevalence : 0.2983         
#       Balanced Accuracy : 0.5980         
#                                          
#        'Positive' Class : 1     


test$predY    <- as.factor(ifelse(test$predprob > 0.5, 1, 0))
confusionMatrix(test$predY, test$readmitted, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 3148 2076
#          1  825 1450
# 
#                Accuracy : 0.6131         
#                  95% CI : (0.602, 0.6242)
#     No Information Rate : 0.5298         
#     P-Value [Acc > NIR] : < 2.2e-16      
# 
#                   Kappa : 0.2077         
# 
#  Mcnemar's Test P-Value : < 2.2e-16      
#                                          
#             Sensitivity : 0.4112         
#             Specificity : 0.7923         
#          Pos Pred Value : 0.6374         
#          Neg Pred Value : 0.6026         
#              Prevalence : 0.4702         
#          Detection Rate : 0.1934         
#    Detection Prevalence : 0.3034         
#       Balanced Accuracy : 0.6018         
#                                          
#        'Positive' Class : 1  



sstrain        <- performance(predtrain, "sens", "spec")
best_threshold <- sstrain@alpha.values[[1]][which.max(sstrain@x.values[[1]] + sstrain@y.values[[1]])]
best_threshold
# 0.4464716




train$predY    <- as.factor(ifelse(train$predprob > best_threshold, 1, 0))
confusionMatrix(train$predY, train$readmitted, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 5858 3412
#          1 3415 4816
# 
#                Accuracy : 0.6099          
#                  95% CI : (0.6026, 0.6171)
#     No Information Rate : 0.5299          
#     P-Value [Acc > NIR] : <2e-16          
# 
#                   Kappa : 0.217           
# 
#  Mcnemar's Test P-Value : 0.9807          
#                                           
#             Sensitivity : 0.5853          
#             Specificity : 0.6317          
#          Pos Pred Value : 0.5851          
#          Neg Pred Value : 0.6319          
#              Prevalence : 0.4701          
#          Detection Rate : 0.2752          
#    Detection Prevalence : 0.4703          
#       Balanced Accuracy : 0.6085          
#                                           
#        'Positive' Class : 1       



test$predY    <- as.factor(ifelse(test$predprob > best_threshold, 1, 0))
confusionMatrix(test$predY, test$readmitted, positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction    0    1
#          0 2466 1430
#          1 1507 2096
# 
#                Accuracy : 0.6083          
#                  95% CI : (0.5972, 0.6194)
#     No Information Rate : 0.5298          
#     P-Value [Acc > NIR] : <2e-16          
# 
#                   Kappa : 0.2149          
# 
#  Mcnemar's Test P-Value : 0.1608          
#                                           
#             Sensitivity : 0.5944          
#             Specificity : 0.6207          
#          Pos Pred Value : 0.5817          
#          Neg Pred Value : 0.6330          
#              Prevalence : 0.4702          
#          Detection Rate : 0.2795          
#    Detection Prevalence : 0.4805          
#       Balanced Accuracy : 0.6076          
#                                           
#        'Positive' Class : 1   
