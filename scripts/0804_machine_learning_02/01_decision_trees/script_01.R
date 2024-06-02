
library(partykit)

empdata <- read.csv("./data/0804_machine_learning_02/01_decision_trees/EMPLOYEE CHURN DATA.csv", header = TRUE)

empdata$status    <- as.factor(empdata$status)
empdata$function. <- as.factor(empdata$function.)
empdata$exp       <- as.factor(empdata$exp)
empdata$gender    <- as.factor(empdata$gender)
empdata$source    <- as.factor(empdata$source)

ctree <- partykit::ctree(formula = status ~ function. + exp + gender + source, data = empdata)

plot(ctree, type = "simple")

plot(ctree, type = "simple", gp = gpar(cex = 0.8))
