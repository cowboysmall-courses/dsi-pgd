
library(ROCR)
# library(lift)
library(car)


data <- read.csv("./data/0404_advanced_predictive_modelling/01_binary_logistic_regression/BANK\ LOAN.csv", header = TRUE)


data$AGE <- factor(data$AGE)


model <- glm(DEFAULTER ~ EMPLOY + ADDRESS + DEBTINC + CREDDEBT, data = data, family = "binomial")


data$predprob <- fitted(model)
pred <- prediction(data$predprob, data$DEFAULTER)


perf <- performance(pred, "tpr", "fpr")
plot(perf)
abline(0, 1)


auc <- performance(pred, "auc")
auc@y.values
# 0.8556193


data$resi <- residuals(model, "pearson")
head(data)
#   SN AGE EMPLOY ADDRESS DEBTINC CREDDEBT OTHDEBT DEFAULTER   predprob       resi
# 1  1   3     17      12     9.3    11.36    5.01         1 0.80834673  0.4869219
# 2  2   1     10       6    17.3     1.36    4.00         0 0.19811470 -0.4970525
# 3  3   2     15      14     5.5     0.86    2.17         0 0.01006281 -0.1008221
# 4  4   3     15      14     2.9     2.66    0.82         0 0.02215972 -0.1505387
# 5  5   1      2       0    17.3     1.79    3.06         1 0.78180810  0.5282862
# 6  6   3      5       5    10.2     0.39    2.16         0 0.21646839 -0.5256165



influencePlot(model)
#        StudRes         Hat       CookD
# 1    0.6675108 0.077944303 0.004347290
# 36  -2.4744534 0.006728529 0.025951104
# 152  2.8779760 0.002847547 0.032633681
# 281  2.6041504 0.002354813 0.013123240
# 633  0.7685420 0.112165052 0.009019769



vif(model)
#   EMPLOY  ADDRESS  DEBTINC CREDDEBT 
# 1.807288 1.131470 1.328375 2.335715
