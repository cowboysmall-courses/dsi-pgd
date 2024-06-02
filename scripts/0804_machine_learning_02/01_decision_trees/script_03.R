
library(rpart)

bankloan <- read.csv("./data/0804_machine_learning_02/01_decision_trees/BANK LOAN.csv", header = TRUE)

str(bankloan)
# 'data.frame':   700 obs. of  8 variables:
#  $ SN       : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ AGE      : int  3 1 2 3 1 3 2 3 1 2 ...
#  $ EMPLOY   : int  17 10 15 15 2 5 20 12 3 0 ...
#  $ ADDRESS  : int  12 6 14 14 0 5 9 11 4 13 ...
#  $ DEBTINC  : num  9.3 17.3 5.5 2.9 17.3 10.2 30.6 3.6 24.4 19.7 ...
#  $ CREDDEBT : num  11.36 1.36 0.86 2.66 1.79 ...
#  $ OTHDEBT  : num  5.01 4 2.17 0.82 3.06 ...
#  $ DEFAULTER: int  1 0 0 0 1 0 0 0 1 0 ...

bankloan$AGE       <- as.factor(bankloan$AGE)
bankloan$DEFAULTER <- as.factor(bankloan$DEFAULTER)

rpart_c <- rpart(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = bankloan, method = "class")

par(mfrow = c(1, 1), xpd = NA)
plot(rpart_c)
text(rpart_c, splits = TRUE, use.n = TRUE, all = TRUE, cex = 0.75)


rpart_inf <- rpart(DEFAULTER ~ AGE + EMPLOY + ADDRESS + DEBTINC + CREDDEBT + OTHDEBT, data = bankloan, method = "class", parms = list(split = "information"))

par(mfrow = c(1, 1), xpd = NA)
plot(rpart_inf)
text(rpart_inf, splits = TRUE, use.n = TRUE, all = TRUE, cex = 0.75)
