
library(GGally)


data <- read.csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance\ Index.csv", header = TRUE)

head(data)
#   empid   jpi aptitude   tol technical general
# 1     1 45.52    43.83 55.92     51.82   43.58
# 2     2 40.10    32.71 32.56     51.49   51.03
# 3     3 50.61    56.64 54.84     52.29   52.47
# 4     4 38.97    51.53 59.69     47.48   47.69
# 5     5 41.87    51.35 51.50     47.59   45.77
# 6     6 38.71    39.60 43.63     48.34   42.06


ggpairs(
  data[, c("jpi", "aptitude", "tol", "technical", "general")],
  title = "Scatter Plot Matrix",
  columnLabels = c("jpi", "aptitude", "tol", "technical", "general")
)


model <- lm(jpi ~ aptitude + tol + technical + general, data = data)
model
# Call:
# lm(formula = jpi ~ aptitude + tol + technical + general, data = data)
# 
# Coefficients:
# (Intercept)     aptitude          tol    technical      general  
#   -54.28225      0.32356      0.03337      1.09547      0.53683
