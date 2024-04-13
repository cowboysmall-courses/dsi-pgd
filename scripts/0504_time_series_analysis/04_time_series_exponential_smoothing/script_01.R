
library(forecast)
library(urca)

data <- read.csv("./data/0504_time_series_analysis/03_time_series_modelling/Sales\ Data\ for\ 3\ Years.csv", header = TRUE)
head(data)
#   Year Month Sales
# 1 2013   Jan   123
# 2 2013   Feb   142
# 3 2013   Mar   164
# 4 2013   Apr   173
# 5 2013   May   183
# 6 2013   Jun   192

series <- ts(data$Sales, start = c(2013, 1), end = c(2015, 12), frequency = 12)



fit1 <- HoltWinters(series, beta = FALSE, gamma = FALSE)

predict(fit1, n.ahead = 1)
#           Jan
# 2016 314.4432


fit1
# Holt-Winters exponential smoothing without trend and without seasonal component.
# 
# Call:
# HoltWinters(x = series, beta = FALSE, gamma = FALSE)
# 
# Smoothing parameters:
#  alpha: 0.754789
#  beta : FALSE
#  gamma: FALSE
# 
# Coefficients:
#       [,1]
# a 314.4432



fit2 <- HoltWinters(series, gamma = FALSE)

predict(fit2, n.ahead = 1)
#           Jan
# 2016 306.1702

fit2
# Holt-Winters exponential smoothing with trend and without seasonal component.
# 
# Call:
# HoltWinters(x = series, gamma = FALSE)
# 
# Smoothing parameters:
#  alpha: 0.3835632
#  beta : 0.4889297
#  gamma: FALSE
# 
# Coefficients:
#        [,1]
# a 294.81648
# b  11.35368



fit3 <- HoltWinters(series)

predict(fit3, n.ahead = 1)
#           Jan
# 2016 295.9492

fit3
# Holt-Winters exponential smoothing with trend and additive seasonal component.
# 
# Call:
# HoltWinters(x = series)
# 
# Smoothing parameters:
#  alpha: 0.911556
#  beta : 0
#  gamma: 0.8681419
# 
# Coefficients:
#              [,1]
# a   296.725314337
# b     4.522435897
# s1   -5.298595983
# s2   -1.290510241
# s3   -3.658258513
# s4   -0.005594377
# s5   -3.580920942
# s6   -2.015183167
# s7    2.131638936
# s8   -0.258654397
# s9   -3.287793819
# s10  -6.786550699
# s11  -7.502574409
# s12  31.125466834
