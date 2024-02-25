
library(nnet)



data <- read.csv("./data/0404_advanced_predictive_modelling/live_class/High\ School\ Data.csv", header = TRUE)
head(data)
#   sn  id    ses write     prog
# 1  1  45    low    35 vocation
# 2  2 108 middle    33  general
# 3  3  15   high    39 vocation
# 4  4  67    low    37 vocation
# 5  5 153 middle    31 vocation
# 6  6  51   high    36  general


table(data$prog)
# academic  general vocation 
#      105       45       50 


data$prog <- relevel(as.factor(data$prog), ref = "academic")
str(data)
# 'data.frame':   200 obs. of  5 variables:
#  $ sn   : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ id   : int  45 108 15 67 153 51 164 133 2 53 ...
#  $ ses  : chr  "low" "middle" "high" "low" ...
#  $ write: int  35 33 39 37 31 36 36 31 41 37 ...
#  $ prog : Factor w/ 3 levels "academic","general",..: 3 2 3 3 3 2 3 3 3 3 ...



model <- multinom(prog ~ ses + write, data = data)
m     <- summary(model)
m
# Call:
# multinom(formula = prog ~ ses + write, data = data)

# Coefficients:
#          (Intercept)    seslow sesmiddle       write
# general     1.689478 1.1628411 0.6295638 -0.05793086
# vocation    4.235574 0.9827182 1.2740985 -0.11360389

# Std. Errors:
#          (Intercept)    seslow sesmiddle      write
# general     1.226939 0.5142211 0.4650289 0.02141101
# vocation    1.204690 0.5955688 0.5111119 0.02222000

# Residual Deviance: 359.9635 
# AIC: 375.9635 


z <- m$coefficients / m$standard.errors
1 - pchisq(z ^ 2, df = 1)
#           (Intercept)     seslow sesmiddle        write
# general  0.1685163893 0.02373673 0.1757949 6.816914e-03
# vocation 0.0004382601 0.09893276 0.0126741 3.176088e-07


data$pred <- round(fitted(model), 2)
head(data)
#   sn  id    ses write     prog pred.academic pred.general pred.vocation
# 1  1  45    low    35 vocation          0.15         0.34          0.51
# 2  2 108 middle    33  general          0.12         0.18          0.70
# 3  3  15   high    39 vocation          0.42         0.24          0.34
# 4  4  67    low    37 vocation          0.17         0.35          0.48
# 5  5 153 middle    31 vocation          0.10         0.17          0.73
# 6  6  51   high    36  general          0.35         0.24          0.41


expected <- predict(model, data, type = "class")
ctable   <- table(data$prog, expected)
ctable
#           expected
#            academic general vocation
#   academic       92       4        9
#   general        27       7       11
#   vocation       23       4       23

