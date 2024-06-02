
library(rpart)
library(rpart.plot)

motor <- read.csv("./data/0804_machine_learning_02/01_decision_trees/Motor Claims.csv", header = TRUE)

str(motor)
# 'data.frame':   1000 obs. of  5 variables:
#  $ vehage  : int  4 2 2 7 2 1 4 4 2 1 ...
#  $ CC      : int  1495 1061 1405 1298 1495 1086 796 1061 796 1405 ...
#  $ Length  : int  4250 3495 3675 4090 4250 3565 3495 3520 3335 3675 ...
#  $ Weight  : int  1023 875 980 930 1023 854 740 830 665 980 ...
#  $ claimamt: num  72000 72000 50400 39960 106800 ...

rpart_r <- rpart(claimamt ~ vehage + CC + Length + Weight, data = motor, method = "anova", parms = list(split = "information"))

par(mfrow = c(1, 1), xpd = NA)
plot(rpart_r)
text(rpart_r, splits = TRUE, use.n = TRUE, all = TRUE, cex = 0.75)

rpart.plot(rpart_r, type = 1, extra = 1, branch = 0, cex = 0.8)
