
library(dplyr)
library(ggplot2)
library(gmodels)



# 0 - import data and check the head
data <- read.csv("../../../data/0404_advanced_predictive_modelling/live_class/Email\ Campaign.csv", header = TRUE)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success
# 1  1      1 <=45              12              11        11.82         2.68       0
# 2  2      2 <=30               6               0        10.31         1.32       0
# 3  3      1 <=30               1               9         7.43         0.49       0
# 4  4      1 <=45               2              14        13.68         1.85       0
# 5  5      2 <=30               0              11         4.56         1.01       1
# 6  6      2 <=30               1               2        18.99         0.44       1



# 0 - convert Gender to factor
data$Gender <- as.factor(data$Gender)
data$AGE <- as.factor(data$AGE)
str(data)



# 1 - Summarize Bill amounts by "Success" (descriptive statistics like n, min, max, mean and sd)
func <- function(x) {
  c(
    n = length(x),
    mean = mean(x),
    median = median(x),
    sd = sd(x)
  )
}
aggregate(Bill_Service ~ Success, data = data, FUN = func)
#   Success Bill_Service.n Bill_Service.mean Bill_Service.median Bill_Service.sd
# 1       0     503.000000          9.188807            7.880000        5.644067
# 2       1     180.000000         15.287111           14.675000        7.925569

aggregate(Bill_Product ~ Success, data = data, FUN = func)
#   Success Bill_Product.n Bill_Product.mean Bill_Product.median Bill_Product.sd
# 1       0     503.000000          1.746740            1.310000        1.465931
# 2       1     180.000000          2.956167            1.965000        3.282115



data %>% 
  group_by(Success) %>%
  summarise(
    n = length(Bill_Service),
    mean = mean(Bill_Service),
    median = median(Bill_Service),
    sd = sd(Bill_Service)
  ) %>%
  as.data.frame()
#   Success   n      mean median       sd
# 1       0 503  9.188807  7.880 5.644067
# 2       1 180 15.287111 14.675 7.925569

data %>% 
  group_by(Success) %>%
  summarise(
    n = length(Bill_Product),
    mean = mean(Bill_Product),
    median = median(Bill_Product),
    sd = sd(Bill_Product)
  ) %>%
  as.data.frame()
#   Success   n     mean median       sd
# 1       0 503 1.746740  1.310 1.465931
# 2       1 180 2.956167  1.965 3.282115



# 2 - Visualize bill amounts by "Success"
boxplot(Bill_Service ~ Success, data = data, col = "cadetblue")

boxplot(Bill_Product ~ Success, data = data, col = "cadetblue")



ggplot(data, aes(x = factor(Success), y = Bill_Service)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot of Bill Service by Success", y = "Bill_Service")

ggplot(data, aes(x = factor(Success), y = Bill_Product)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot of Bill Product by Success", y = "Bill_Product")



# 3 - Analyze association between Gender and Success
CrossTable(data$Gender, data$Success, chisq = TRUE)
# Statistics for All Table Factors
# 
# 
# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  0.4959814     d.f. =  1     p =  0.4812712 
# 
# Pearson's Chi-squared test with Yates' continuity correction 
# ------------------------------------------------------------
# Chi^2 =  0.3807593     d.f. =  1     p =  0.5371972 



# 4 - Develop a statistical model to estimate probability of success
model <- glm(Success ~ Gender + AGE + Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, family = "binomial")
summary(model)
# Call:
# glm(formula = Success ~ Gender + AGE + Recency_Service + Recency_Product + 
#     Bill_Service + Bill_Product, family = "binomial", data = data)
# 
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)    
# (Intercept)     -1.02152    0.27946  -3.655 0.000257 ***
# Gender2         -0.23697    0.21414  -1.107 0.268462    
# AGE<=45          0.15725    0.26726   0.588 0.556293    
# AGE<=55          0.67267    0.36588   1.839 0.065986 .  
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



# 5 - Finalize the model by excluding insignificant variables
model <- glm(Success ~ Recency_Service + Recency_Product + Bill_Service + Bill_Product, data = data, family = "binomial")
summary(model)
# Call:
# glm(formula = Success ~ Recency_Service + Recency_Product + Bill_Service + 
#     Bill_Product, family = "binomial", data = data)
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



# 6 - Estimate predicted probabilities and add a column in the original data
data$pred_prob <- fitted(model)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success  pred_prob
# 1  1      1 <=45              12              11        11.82         2.68       0 0.09504185
# 2  2      2 <=30               6               0        10.31         1.32       0 0.28790000
# 3  3      1 <=30               1               9         7.43         0.49       0 0.24670257
# 4  4      1 <=45               2              14        13.68         1.85       0 0.39258957
# 5  5      2 <=30               0              11         4.56         1.01       1 0.26344376
# 6  6      2 <=30               1               2        18.99         0.44       1 0.60744675



# 7 - Use 0.5 as a threshold, estimate Success = 0 / 1
data$pred <- ifelse(data$pred_prob <= 0.5, 0, 1)
head(data)
#   SN Gender  AGE Recency_Service Recency_Product Bill_Service Bill_Product Success  pred_prob pred
# 1  1      1 <=45              12              11        11.82         2.68       0 0.09504185    0
# 2  2      2 <=30               6               0        10.31         1.32       0 0.28790000    0
# 3  3      1 <=30               1               9         7.43         0.49       0 0.24670257    0
# 4  4      1 <=45               2              14        13.68         1.85       0 0.39258957    0
# 5  5      2 <=30               0              11         4.56         1.01       1 0.26344376    0
# 6  6      2 <=30               1               2        18.99         0.44       1 0.60744675    1




# 8 - Analyze model accuracy and misclassification rate
table(data$pred, data$Success)
#     0   1
# 0 467  88
# 1  36  92

round(prop.table(table(data$pred, data$Success)) * 100, 2)
#       0     1
# 0 68.37 12.88
# 1  5.27 13.47

round((sum(data$pred == data$Success) / nrow(data)) * 100, 2)
# 81.84

round((sum(data$pred != data$Success) / nrow(data)) * 100, 2)
# 18.16
