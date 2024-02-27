
# BACKGROUND: 
#   
#   The data for modeling contains information on Selling price of each house in million 
#   Rs. It also contains Carpet area in square feet, Distance from nearest metro station 
#   and Number of schools within 2 km distance. The data has 198 rows and 5 columns.

library(car)
library(caret)
library(nortest)



set.seed(1337)



# 1 - Import House Price Data. Check the structure of the data.
data <- read.csv("./data/0304_fundamentals_of_predictive_modelling/04_assignment/House\ Price\ Data.csv", header = TRUE)

head(data)
#   Houseid Price Area Distance Schools
# 1       1 24.74 1036     3.22       2
# 2       2 20.15 1030     4.33       3
# 3       3 25.98 1046     1.94       3
# 4       4 20.10  950     2.45       2
# 5       5 23.03  952     2.47       2
# 6       6 21.02  967     3.64       2

str(data)
# 'data.frame':	198 obs. of  5 variables:
# $ Houseid : int  1 2 3 4 5 6 7 8 9 10 ...
# $ Price   : num  24.7 20.1 26 20.1 23 ...
# $ Area    : int  1036 1030 1046 950 952 967 825 1162 1066 1084 ...
# $ Distance: num  3.22 4.33 1.94 2.45 2.47 3.64 1.49 2.26 1.93 1.47 ...
# $ Schools : int  2 3 3 2 2 2 2 3 3 2 ...



# 2 - Split the data into Training (80%) and Testing (20%) data sets
index <- createDataPartition(data$Price, p = 0.8, list = FALSE)
train <- data[index, ]
test  <- data[-index, ]



# 3 - Build a regression model on training data to estimate selling price of a House.
model <- lm(Price ~ Area + Distance + Schools, data = train)
summary(model)
# Call:
# lm(formula = Price ~ Area + Distance + Schools, data = train)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -6.1814 -1.3303  0.1795  1.6341  4.6410 
# 
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -9.339229   1.961860  -4.760 4.38e-06 ***
# Area         0.034376   0.002258  15.223  < 2e-16 ***
# Distance    -1.751836   0.191119  -9.166 2.71e-16 ***
# Schools      1.170730   0.408580   2.865  0.00474 ** 
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 2.244 on 156 degrees of freedom
# Multiple R-squared:  0.7786,	Adjusted R-squared:  0.7743 
# F-statistic: 182.9 on 3 and 156 DF,  p-value: < 2.2e-16



# 4 - List down significant variables and interpret their regression coefficients.
model$coefficients
# (Intercept)        Area    Distance     Schools 
# -9.33922947  0.03437617 -1.75183599  1.17072991   

# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -8.587180   1.919831  -4.473 1.48e-05 ***
# Area         0.034074   0.002238  15.222  < 2e-16 ***
# Distance    -1.945728   0.180181 -10.799  < 2e-16 ***
# Schools      1.237763   0.414879   2.983  0.00331 ** 

# for every unit increase in Area, the Price increases by 0.03437617
# for every unit increase in Distance, the Price decreases by 1.75183599
# for every unit increase in Schools, the Price increases by 1.17072991



# 5 - What is the R2 and adjusted R2 of the model? Give interpretation.
# R-squared:           0.7786
# Adjusted R-squared:  0.7743

# R-squared gives the proportion of the variation in the dependent variable that is 
# explained by the predictors / independent variables. 

# Adjusted R-squared is the value of R-squared adjusted for the number of predictors 
# in the model.

# in the case of R-squared, the value 0.7786 implies that 77% - 78% of the variation in 
# Price is explained by the model (and 22% - 23% is unexplained variation)



# 6 - Is there a multicollinearity problem? If yes, do the necessary steps to remove it.
vif(model)
#     Area Distance  Schools 
# 1.559863 1.033669 1.590641 

# as all calculated values of vif for each predictor are less than 5, there does not 
# appear to be a multicolinearity problem



# 7 - Are there any influential observations in the data?
summary(influence.measures(model))
# Potentially influential observations of
#          lm(formula = Price ~ Area + Distance + Schools, data = train) :
#   
#     dfb.1_ dfb.Area dfb.Dstn dfb.Schl dffit   cov.r   cook.d hat    
# 17  -0.04   0.26    -0.09    -0.45     0.47    1.04    0.05   0.08_*
# 32  -0.33   0.12     0.40     0.14    -0.53_*  0.88_*  0.07   0.04  
# 33   0.39  -0.42     0.07     0.16    -0.46    1.04    0.05   0.08_*
# 35  -0.05   0.11     0.10    -0.20     0.25    1.11_*  0.02   0.09_*
# 65  -0.30   0.11     0.37     0.13    -0.49_*  0.90_*  0.06   0.04  
# 66   0.41  -0.44     0.07     0.17    -0.48    1.03    0.06   0.08_*
# 98  -0.34   0.13     0.41     0.14    -0.55_*  0.86_*  0.07   0.04  
# 99   0.41  -0.43     0.07     0.16    -0.47    1.04    0.05   0.08_*
# 116 -0.04   0.27    -0.10    -0.48     0.50_*  1.03    0.06   0.08_*
# 131 -0.29   0.11     0.36     0.12    -0.47    0.91_*  0.05   0.04  
# 132  0.39  -0.41     0.07     0.16    -0.45    1.04    0.05   0.08_*
# 134 -0.05   0.12     0.12    -0.22     0.28    1.10_*  0.02   0.09_*
# 198  0.38  -0.40     0.06     0.15    -0.44    1.05    0.05   0.08_*

