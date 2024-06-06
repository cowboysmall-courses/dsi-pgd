
library(tm)
library(sentimentr)
library(ROCR)
library(caret)
library(car)
library(dplyr)

data <- read.csv("./data/0904_text_mining_and_nlp/05_case_study/Email Campaign.csv", header = TRUE)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product                                                                          Review Success
# 1  1      1 <=45              12              11        11.82         2.68                    The product quality is low. Service is quite slow and costly       0
# 2  2      2 <=30               6               0        10.31         1.32                                            Unhappy with staff. Product is poor.       0
# 3  3      1 <=30               1               9         7.43         0.49         The products recommended by the clinic caused irritation and breakouts.       0
# 4  5      2 <=30               0              11         4.56         1.01                        Happy with the product quality . Service is as expected.       1
# 5  6      2 <=30               1               2        18.99         0.44 The clinic provided a comprehensive consultation that addressed all my concerns       1
# 6  9      1 <=45              14               8        41.55        15.97                                                              Worth to recommend       1

data <- data %>% mutate(across(c(AGE, Gender), as.factor))
str(data)
# 'data.frame':   142 obs. of  9 variables:
#  $ SN             : int  1 2 3 5 6 9 18 20 22 26 ...
#  $ Gender         : Factor w/ 2 levels "1","2": 1 2 1 2 2 1 2 1 1 2 ...
#  $ AGE            : Factor w/ 3 levels "<=30","<=45",..: 2 1 1 1 1 2 1 2 2 2 ...
#  $ Recency_Service: int  12 6 1 0 1 14 13 4 1 15 ...
#  $ Recency_Product: int  11 0 9 11 2 8 1 3 0 0 ...
#  $ Bill_Service   : num  11.82 10.31 7.43 4.56 18.99 ...
#  $ Bill_Product   : num  2.68 1.32 0.49 1.01 0.44 ...
#  $ Review         : chr  "The product quality is low. Service is quite slow and costly" "Unhappy with staff. Product is poor." "The products recommended by the clinic caused irritation and breakouts." "Happy with the product quality . Service is as expected." ...
#  $ Success        : int  0 0 0 1 1 1 1 1 1 0 ...

data$Cleaned_Review <- tolower(data$Review)
data$Cleaned_Review <- removeWords(data$Cleaned_Review, stopwords("en"))
data$Cleaned_Review <- gsub("[^[:alnum:][:space:]]", "", data$Cleaned_Review)
data$Cleaned_Review <- gsub("[0-9]", "", data$Cleaned_Review)

data$Compound_Score <- sentiment(data$Cleaned_Review)$sentiment

names(data)
# "SN"              "Gender"          "AGE"             "Recency_Service" "Recency_Product" "Bill_Service"    "Bill_Product"    "Review"          "Success"         "Cleaned_Review"  "Compound_Score"

model <- glm(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product + Compound_Score, family = binomial, data = data)
summary(model)
# Call:
# glm(formula = Success ~ Gender + AGE + Recency_Service + Recency_Product + 
#     Bill_Service + Bill_Product + Compound_Score, family = "binomial", 
#     data = data)
# 
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)    
# (Intercept)     -0.80281    0.74878  -1.072 0.283654    
# Gender2          0.13821    0.59511   0.232 0.816352    
# AGE<=45         -0.70384    0.68454  -1.028 0.303863    
# AGE<=55          0.51356    1.07003   0.480 0.631262    
# Recency_Service -0.27376    0.07425  -3.687 0.000227 ***
# Recency_Product -0.09452    0.06072  -1.557 0.119569    
# Bill_Service     0.11513    0.04822   2.388 0.016950 *  
# Bill_Product     0.57387    0.16379   3.504 0.000459 ***
# Compound_Score   4.27999    1.00545   4.257 2.07e-05 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 194.028  on 141  degrees of freedom
# Residual deviance:  83.361  on 133  degrees of freedom
# AIC: 101.36
# 
# Number of Fisher Scoring iterations: 6

vif(model)
#                     GVIF Df GVIF^(1/(2*Df))
# Gender          1.126950  1        1.061579
# AGE             2.086499  2        1.201862
# Recency_Service 2.295217  1        1.514997
# Recency_Product 1.663177  1        1.289642
# Bill_Service    1.334899  1        1.155378
# Bill_Product    2.319913  1        1.523126
# Compound_Score  1.217224  1        1.103279

model <- glm(Success ~ Recency_Service + Bill_Service + Bill_Product + Compound_Score, family = binomial, data = data)
summary(model)
# Call:
# glm(formula = Success ~ Recency_Service + Bill_Service + Bill_Product + 
#     Compound_Score, family = binomial, data = data)
# 
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)    
# (Intercept)     -1.44090    0.56862  -2.534 0.011276 *  
# Recency_Service -0.28931    0.06480  -4.465 8.02e-06 ***
# Bill_Service     0.11140    0.04578   2.433 0.014968 *  
# Bill_Product     0.58250    0.15355   3.793 0.000149 ***
# Compound_Score   4.03052    0.94732   4.255 2.09e-05 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
#     Null deviance: 194.028  on 141  degrees of freedom
# Residual deviance:  89.212  on 137  degrees of freedom
# AIC: 99.212
# 
# Number of Fisher Scoring iterations: 6

vif(model)
# Recency_Service    Bill_Service    Bill_Product  Compound_Score 
#        1.929278        1.215582        2.031579        1.158012


data$predprob <- predict(model, data, type = "response")

data$success_pred <- as.factor(ifelse(data$predprob > 0.5, 1, 0))
# data$success_pred <- as.factor(ifelse(data$predprob > 0.5, 1, 0))

confusionMatrix(data$success_pred, as.factor(data$Success), positive = "1")
# Confusion Matrix and Statistics
# 
#           Reference
# Prediction  0  1
#          0 70 12
#          1 11 49
# 
#                Accuracy : 0.838           
#                  95% CI : (0.7669, 0.8945)
#     No Information Rate : 0.5704          
#     P-Value [Acc > NIR] : 8.797e-12       
# 
#                   Kappa : 0.6688          
# 
#  Mcnemar's Test P-Value : 1               
# 
#             Sensitivity : 0.8033          
#             Specificity : 0.8642          
#          Pos Pred Value : 0.8167          
#          Neg Pred Value : 0.8537          
#              Prevalence : 0.4296          
#          Detection Rate : 0.3451          
#    Detection Prevalence : 0.4225          
#       Balanced Accuracy : 0.8337          
# 
#        'Positive' Class : 1

pred <- prediction(data$predprob, data$Success)
perf <- performance(pred, "tpr", "fpr")

plot(perf)
abline(0, 1)

auc <- performance(pred, "auc")
auc@y.values
# 0.9342238
