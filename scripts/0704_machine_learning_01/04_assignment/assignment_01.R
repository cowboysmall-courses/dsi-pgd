
library(car)
library(caret)
library(ROCR)



# BACKGROUND:
#
#     The data is a marketing campaign data of a skin care clinic associated
#     with its success.
#
#     Description of variables:
#
#         Success:         Response to marketing campaign of Skin Care Clinic
#                          which offers both products and services. (1: email
#                          Opened, 0: email not opened)
#         AGE:             Age Group of Customer
#         Recency_Service: Number of days since last service purchase
#         Recency_Product: Number of days since last product purchase
#         Bill_Service:    Total bill amount for service in last 3 months
#         Bill_Product:    Total bill amount for products in last 3 months
#         Gender:          (1: Male, 2: Female)
#
#     Note: Answer following questions using entire data and do not create test
#           data.
#
# QUESTIONS
#
#     1: Import Email Campaign data. Perform binary logistic regression to model
#        "Success. Interpret sign of each significant variable in the model.
#     2: Compare performance of Binary Logistic Regression (significant
#        variables) and Naïve Bayes Method (all variables) using area under the
#        ROC curve.
#     3: Implement binary logistic regression and Support Vector Machines by
#        combining service and product variables. State area under the ROC curve
#        in each case.


data <- read.csv("./data/0704_machine_learning_01/04_assignment/Email Campaign.csv", header = TRUE)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success
# 1  1      1 <=45              12              11        11.82         2.68       0
# 2  2      2 <=30               6               0        10.31         1.32       0
# 3  3      1 <=30               1               9         7.43         0.49       0
# 4  4      1 <=45               2              14        13.68         1.85       0
# 5  5      2 <=30               0              11         4.56         1.01       1
# 6  6      2 <=30               1               2        18.99         0.44       1


# summary(data)
# sum(is.na(data))


str(data)
# 'data.frame':   683 obs. of  8 variables:
#  $ SN             : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ Gender         : int  1 2 1 1 2 2 1 1 1 1 ...
#  $ AGE            : chr  "<=45" "<=30" "<=30" "<=45" ...
#  $ Recency_Service: int  12 6 1 2 0 1 11 16 14 8 ...
#  $ Recency_Product: int  11 0 9 14 11 2 8 9 8 4 ...
#  $ Bill_Service   : num  11.82 10.31 7.43 13.68 4.56 ...
#  $ Bill_Product   : num  2.68 1.32 0.49 1.85 1.01 ...
#  $ Success        : int  0 0 0 0 1 1 0 0 1 0 ...


counts <- data.frame(table(data$Success))
colnames(counts)[1] <- "Success"
counts$Percent <- counts$Freq / sum(counts$Freq)
counts
#   Success Freq   Percent
# 1       0  503 0.7364568
# 2       1  180 0.2635432

threshold <- 0.26


data$Gender  <- as.factor(ifelse(data$Gender == 1, "Male", "Female"))
data$AGE     <- as.factor(data$AGE)
# data$Success <- as.factor(data$Success)





# 1. Import Email Campaign data. Perform binary logistic regression to model
#    "Success". Interpret sign of each significant variable in the model.

model_glm <- glm(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, family = binomial)
summary(model_glm)
# Call:
# glm(formula = Success ~ Gender + AGE + Recency_Service + Recency_Product +
#     Bill_Service + Bill_Product, family = binomial, data = data)
#
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)
# (Intercept)     -1.25849    0.27115  -4.641 3.46e-06 ***
# GenderMale       0.23697    0.21414   1.107    0.268
# AGE<=45          0.15725    0.26726   0.588    0.556
# AGE<=55          0.67267    0.36588   1.839    0.066 .
# Recency_Service -0.24592    0.02944  -8.352  < 2e-16 ***
# Recency_Product -0.09087    0.02207  -4.117 3.84e-05 ***
# Bill_Service     0.09293    0.01854   5.013 5.36e-07 ***
# Bill_Product     0.51966    0.08103   6.413 1.43e-10 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 787.81  on 682  degrees of freedom
# Residual deviance: 545.98  on 675  degrees of freedom
# AIC: 561.98
#
# Number of Fisher Scoring iterations: 6


vif(model_glm)
#                     GVIF Df GVIF^(1/(2*Df))
# Gender          1.008713  1        1.004347
# AGE             1.638617  2        1.131408
# Recency_Service 2.019479  1        1.421084
# Recency_Product 1.484285  1        1.218312
# Bill_Service    1.322204  1        1.149871
# Bill_Product    2.241463  1        1.497152


model_glm <- glm(Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, family = binomial)
summary(model_glm)
# Call:
# glm(formula = Success ~ Recency_Service + Recency_Product + Bill_Service +
#     Bill_Product, family = binomial, data = data)
#
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)
# (Intercept)     -1.15780    0.24777  -4.673 2.97e-06 ***
# Recency_Service -0.22984    0.02728  -8.426  < 2e-16 ***
# Recency_Product -0.07389    0.01932  -3.825 0.000131 ***
# Bill_Service     0.09183    0.01846   4.974 6.55e-07 ***
# Bill_Product     0.51852    0.08083   6.415 1.41e-10 ***
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# (Dispersion parameter for binomial family taken to be 1)
#
#     Null deviance: 787.81  on 682  degrees of freedom
# Residual deviance: 550.87  on 678  degrees of freedom
# AIC: 560.87
#
# Number of Fisher Scoring iterations: 6


vif(model_glm)
# Recency_Service Recency_Product    Bill_Service    Bill_Product
#        1.737141        1.131628        1.320786        2.218089


# - one unit increase in the Recency_Service estimator will result in a -0.22984
#   change in the log odds of the email being successfully opened
# - one unit increase in the Recency_Product estimator will result in a -0.07389
#   change in the log odds of the email being successfully opened

# - one unit increase in the Bill_Service estimator will result in a 0.09183
#   change in the log odds of the email being successfully opened
# - one unit increase in the Bill_Product estimator will result in a 0.51852
#   change in the log odds of the email being successfully opened

# - Both the estimates of Recency_Service and Recency_Product negatively affect
#   the outcome - the greater the value of each estimator, the less is the
#   likelihood a successful outcome

# - Both the estimates of Bill_Service and Bill_Product positively affect the
#   outcome - the greater the value of each estimator, the more is the
#   likelihood a successful outcome





# 2. Compare performance of Binary Logistic Regression (significant variables) and Naïve Bayes Method (all variables) using area under the ROC curve.
index <- createDataPartition(data$Success, p = 0.7, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]


model_glm <- glm(Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = train, family = binomial)


predprob  <- round(fitted(model_glm), 2)
predtrain <- prediction(predprob, train$Success)
perftrain <- performance(predtrain, "tpr", "fpr")

plot(perftrain)
abline(0, 1)


auc <- performance(predtrain, "auc")
auc@y.values
# 0.8459024