train[cooks.distance(model) > (4 / nrow(train)), ]
#     Houseid Price Area Distance Schools
# 17       17 26.75 1028     2.23       1
# 18       18 34.97 1072     0.10       3
# 32       32 17.73  929     0.70       2
# 33       33 33.36 1345     2.07       3
# 65       65 18.10  929     0.70       2
# 66       66 33.20 1345     2.07       3
# 98       98 17.53  929     0.70       2
# 99       99 33.25 1345     2.07       3
# 116     116 26.99 1028     2.23       1
# 131     131 18.35  929     0.70       2
# 132     132 33.41 1345     2.07       3
# 150     150 35.49 1072     0.10       3
# 164     164 18.98  929     0.70       2
# 183     183 34.93 1072     0.10       3
# 198     198 33.49 1345     2.07       3

# We can see from the above summary that there are as many as 15 influential 
# observations in the training data.

influencePlot(model, main = "Influence Plot", sub = "Circle size is proportioal to Cook's Distance")
#        StudRes        Hat      CookD
# 32  -2.7703899 0.03506313 0.06686166
# 35   0.8101086 0.08992431 0.01624741
# 98  -2.8678549 0.03506313 0.07140771
# 134  0.8944953 0.08992431 0.01979031



# 8 - Can we assume that errors follow ‘Normal’ distribution?
train$pred <- fitted(model)
train$resi <- residuals(model)

head(train)
#   Houseid Price Area Distance Schools     pred       resi
# 1       1 24.74 1036     3.22       2 22.97503  1.7649656
# 3       3 25.98 1046     1.94       3 26.73188 -0.7518761
# 4       4 20.10  950     2.45       2 21.36760 -1.2675972
# 5       5 23.03  952     2.47       2 21.40131  1.6286872
# 6       6 21.02  967     3.64       2 19.86731  1.1526927
# 7       7 17.44  825     1.49       2 18.75234 -1.3123380

# q-q plot of resi
qqnorm(train$resi, col = "cadetblue")
qqline(train$resi, col = "cadetblue", lwd = 2)
# The q-q plot appears to be reasonably normal, but deviating from normality at the tails.
# We should perform the standard tests for normality to confirm.

shapiro.test(train$resi)
#         Shapiro-Wilk normality test
# 
# data:  train$resi
# W = 0.98159, p-value = 0.03149

# as the p-value is 0.03149 we reject the null hypothesis that the residuals are drawn 
# from normally distributed data. However, we would fail to reject the null hypothesis 
# at the 0.01 level of significance (99%)

lillie.test(train$resi)
#         Lilliefors (Kolmogorov-Smirnov) normality test
# 
# data:  train$resi
# D = 0.062922, p-value = 0.1261

# as the p-value is 0.1261 we fail to reject the null hypothesis that the residuals are 
# drawn from normally distributed data.

# the above tests give conflicting results, but looking at the q-q plot we can see that
# both the tails deviate from normality, and hence the Shapiro-Wilk test will likely give 
# a p-value < 0.05 as it is concerned primarily with tails. We accept the outcome of the 
# Kolmogorov-Smirnov test.



# 9 - Is there a Heteroscedasticity problem? Check using residual vs. predictor plots.
plot(train$pred, train$resi, col = "cadetblue")

# residuals appear to be reasonably randomly distributed, which would indicate 
# homoscedasticity, and hence no heteroscedasticity problem.



# 10 - Calculate the RMSE for the Training and Testing data.
RMSE_train <- sqrt(mean(train$resi ** 2))
RMSE_train
# 2.216225

test$pred <- predict(model, test)
test$resi <- test$Price - test$pred

head(test)
#    Houseid Price Area Distance Schools     pred      resi
# 2        2 20.15 1030     4.33       3 21.99497 -1.844969
# 12      12 34.10 1138     0.88       3 31.75143  2.348570
# 14      14 19.75  990     3.39       2 21.09592 -1.345918
# 24      24 30.85 1160     2.80       3 29.14418  1.705819
# 37      37 20.18  950     2.45       2 21.36760 -1.187597
# 51      51 34.92 1072     0.10       3 30.84903  4.070965

RMSE_test <- sqrt(mean(test$resi ** 2))
RMSE_test
# 2.17643

# both values of RMSE are consistent, which is a strong indicator of the stability of 
# the model.

((RMSE_train - RMSE_test) / RMSE_train) * 100
# 1.795594

# the difference between the train and test RMSE is around 1% - 2% - which is acceptable 
# (a difference of around 10% is usually the ideal). Also of note is that the test RMSE 
# is less than the train RMSE, which would indicate that the error has decreased going
# from train to test.
