
data <- read.csv("./data/0604_unsupervised_multivariate_methods/01_data_reduction_methods/Athleticsdata.csv", header = TRUE)
head(data)
#     Country X100m_s X200m_s X400m_s X800m_min X1500m_min X5000m_min X10000m_min
# 1 Argentina   10.39   20.81   46.84      1.81       3.70      14.04       29.36
# 2 Australia   10.31   20.06   44.84      1.74       3.57      13.28       27.66
# 3   Austria   10.44   20.81   46.82      1.79       3.60      13.26       27.72
# 4   Belgium   10.34   20.68   45.04      1.73       3.60      13.22       27.45
# 5   Bermuda   10.28   20.58   45.91      1.80       3.75      14.68       30.55
# 6    Brazil   10.22   20.43   45.21      1.73       3.66      13.62       28.62
#   Marathon_min
# 1       137.72
# 2       128.30
# 3       135.90
# 4       129.95
# 5       146.62
# 6       133.13

athletics <- subset(data, select = c(-Country))

fact <- factanal(athletics, 2, rotation = "varimax", scores = "regression")
fact
# Call:
# factanal(x = athletics, factors = 2, scores = "regression", rotation = "varimax")

# Uniquenesses:
#      X100m_s      X200m_s      X400m_s    X800m_min   X1500m_min   X5000m_min 
#        0.079        0.077        0.151        0.135        0.082        0.034 
#  X10000m_min Marathon_min 
#        0.018        0.086 

# Loadings:
#              Factor1 Factor2
# X100m_s      0.287   0.916  
# X200m_s      0.376   0.885  
# X400m_s      0.537   0.749  
# X800m_min    0.686   0.628  
# X1500m_min   0.795   0.535  
# X5000m_min   0.898   0.400  
# X10000m_min  0.904   0.406  
# Marathon_min 0.913   0.284  

#                Factor1 Factor2
# SS loadings      4.071   3.268
# Proportion Var   0.509   0.408
# Cumulative Var   0.509   0.917

# Test of the hypothesis that 2 factors are sufficient.
# The chi square statistic is 16.65 on 13 degrees of freedom.
# The p-value is 0.216 

data$stamina <- fact$score[, 1]
data$speed   <- fact$score[, 2]

plot(data$stamina, data$speed)
text(data$stamina, data$speed, data$Country, cex = 0.6, pos = 4, col = "red")
