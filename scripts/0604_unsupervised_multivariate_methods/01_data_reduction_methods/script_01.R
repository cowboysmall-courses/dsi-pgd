
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


pc <- princomp(formula = ~., data = athletics, cor = TRUE)
summary(pc)
# Importance of components:
#                           Comp.1    Comp.2     Comp.3    Comp.4     Comp.5
# Standard deviation     2.5740680 0.9355011 0.39820722 0.3521954 0.28286280
# Proportion of Variance 0.8282283 0.1093953 0.01982112 0.0155052 0.01000142
# Cumulative Proportion  0.8282283 0.9376236 0.95744470 0.9729499 0.98295131
#                             Comp.6     Comp.7      Comp.8
# Standard deviation     0.260301726 0.21484785 0.149909664
# Proportion of Variance 0.008469624 0.00576995 0.002809113
# Cumulative Proportion  0.991420937 0.99719089 1.000000000


pc$loadings
# Loadings:
#              Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8
# X100m_s       0.318  0.565  0.326  0.129  0.267  0.590  0.154  0.113
# X200m_s       0.337  0.462  0.369 -0.257 -0.157 -0.648 -0.128 -0.102
# X400m_s       0.356  0.249 -0.561  0.650 -0.221 -0.158              
# X800m_min     0.369        -0.531 -0.482  0.540        -0.237       
# X1500m_min    0.373 -0.140 -0.155 -0.407 -0.491  0.143  0.608  0.143
# X5000m_min    0.364 -0.312  0.190        -0.250  0.155 -0.593  0.543
# X10000m_min   0.367 -0.307  0.182        -0.128  0.232 -0.165 -0.796
# Marathon_min  0.342 -0.440  0.260  0.300  0.493 -0.329  0.393  0.160
# 
#                Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8
# SS loadings     1.000  1.000  1.000  1.000  1.000  1.000  1.000  1.000
# Proportion Var  0.125  0.125  0.125  0.125  0.125  0.125  0.125  0.125
# Cumulative Var  0.125  0.250  0.375  0.500  0.625  0.750  0.875  1.000


data$performance <- pc$score[, 1]
head(data)
#     Country X100m_s X200m_s X400m_s X800m_min X1500m_min X5000m_min X10000m_min
# 1 Argentina   10.39   20.81   46.84      1.81       3.70      14.04       29.36
# 2 Australia   10.31   20.06   44.84      1.74       3.57      13.28       27.66
# 3   Austria   10.44   20.81   46.82      1.79       3.60      13.26       27.72
# 4   Belgium   10.34   20.68   45.04      1.73       3.60      13.22       27.45
# 5   Bermuda   10.28   20.58   45.91      1.80       3.75      14.68       30.55
# 6    Brazil   10.22   20.43   45.21      1.73       3.66      13.62       28.62
#   Marathon_min performance
# 1       137.72   0.2656535
# 2       128.30  -2.4669681
# 3       135.90  -0.8134149
# 4       129.95  -2.0582394
# 5       146.62   0.7471461
# 6       133.13  -1.5710562


plot(pc, type = "lines")


plot(data$performance)
text(data$performance, label = data$Country, col = "red", cex = 0.4)


top3 <- head(data[order(-data$performance), ], 3)
top3
#          Country X100m_s X200m_s X400m_s X800m_min X1500m_min X5000m_min
# 12   Cook Isands   12.18   23.20   52.94      2.02       4.24      16.70
# 55 Western Samoa   10.82   21.86   49.00      2.02       4.24      16.28
# 36     Mauritius   11.19   22.45   47.70      1.88       3.83      15.06
#    X10000m_min Marathon_min performance
# 12       35.38       164.70   10.653867
# 55       34.71       161.83    7.297965
# 36       31.77       152.23    4.299192


bottom3 <- tail(data[order(-data$performance), ], 3)
bottom3
#                               Country X100m_s X200m_s X400m_s X800m_min
# 29                              Italy   10.01   19.72   45.26      1.73
# 21 Great Britain and Northern Ireland   10.11   20.21   44.93      1.70
# 53                                USA    9.93   19.75   43.86      1.73
#    X1500m_min X5000m_min X10000m_min Marathon_min performance
# 29       3.60      13.23       27.52       131.08   -2.750446
# 21       3.51      13.01       27.51       129.13   -3.050287
# 53       3.53      13.20       27.43       128.22   -3.460450


round(cor(pc$scores))
#        Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8
# Comp.1      1      0      0      0      0      0      0      0
# Comp.2      0      1      0      0      0      0      0      0
# Comp.3      0      0      1      0      0      0      0      0
# Comp.4      0      0      0      1      0      0      0      0
# Comp.5      0      0      0      0      1      0      0      0
# Comp.6      0      0      0      0      0      1      0      0
# Comp.7      0      0      0      0      0      0      1      0
# Comp.8      0      0      0      0      0      0      0      1
